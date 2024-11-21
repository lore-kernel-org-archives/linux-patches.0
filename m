Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2BE74C08
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 04:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732162217; cv=none; b=fDtwmhp7NxhtEzul178DJRPreR8aeAwHdr7pTRaaE/zv/gj4eKgjlkR8WCHiWaTxweXgU/+QE2PYvaA2JgliMiA0pJcWo/BbD+vfzllAbUm9IzIdNDaUDgOztvGzORaJCa2NRhxL2UtLFIApUZHCRFq0jTa9La0ULV3WkWM+j/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732162217; c=relaxed/simple;
	bh=B7xihZT26qiygX0gKCUDPAr5CIdT5RCJ87wuM5RULLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f81w4PeZQv29kltCcoarBd029r3XO93TprIu4rSEL0qCGzB/sqqwk1lfGUPODIZc9ELNiBLIaT/qvzbiS/IrD3AxwKUvDEjL54G1gNbgqwvNwZw1Fpsq0Bcz5s2wL27G4MVw0t1wj2OttPodemDcF0Ufrkb7klceXNm7YDsgXms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=UiTZZHWe; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="UiTZZHWe"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-720aa3dbda5so365965b3a.1
        for <patches@lists.linux.dev>; Wed, 20 Nov 2024 20:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1732162214; x=1732767014; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9eW+fFrqUQmQKRzIcmuovs8hOwhvb53DeD1uVIRrkq8=;
        b=UiTZZHWeIkyeNFn7+5th89fSgYbcuZQaRHfCjcvpqj3p+nGM1wPR/OJVpacz+buTrs
         XMxB7mBPvOhpQxDwEWtXe7AsmJKOBp4q5Uudgc54gtSXx3b9mBlnwXleuAZ1/ZGr2CpA
         HLGRIIBITdFCza68RU3gSFLJZTpL5G+ZTzH42R+zFFcxdbj0J7rFZP7G+yRUfHUVwpzm
         o+fRgFcG+ujJdl8BSYuVkJiKwpWFcWLhdGBmB3QrMbRdidhaTDlSNrq/1XZc/KWJAPyt
         WBTXeah0UmRRGxMyAOMCkK+pJt3/EuYoyp23Tv0OMhKbLCWHlUtSUfKxHCaltBrn6Kkn
         T7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732162214; x=1732767014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9eW+fFrqUQmQKRzIcmuovs8hOwhvb53DeD1uVIRrkq8=;
        b=ZeEffic19UXwshhZFIoaIg9SONz36KO9kaywkRE8YWSTmB4oNnSj4wy7xeLeBkUcAG
         pUwM9ujHOJoTDPHSF0wEAsTAFu06R4pWuxrIdqDX7utQK2IaxjOcRPa7mDEYsygo155/
         HwX8ZOc/TgP5D8RqSfBdL8x/ixlPg3ccwr8V+2epSLfOMErrvl+lTwRNvactjcBqfBpq
         pq3mZlI1O+IDZxMlMAVoAdXM+wsGhOzbkUA4jYWDNl2UJXjY4H4eHHwYRqs9h9CC0z+g
         I4sxvNTjIVztojsWqZXzoFGtY/rB8VFasTtWOLbkN7KxckMdrBhIr2N2PhTC++q4GiKo
         Hifw==
X-Forwarded-Encrypted: i=1; AJvYcCX8L5puXpfWTUKArZ86YIZweKEX+oaUflDbMRCgQxtbPDyUgvzfmXy4uUoL1Y9CI/G8kI13CuKm@lists.linux.dev
X-Gm-Message-State: AOJu0YxuueE8r0rXIhCqgbc8Pfrsql/gqiWTlxcBNp01LPP9oPZeFia2
	vvxWWmUXNvibB9vEvxWF+uXzhArnD9pPei2+xNVm2PMRZQcLdPAGlIhFoyhpZEGWG2gbHHax0PP
	ZV8suGjv1r4t9XrGde5xjOZor0yR7J9E2OVETYQ==
X-Google-Smtp-Source: AGHT+IFdPQvHbccmjyatlDgiS9cIuoXmk/x192oJMaXaoFIZ+y7bREGGD/Gs+VCdZ7po1w9u+EDS8LYFG90e1gtySXI=
X-Received: by 2002:a05:6a00:1743:b0:71e:702c:a680 with SMTP id
 d2e1a72fcca58-724bed98ce6mr6543640b3a.26.1732162214596; Wed, 20 Nov 2024
 20:10:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241120124100.444648273@linuxfoundation.org>
In-Reply-To: <20241120124100.444648273@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 21 Nov 2024 13:10:03 +0900
Message-ID: <CAKL4bV5EzB3HVJQ7YcpyhMECmjfH3B_6JcJxeuuxrE3+Z0vNZA@mail.gmail.com>
Subject: Re: [PATCH 6.12 0/3] 6.12.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Nov 20, 2024 at 9:56=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.1 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Nov 2024 12:40:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.12.1-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.12.1-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Thu Nov 21 12:38:33 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
