Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E36569F13
	for <patches@lists.linux.dev>; Wed, 23 Sep 2026 18:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790188260; cv=none; b=FmKGYO6svD2WTDAdjN4nmZWrChUn9C3GWvq0KRElqI+dSvWQLjk6pOOI0ycVUDqNTjbVV8QbFmQ0+L7MXJH12bkLBIPtsUY+dg/l2cTPi5XykJV1eGF1PscJaETvNXBRIKcstiNjW1Qab+UJ4pwNnbOMiGqAhcJVSsVdmU5GEN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790188260; c=relaxed/simple;
	bh=lWag3oM9sYGpdHyGnDE7rA3iXeVqrktsZhX6pT4UGs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xlm8QS+Rpq2bOzu+5T13Iagmj6bRSrIr6PeyCaFqwY5LvEOPdA0jr4tjLR3IElzSxJPm5JgrvJOs3tii174CiBp3Xw0ppoynk5EVYXkc1CsS+b1PdpJ3o9XoHst1e6Y1VT95cZDDKq/h/O2JgtJHVeVGcr1CVkACXdN/0Vsyt2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AF6yOIAv; arc=none smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AF6yOIAv"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-86dd69a1b15so410316b3a.0
        for <patches@lists.linux.dev>; Wed, 23 Sep 2026 11:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790188252; x=1790793052; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qQbES28pq+4+5SdsOxa0hPCoAfkWzPeIh6+fD64KIF8=;
        b=AF6yOIAvyXRSQF0F4g+548lS//aE8Vy40b7Mt4CSlDKkyBaiOffOzXuwL+iR8+porO
         ka/uc0VA6bi1l0fKpN1lIddKBu7Pd5gntRL18rkq1/tFc2JGbkpa4WzH3/eRzgNw7jVk
         xy+kd8xEHIvMjVJzJq257BIb8AMD4EEe8luX03TZAWxlicdny98O6ltQ+hgaxob6luQr
         llb80QY15dkb43IgCOPOWOjqaLJW6QtV7am5+9JX6o1s2bBQVLLhN+BvwLIwd8tSXXEA
         NrLYi1DFP0oFPUY9STywzAuAJxLNkGyZAIsQmTvvcQgKO3ZtPOaUcQ59x1E8ZPJbLIgR
         kVMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790188252; x=1790793052;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qQbES28pq+4+5SdsOxa0hPCoAfkWzPeIh6+fD64KIF8=;
        b=kvAYUKKSIfDZg5ng2vDubjcWxDc/y5EYoYIehTgVa/y+c7XQ8ukDaSoocGUqWk/iIY
         VjsSET2KwxltKwrz5dEry8HvCVcir6CbVsqVlhjAnKbxSAVnuS2dVri5TvXWAj12iFYI
         GkHBkwVEupv11efTlO6th+DEwP7ndqWaen9d321eex2WkXwHyOjfF1ZCwBddh7EC4lXt
         X3knDU0TsnjCg7cfVoFusl3CesK0a9O2PScmh8Aq6nuBHs9PJRXF24clQu4LAcM2wGBs
         r/HMZdoRk2TlFs2ojkAU3y7ahoW8yg4cdxbt8JIA4JrNZGU56PASamXoSk3FF2UCrfcH
         J07Q==
X-Forwarded-Encrypted: i=1; AKwUvBzgARioNgWPx/OppC1PI0hnJ3V5jdqUhlM9aZnJyprGI7eZoG2oCmgpT/OdokAnZGmhdQbNRjC1@lists.linux.dev
X-Gm-Message-State: AFuF++nx+I/h0vyLggv9qtV5AHuBxhWm4bZyIGbrSaTnVGTBOlONM+bE
	DijJB/oS4n4vYk+Hw0QNhX5UcqH5CJ5fbI7GQ24JgLAkpaL2yF/NzfIMy3k541idNQ==
X-Gm-Gg: AYBFou1Cdvn04xo5x4KaGINM/dUOfp8bFMwnLszC5YcbXLZxFtSZhBfs9h3oefGCJ/p
	wQ3AoC9JH1Auxr1KHp3HJR7/YOdI+G0g5Zu+l0WYvITN7domxn9cAtgQ2NdIgNgapZIIzsCGeSj
	jK+opSyl/BTrQ473xnSuVhHsf7JRK3nzY3bF172ZOFhThI73Nptd8cGM2YTWs3B1nWSSHzvHEaw
	OyV85surAfWW6yMDpQ+wPo9fllNfxjpC/nQO2jIHPpl4SiT+Yi6kgu5OkbJJ27MrVvlNvi5HlSh
	QrMNTKsQZHX7cxIAZPPINd3olguK0Oukhikx5jfGzaSJ9L4dN643oDlH6zvtC9UPsLcsfM+/cqa
	mdaVlLAU7E4A4FVHThFWlHe/f5ELgX3bc5Yq+MRUq5cc4AArVU6Uhe4tc9roNJOeXYZXRx6qwGu
	MnCUehQr/kdxAkr0rrU7vHal/my2opOJ7DlyBHKLE2VK5r7OKT5bmUQfZPHFo6eKbK5t17tuh7c
	sQOFW04eFGhFrPx4hQOyDA6vcO8sZtrFK7O4tex7wz+ieB1cG0=
X-Received: by 2002:a05:6a20:7290:b0:3db:131b:8d8 with SMTP id adf61e73a8af0-3de0e7300c0mr45910637.14.1790188251251;
        Wed, 23 Sep 2026 11:30:51 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1d5c12besm1736810b3a.29.2026.09.23.11.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 11:30:50 -0700 (PDT)
Date: Wed, 23 Sep 2026 18:30:46 +0000
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
Subject: Re: [PATCH v7 00/10] mlx5 support for VFIO self test
Message-ID: <arQa1khEHzKOfkCK@google.com>
References: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>

On 2026-09-21 07:35 PM, Jason Gunthorpe wrote:
> Add an mlx5 driver to VFIO self test. This is largely a remix of the
> existing VFIO mlx5 driver in rdma-core. It uses an RDMA loopback QP
> to issue RDMA WRITE operations which effectively perform memory
> copies using DMA. Since mlx5 has a stable programming ABI this
> should work on devices from CX5 to current HW. The device FW must
> support the QP loopback configuration.

> v7:
>  - Fix some compilation problems, kvm and the igb

> Jason Gunthorpe (10):
>   net/mlx5: Add IFC structures for CQE and WQE
>   net/mlx5: Move HW constant groups from device.h/cq.h to mlx5_ifc.h
>   net/mlx5: Extract MLX5_SET/GET macros into mlx5_ifc_macros.h
>   net/mlx5: Add ONCE and MMIO accessor variants to mlx5_ifc_macros.h
>   selftests: Add additional kernel functions to tools/include/
>   vfio: selftests: Allow drivers to specify required region size
>   vfio: selftests: Add dev_dbg
>   vfio: selftests: Add mlx5 driver - HW init and command interface
>   vfio: selftests: Add mlx5 driver - data path and memcpy ops
>   vfio: selftests: mlx5 driver - add send_msi support

>  .../selftests/kvm/include/arm64/processor.h   |    4 +-
>  tools/testing/selftests/kvm/irq_test.c        |    2 -

Sean and Marc/Oliver, can you take a look at the changes Jason made to
KVM selftests as part of this series before we merge this into the VFIO
tree?
