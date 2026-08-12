Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7EF3242B8
	for <patches@lists.linux.dev>; Wed, 12 Aug 2026 21:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786570895; cv=none; b=C/4hUAsLXG0+iRh4AQ9mQRUAQz7ZAdKs5pUinQVLgU6wz9eewzp2QsMGIaBuluiCRweh7Cone+yvTzRwrQss1kDcI72VTi2pzIAr3GxS0KjrydwZ4ktD2RZloYACYxrY9IMjSx6IVVbjxWjFdLvmLMhWWUJRrVnwX83FKUVcZUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786570895; c=relaxed/simple;
	bh=Myn0f5PoONuBeSnhGPwFLjCEATkMK/fQIXssiOVSNy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/fBsEXkYVwURdQweBvJGtEYguLV1VjEeshYmrjZVvNZ9hAkxCV7tF8YMIKx+X0xtIs1LVIcEDNB6LEdsy4Sndt7cIKgHpn9UVbKfCUKqi1CIAvQDOvVtnWxy8AIOx/UJGymTNGnTLLz8RRSpN78+FSEKf1iIApNwaNkNlekfQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=isIcbPne; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="isIcbPne"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso413536a91.1
        for <patches@lists.linux.dev>; Wed, 12 Aug 2026 14:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786570893; x=1787175693; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NPvoXejEXMCOLtks/4P44XseBHeJ9j+rFY5G6V1i118=;
        b=isIcbPneFASy2It0XUzo5q4yuWqjQxd9Tdbe1SZCfxCtakI1qVeO6AxFcgnP+EIljT
         SXYWTJdTXQ14dbnSowOQ9WzLfUZoh8NThbSjvEEozLPrqizxHNBav8ey1EySJ+1+jrUa
         7LIFzvm+U6vHKcOTApoahMlPdnQFEVfAZEmJcsprMnki+Hs1QeEHbHK4YRnUVYzMb6vk
         +B4G/HyVQXDUiw+ZNKl4Klc92wqf3gJa1zZJq083n1sIJtITUKOHQeXfDa2E0278ukTE
         9Cuma40jNy055+0JkSDNqvq9WspQjtY/zhYTYmL9CJ32B6u0T2agr8hEouvfhDkH7zIG
         SswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786570893; x=1787175693;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NPvoXejEXMCOLtks/4P44XseBHeJ9j+rFY5G6V1i118=;
        b=VP2nMYB10NTow8/miIHcXjY852xay5uSEfcqDYjgro3TxO+RAfZ8PxKw0JOcsVO66W
         9bnLoQ+091Tdz8lwinDeiDtMAPs0YWkAx4N0v9nCEbvI4cbDpqgrsVDclNnPfh7A7Asf
         tGqosAg9VSB9yFwYZRIfvNz9j7QxwXxNKjQrUjOgFOlUlIQtrAjKW02FtXGUOt3eEzCT
         f3Aat3MS9WxocnKjj37kVJeq2gilPvILZWd5+Xe1k+w4cvxVKyuU9cyTzcwTJnXWgk4i
         1dEsKFqCJ3N3s25V9zRuwid8TkIfwWe6LJBLWA9i5Yr+B9656t4QR205owwmYljmFlBN
         u80A==
X-Forwarded-Encrypted: i=1; AHgh+Rpcoq873N59dMy9u49zWgou3Cft61/lnakbudGRJ0X8UJKwlMBsazYXIN6So2B1QybbJHgoLy+Q@lists.linux.dev
X-Gm-Message-State: AOJu0YwOCXd3cedNCxxwC+AGywXl8Orpu6vJhTZR+J7/kldXFHj1/xXK
	MJY01W3wS/7ufB3KU6rBlbdVhg+DyeVIr+SqBGPUTnuHv4xrKsX7eCVHKlCHxjQQ0g==
