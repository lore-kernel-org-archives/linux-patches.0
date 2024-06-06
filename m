Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72131AB8FB
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 14:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717684065; cv=none; b=RWju4kJXmZ+eBfBom+JkS4Q/3vpgY6yTEwqYpOijVuVhirykj7y7Kz0UaZNHY4doAVH+mQOI2rpcCoMHQY9dX57d7eOS0XcOqur0Su+3ir+9Y52CBVkmt0xXqZ9538ssX2XVa6Um4sBmoSbHcbOb9H45PoK0DA8ZvgKni3H2k+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717684065; c=relaxed/simple;
	bh=zgz2bLOFJRkBwOEW5RaCFDEbiZHMyOTfAejaJyCZblg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NWkVrQTSYEwYM96yMLjEtN9yMfltzkVHI9CtAlKK2w5+FeHGuXnbEIXZKDCdZIUTFW/9eJotbC8eUE7cOpsGKu3uszzryqd4sJJOvW+VlfvyUU1PgynqcITn/vZrJcX0ZwcNXIOngNJlytbwh0Y+by4mjDq6HhqKQvPHSmdUfik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BPkigp+P; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BPkigp+P"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5751bcb3139so1113963a12.1
        for <patches@lists.linux.dev>; Thu, 06 Jun 2024 07:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717684062; x=1718288862; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DXB1vdhxU7ozzaIOv3LXxHYx4cJj0wQEg5HvR8ydDjc=;
        b=BPkigp+PeC+n9dHjoGR+JtGlUTQFgjESDsmrFCscfYL9GJ8HjXvlFwNaIDfpoGcrqQ
         OSiiwS5HZE/Ltj/XMY+hCiRAAaruf7vyTFILq0sundrplQT7Rb8IJtaZCP1FJWBMO7PU
         kFQesC7ppF3Hs4woXFWwv0/KMS0OhStywkxqVjcrdnxUgJe3Jur+aQCRxgyruA368yQT
         snZTN4+YtWONs5ejBMV+ncTpi2jZNf5Ao+ygHZaX4Xm1YlE37UXu0XnzGqEUoOBboWSD
         RuetvsoWTALTVL+VPc3fsor4KBpenNerOUMpYnmuFg9yBjKQn8istnDrjMhvVFz0HInH
         TNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717684062; x=1718288862;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DXB1vdhxU7ozzaIOv3LXxHYx4cJj0wQEg5HvR8ydDjc=;
        b=cE5ZvlqhyujK9h6kFAU03pp9xokqomGiE8nQb0I5ngM9x4lndkUBl48V2dv5OuQeb3
         lOXhcaTio+M3bgNVz+vXKoZQNgJiT4slJ6SvPt1Ca63b1o0mKy1CxMBhmPLQc/s3kWcN
         WXs2jmG3F6wRLlvnEvwjRzSFTBdeuM0p4Sb7cJImrwPqCuxN9uJhrogwpboAWIUINHxo
         ys+8MP8V04DfPYIv5oLbuHMV8PBeyCiv9ni0BvKKWBW3OQk9p0nupJOvnYJ3iWHK+6Ru
         U3FQCzQPXzPWIC0mOQ/HjqcIT9x8wRNAhofWNNBry8A/I3T1y69uvc50stBvvXk2k+5B
         QCeA==
X-Forwarded-Encrypted: i=1; AJvYcCUBG93XEyfYxcpB9oScXbCR8sXMv5orgylwRCJ6Ie+wtklfBYsGVs6o0ofnRsVxkt3yHLPzFL/IICN+aWGJ04s18Wm49wn13Q==
X-Gm-Message-State: AOJu0YxI5+zs18k+A2wUZSum/ECrhJy4E5AMTEpC4SpsO49geQEkZ3ox
	skXIZ4lHtdZs71ki8RQM8nQi2WpsHhZHPUu34wdcQlikEC/SgzGdv30ucNz5o0/kWAEV36t90y3
	D6g6XoL0H3xZ6UxWLO2sGviua3mAT9Z7zaWALlQ==
X-Google-Smtp-Source: AGHT+IGu9Nb7LzeYBiQRctkm+Mte+Uml7Mcg4Wm54UUxwsCVucNqjC5EhuyxtMfysFzkWUictLWSdMHJTlM05oWiqTU=
X-Received: by 2002:a50:d5c8:0:b0:574:ebf4:f78c with SMTP id
 4fb4d7f45d1cf-57aaaf0eb41mr1306728a12.7.1717684062055; Thu, 06 Jun 2024
 07:27:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606131651.683718371@linuxfoundation.org>
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 6 Jun 2024 19:57:12 +0530
Message-ID: <CA+G9fYu+5dfJMBsZFECzkWc1cxzqWNNHpaKfOcZhZ4frUJNCOQ@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/374] 6.9.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 6 Jun 2024 at 19:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.9.4 release.
> There are 374 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The Powerpc build failures noticed on stable-rc 6.9, 6.6 and 6.1.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

arch/powerpc/include/asm/inst.h: In function '__copy_inst_from_kernel_nofault':
arch/powerpc/include/asm/uaccess.h:177:19: error: expected string
literal before 'DS_FORM_CONSTRAINT'
  177 |                 : DS_FORM_CONSTRAINT (*addr)                    \
      |                   ^~~~~~~~~~~~~~~~~~

Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.9.y/build/v6.9.2-803-gfcbdac56b0ae/testrun/24217279/suite/build/test/gcc-13-maple_defconfig/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.9.y/build/v6.9.2-803-gfcbdac56b0ae/testrun/24217279/suite/build/test/gcc-13-maple_defconfig/history/

--
Linaro LKFT
https://lkft.linaro.org
