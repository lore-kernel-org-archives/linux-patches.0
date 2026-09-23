Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD51F4A64E5
	for <patches@lists.linux.dev>; Wed, 23 Sep 2026 18:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790187976; cv=none; b=F8UrmXrDMVhcZT1G2HKivOoF8JfqNkeNEeE5juixF3ewjeFPlsZX3v2z+PzCZaPOQW2q2x8jWe81EOTDPkxQQYzKKuaPMaf3SOCrUGKSkRaydidXTH6gXJRz2PnKkHjuMkKTM4CdErtzn+XVLqI1ru9A3NBa5U6JOvl5pWvCoZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790187976; c=relaxed/simple;
	bh=LhiPso6phLQM0wA+k6tjmIhIVqDrjbY4C0VTVIyFW7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrW44SD2W/Ees9hqM87HBmg/jtWnu0a33UjFrGhHh8Y97qjcy+EVMMhqYgCqycg3hnO3hFOfuiqvHruTAZNzPnhlwnOChvbXTiljJYiV/DdOKCgMU7Bi8YdBtRG3PKedpT/eJsn66cEKxJBvxC74OOxtKQji3xgQ+9bf6u2g0dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FaI5h3oS; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FaI5h3oS"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747f0135fso8717925ad.0
        for <patches@lists.linux.dev>; Wed, 23 Sep 2026 11:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790187972; x=1790792772; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LNon7FG4gNvQZ8cTIn7dGZggjcYoEo+V3D2k9W/8Sxo=;
        b=FaI5h3oSvIaTYtx3E/BJ3Z6cF17TZ5GU+E78NaxfDz+s+hrcHk2R651xiJPhNYpwD4
         752OkiNNN8+YVIIbLsZv5MRx5qL3mA+ttWdWt3OeAd6TllkiFIVAzyAfCZQEa8uebyZE
         Q2+1hFlur1arC9mh7YWxn+ZVBw0KBEnCubiMRSCpSI2ZMUjDlqjKKJX6YOY5FT0W7JGV
         fIPKjhdee4D4j8KhsZqJ7sYOkz9MYIvXrXw3kP3i430eg9gkIUcyMmGpd7aQr7DOjJj8
         GUTz51SRY3Z7cZ6znXHB/BDF7Y+lww3Fnzf2CCcZVBzdb24CosdRX6DXzheA9bPw5tOA
         mRFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790187972; x=1790792772;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LNon7FG4gNvQZ8cTIn7dGZggjcYoEo+V3D2k9W/8Sxo=;
        b=yZK/W4oeKzGD6CUrIuE14/3qmcQL0pClvUSoJ3f/aALn+wvSbCFJ0lXERLB0wwlnCX
         UgdacmuZYP+Mv3tRIP6UjhMA1w9mGzC2ovB+wlmrDWnvoqbnPwkKNNA4CZ/LeWhzkL2C
         mNbRSfImr1y/aTv3nkUnL8XoDVHnocHwWun5IBnHRVXb8bZizs/dpj+KsjqEzGWlyQL1
         K162IVbc0xYhKEJavR4oD9GIhAT/2J6pVNRKtvv2Ue5baG64UK4fTaknKFxHoyaaBD0O
         jh3MaOeI38Za4MpK3avwFUaQ4d+b7JYIqAD73xc+eANmWpYtHQ5ux2SvGzEX1/q9LRmB
         g7rQ==
X-Forwarded-Encrypted: i=1; AKwUvBx5Jsi6ME3pacnDvS00qSh94BpoKJkzmJQiWSKjp89LXSFPRCPsBVlCg0wHWHNYFnkSrrTiZGDY@lists.linux.dev
X-Gm-Message-State: AFuF++nXxRifM6p5uSQ/824OYfnRrVDohbXOzXn2R/BQB02TGvbW5gBf
	YcurThh+VtqM/RSjD5zV/1zaN/BOCKVN5JgmuIxXDxI514/kCJJrqssgmZz4VtkknA==
X-Gm-Gg: AYBFou3KDbzmuLJ7nAL8rpK4GjFbHyQyvpbSs6CA883B9PnnP4oUf1eGdxTcsdZ7HNx
	PB1ExuSYlAl1d4+R+jNNfl6YTeUW0FwzAPSb23nEqAO7NezfThm3lX4y+SB+Lt5rfNcpDkq/kiy
	1obmzT59NvxCtKp2vLT2BGFuthVcsEL8C8AUi3cUTChHoDXc6L8pXiH3dpOvwW5NltvntxvL0fE
	sG+T2BSnQWUMjFfv9XBxgsUTt+dE0lU4AQH1zGcb9F1upx/XC2QuqYS1wTbPNoYcry7wnsClnFR
	0Evf4jmCUd/OZ9Bxi4iVgGcVhTNekbapF5ymqygEKOJBoWF1sZ+5uPLqLn5nFmFrbK2DiPGaayC
	JGJG9OvmfuCGChJh01mJkvr9cGGko1gwey5YIu5AAffy6JVUWYgHRq7Ny8bnR+KyyGV3FadqFxJ
	Hs5P8F060nTQItbaC/uTH31r0QxLOBvCBSoj9hMOdYgzbubeDtKVCQdjCzF3ZCo7SLCSeiiwK8C
	tTJBVGRq91sE0RbryXhfTS3l/3yE2+GeFGGDkrOedfRWqnSJb8=
X-Received: by 2002:a17:902:ef52:b0:2df:3b09:664 with SMTP id d9443c01a7336-2df69dcdbf3mr30657015ad.32.1790187971787;
        Wed, 23 Sep 2026 11:26:11 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5eea15sm15475075ad.64.2026.09.23.11.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 11:26:10 -0700 (PDT)
Date: Wed, 23 Sep 2026 18:26:06 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Leon Romanovsky <leon@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sean Christopherson <seanjc@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>, Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tariq Toukan <tariqt@nvidia.com>, Zenghui Yu <yuzenghui@huawei.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v7 06/10] vfio: selftests: Allow drivers to specify
 required region size
Message-ID: <arQZvkNtgq-NlUkh@google.com>
References: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
 <6-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>

On 2026-09-21 07:35 PM, Jason Gunthorpe wrote:
> Add a region_size field to struct vfio_pci_driver_ops so drivers can
> declare how much DMA-mapped region they need. The mlx5 driver will need
> ~18MB for firmware pages. Existing drivers pass in the sizeof their state
> struct. Since drivers all use only their declared state we can use the
> value directly and remove the SZ_2M hard coding.
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: David Matlack <dmatlack@google.com>
