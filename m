Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795307074;
	b=p8IeJ88wEuUgeDWxuU1EZLeAXdlSabbqeUQXNO4QR2q6BRkdkS7oDUxNFcS4VtsFMXSA
	 ayTyiN6IMbf1xcRwh6gOdWddtSK7GejXvR/V/FEy+1JucZBiSUyFfxB7r8466iqRhbiuk
	 Cik1u70JbJF9I2u4PqhQN5FiAcZsy0fpIJYOK9z98oTraTWekipc69uUYPR75FtA4k6Bc
	 GcfK1ZfSKp6E223LBKeswmgRDjx1w9HpkIgQq8BwAqY1hCc03252iQnjvd0UsBa8sePWE
	 scwzai/crZMjm5GYx++WeO86VRmbV97GD7kwPnZWeF4Ag2OSRxLH1b6hpwfHbn15Ihg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795307074;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=7AutQAwdwwoaFEE4x44ILwTb8k/RmhAWlEsJY45jANo=;
	b=PtohiR2Zoi9mBL/KdDQs/SGC7nMAFpnC2BaFVC9CL6SKKqopeony2d2yag88BOnfFkim
	 Lmv349YX6UdLeZp+PwCqnUR0DrtWTmVyQzB6YQ8HX6myugff6JsoxGq6OuSjbzEwEMGjL
	 DR8cdYhm4CCXiRZGAy1Nkg5TlG1QxgWeymD+7+Q7z7FVsBK+p5Ut3qle8jMX36ZK1nNdJ
	 bET/AkxZvDwkMhcv1ms1vgKCGXCKXQz28Xxu23XCzmrVjBcGxLNTfWfo5p+KhgTw9FTOe
	 pOCfipYcjqcttVYsmGt2/sIHYNGLQbZ/Dgu2aZarwLzGCetRcJYrhE5+ZrgTiia8Duw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Kbs0OsON;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD402606A320
	for <patches@lists.linux.dev>; Sun, 22 Nov 2026 00:24:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD402606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Kbs0OsON
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4bb6adaf0f1so17864665e9.0
        for <patches@lists.linux.dev>; Sat, 21 Nov 2026 16:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795307072; x=1795911872; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7AutQAwdwwoaFEE4x44ILwTb8k/RmhAWlEsJY45jANo=;
        b=Kbs0OsONgui9fodWoLiEOS0DndshYk7o6SzeybuUdQVM975uAzqhO13oJQLVMW4FXw
         WLDRkKkCNkLAoIcN9MHMb8MtoxEBFTq4hTEEcACybsjPM2DsPAf4CgDG+z4rcvPxfcQG
         vMCSzlTt5XPRNuj272KYtfnjHBEN9AK9GG7yeiDFWKfZtgih/a4/rYkq2k8HIj1zUV45
         6q8lOOAh+7UIb1d0OJcV9vXoXCyflZYtrb9nahnBqT5e40pLsV7IvzS6DaTSPtPwEAKL
         /bPLAsCChZ+fnZ+Cgcb5en4C/XUG/mcPKzw4aQ7UIQb7zCbcia2cdfb4FZqusJch32+F
         ZPrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795307072; x=1795911872;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7AutQAwdwwoaFEE4x44ILwTb8k/RmhAWlEsJY45jANo=;
        b=fnYlFpU//1QqOa/DhBGNChhZWBG98dHQR9jNFpSwjZPthigsMNgodYqMswLoOkfySQ
         PWKqqhQb6IsXaJeCojKPDS0XoN8wR0DLSAwAL0zQ9Pa8eo+D4lIEJeK7aM6tOPOo+yot
         bOqBM0BC9D0nosmL2L/Svd/kRvKRHDQv1YzBtutP5MuICfPYU/74MgIiY5qxzNrVECju
         PEAsnQ78CULJpKq15eTD9sOkvTde9nnDsHYWembXRNmE6uDYqiCyFbmzRTGME+dRyfdU
         P912T9GStPu9CbAjO1p9EtYjgGezKVjNn4Q9jjAvGmaUi1nkJzaVhuChN+EHGhaEyvnj
         J2/A==
