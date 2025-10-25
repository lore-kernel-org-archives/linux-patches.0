Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DED3002D2
	for <patches@lists.linux.dev>; Sat, 25 Oct 2025 14:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761403966; cv=none; b=I0qIQVsFK1MOgzjqS1VFjZmpUc0nccTjiqSPmj1JKjK9eb78g36LiY3xEsfhPYf8K655wmZBsTGrRC4lW7JyKBjrW5zJfO+ce1BDC/TCHCOWvquW6uIyT24Il6jD8g7Tl/ixp2ppGzhaH20pZqEelLKZMRdVdO9MXy4eG+G6S7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761403966; c=relaxed/simple;
	bh=rxkH9HqQp8MJpuSr9SUPPrL1eIBYUI8t2HD6mPry1gY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SMmw42nATheQSRnwRV6nkq2DXgSNZEqtsHTRvP+ZJEadKm7wbxrwXSHz+GsjD2OrY/SSGEyyjux2IgI7zCPSOwxjXlqPp4FLp3dPOtl36gv0AyH6v0oEnSsbbKxl2VPNejA/b6IQ40YPwGn5rblvwDOrvCwoa+5cfJzthBjmO9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=gyTuKpDl; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="gyTuKpDl"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63e18829aa7so4341370a12.3
        for <patches@lists.linux.dev>; Sat, 25 Oct 2025 07:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761403963; x=1762008763; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rxkH9HqQp8MJpuSr9SUPPrL1eIBYUI8t2HD6mPry1gY=;
        b=gyTuKpDlC7h/8d+8pgTfoWAWqWRXJJL1Xk6JRhnU8eshfqr0Qeo88YQDvi/rTLj6pY
         GrXTpS4yRFEEg8Z/fHItlCIReTO+Des8WRUxXPCrkvafw6gYztKgqc8961xlrnMveETu
         8J/UwcCF3W4pgMoYAxN/Yg6MJ01jk7B92mwPhTXjONi+EKs6X2gnE4WM0njSnvUsAz2d
         DddpD4TNsC44taEes7hs9qgLrEpBrNkKTsjsuNqQoruqP2iu5NcF5evWYYJr74QKUGaQ
         s13R4X0qIpVywmXO4KAhAcrZsAsO4EOB/TUCefKINIiapbojkqLD3TIqa5OiD+S8yHBy
         bbjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761403963; x=1762008763;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rxkH9HqQp8MJpuSr9SUPPrL1eIBYUI8t2HD6mPry1gY=;
        b=J+PE0A/xDjAJ/7OuxgsjDSRthAbFCN2mHTjMJsHDrwbPaczlBGgMcsV+34HsS/v8I3
         9ryFj5zqUJMwT+RVvqiBhkJlSf1XvGPgLJZjWMPHr8dgQ79AvnIT8s6jXLX6aWEGmE95
         1ufcJmrFmeS/UB9gerUWJ733EFXPh+CEsZC1phEp5/MDkEMiMY8H9cNpDXS/01Vz030N
         g8+nsLG1ul0pNS085V5J9jV0+sS8zc2jB3qqkrQaJaM2iOYV5O0IpfPxEzu0JrXUIRcY
         JcYmUx/y4pVNZ4DZhdpVScZfRFDbeKkTva8hTALhVd1CdLVxboCIGaiS693oG7l6aBtC
         uV6A==
X-Forwarded-Encrypted: i=1; AJvYcCUa2ioXaojht+jCSICOHMkcp9MppS6ar/NgCDConCoDkCOPB2hZcqrWbUSyePDI3nhuZIwpa1PM@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2O9GKsrXC3qKE8ECR2KbdB/vdcY3xmTZelCpF6Ir7KSLZ0Uz4
	H6MxMpKpCRRhZq5reujb+ttHa6zbb/pfKYIU5P43bO6WoH4fadWr+glWCwRteqlO0iI4H2Wjlvm
	1C9KoNBYBEc7mNawk+0Bf/Nx6HAMdTdfbSJdgb6/O6w==
X-Gm-Gg: ASbGnct251VTE2VQ2ttpBGS1l8ebtZzbYEf4/zc0YUjEN8zVhlWfS6CrpZrVe4p0ILp
	mphybl876YQT8NP+ZOCBU4SWhzeowGf3f9uD89oWnmwKmYmCfG8A7DfS8iJ0Pbs4CqfNBic/ru+
	jINjY+Ut6ZfRl7nNF10XdEOnGNij7jXR2Dam2e/RoxjD/HC1qxHypg4Dp8aLCqR61/9G6uKCme2
	9DKAWqgWMUHbJU2OUbMb92FYaCTCvevUiepzi2mi0zgCuNxMa7vTnJBk7Y2CmTa9RTEF7wmJ75s
	d09uYZfkXuFlWl29pEazkVJL0jKf
X-Google-Smtp-Source: AGHT+IEEmtC5AP/1Gyl7o28TLb62A6fjQmpgJI/nFlghPy3b8TZfgzFAjEpwZUdPvlcd5pyK5S+BLKOml0q59+GzhB4=
X-Received: by 2002:a05:6402:13ca:b0:637:f07d:e80f with SMTP id
 4fb4d7f45d1cf-63c1f58c0d3mr30957969a12.0.1761403962844; Sat, 25 Oct 2025
 07:52:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v7-ab019a8791e2+175b8-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v7-ab019a8791e2+175b8-iommu_pt_jgg@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 25 Oct 2025 10:52:07 -0400
X-Gm-Features: AWmQ_bllNz8YycDjixpyqg8hZuOQcw77RRZ1nqOvRZhBjS1lHQKHtPcetSr4uhE
Message-ID: <CA+CK2bBvCytQhJ-DbgBDUo-MT0xtuXNW=yzX3StwaNUj=JfnoQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/15] Consolidate iommu page table implementations (AMD)
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>, 
	Albert Ou <aou@eecs.berkeley.edu>, Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	llvm@lists.linux.dev, Bill Wendling <morbo@google.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, 
	Alexey Kardashevskiy <aik@amd.com>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	James Gowans <jgowans@amazon.com>, Kevin Tian <kevin.tian@intel.com>, 
	Michael Roth <michael.roth@amd.com>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

>
> Cc: Michael Roth <michael.roth@amd.com>
> Cc: Alexey Kardashevskiy <aik@amd.com>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: James Gowans <jgowans@amazon.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

I tested this series via iova_stress [1], on Intel, AMD, and ARM
machines, no regressions were detected.
Tested-by: Pasha Tatashin <pasha.tatashin@soleen.com>

[1] https://github.com/soleen/iova_stress
