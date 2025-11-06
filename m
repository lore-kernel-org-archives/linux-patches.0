Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4BB1B425C
	for <patches@lists.linux.dev>; Thu,  6 Nov 2025 00:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762389615; cv=none; b=FOpSueSGFhL8zX7PXl58aShHlUQy38gZHLx+umRyERRWKqA7PJ6h9oFYwANMpZXayjW6+l14S63iHjVxpf6zMjik4JQT3ebAKRvcb+otZRStnfaB2R3GmQ5lEwe0Cxf6tcALD1dve/IwaYitqJF14f5EeWiiHzz+zlzZyJ3jEXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762389615; c=relaxed/simple;
	bh=rue2bCVLqqgDBX61ZwQetRzMYMuU2vRzhd7cN9vguj4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mKnhF9WEsUQgVwB58Y7BwwIewNKecjGXp7uyjmWqPjYolNnf6eCFkvLDliyZGghtYQs5Zvd2nrfmFHQ6p4shWFTnBsNz+xL+MyKdDjlgsU29T++NCJeUSKPSagYRterSXbL00V1jfSAFR92B33GQ9BRCrMjC/QKwRhVCeFfMJ3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=UeIG2x8M; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="UeIG2x8M"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-33067909400so352495a91.2
        for <patches@lists.linux.dev>; Wed, 05 Nov 2025 16:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1762389613; x=1762994413; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y4Fdh+kQLyNyqbGV17ENMExDWzQqmTQ2Vs89uoeAIDg=;
        b=UeIG2x8MM79W52ggHlC3QS8bpbwNQMeKpSIYjeQTwvSRflrDGlwJAgI3LmOVH7vumH
         bRdxuv7ZtslImXAbDznq/M8AMS9adLsSar3wuEuyc8VdLM+r6XgWKqBvs+0QWpeapQ+8
         94FCokaJC+0zugYmJ2keyJ42Ja3IqYZ6lIkO+EWh5x9DXupSu2ffHTzXno1TMNva2be9
         Uv9seqVe9TC96zrDNJ+80p8nlX6iY3bFj2mxiXpEq7NdNuYkMsWSxFR4yatiiUGFstJ4
         gGzInRHyeE0clZc84uhqWRkLrXKPbfuv2BL1wpC9Ow8ojcbmyhYN4GM+SddzL+JoJk0c
         Chfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762389613; x=1762994413;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y4Fdh+kQLyNyqbGV17ENMExDWzQqmTQ2Vs89uoeAIDg=;
        b=mpXSk1Z5RKKuHHn7uMLz73ew4Wf6ar8kL4NNmfVayjXSzrGUrlojWzzOhhMWlmiSfT
         Ah2prRNRVsvOdKvrTupomHf5T6qHNsYz6TivssbBn5nGMLYezX+MytpnUiRtlosu8wdR
         W5vvEmM0wk67TAI9UpJ0oxIGUar783qafXLMgVxHd5G0uZfmUUWGGLHL8z2KiqAFbFiM
         1uUKtar0nsDPbGWqeLjcetf8rR4jkCZ4Nlyia5Uq8OQZNRb/s2i5ZnTDw8GQVKmk23sK
         UTMVZKfYysfOOlZl/ivP8XySqTp7WiPJGSxJAU5BPlDK3qLMEoXPGRh8uvvcc+5NXNLc
         nsLw==
X-Forwarded-Encrypted: i=1; AJvYcCVnwsokVruti9UpU0I0tQTuCsHgn9cLrLJDukqhhajiJ+kNGGNZGwLCgmekqURC6cP9yqab3sj8@lists.linux.dev
X-Gm-Message-State: AOJu0YzUMSTLci+xvfB2cwlp1uPWZQ8Lj+f5haCLGVCDYL4Ms8+lthOR
	Hy6SeGvC3EV2PNnMs6YK96QQSIXJhqrvu4XROBsokWizTzjrEWei65PZzrB7VdyW7ByAOmKPoi4
	ElKf4
X-Gm-Gg: ASbGncv46g4puepZo8FocAKrJLydzUpOo5zNl7VrfoKUUJxckPMFPIATpzR74C5O8IS
	lZQKVWraSgKisJVqQnj41UtgRAo2VHYd0ZDCWDTthoH+/d0aX8iVz0fCCdwF+T09MdOdkhjgTex
	nBvZ+lGYVXya4VtmLQVj6nG7eonx0FVq+AxNBGIV8oOfJOxqLVsnRq6D6n2RSjrgLcDBNhOgPEu
	mRK2HFmj0nXkvxS/y0YWAGj+H4mW7pbUUioGhvb0wXJR2WxUqCwVGQZFXOVtb1VIxAV6VYHsAno
	108XJTNGGGTPqWFCSeXEeS5+z6+7LCbkwNevQ2em1mq2tEjAoIH390256T5fJH+pp7wmDX25mkV
	ydvbpbUIDx2fKI+/Epbxroxv1H64uuy0vxdbZTMGAXxZrHQ8lpSTGvIJ3lT6sI9P3OvWEdSVoHw
	==
X-Google-Smtp-Source: AGHT+IEcLNKZAx7Gs58quiN/BqhCrVzUdA9uzXWTUpsiUUbQ/IIuN6vGZJk0KYstqzmC11nr84QNuQ==
X-Received: by 2002:a17:90b:4a84:b0:340:be40:fe0c with SMTP id 98e67ed59e1d1-341a7009dd4mr6232479a91.36.1762389613281;
        Wed, 05 Nov 2025 16:40:13 -0800 (PST)
Received: from localhost ([71.212.208.158])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba90307193fsm507604a12.38.2025.11.05.16.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 16:40:12 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Tony Lindgren <tony@atomide.com>, Nathan Chancellor <nathan@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Schiffer <matthias.schiffer@tq-group.com>, 
 Alexander Stein <alexander.stein@ew.tq-group.com>, linux@ew.tq-group.com, 
 linux-omap@vger.kernel.org, devicetree@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev
In-Reply-To: <20251105-omap-mba335x-fix-clang-comment-warning-v2-1-f8a0003e1003@kernel.org>
References: <20251105-omap-mba335x-fix-clang-comment-warning-v2-1-f8a0003e1003@kernel.org>
Subject: Re: [PATCH v2] ARM: dts: omap: am335x-mba335x: Fix stray '/*' in
 comment
Message-Id: <176238961246.3045323.4889142584936333323.b4-ty@baylibre.com>
Date: Wed, 05 Nov 2025 16:40:12 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-56183


On Wed, 05 Nov 2025 13:41:09 -0700, Nathan Chancellor wrote:
> When preprocessing arch/arm/boot/dts/ti/omap/am335x-mba335x.dts with
> clang, there are a couple of warnings about '/*' within a block comment.
> 
>   arch/arm/boot/dts/ti/omap/am335x-mba335x.dts:260:7: warning: '/*' within block comment [-Wcomment]
>     260 |                         /* /* gpmc_csn3.gpio2_0 - interrupt */
>         |                            ^
>   arch/arm/boot/dts/ti/omap/am335x-mba335x.dts:267:7: warning: '/*' within block comment [-Wcomment]
>     267 |                         /* /* gpmc_ben1.gpio1_28 - interrupt */
>         |                            ^
> 
> [...]

Applied, thanks!

[1/1] ARM: dts: omap: am335x-mba335x: Fix stray '/*' in comment
      commit: 35c973187f59328a5a58be132bd83ec2fe076620

Best regards,
-- 
Kevin Hilman <khilman@baylibre.com>

