Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0FB386564
	for <patches@lists.linux.dev>; Mon,  4 May 2026 22:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777934149; cv=none; b=TwEq5uuvYzN2tXRITs5ZyJTmT2QPkn3/T6iTcthfdy0VbfLXG+DQo+gizQ+QbGMXpqBxLdsKzbb3RKsD0oqQk7Nuel8wcpVIClFWpURl50UMkSNB73/XjlR5s/XKJKlq8ZWMCBm9uJqwwWNRXV7O3/py8unGljHHQE2+A0mtVPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777934149; c=relaxed/simple;
	bh=053J+k+T3qlqygZGjMWRpvpwj73ZalGKJrYZu+NUK2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sML2dvSe/iH+ttopar0mXHDYWk9jDKR3KtBi+KjhUPIRSEZ+zJB6146i/tza8VwmfiCCl3506I6+Z61bo9YJ1GQsOei/pDeeeC4FDC4FuMs5EwXHUzm6YLcpbGiFGBrsyoy+41y114ssJrhn6Mt/ejNczLLumNXTXnLBJ39mBuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UQW89x5b; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UQW89x5b"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c801d732058so893240a12.1
        for <patches@lists.linux.dev>; Mon, 04 May 2026 15:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777934148; x=1778538948; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PQ3tNPMFkM7QrJ5Q+mR4uTB1pqSv2OnkcWUNEBkdVs8=;
        b=UQW89x5biUYPR1VLiBFTKYKswdIwBNUPja8J6mf/GyEh/FANnIoWcIURGoeY3Ws9Y2
         CQv4SJSiAiWtNW73TYxS+IPc1jX6ovAHTF25e2G2enWxLoicL4e5sze5++0moAk4GtGz
         EGKliFNKo/63iC9WQs4Nve5cxJfOeXJbhw0uBN7+yPXYrd7ngXO+3ozYwYWVKgwAn+su
         OsbgJXInQH8djD58y5deMaJmPvt3QKSkNgxh7UD33uoTSsEhnNnU58Qc0TJdeczUFHvB
         WQmal4+gf8xLXgMY/2nH31uCFbgK2bwA7zJyFqx03ZGfUp7b2kyF2rTHZmDIZlA01OYr
         aGjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777934148; x=1778538948;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PQ3tNPMFkM7QrJ5Q+mR4uTB1pqSv2OnkcWUNEBkdVs8=;
        b=KRJknL1TMLoYAFs9Zh2X3Zk1TjQBbGvIR4XoeDzRL+hkPK16+5p7+OuOBX34SUJPNi
         8UBYLqIM8lEDNM6j/gnrV9iHmHKvmYhKz/rmIwIOTwUlD7LJgHAsC2d6bDhbMMP3V4Dx
         eLLnEJwULUdrJUKs0McvFJJxAlab2q45r/gD4Up0oyje6Q7IlvhTNSuKrRTTrDLCxtsg
         xewJ9nr05JmYPJRcq60xHcf3peM1VyN7uzfXc6B34yNb1Bk6OLqrf5g2nY8WRnLV1Mt0
         ZiDx3EgM+skroSWnI5l/vfNEtYU91SeUuUhEDV0gbLbUS9UlE5Bv6YydQ7GVRqrFQ49B
         LGKQ==
X-Forwarded-Encrypted: i=1; AFNElJ9kAjvZFKbzmI8lG+RNMT3ZDQJwYwxLfqAxXF0P6GFe7+nch79fd4C6ynajeKzxYKP5dJeqqSFy@lists.linux.dev
X-Gm-Message-State: AOJu0YzZXGfBzqP36PhLzK+qHkkjpkG9ch0I8ey4la2PGImC2oJOG1lA
	cz+cWq3K8IWMd2s7V1F4ODbjlIfCF6v+leITUuj3pT9La3n/cTsSZCYohITEZ3Lr4A==
