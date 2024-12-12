Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0593189B8B
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 18:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734029330; cv=none; b=sniBDVLgzwktFZEXNJ9oMODogFxW7V7MeCDV0bcdBam1VX6MyPDiamx5yIuZygr0THM/a1n6J4zFI0OtS307+DfMxHWhM+DPsTeXQZOnXg0mb5PbaXyHADeYZIUscFLrKvydYY9A3ERPrOakz2A8E+GT5lB8mUbGAWh0gXVXVpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734029330; c=relaxed/simple;
	bh=QKQL4MS5nZa+ROMEXkXGLP2EpoqfuvY8r+Y2F7K489w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=m+tM4sBNgMVq83S34gRYF5M6/Q/uHf4urm2SNVC6gZDOMfSDmi1Q9CDm6BjvY6TG5S7HYv8n+usRzCaJGh62Ewr7yAHv5Rr5dusESJcpErB0daRTa0uvRPM+bFBygJAvr24HeDhRTjD+YGRm3XzM7BXdeN5NxXB6ciVrloc6e6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OBTnHCCg; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OBTnHCCg"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3a7deec316aso3601415ab.1
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 10:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734029326; x=1734634126; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+NEanoTkIUxCO+RPtP6A6ijL8u3YML6PUoYR1PXvvOM=;
        b=OBTnHCCgKKE63aS3/MSSialaS0vLw8wwO0VZbXO1U6WHRAZgUyVJwUqyBqvaZapM6c
         UoEIE0URB27gRSV0wEy9gYGgyICUUM97Hug9jXiLvheQzHNX4jWAs2DPCqm5V94lh48c
         lzLFl2BD1QIRlm5HKp+rEkKLiYLmgQHA51g8cl1AWyXGleisWFPTq476/+r5ur1NzXxF
         jGfOqC0lTWhjviAG08Z1gT46f3LjGSV/+k3XGN6FCFa9dRvWP3vbY2Yrt5dmaLt5F8l8
         VuKu2ymszuVwGPqk85Kt0gs+SjaFkHowLtvw2qbKam1gxdDuu4AukT3f5Gf326beINne
         QT+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734029326; x=1734634126;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+NEanoTkIUxCO+RPtP6A6ijL8u3YML6PUoYR1PXvvOM=;
        b=qsnXf01nWD+QEiqT7weEe4G7tXhVLoweWcPAMraG7OHpEbhGYWUMuEATOCqtedM1ij
         24lSN8oDPdZGdwycZtyBehqWhSswdYgB9n7BwQsMxKfWuWUN/0wPS/HhweoHiq92Obom
         BOfLQh7TyWFoL4K0PsvGBiPXgOfjfOblWWWeGSAM4YH1K8WmpZXJjYc427NenxioFeX1
         /gNM6tv2eXkw3Z0ZXhxJd6ElFTudywTgtsUpNbBR9KpCP1iRrOza0kdkPNEmlXUfURRX
         7rDVT/xGkiGGfXC5/TT5iYWIX1RrgPD89mXANAdlCEOIO2McXte7RoDmyb8M78TFHyQZ
         TsGA==
X-Forwarded-Encrypted: i=1; AJvYcCV3rwS4xHIhdNXluqudlQDKOw4ImIALLEYyU8NfiuMLDY4XJzL64zmPGLkFCHY1MfR4PirFLVHI@lists.linux.dev
X-Gm-Message-State: AOJu0YzecYJALdf1xNx5wVOy7KDqIqZkIQmon2CeGcEL2wSX3kRn0sth
	HEJJRhHq1fnnQ9EaNAebFbTDYAS0CaDSSnIypOhi/vE4oRBDLIFqXZbZz1rHYG4=
X-Gm-Gg: ASbGncui50khRV9IESFyuJS8kNvUselJ5ASZW8s+jrWwslAx/nhT7Pl6Mh+B3jK1u3p
	3zS9tNNml1g2BRJmXG8643NBAE/0vEuXVVizB0FMTiEU4h1eN3DtzN88O9GV785EMDAi7fZdewo
	FKvp20r0nQV2MkblipNcQa22LkPQ0M0fJgUARe8pdNKauhC7K+/IXTJf6STDBBfHBNXZhDIr9WK
	E7kVKvIEhLrOSUndKgp8+RzoJOT62UzqCB/myl/KRNm36I=
X-Google-Smtp-Source: AGHT+IGhhvkFg5+OlRRW7dAh+LXxFzeHxLNLeGbrpzVSX1Hr5klBw9D+P9RZ3N63ZKwQ7KiNLlXZng==
X-Received: by 2002:a05:6e02:1707:b0:3a7:fe8c:b015 with SMTP id e9e14a558f8ab-3ae5953b1fdmr15053365ab.24.1734029326669;
        Thu, 12 Dec 2024 10:48:46 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a819dd4ac9sm33682775ab.12.2024.12.12.10.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 10:48:45 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Nathan Chancellor <nathan@kernel.org>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 David Laight <david.laight@aculab.com>, 
 Linux Kernel Functional Testing <lkft@linaro.org>, 
 kernel test robot <lkp@intel.com>
In-Reply-To: <20241212-blk-iocost-fix-clamp-error-v1-1-b925491bc7d3@kernel.org>
References: <20241212-blk-iocost-fix-clamp-error-v1-1-b925491bc7d3@kernel.org>
Subject: Re: [PATCH] blk-iocost: Avoid using clamp() on inuse in
 __propagate_weights()
Message-Id: <173402932544.982680.529127077152903218.b4-ty@kernel.dk>
Date: Thu, 12 Dec 2024 11:48:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Thu, 12 Dec 2024 10:13:29 -0700, Nathan Chancellor wrote:
> After a recent change to clamp() and its variants [1] that increases the
> coverage of the check that high is greater than low because it can be
> done through inlining, certain build configurations (such as s390
> defconfig) fail to build with clang with:
> 
>   block/blk-iocost.c:1101:11: error: call to '__compiletime_assert_557' declared with 'error' attribute: clamp() low limit 1 greater than high limit active
>    1101 |                 inuse = clamp_t(u32, inuse, 1, active);
>         |                         ^
>   include/linux/minmax.h:218:36: note: expanded from macro 'clamp_t'
>     218 | #define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
>         |                                    ^
>   include/linux/minmax.h:195:2: note: expanded from macro '__careful_clamp'
>     195 |         __clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
>         |         ^
>   include/linux/minmax.h:188:2: note: expanded from macro '__clamp_once'
>     188 |         BUILD_BUG_ON_MSG(statically_true(ulo > uhi),                            \
>         |         ^
> 
> [...]

Applied, thanks!

[1/1] blk-iocost: Avoid using clamp() on inuse in __propagate_weights()
      commit: 57e420c84f9ab55ba4c5e2ae9c5f6c8e1ea834d2

Best regards,
-- 
Jens Axboe



