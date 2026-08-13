Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8D248C8AF
	for <patches@lists.linux.dev>; Thu, 13 Aug 2026 15:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786635641; cv=none; b=leCIhMboocaePcii7jm1dXOS9GKK8VkX/dhjhMFhWSlbOWS6DF6lDX3qzo6/klYBpwnOvp6Pgmm/AoxQ5EHrYvnDJbYEcIUsH0SGgPTffz7wXKfGoDy9nUuWugy7JgL1fxneNKAnvnoQfzId7scTLc6bDFKgPO6HQg3gFr0TEdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786635641; c=relaxed/simple;
	bh=WtqsLzrgSjg/xVRfW9WfYBYpQ3bP/9ChUav4NHg7yVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WpOO6+fgw9DBH9id5wVaiDzKbEYMd7yk7LEuM608bqaioJyLXl1A7/PwPNleUwrY6vG4sr3Mv1B55CodBdq+/qRPTLreDrjW+pBxeL31tjWS2p4N/NQD9tDpFf+F+p3VXtxetuBC3C6lVn7W7kvPdcaiivulg2Z7kYHZlgnKNg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JWlDYb3h; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JWlDYb3h"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cc61541f8cso15399175ad.0
        for <patches@lists.linux.dev>; Thu, 13 Aug 2026 08:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786635637; x=1787240437; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AcZvN96x3R8L9Ww6tvDjLJoxtHOJUhdmG67qkMsuoE8=;
        b=JWlDYb3hVLxXjF5iN28cOZO2M6hHcUw5/1YozLU4eccvOvq239GqC8ID1kb7LRCMk6
         UI260szi5SX9mrELVjmDG/fXWbtMa0q6XNqdu6v/Ap1qguOBypSAsYGarzqR8v9gHjEm
         WiRnXMxhoS6hqseJ9Q3gvalknq9BngfMoXe7JT9CxlPiljgH+lFmy0yEEk+oMCLvNUBn
         cjHDgbgUEfteT1U2X03ukJIGjp2vFCLkcg6cJglQ2dk0RJkRs0mhEFZJcEly1Ml5Cql8
         Key4mSu/WZjQP6iosmPD8AXmXpeTObBhO8zzNJ0Z4+jgkUtkoEIjqXr8qEwc9QClzTmf
         9TKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786635637; x=1787240437;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AcZvN96x3R8L9Ww6tvDjLJoxtHOJUhdmG67qkMsuoE8=;
        b=HtxJ9uawq9LfA6a7llFJFVDf2ppQp0tdfeBrkGcxT1GjyxCuz9X8GXnBVJcTRx58Xx
         aFOS3hLt/+P43t3gTJMxbUnDYlUqPKDiOxTr0agPLOiG0524+qkJTL//dIWZQdqbQIzT
         sDAR4MM19n5NJyVgLhOCT+YZC0M1KIBFkeq8Yr4FPkCI7QQ7MaYdlGdLYx8mQaF6fOqQ
         rqm1Wj/liHB5U7HsZOXY9+Mx4BdzAtsFXoCEiYBJOya3eSu49TJQp7tfEcMEtWd99JyA
         bqsw3FcayX3fCxgqOMIyN0qEvWhdj9ww6hnhC+sFGGMF7q+3CvNvSOaX44fBhaymV/ad
         r5EA==
X-Forwarded-Encrypted: i=1; AHgh+RoC0LCx0N0waI+pq91QpjUuqh2R/bSk+RhE2m/ecFuKhbMToKEqfs9/4QYclfHkzBDf4CjjH5ou@lists.linux.dev
X-Gm-Message-State: AOJu0YwXHLUzaAQYgppv3uzh/dMqmJvTnmO9x6HU0AvlkRmPK5Pdip0T
	advDkjdLZrvHZEHMvrgzboj9nosUVYZy3zcwlq1FlQyN3L1oxasHqjBd2+lOS31WRQ==