X-Forwarded-Encrypted: i=1; AL+hErFOvqhDRBywoVolTRmfm2bVKp5qiQPz6sXUvBxmDVjrqxbolSZCWLrHNDa40YVqsHvPwKaE1RB+@lists.linux.dev
X-Gm-Message-State: APuU4Z9dKKmW4DTacmOEnt8BwFOaayhEHePtsyVTHx86fGIUHTd4Uopz
	eEop5gbC2TFi/ghFBcdLZyPNoIWfG01rPFbOWTCGJjJh2/1iTA5xb1v8
X-Gm-Gg: AZFdTZf/TEqZZS9j8vVVoxJ2uEPf2VBDm5zxlSbjIOFclXrhEmMKikexmtTcn2RUztU
	o8eeviNN1vYz4pkcj7G+zC41A2rqNuJ8Gkd2mbuipfCQBTAzfaxdrywv+pa3xvmF6OLDWVTp+Fs
	w/MvUI0N9b1+G2mX0wAL5KoEtkpGkx0TbB3ANyq479liSQ/zkyjkhiwMpuCagaw7n/e2hOWarSC
	HiTIMRURNfdZvEfZn3ieyFuCSTzFoolsK0W6dXPFdatDjizsKr+EbXZJvjtxFLa+oz8EPlWcHRs
	nDpgJcJwcC9FIdvT/BYH+RCUjUeZg2cKTIbl8aFsXIfeu4l6IVaGqUVJmeLy93awb4C+8dLCtld
	N5GqiJUpN2UJNM60oFoDalXLxBUkprNVWh7yzZUgm61WmthDt+ArH8DzWSBwMqn+gVBT6GE54Mv
	UjFsfisRAz/jrSwajwZ4QKDZPMsqxF75ABeYfSZH708T6YwHmU3C3fWhEbGpPECRjyas0/dsJsH
	RLRri4pG0Ty5rmPCs2hTd/ZYSxTB7UTyDmk8aN9qSa1ZvCnCCVrVqAr/cWmfxtlGy+WjewhoxmD
	xC4RTktGX/aWsEfV3jHXaSfU5tZ/gs3aZhrlFSte2j4z3nvLswgLsq87qDshXg4hY6lQZ5wGppY
	YLWSA2H0zrck/PoNE+fQNnsvijRCqXQFvi6B+p3bvmz/JO872Ltn5hEZ/cUo/HCpCBYEoGUkD9v
	R1CaU5aA==
X-Received: by 2002:a05:600d:82d0:b0:4bb:818d:8d8f with SMTP id 5b1f17b1804b1-4bb88818955mr181628885e9.23.1795307071931;
        Sat, 21 Nov 2026 16:24:31 -0800 (PST)
Received: from eagle.home.marco.cx ([2a02:908:176:3bde:b462:7469:ce26:99ed])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb9066e34esm88663715e9.3.2026.11.21.16.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 16:24:31 -0800 (PST)
Date: Sun, 22 Nov 2026 01:24:30 +0100
From: Marco Schirrmeister <mschirrmeister@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 0000/2144] 6.18.65-rc2 review
Message-ID: <awI18u5yuXDv-6rT@eagle.home.marco.cx>
References: <20261120055114.182757740@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120055114.182757740@linuxfoundation.org>

On Fri, Nov 20, 2026 at 06:58:10AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Native arm64 build on Arch Linux ARM with 7.3 uapi headers and
CONFIG_DEBUG_INFO_BTF=y works fine, without my local __u128
patch.

Booted on an Odroid HC4 (Amlogic S905X3), no regressions noticed.

Linux habicht 6.18.65-rc2-1-aarch64-msc-lts #1 SMP Fri Nov 20 23:02:16 CET 2026 aarch64 GNU/Linux

The SPI NOR flash on the HC4 is now also detected,
thanks to the HC4 DTS fix in this series.

Tested-by: Marco Schirrmeister <mschirrmeister@gmail.com>