X-Gm-Gg: AeBDieu+QM/UdjZkjEraRgRdMkXDFxbjnpBXhvfie5caE4nil5kt+fkROVePVOuc/Dx
	ld2NK2w7M+X3jFt2Ww2haRtf3/iw/JbpX96//j5a42kwE9z4fGprhf5tLW2S4QcofW4LuSSnIiH
	VY1jFQh+isHINJYvBdcjLTv2Qy0yBdJIzYujtCEV1sl+6MLIXp2CaPkIjAYj0/f5sj4xTVMMOFD
	5CcJjLhP/HM/fcw/RvNXh15iWuE8caB3sAER1KcT9TbMSkW1btExwB/FJvOWwIyy+l6x06MlnRK
	X68D/MyDtImTM30TyrPe3XclY2t2MsgTPCdepVbMuIejPkMl86FpsZ1DUipPtg23J0nzwiAkjvO
	WNbI1lEc9S1Z/qrmrllN8j5S1vM5KWK4uAK4kBVnnSQnKhB7Y80mc97VB4cA/3eUJ1/MZ6Oftfp
	qBqiRtOL7+JzlWnWBenFJFr6xyBmS+ujdDSPefH/Ad8z2NoEOAuEvUH1sqiqEWbpnKCQ8DfK1i2
	Hp0Kw==
X-Received: by 2002:a05:6300:210d:b0:3a2:cbd1:11f with SMTP id adf61e73a8af0-3a9ea589e46mr1260508637.5.1777934147330;
        Mon, 04 May 2026 15:35:47 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7ffbcaa477sm10680045a12.31.2026.05.04.15.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 15:35:46 -0700 (PDT)
Date: Mon, 4 May 2026 22:35:43 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 09/11] vfio: selftests: Add mlx5 driver - HW init and
 command interface
Message-ID: <afkfP-8UHaoyLd5Y@google.com>
References: <0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
 <9-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>

On 2026-04-30 09:08 PM, Jason Gunthorpe wrote:

> +/*
> + * Driver state — overlaid on device->driver.region.vaddr.
> + *
> + * Contains both software-only state and HW-visible DMA buffers. HW buffers need
> + * strict IOVA alignment.
> + */
> +struct mlx5st_device {

Can we do s/mlx5st/mlx5/ on the series?

I assume st is for selftests and that is already implied by this file
being under tools/testing/selftests.

> +/*
> + * Probe — match mlx5 devices by PCI vendor/device ID.
> + */
> +
> +#define PCI_VENDOR_ID_MELLANOX 0x15b3

nit: Use #include <linux/pci_ids.h>

> +static int mlx5st_probe(struct vfio_pci_device *device)
> +{
> +	static const u16 mlx5st_pci_ids[] = {
> +		0x1011, /* Connect-IB */
> +		0x1012, /* Connect-IB VF */
> +		0x1013, /* ConnectX-4 */
> +		0x1014, /* ConnectX-4 VF */
> +		0x1015, /* ConnectX-4LX */
> +		0x1016, /* ConnectX-4LX VF */
> +		0x1017, /* ConnectX-5 */
> +		0x1018, /* ConnectX-5 VF */
> +		0x1019, /* ConnectX-5 Ex */
> +		0x101a, /* ConnectX-5 Ex VF */
> +		0x101b, /* ConnectX-6 */
> +		0x101c, /* ConnectX-6 VF */
> +		0x101d, /* ConnectX-6 Dx */
> +		0x101e, /* ConnectX-6 Dx VF */
> +		0x101f, /* ConnectX-6 LX */
> +		0x1021, /* ConnectX-7 */
> +		0x1023, /* ConnectX-8 */
> +		0x1025, /* ConnectX-9 */
> +		0x1027, /* ConnectX-10 */
> +		0x2101, /* ConnectX-10 NVLink-C2C */
> +		0xa2d2, /* BlueField integrated ConnectX-5 */
> +		0xa2d3, /* BlueField integrated ConnectX-5 VF */
> +		0xa2d6, /* BlueField-2 integrated ConnectX-6 Dx */
> +		0xa2dc, /* BlueField-3 integrated ConnectX-7 */
> +		0xa2df, /* BlueField-4 integrated ConnectX-8 */
> +	};
> +	unsigned int i;
> +	u16 did;
> +
> +	if (vfio_pci_config_readw(device, PCI_VENDOR_ID) !=
> +	    PCI_VENDOR_ID_MELLANOX)
> +		return -ENODEV;
> +
> +	did = vfio_pci_config_readw(device, PCI_DEVICE_ID);
> +	for (i = 0; i < ARRAY_SIZE(mlx5st_pci_ids); i++) {
> +		if (mlx5st_pci_ids[i] == did)
> +			return 0;
> +	}
> +
> +	return -ENODEV;
> +}
