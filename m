Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A55F3E2AD6
	for <patches@lists.linux.dev>; Fri, 26 Jun 2026 15:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782489572; cv=pass; b=rrv6hSBQkjOvqZYzo0z9/F3cw8M792olErq1+D1EnXLD726gpG8MQ2RLx7LVqbTr2baImx91j7mEWTXUh2w3Fq7wUyba9lMPBrzPY7hvcu+fNC6TkfGCUK78SiXMIPkxCz46FKP2u2F4/IS+7XGR7b7mpWVGYfL/mO68cLJMH30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782489572; c=relaxed/simple;
	bh=sa77kVbAwLb6akjpKfyR0FVo5MP9BFTqAcnkd0xKDjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PL9JhpI78A68qhOMG5HyMVRPh1NOjNdt+7J4Qt+rnj1S2FuKv1rPHdD4pzoey4HaxdCqFuZCbrx4rq/xXlp4vnAIKA3dof4IdoAqe7i7SnA+v58Scjy6jljRRORSwIBco/QRihRECOOcqoEXjRTGDrj4HB6bKUfa1YeidxglUMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b=q+p4Z8CT; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b="q+p4Z8CT"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bebb72b845aso188660366b.3
        for <patches@lists.linux.dev>; Fri, 26 Jun 2026 08:59:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782489570; cv=none;
        d=google.com; s=arc-20260327;
        b=WJki+Ra3+mi4rWnnmzaAAvAzPa9RCUYf9nAzm215+Pcm63QeL5Xf6uKXyOhxRaafsG
         /8PZ1nXISKh0bnIgcv1lhV0j0EuP90coiHvLvTX4tSnehGL8yjqCcYhv00JHYAED+lGF
         rAb8BA/tRbSVENuguNuUp9eo8qUINryq+5SQ3SYTsLE3VBeLx5I1VWBG+Vgebsod7zsn
         FMHt70E9XKS3FmSgn/i5qRNaiJGQVAeihBQ3UGUp5FDQPdGlVN2HKWSbR+yfIFSh4E/B
         rFje7O8PGm5ZKxlg2oGA8fW7b9eUTpuiGoKsCsUsPdNyjqE8FbdbHzQbVoIZr7xXX0fo
         ljlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bSdNcjBKXhemYGAFxDX0HcEA04mDXXcRsTRsV6T4JXY=;
        fh=4v3D1eOkaklR5XMgM+eWwTkCEX6RmSuF0QwH1hLpGFQ=;
        b=Tb96mjte5tZsSqBRnRtfbZt580VOFptaLHbvRjXTUbObtqmFWqcbtt23alhgWaCl74
         ISjRAvHM70VqVS8BgwB0W5CaApqOeH1sDpA057oWmy5L9VZWUHHIM8uwc6l6dmrCcZc0
         Hy82vUO34dpkWKSHq2JB6KRJw6NFa+kMXSPFTb7sBpavxnDdxqKCNORaeyvvMdSgzIJf
         ARr37twovraSxOjLpTyk0dgSTatLo74tMYxBG7LH7FCIoqaTWWyy50gMMgLafxAG5YGA
         ICyoqaAVoK6kkbR17NOFtsFfcnW08JTBeDr1k0Nsw92TBsFBi0RtdnbLuce3Dm50nccG
         Gxew==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20251104.gappssmtp.com; s=20251104; t=1782489570; x=1783094370; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bSdNcjBKXhemYGAFxDX0HcEA04mDXXcRsTRsV6T4JXY=;
        b=q+p4Z8CTYW2No8OahSbyCuxwEduS10A4v27/moChTcqh8BUd8f0W4WClnrZrKXZnGl
         scbjm47jLxj7OjAIJxxHIGBBoVQA+e4cMeke/RleWlczmDMTj14O+D0H8r1d0bHjw2py
         6UzJgcOZCHOvV8TseinNnMaSieLrMwAPRWuYtWJVl17k7WP1Iqf087snYBdhfgwepWV4
         eGOx46S/J6Z0brWu5sAX2bfGPWAZjirniMPWaCoY6ybcsBexbPcViIIZAqlDIXj8+8Ju
         c6b9BLUv1X0ISU/hKG6KCs7+629jnorfZfbmCg6KLawb61HLT5YXMzQpVXX8PcfkYadJ
         4e4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782489570; x=1783094370;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSdNcjBKXhemYGAFxDX0HcEA04mDXXcRsTRsV6T4JXY=;
        b=EluSrKRFxXilCe9ZwcvxGMTer0IEDKdADSaJZUpyl4XBAPO5auyDisw3oWVAuR0o9q
         DYYTRneUpYAvAG/Q6GGhFutpS/l0NeiE9sPwJVyHhzK3jsc2Pijr4lizWGTnQBTQXB3N
         ruKN+0o9upnA6IrwuKOeaEEk6QajUo9tCzZJcT+pnpzST3lwFiE82Pn/MOAdEYCbnYUa
         NLNnfcXGe/CoGLtfFnCBaxgNpmwXTif39wYFVTNrsNKpeGgr0J5GSGLLsFG9uKmc7Nim
         8OE3uM9mfAF01kVrl+VqHF6R5HloyE0leg1zkelaNRj/pFFEDpgPjaNNHPctE4aM8Csm
         2blA==