X-Gm-Gg: AR+sD116IhMavQdz6qvBelPxPs27gFiztmzsmEJNooSKkme+YNuZ9vdLq7Irnd4x2sx
	ZVbuZ4SFk2oB2jj4kIkQEtLyu5nUJIoL7LWjJ60iJSTlRJ/nE7bhPspC7JV2X44DgDqEBGHB+Nl
	V2zypWi1GRIcHCN3vvB0H/wyVr9S3yz8O/9cbUz6/Oa2Iq0So7AV/ziME2VxpZGG5GtEjY41X1G
	3DCqMkkSGGh3AdSXXmY3uy5BoRpPycY1tl1WZqMjA4wnTlTul4usYXJ2yRkxHT3jMxhvVllrBd+
	eEkckbQJM4solmxx184nbuB+P7oAjaMoVeLmsK5LNqNV5NkzFpwRkmuBdDttJsL+vgmjow2unMe
	Oi/JYqSwz/7M3GV73TC62FTnwsSLNdEC84JiN3M7OoM0nCWYBnnbVHtDmKzT2MwiNF5b61otazj
	zXI8qqeLGE8tCh4mOhXiGjCGGDC6aMmuVa5LVw7xUN5UxK9m49PSZLSG4OzNt2iM7YSr477/fvQ
	F6Sk6VpYYSguGF1IzAmvTiyWgIMIA==
X-Received: by 2002:a17:90b:274c:b0:36b:de66:92c3 with SMTP id 98e67ed59e1d1-3931f583a5amr478962a91.10.1786570892837;
        Wed, 12 Aug 2026 14:41:32 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3931ced0781sm878738a91.11.2026.08.12.14.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 14:41:32 -0700 (PDT)
Date: Wed, 12 Aug 2026 21:41:28 +0000
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
Message-ID: <anzoiALsjiWrsZtl@google.com>
References: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
 <8-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>

On 2026-08-12 11:59 AM, Jason Gunthorpe wrote:

> diff --git a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h
> new file mode 100644
> index 00000000000000..a2506ec8a19523
> --- /dev/null
> +++ b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h
> @@ -0,0 +1,108 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
> +/*
> + * mlx5 VFIO selftest driver - HW definitions
> + *
> + * Typed wrappers, constants, and helpers for programming mlx5 hardware
> + * via the VFIO selftest framework.  Most HW constants and all MLX5_SET/GET
> + * macros come from the kernel headers (mlx5_ifc.h, mlx5_ifc_macros.h).
> + */
> +#ifndef SELFTESTS_VFIO_MLX5_HW_H
> +#define SELFTESTS_VFIO_MLX5_HW_H
> +
> +#include <linux/io.h>
> +#include <linux/build_bug.h>
> +#include <vdso/bits.h>
> +
> +#include "mlx5_ifc.h"
> +#include "mlx5_ifc_macros.h"

I'm getting a compiler warning here when building with clang which is
getting upgraded to error from -Werror.

  /usr/local/google/home/dmatlack/kernel/trees/review/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc.h:2706:50: error: field 'menu'
  with variable sized type 'struct mlx5_ifc_resource_dump_menu_segment_bits' not at the end of a struct or class is a GNU
        extension [-Werror,-Wgnu-variable-sized-type-not-at-end]
         2706 |         struct mlx5_ifc_resource_dump_menu_segment_bits menu;
               |                                                         ^
           1 error generated.
           make: *** [lib/libvfio.mk:36:

I assume the mlx5 header needs to be fixed... But we can also work
around it in VFIO selftests if that turns out to be a can of worms:

diff --git a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h
index 2c451e411ec1..b9fad2b722a0 100644
--- a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h
+++ b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h
@@ -13,9 +13,18 @@
 #include <linux/build_bug.h>
 #include <vdso/bits.h>

+#ifdef __clang__
+#pragma clang diagnostic push
+#pragma clang diagnostic ignored "-Wgnu-variable-sized-type-not-at-end"
+#endif
+
 #include "mlx5_ifc.h"
 #include "mlx5_ifc_macros.h"

+#ifdef __clang__
+#pragma clang diagnostic pop
+#endif
+
 /*
  * Typed HW object wrappers for driver region arrays.
  *

