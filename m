Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E496E60D
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 20:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708633683; cv=none; b=Nr5vieYZpbgZmpp2ibbxRblXtJl7E+rLf9c4TedLzXDUJubI7I7sqlDFjw/v0sE8CAzIHd/s2dySjXunF1FdqD3r4Z2kH5nqc78rB2OGnAH9D8u82c9sEOvaKTqGgtfqCPQOj8zUNIFQDLfkNpm/uOkOsXs/Cx+T6HCUlCQzPRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708633683; c=relaxed/simple;
	bh=Q0oE6TAKOeGg7TRSoz97WttfP+sVDr0TwCb22dSeOhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JSMgMhajN8G4eDdyx1vBa/H/gd42iIo51cZPMV7ce/zF5iPtTjaHfkeJ+kMzJyVC7bR0Wk2HY5/5OlJcCjIjg73YvjovaS45rK+UF/F7JV1TqkkyWvojzBnQujMx4v041r3wnKbEAyN7BgEDdxjpZ9YutO+CzoUsfaBDwXogiqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xx5iSR+A; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xx5iSR+A"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4c01076b9faso80549e0c.2
        for <patches@lists.linux.dev>; Thu, 22 Feb 2024 12:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708633681; x=1709238481; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XUGFYzBsTBnCe9D+1RLKs/AQxHEx3a1SbCVCaYcyXs0=;
        b=Xx5iSR+AHBhmuqtiGRTmmdly5wXcboYT9YOHmoGy/i6c1bp38QcuNJ00CG5kuMB6iP
         wsocJ4eCIF1ScJmmLLgISD9b3qwdtYbe8FOwCw1CExBEDtrkbqmiptd5I3Of1q3ss6OE
         pO2wd+MLem/zfIiEV1cIQqw6YwHdA0M552LL+y5KDyZBjUJEl0aSbuoWITipa4lxSmuE
         CxNCMZJBGizYK6grblFWqhWHFqPw673jI/bjzRkTCaH2WNZkRW5fRFL80KNoJGekjr0H
         yzS5/lNYpwRc/mbWmDimbUWkiYAz1OvddEijMvNFyz30jBSNW++++zwexvWsrTo0wud8
         TrIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708633681; x=1709238481;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XUGFYzBsTBnCe9D+1RLKs/AQxHEx3a1SbCVCaYcyXs0=;
        b=nSxKsB5xWupyV9QIPvmXUcHyv8QcUgdWo3OkMgkIK2N3luOwwVeyoQOKkr0m8aAFDf
         4VxaUMwB5EJ/OhagmeUk2Dg+hDAMIkXs6tk5v89rwYNL9vjggL/48xRhBHqvV0KsA8UJ
         Z2ZxRnzzwhMXpXlZXt34a1FeAP+YCPPEuVWpTdfS64Wj3XzydKjknaqzVnIa1GWgsDno
         z4bpdPCa947X/E7O56G9A3H3dWd1BQDyD154eD2mPXPz+YcJDYHqpC6YDWFa5+e2dmen
         +esIE9QXbkuhCOYF4ELyrk/jSSWduM0s/mb2BSV/vEUZt3uiilY1bwRKTJ8afrUGERaz
         BN/g==
X-Forwarded-Encrypted: i=1; AJvYcCUyi21ZncGCBF8Ax/Ea1NUtlMNME6Uph2xcB3c39kbacFCtFYaebPrPkkW8g3NFD6MXRFW6zNR5JKzDYxziocKic9t8rBdSaA==
X-Gm-Message-State: AOJu0YyQwiHym3pW54FMETXxNLgTX1e7I6mvkzI7+XstDHw2R6pnaikL
	y2cKRORDGTjRlDM4oyWSo73UBT2wqiIGbNH/qeYIpAHpyGnA6k9e6AHz81Ll+9ng4D8PJe5RJgJ
	XP57LTxY6qJHh6BiDtEETiQCFfl4=
X-Google-Smtp-Source: AGHT+IGzcm51XqB/4oshCKEPTQnf9f7vbtkjyf06veyI/L/glAwnKLL6O3gAs2pu8wsxMkcreIHmxBcsoK+j6SvxbLs=
X-Received: by 2002:a1f:da81:0:b0:4c9:98f8:83d7 with SMTP id
 r123-20020a1fda81000000b004c998f883d7mr188242vkg.0.1708633680846; Thu, 22 Feb
 2024 12:28:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240221130007.738356493@linuxfoundation.org>
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 22 Feb 2024 12:27:49 -0800
Message-ID: <CAOMdWSKKpAV_q7q+mbRo=DQm9KJp_73-Q9-Vpgz9bVv+TDCEUA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/476] 5.15.149-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.149 release.
> There are 476 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.149-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
