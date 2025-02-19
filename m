Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A637214A82
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 20:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739996041; cv=none; b=TAZFXrck1rkP5glrNwwYTPFCtQxNXpU/gs0ZQJNvy/jQau46TnKtXy5I90TA949NK8k3yilg5bNw4ghWoJJAVMDXJ+PYYras9P1RsQt6+AAFmp1pp5ZVGL4ard0Ix3iVgDwFeNtlSuI4q5TRNjv6eAMakyt3Tq7acNz3vrBmwlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739996041; c=relaxed/simple;
	bh=ncGs2z4pfHMjN+d3lpcfpfn98kj6rBfaHKbLUA6xG98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=npz8A+2rsT/6K2+brFUU9CtoDkWlyrhYKeDhY1C7b9VG9NIo0BnLfHpjAnnUQPnqJkF82I2hfEEL2szgP47LEVZ8b72Ram7+gGcy8nopJu1r+9SIpd+VaaHUaefKTCnJxm/gijNb/d7M4X9HZOyy3/WUrJ8MeCXssAUIGVrfns8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=Awq6Xmbh; dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b=hDkeHOi0; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="Awq6Xmbh";
	dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b="hDkeHOi0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sladewatkins.com;
 h=cc:cc:content-transfer-encoding:content-transfer-encoding:content-type:content-type:date:date:from:from:in-reply-to:in-reply-to:message-id:message-id:mime-version:mime-version:references:references:subject:subject:to:to;
 s=selector-1739986532; bh=ut4P1R7thuxaKMIe42U//2Z0wRf+Qh4WiJbioRnnIoI=;
 b=Awq6Xmbhiym8F2HZvToYTK3lP+Y5eTsASm6KRf0aGFWdro7wF8N31XFQw+5V8wsNGiIR5XfTt8mTPrliDUuTmlfpfhd6wS5o+G2UBtUvjowd3cdJgIWFQfkqVlW8fCiQpUn6fW7TJiTanYZanWK1g/49h0ljmCjRYMB7eM/wNN3/TWqYiL8cOu5DCPQq8/zsKRQPi2nvNANgu4mZSdBloMwLGUlQZhJbLiX7HYOx6pnSaLzMEeaQH3vmu2YaSOB/BNW6epxBq17swS4VITWMW6jb44mi6l96sgOVgfuDkPnY3n7e21l66mCHNX0Di1WnKGMXwG/FHBymA6uKkAUi8w==
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3DD612C008C
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 20:13:57 +0000 (UTC)
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5e08dfe2283so174127a12.2
        for <patches@lists.linux.dev>; Wed, 19 Feb 2025 12:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=google; t=1739996036; x=1740600836; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ut4P1R7thuxaKMIe42U//2Z0wRf+Qh4WiJbioRnnIoI=;
        b=hDkeHOi0qul8nA3Z6Y3QdqlzR+eZ3yhlSheF7JoOaHXU5sJywlOjkiSMHdT1+m5y6V
         PadSBZweCiznEUhcrUjdVN4mznjhS0OG1WJmwffbE/BNTyX54W914UfxCBWyM/GmEBLW
         guCbsXW/+YoVkT3H62GJ3VUmGz/qFRPGGY0DSOsGioZDA62COOuNhZmD7RGKIru/kZ8i
         WgXDzfP6rifcPzdBaJmIiWAa7aV0coD/hdIQeQuxJmygCH0bpTSH1XgnS2ta6XSioIrD
         AB2fwUezARPSMgUCz5DbUmRSS82BcOJvmoy3xuAd9XkZ/rxDhDJ/+CiTn7vb29BNQFLh
         d90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739996036; x=1740600836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ut4P1R7thuxaKMIe42U//2Z0wRf+Qh4WiJbioRnnIoI=;
        b=m1Uez6aulu5Xogyz+gChMimJxehsfU9QerxLxHSW26HEjV3AzmxzXIP179BONqze++
         LcVf0n6apmjr8QdM9WLe0IULZb1DQzNjZPCiyquPHkA5jyAScRRlKzTFXiaz9Zia995+
         98rcPdqtFrGjwoXscZyQltnez/+kuzZAibXsmwHepX9OS7qWaIfzXUgUinUi+dS7poDx
         rc93JueV1ZZTtZ3A117xsf/dsNe1FbJWZOGMLJaAHrVZtpXykr0w9NOKuokEWoYPk6Ud
         1eS4Xhil1IYBjK4HqDT+huotIZYwevkaa5A/K42E+Gwe4RKEKi9e5tankjD4HfYIsuBr
         X4PQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXpz6uv5WCqT/lmwGvMPFfxEsVWsxvHHaDTOyHnVUtGshebaXSehFB+UnTy3q+4dqiYFixidv3@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2+hm8Em0SK4QtmLFt+yJ9u9+b1d36SQnZhKKZXhI2yHP5iAt6
	BLArTQKjvC38deAzaPtMSkP7DMrLB4ZLYkExsKcd2wXiHxHcNuW6y+rmmS6YHnZVAKU5+kZeDUb
	KEUwCvjeL+PplSdSNYCjmBw2B3Zx+2Yz4eWQdwjWysa/YxlbHv85wJ6WSPhkluZ/QuYhZrl91qM
	0+3T/VU5SYkq/n+gQ0Kcf1lcAuOyDZ+3zosQI4kq9bCKe6enMLz1A=
X-Gm-Gg: ASbGncvyDQqdT0BTU2DdnCvGD3+KsBF+YgTzL2l5FBwBGNV13YSdx8DwMExtUdkxf9c
	Nfxwy7arypL13jzmweAPxCQD86XnulmLPwz/PESReCavIOBB79dkM28fAdh+tOg==
X-Received: by 2002:a05:6402:35cb:b0:5dc:caab:9447 with SMTP id 4fb4d7f45d1cf-5e036063e6amr49232754a12.18.1739996035995;
        Wed, 19 Feb 2025 12:13:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0KvQ9Ik3mCAFqGO1Y3HmZ0iJJC1SyKZfLV7M2w+N5UlImKuoI4YmqvkXHE+fgnAGu7i3sSGq4opUKSR07pFE=
X-Received: by 2002:a05:6402:35cb:b0:5dc:caab:9447 with SMTP id
 4fb4d7f45d1cf-5e036063e6amr49232642a12.18.1739996035270; Wed, 19 Feb 2025
 12:13:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250219082652.891560343@linuxfoundation.org>
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Wed, 19 Feb 2025 15:13:44 -0500
X-Gm-Features: AWEUYZlZSDPa0fGt2SFhUpS9xdY1jqEpDAGyJntR_9fKDs7gkaEck9SEpNdTnsI
Message-ID: <CA+pv=HNn2rhObW67iY-i0LkQoL30uXXxAbfWio7BgFCVp-0r3Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/578] 6.1.129-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MDID: 1739996038-LClEKvFfrG0z
X-MDID-O:
 us5;at1;1739996038;LClEKvFfrG0z;<slade@sladewatkins.com>;34a45300d431351f6eba03f8f221989b
X-PPE-TRUSTED: V=1;DIR=OUT;

On Wed, Feb 19, 2025 at 4:05=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.129 release.
> There are 578 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,
No regressions or any sort of issues to speak of. Builds fine on my
x86_64 test machine.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
Slade
