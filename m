Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D851C84C8
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 19:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739562196; cv=none; b=ZN73h2URjCEWK4hhD9t8OloGHGfx/XBhTjoUqrC1JzdQMhJIb63wZVyIQp5kPvTN4Bw101kFBoS/atf98cxqri00PZCfjb+upONIXgBapYGEriy/aGA+xYKlwCND+YENzDVVHWTYb1tMpMOLcRy/P3bz1JOJmhyEKSFdzkYKsjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739562196; c=relaxed/simple;
	bh=Q56QkAqSvsIKQBhKc9/nl5EaiJ4PZsSBDuJjpKC1AuM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZZzBuKNZI5tqFcUuUhdKvWowyes9AmFkMOT2AzabG2ceMSadIHxAbQQeAL4zx7wNxTFakxMmT9JbrHH+TfQq4ym42FWpPd7QWKhkPlgtaJc6MkYXqOc4Z77DKi8s53vBThhqX0kEp/7JMw7QdjVMeJSUaYTOnNodLxhd+KPpCis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sladewatkins.net; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins-com.20230601.gappssmtp.com header.i=@sladewatkins-com.20230601.gappssmtp.com header.b=SZVUc2Rd; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sladewatkins.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins-com.20230601.gappssmtp.com header.i=@sladewatkins-com.20230601.gappssmtp.com header.b="SZVUc2Rd"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ab7e1286126so425348766b.0
        for <patches@lists.linux.dev>; Fri, 14 Feb 2025 11:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins-com.20230601.gappssmtp.com; s=20230601; t=1739562192; x=1740166992; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TY0DoOA/s8kkBWd88tL/y1YZXdpMeL10h/GY/yl8oOg=;
        b=SZVUc2RdIG4/I3jYDu3L+YOEI3gVGRaZUYRXxqY7/qUyfz0+Cj+xC5TkmWF1H1XXAl
         dXSLsugEk5+VeyD02E7oHnkORC3QVzjPWL+BCQXn3A8hetZjiMy1zgR2oUpy5K01pIoq
         MwiXCiy1PVI1TO7HOMe/eRUscTSay2OlvoZYWITAroWWj1wbL4DIkQBDsffsdjvxxjD7
         BZS3+DDIUJCi5mhtvc32M+mG6LnEuTWcsdHfxEUgskBnrZ6Rbhj9efIBF3jsg/crTfhn
         NI6DSiqK717BmmxM9AHAxoFZVQz2Q9Jjp6/rNYwN2LxCiIJJeVOyr8XS7pKSu7t3q1Pg
         BHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739562192; x=1740166992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TY0DoOA/s8kkBWd88tL/y1YZXdpMeL10h/GY/yl8oOg=;
        b=hEBhySlQPWng7nZ/NijygQ5q5rJ4KFcPKJL2WK8TR7cnBoZ43wTOjNz87N6AGkv8l/
         CE/KSjDiOdsg+diMtSiCdnd9BrUAVm0YmDQPuCKjvpDGiRAs6pmlW+8S341haHbUWqTc
         2EULXV0cpjziV/fKVw3u45pUaJ4uYWUDmG26OC05+VphuTv5R/wsQSfcTrwMZxcoyHjS
         u71Tlcpjvd5dsiizhgz19jtRARnN8mCMUURoVyjzFS1CnVL3/GORvoRQPk1Wr+Ai7Pr/
         yFXBDtxcm7BCBjwRFjry1Nbk1t0mr0DmYyy/I81UN6zjwi239Pvr1gxlvG2RNbkAF7P0
         BIDg==
X-Forwarded-Encrypted: i=1; AJvYcCVU8Rdd3BALRFlRnc58pVJFTeED2/EfYEuchZLW4ukrGUkcUh9P0QE/iVy3c01mTL0OktIhlgzx@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0Myi8W5DBf6OPIUY2+fQquC/MoogQFgi7fD1ty35cnaN4mOT8
	OiT1MJEpyIc7zM+UsWM+BwdC8vtjKR5faKMfVfvWw3AFwiPviu34EOA2qodaVfHjE6ClLhhUrX8
	GwbVPpNWX14uL5ynIshR0puHQ1NHsk7itlKv6OQ==
X-Gm-Gg: ASbGncuRTc1zJ4sm3NMbj+44GEsMR5id2OUnzH0ZNXS+L62O1j7PDVHvIH/hNc3CugB
	k00n5mVN/QYEFlbqEM/vr00BlUvjjde866wjxsl90awP+QESTxVDziBzOr4vtNFtYPQ0+R0w=
X-Google-Smtp-Source: AGHT+IE1oGc2ZQExbVhQL+yj7D6/9XuOay+H9ZYPuFBGVhs2U2fRcRQf9e/FV030JbpAF4s0bLXtmTSrCHVrj20z6WY=
X-Received: by 2002:a17:907:784b:b0:aba:6055:9f5b with SMTP id
 a640c23a62f3a-abb70c01eadmr33484666b.2.1739562192539; Fri, 14 Feb 2025
 11:43:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250214133845.788244691@linuxfoundation.org>
In-Reply-To: <20250214133845.788244691@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Fri, 14 Feb 2025 14:43:00 -0500
X-Gm-Features: AWEUYZnRv0kmWQ8Wfq4_P-n3RgbAjB3ZTI3Gtrs3oZe14Y2S4Ma3FjndvU69qsQ
Message-ID: <CA+pv=HMHE=uB2ya2_bd43H5H__Nay0nXG6cQH93ueC-R1K7YrA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/419] 6.12.14-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2025 at 8:58=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 419 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 16 Feb 2025 13:37:21 +0000.
> Anything received after that time might be too late.

Hi Greg,
No regressions or any sort of issues to speak of. Builds fine on my
x86_64 test machine.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
Slade
