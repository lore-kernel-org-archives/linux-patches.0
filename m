Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2601340DB4E
	for <patches@lists.linux.dev>; Wed, 12 Aug 2026 22:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786572697; cv=none; b=RzxrD77s7M5amHjc8oWTzxJRcNPHB7YO49bP0We3Db3IomdsWQMFZ9Dkrh+lgDvHqVfJH+TGY4hGtaSS8y7b/3DIGB0bl2xiiBqTSskrpLe1f266HH2YT03tk/Fq9/fwpLdAGqYi2Q3QbcKRQnAA28z88LM4dSIfL41SyS6YB1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786572697; c=relaxed/simple;
	bh=W/W3zvPMNBs7G76j3kOF1p094KPwTL9rIaA3xKhxAak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g6A7rPwyhN21yXF7AdFGnJlBRlWjoCdcpzgJyMBPBNm4k5sshsb4eU7dqewfmuEaCXdYZ+7Qea6eyxMGpibFA3aFZjRyhIOTHU/6E1FH/VjmVQRZoKhmis1Y6QeQJNycU1BonyKgsGjRsNzxh36EReToy5+txU1jYh6S15JFY/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hgqs2uDA; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hgqs2uDA"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-ca00f126b7eso107140a12.2
        for <patches@lists.linux.dev>; Wed, 12 Aug 2026 15:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786572694; x=1787177494; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=84UXfrTD07ipm4YJ6onVJzQAj8OjhirewXBuPuaWHiM=;
        b=hgqs2uDAn5lv8EbF+ELgpx+zl0dEDnAHZ298MwMwCD9dxeVKw/40MjZA1LceGIaL12
         6d3Kb8iPNwUFIw6MWnUQ2sTjHx17BimJ4n4736ZTkOv8lwaoVzttPTxrYhdUTyVMMYsT
         AJyseCaMYtW2qhXvL+Q3hZ0azAxdjoMnDgZm9FgyiZY36gnCLd97AvwmrOfn/G26wB6B
         llFFQiGhFV5BIfJsrZfoDQ3Tjh9Rnq6hHpGe9s2tuC0admyPPq12/AeHidG2B3S83s8o
         Gu2tfxw/pgQczBO3AgNExwNtyfkqqI/kCEtcTxej3jiExYA8gR7e4+/weXE56FxBecHd
         SqYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786572694; x=1787177494;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=84UXfrTD07ipm4YJ6onVJzQAj8OjhirewXBuPuaWHiM=;
        b=KVI7OnenA7d2XlTh8ge7zgme9PmB2T55WyNqmf+6HFpivQQuc7ymYTBvnVofzrqPhy
         56QPLVRE5X2O2EXlZSPZ9bjZRD8gnl1R9XVcuAiuTy85ocDSm+W1Avr2XFsE9nHEfdS/
         CWf46sUbDxETDkL9YJEG2VFMgZ2JC/ffgeKeXQxowFSMBtdhiYDtLdQ5Fqw1E9Y3lbep
         UoCsgwsqmhDpz4ZSbotFlifKi5A++QrYvmboG7yd2qz9egn8tY1GLBSPEQDQLiH3xyBx
         v8lNvrKM2YMoGb9uKMWALW3D9RdxOtsjn/tXfSYg110VFNWGEfRukaglpgbihMFlKRf6
         fi+A==
X-Forwarded-Encrypted: i=1; AHgh+RrYByvjkZBzluRSRIYBhCNeRCU+PXzJtq/1AEEjLrWcxvFf0lzfrzscDY6sfdmcnmT7THSVRyVc@lists.linux.dev
X-Gm-Message-State: AOJu0YzVpOzHdfa61Y3Jexg9qLXufVDKW+WyvDcNV5MdCTrORcBxju8b
	w2dkgPibGw8simj3Ta36NkX6GPpuSqBy+HKpMj+TT/K5z9aelMSTHtYaeIsNiOzc7A==
X-Gm-Gg: AR+sD10uWwkdxCa4Ew1MLcesIdDs/8PR2mM/jafCXX+VSC2M8m4vz0lOFcPySVeEMQN
	M3z72v2JevwxFj5EJavJLafNGpeTYo6F8OzQV0N/pUL7njnFHniERttmjRdyMIzF8O/Nc0oy+Ts
	JMMidhZP5qdPsy2UxKEUReXIVDQKnfgRLTR9BMw1zSv9Ng5n+wOqaOe7aZbWMUzDW9Y2noISHbJ
	wz9V1a0YPo8JgunXaHwx4BTpVP0/1sLhncYaxWt8KrjrNavoRoplR6tUsffHTFG3T+MRi2kzCGN
	4sBpyTwUFOfKxhR5qhy4Cfnc02u67ERapFKcKoHax+xog9ldv4taVDK4ToUCGXsouT0pXvIo1RL
	DoYDe9+06+zQwwvyIv9iJDt1GJVE419+DJyKl/To5YTxeX3qfQeXhy5n/xbUiTvB0nTzqwmC79o
	MSPxwT46G2nMnkemev0lBMYP1huWE9/TBCef1VCALvu3DmPvN/nSbPYIItEo1cY14s+SigolwAI
	1oZUNgIwiC0EbqazASjqsamBxwHpQ==
