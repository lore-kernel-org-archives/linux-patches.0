Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0D64422
	for <patches@lists.linux.dev>; Thu, 18 Jan 2024 02:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705543913; cv=none; b=IknJYspcpwHtmnwEEasqh97f5wgbEDp2SKO4VgoeN8+++5aYzwSCR4yrGvOIuJkajBgPisM9nbx03GLUFcCDh+H2yb1o330EsmAT5Jf3he6ILF8kIXGgIjcjYjn/Bc8UelWjZU2GVqhMRMMbBhazIpIh+JfPd/QNg2ZvKHC0ZYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705543913; c=relaxed/simple;
	bh=i0Hg10Dyup9X2c3xTgF/zfE0rATo0lTALcE2U24rEtY=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:Date:
	 X-Google-Original-Date:Subject:In-Reply-To:CC:From:To:Message-ID:
	 Mime-Version:Content-Type:Content-Transfer-Encoding; b=R7JyuagKQOK+X3RSJ1TDcx67hclqJ3qSw9v5tzDA0StKDnZQ5X2snelObyOF6e1EmJSXHpuSWFexLsHKF9YuDxGzKpNW27Iz1/aJ/wrOKZGLX8Rfndz+ssHrtsErPgMhjdT13+1DhEL9+0gffDvkTuM21WlLAiw8mM5r7yya6oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=X9i+EYbM; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="X9i+EYbM"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d6efe27c1dso7628235ad.0
        for <patches@lists.linux.dev>; Wed, 17 Jan 2024 18:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1705543911; x=1706148711; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3GxiD+C5XoSqxhbWjkOfmxyd0ivTIk3zxlBcPpdRnRk=;
        b=X9i+EYbMNMzxXaVgNAvJ6EzJIA/3w2Tx1Tfo3gmEvwKj2/rcVSrlNN4B1RyWvzPEFR
         AmJmcftyupBhJWretzeJ284o+vtX3WD9Xv1X4oW4LDrPTe3+r3manwbP4Wy9zMI3oJuY
         Epz0iQDAu84eiosN1a4qvPFDT4fQrRz7s+OOjKARYf5i3F3hWd4uD2Llj9RgBP330axS
         2jwyZWeDcCK/tpzM9opkx02acZvOLzMgwJ6TbxYzfuA8UV7McHmtpH0OilzM11XfyXQn
         h8Lkm+3HR3RmHKOtz8BXQR6k9FbKFMjXVL4ZU0S2KMFlSjK3qOBySxxhNIbYgTCZYtjo
         GDhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705543911; x=1706148711;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3GxiD+C5XoSqxhbWjkOfmxyd0ivTIk3zxlBcPpdRnRk=;
        b=ojMfJeG9Jg12Ygm7G88B0VE7uW0qrQyzJmPXHbI+VO/zGuXuMkoSUtqaXgAVJCtekO
         xUUYwq3Fq8Db6IEHjUs4i944yF+ngXEevVRA/0nbJOPs8yrNuxHsoYMW7YU3oYBhHLal
         OkL17I7pWr31KK6Kzij6z99ANzvlCiqBkrqdpHn2R8RjWTn0DNxO2EcZhl5NSEy3B4LG
         eXi0Mk1VTQwiRwQL5JulaPaKlqPPL2w8b+LYavX7qyaZrP5x+Pwq2jxhMENyjuk6PUyo
         GThgCyBIFG2VJ1BQ+V3sHpN0kY4mRjuWHX74y/pzb5+CuiXdlL8mcWrjCsr1i0Ni0kmE
         AknA==
X-Gm-Message-State: AOJu0YwooP9N5MZmhD8GflJqW+3PFP3jOE1pnIXyyDPnOwwlP9QmqX7M
	S04pVraxJ2gnTLoJnQHcERM7J64sNkgOEbeHoto2Q2P9CHh1IubcF/7lYmba1hs=
X-Google-Smtp-Source: AGHT+IF1H7DeUCLS8hvg6twzPV4HKfmWrjCdGRY317R5hDysJa1jVFjdplvhB1jqQV12uhi7ioh8Ew==
X-Received: by 2002:a17:903:2449:b0:1d5:30fd:26b6 with SMTP id l9-20020a170903244900b001d530fd26b6mr262259pls.66.1705543911191;
        Wed, 17 Jan 2024 18:11:51 -0800 (PST)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with ESMTPSA id jx16-20020a170903139000b001d4e058284esm305758plb.89.2024.01.17.18.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jan 2024 18:11:48 -0800 (PST)
Date: Wed, 17 Jan 2024 18:11:48 -0800 (PST)
X-Google-Original-Date: Wed, 17 Jan 2024 18:11:20 PST (-0800)
Subject:     Re: [PATCH v2 0/3] RISC-V: Disable DWARF5 with known broken LLVM versions
In-Reply-To: <20231205-riscv-restrict-dwarf5-llvm-v2-0-aedf00a382ac@kernel.org>
CC: Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
  Conor Dooley <conor@kernel.org>, maskray@google.com, ndesaulniers@google.com, linux-riscv@lists.infradead.org,
  llvm@lists.linux.dev, patches@lists.linux.dev, nathan@kernel.org
From: Palmer Dabbelt <palmer@dabbelt.com>
To: nathan@kernel.org
Message-ID: <mhng-ebd9adde-eb2d-44ea-a8cf-f811dff3f70e@palmer-ri-x1c9>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Tue, 05 Dec 2023 15:53:49 PST (-0800), nathan@kernel.org wrote:
> Hi all,
>
> This series disables DWARF5 for LLVM versions where it is known to be
> broken due to linker relaxation:
>
> https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16f649fc21dd18e5b0918f6
>
> If I understand correctly, it sounds like GNU binutils has a similar
> issue but I am not sure of the status of the fixes and such, so I did
> not bother with checking for it but it should be easy to add if so
> desired.

Do you have any more info?  All I know is this add/sub/set mess we've 
got, but that's a cross linking problem.

I queued this up for testing, should show up on for-next soon.  Thanks!

> ---
> Changes in v2:
> - Added patch 3 with Fangrui's suggested improvements around
>   CONFIG_AS_HAS_NON_CONST_LEB128.
> - Pick up Fangrui's Reviewed-by on patch 1.
> - Link to v1: https://lore.kernel.org/r/20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org
>
> ---
> Nathan Chancellor (3):
>       riscv: Hoist linker relaxation disabling logic into Kconfig
>       riscv: Restrict DWARF5 when building with LLVM to known working versions
>       lib/Kconfig.debug: Update AS_HAS_NON_CONST_LEB128 comment and name
>
>  arch/riscv/Kconfig  | 14 ++++++++++++++
>  arch/riscv/Makefile |  4 +---
>  lib/Kconfig.debug   | 12 +++++++-----
>  3 files changed, 22 insertions(+), 8 deletions(-)
> ---
> base-commit: 2cc14f52aeb78ce3f29677c2de1f06c0e91471ab
> change-id: 20231129-riscv-restrict-dwarf5-llvm-a9824bb974cb
>
> Best regards,