X-Gm-Gg: AR+sD11Im/tF9kz1iO4OlQL5InPi4DKEjLNjeiGJ6Hi4Zbe9yn5/sgzgLAVGaaKRR/R
	7eaHZLvNNvLxEIDiYtzXNRpavHwNrO7QrLYaje/WEPe53gAjwwzqlcMfA+bkYv+Q3q9miGjEqB7
	IKefmSvuvbZQyEqsckQO0t3RznCxvTyRN9+AAX1Z54Ms/Pk95tD5++FW9DOFocrC/2lY6/CCtQ/
	9gW5fdUG8oTUeQoBsYgdcmYknT/aCtW5MMnvgRJsuGzaO4FBZUUeTOiO1gUhrWTARBXN19b3rgw
	kdpUFDglpkeCHBWqc3AiKJTJvj8SwVN6+4trUoaihvRPGujMG64yJh9WxPbhRw/4cKUkdfOrtFs
	L81s1AB7oEnv1VhrvAdOUa6pg8Bu+d2gq+3NIa84ZL0Q3o32Nd4Nvz676hf6tW4YAz7uMrQATjV
	PTCB0l2w4W2Jf33EbywJoONQKWH8Ipz5u1Z09oW0EHmLiZs1Yvaa2mGgek9PBeauXpofQSYZxpS
	ZWnK5e5fKBCWz0fCMGHfm55zNk8hRjp009gCiAB
X-Received: by 2002:a17:902:f64e:b0:2cf:70d2:da7c with SMTP id d9443c01a7336-2d37f77fdfemr84524235ad.12.1786635636542;
        Thu, 13 Aug 2026 08:40:36 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d37c2000bbsm12399845ad.7.2026.08.13.08.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 08:40:35 -0700 (PDT)
Date: Thu, 13 Aug 2026 15:40:32 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v4 08/10] vfio: selftests: Add mlx5 driver - HW init and
 command interface
Message-ID: <an3lcKmhXbRnDpRL@google.com>
References: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
 <8-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
 <anzoiALsjiWrsZtl@google.com>
 <20260812233207.GB730363@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812233207.GB730363@nvidia.com>

On 2026-08-12 08:32 PM, Jason Gunthorpe wrote:
> On Wed, Aug 12, 2026 at 09:41:28PM +0000, David Matlack wrote:
> > On 2026-08-12 11:59 AM, Jason Gunthorpe wrote:
> > > @@ -0,0 +1,108 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
> > > +/*
> > > + * mlx5 VFIO selftest driver - HW definitions
> > > + *
> > > + * Typed wrappers, constants, and helpers for programming mlx5 hardware
> > > + * via the VFIO selftest framework.  Most HW constants and all MLX5_SET/GET
> > > + * macros come from the kernel headers (mlx5_ifc.h, mlx5_ifc_macros.h).
> > > + */
> > > +#ifndef SELFTESTS_VFIO_MLX5_HW_H
> > > +#define SELFTESTS_VFIO_MLX5_HW_H
> > > +
> > > +#include <linux/io.h>
> > > +#include <linux/build_bug.h>
> > > +#include <vdso/bits.h>
> > > +
> > > +#include "mlx5_ifc.h"
> > > +#include "mlx5_ifc_macros.h"
> > 
> > I'm getting a compiler warning here when building with clang which is
> > getting upgraded to error from -Werror.
> 
> I don't get that. My builds have -Wno-gnu-variable-sized-type-not-at-end
> which comes from here:
> 
> tools/testing/selftests/lib.mk:
> 
> # gcc defaults to silence (off) for the following warnings, but clang defaults
> # to the opposite. The warnings are not useful for the kernel itself, which is
> # why they have remained disabled in gcc for the main kernel build. And it is
> # only due to including kernel data structures in the selftests, that we get the
> # warnings from clang. Therefore, disable the warnings for clang builds.
> CFLAGS += -Wno-address-of-packed-member
> CFLAGS += -Wno-gnu-variable-sized-type-not-at-end
> 
> Why doesn't yours? Are you building it correctly?

Ah I see the problem. I was building with this command:

  make CC=clang -C tools/testing/selftests/vfio

But the correct way to build selftests with clang is to use:

  make LLVM=1 -C tools/testing/selftests/vfio

LLVM=1 triggers the conditional logic to add
-Wno-gnu-variable-sized-type-not-at-end to CFLAGS and the build works.