X-Received: by 2002:a05:6a00:3923:b0:835:6388:655d with SMTP id d2e1a72fcca58-84fc6ce7c17mr1032589b3a.14.1786572693710;
        Wed, 12 Aug 2026 15:11:33 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbef7109658sm202295a12.16.2026.08.12.15.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 15:11:33 -0700 (PDT)
Date: Wed, 12 Aug 2026 22:11:30 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v4 06/10] vfio: selftests: Allow drivers to specify
 required region size
Message-ID: <anzvkibgzTae9eV9@google.com>
References: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
 <6-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>

On 2026-08-12 11:59 AM, Jason Gunthorpe wrote:
> Add a region_size field to struct vfio_pci_driver_ops so drivers can
> declare how much DMA-mapped region they need. The mlx5 driver will need
> ~18MB for firmware pages. Existing drivers pass in the sizeof their state
> struct. Since drivers all use only their declared state we can use the
> value directly and remove the SZ_2M hard coding.
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

...

> diff --git a/tools/testing/selftests/vfio/lib/iova_allocator.c b/tools/testing/selftests/vfio/lib/iova_allocator.c
> index 4a660f636f4972..c8075575e9131d 100644
> --- a/tools/testing/selftests/vfio/lib/iova_allocator.c
> +++ b/tools/testing/selftests/vfio/lib/iova_allocator.c
> @@ -13,8 +13,10 @@
>  
>  #include <linux/iommufd.h>
>  #include <linux/limits.h>
> +#include <linux/log2.h>
>  #include <linux/mman.h>
>  #include <linux/overflow.h>
> +#include <linux/sizes.h>
>  #include <linux/types.h>
>  #include <linux/vfio.h>
>  
> @@ -50,7 +52,8 @@ void iova_allocator_cleanup(struct iova_allocator *allocator)
>  iova_t iova_allocator_alloc(struct iova_allocator *allocator, size_t size)
>  {
>  	VFIO_ASSERT_GT(size, 0, "Invalid size arg, zero\n");
> -	VFIO_ASSERT_EQ(size & (size - 1), 0, "Invalid size arg, non-power-of-2\n");
> +	/* Adjust the size to the allocator requirements */
> +	size = max_t(u64, roundup_pow_of_two(size), getpagesize());

...

> diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
> index 5e65434d2318b2..52b9c2a2bbb9b6 100644
> --- a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
> +++ b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
> @@ -32,6 +32,9 @@ void vfio_pci_driver_probe(struct vfio_pci_device *device)
>  			continue;
>  
>  		device->driver.ops = ops;
> +
> +		VFIO_ASSERT_NE(ops->region_size, 0);
> +		device->driver.region.size = ops->region_size;

I'm seeing failures with the IGB driver with this series. I think it's
coming from here. The region size needs to be page-aligned so that the
IOMMU map/unmap calls can work?

The size of struct igb is 0x20080 bytes which is not page-aligned. The
size of struct mlx5st_device is 0x200D000, which is page-aligned, so
that's probably why your Claude did not notice.

# #  RUN           vfio_pci_driver_test.iommufd.send_msi ...
# /usr/local/google/home/dmatlack/kernel/trees/review/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h:42:
# Assertion Failure
#
#   Expression: __iommu_map(iommu, region) == 0
#   Observed: 0xffffffffffffffea == 0
#   [errno: 22 - Invalid argument]
#
# # send_msi: Test failed
# #          FAIL  vfio_pci_driver_test.iommufd.send_msi
# not ok 33 vfio_pci_driver_test.iommufd.send_msi

Applying this on top fixes things and also avoids a potential overflow
when doing the roundup_pow_of_two() in the allocator.

diff --git a/tools/testing/selftests/vfio/lib/iova_allocator.c b/tools/testing/selftests/vfio/lib/iova_allocator.c
index c8075575e913..66a160d4ff9d 100644
--- a/tools/testing/selftests/vfio/lib/iova_allocator.c
+++ b/tools/testing/selftests/vfio/lib/iova_allocator.c
@@ -52,8 +52,11 @@ void iova_allocator_cleanup(struct iova_allocator *allocator)
 iova_t iova_allocator_alloc(struct iova_allocator *allocator, size_t size)
 {
 	VFIO_ASSERT_GT(size, 0, "Invalid size arg, zero\n");
-	/* Adjust the size to the allocator requirements */
-	size = max_t(u64, roundup_pow_of_two(size), getpagesize());
+	VFIO_ASSERT_LT(size, rounddown_pow_of_two(SIZE_MAX),
+		       "Invalid size arg, too large (%lu)\n", size);
+
+	size = roundup_pow_of_two(size);

 	for (;;) {
 		struct iommu_iova_range *range;
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
index 96a940ea59b5..b31abfe2c7ff 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
@@ -36,7 +36,8 @@ void vfio_pci_driver_probe(struct vfio_pci_device *device)
 		device->driver.ops = ops;

 		VFIO_ASSERT_NE(ops->region_size, 0);
-		device->driver.region.size = ops->region_size;
+		device->driver.region.size =
+			round_up(ops->region_size, getpagesize());
 	}
 }