X-Forwarded-Encrypted: i=1; AHgh+RoKE9U6l6BgwYJbbppQTFB5vZqPVdDUOhiAbkV7nkDCNoMzRpCnEg+5TurcJ/dGk0SjHUq2i0Qs@lists.linux.dev
X-Gm-Message-State: AOJu0YyQ8Gz/7NQulySKhCuOPc5dvYQzk1ZH8XzNXK8Y11i8WDbK+ss2
	4jVgEdOu9Qkffd8c6eFNtkeBkPjCYkiHn1t1ED4zvYOtDK1ywfCroIVZOLMf04ZO+lexUvhIaG9
	T3orAdcsY0VUDZtuRBFq9EZYxpi/nfa82NpOt2QZAMQ==
X-Gm-Gg: AfdE7cmhS/Dbig+UsGVQUBN2PB7WimbmVS9wTCXry8EqIkKPwZNgx/47bsLNZq5KeQ8
	2NTTtcUHkhJpjQ+75kkbGW3b8jTLkbr03ku+x6qiHiA5WfQnXQFHzchbFPTGIuh4dxr9N0xJMK1
	O+TiNUYU+XaK8AFycRgME/msItufmt/4XKwBXfd3rSPBlC1JX045NILWznOx1PyDNZbjkRFez26
	TAxpzxVqyHKoShB1SvkcCTwam2y7C2D+p6nLj2VO/B8zdMsWtWgptqa+UL02K6HL2NwxypvAHBV
	y33r9vifb6S9ffIn1ViM2o32bEGt5ENnLIs4aMwxcsBqjgGyVR8ejG1n6bWRyySvIQSCCGQEv+l
	TWT/4f2XUkh7AWoYL003A/y5Lm9AXdXwwogT4IREv
X-Received: by 2002:a17:907:c49a:b0:c11:f528:869f with SMTP id
 a640c23a62f3a-c1205dc1c57mr485522066b.19.1782489569622; Fri, 26 Jun 2026
 08:59:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260625125613.243729608@linuxfoundation.org>
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Fri, 26 Jun 2026 21:28:53 +0530
X-Gm-Features: AVVi8CcVlvFIWZ3IZYi9detLPFCd_waRaCiCuFqo098eJ3zgk-_5YmbutM7qhfU
Message-ID: <CAG=yYwmzH+qbJPpZpk6UEWGzS-S-4VJ=az46wPJuJUuZrGyU-A@mail.gmail.com>
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

hello,

 Compiled and booted  7.1.2-rc1+
----------------x---------------------x-------------------
$sudo dmesg -l err
[   23.704215] ACPI Error: No handler for Region [VRTC]
(0000000042f760aa) [SystemCMOS] (20251212/evregion-131)
[   23.704246] ACPI Error: Region SystemCMOS (ID=5) has no handler
(20251212/exfldio-261)
[   23.704275] ACPI Error: Aborting method \TAAD.RTWT due to previous
error (AE_NOT_EXIST) (20251212/psparse-529)
[   23.704359] ACPI Error: Aborting method \TAAD._GRT due to previous
error (AE_NOT_EXIST) (20251212/psparse-529)
[   28.080686] ACPI BIOS Error (bug): AE_AML_BUFFER_LIMIT, Index
(0x000000032) is beyond end of object (length 0x32)
(20251212/exoparg2-393)
[   28.080708] ACPI Error: Aborting method \_SB.WMID.WQBZ due to
previous error (AE_AML_BUFFER_LIMIT) (20251212/psparse-529)
[   28.080732] ACPI Error: Aborting method \_SB.WMID.WQBE due to
previous error (AE_AML_BUFFER_LIMIT) (20251212/psparse-529)
[   28.081634] ACPI BIOS Error (bug): AE_AML_BUFFER_LIMIT, Field
[D008] at bit offset/length 128/8 exceeds size of target Buffer (128
bits) (20251212/dsopcode-198)
[   28.081647] ACPI Error: Aborting method \HWMC due to previous error
(AE_AML_BUFFER_LIMIT) (20251212/psparse-529)
[   28.081662] ACPI Error: Aborting method \_SB.WMID.WMAA due to
previous error (AE_AML_BUFFER_LIMIT) (20251212/psparse-529)
$
-----------------x---------------------x------------------

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology
