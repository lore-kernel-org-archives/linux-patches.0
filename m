Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0053A71A8;
	Sun, 13 Sep 2026 11:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789298802; cv=none; b=W2zQHATl6+5OqCTGct2Cm3G6Obc5DIcBTfNus2Rk4XXhjKioSyRabJiauomARaxsM0ih575NO7K3tiFyywaHgagIVXymxoTQp9v1mVIk4WMd+rbBhYk5qxQi+ruyY+tQzgD6pmtuulDHEvkvCmH7rUo6XQIcRn9jkKXuDCgLSbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789298802; c=relaxed/simple;
	bh=ijj0b1tUOu01EZHSgJ9UEYtO7eDF+s4CN1rvJZMrmjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MU+sW4B0OHSnSp3NZYNiDgTHWguixZ3MXXxO1RGa1RY4FT1+VPg5veeoBU1fje7kz5Wi5TGjI2AKBVUBNTRBhg1uizwWI6HeanEfc0k62W0f4HKyv25NT3hxG5ApFpbyZ6K/BpIMhgyH7vr3LlMX2PKyKTIAy4fD8xBPqv0hUwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=noKeahuO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="noKeahuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BA81F00898;
	Sun, 13 Sep 2026 11:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789298798;
	bh=+UeFP0MN0uSHMyHHESdpH2d12ZiLI8blNfBqNiJcXLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=noKeahuOYAJV8hSsV1C2GVQHt8k058fBlGQV+B890jz2Xb2pVgvav/cPGExZJ8ib1
	 sp/oJ44EEMbD3YOLe+BJPrYF6GSKymc1ua0Nv6NOh5AxTjxbq85FVpdsmKyeAsTc11
	 b4JKOFGh9owSxeEiPBYxU2XXyxmEfmzdVtRFvny5T5XEwN8naES7hqLijfvdd2WzUq
	 hbUgHA7m1yl/eVFVBWUFr9knM/SPtmearOcTClxTCM1/P9mIjFt4YE0spI1eBphMfV
	 A9a75ZufAE4JW4Dnj4Lq3SkO9ceMiynPw9MhTz2LrlSfVYzL2MLsfsmvG1K2KlAt71
	 EkLZnB/72qODw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yee Li <seven.yi.lee@gmail.com>
Subject: Re: [PATCH 7.2 0368/1815] iommufd/selftest: Fix dmabuf leak in iommufd_test_dmabuf_get()
Date: Sun, 13 Sep 2026 07:26:22 -0400
Message-ID: <rc-reply-report-026-iommufd-20260913@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CALX8JfSjnAd6bY8zBCHuG=_+f4JiVCrhT+sW4DPEpUM6+5LF-w@mail.gmail.com>
References: <20260912065648.999753832@linuxfoundation.org> <20260912065657.541103882@linuxfoundation.org> <CALX8JfSjnAd6bY8zBCHuG=_+f4JiVCrhT+sW4DPEpUM6+5LF-w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Success path return rc was changed to return 0.

Dropped from the 7.2 queue. Will requeue together with the upstream fix
("iommufd/selftest: Return dmabuf fd from IOMMU_TEST_OP_DMABUF_GET
again") once that lands in Linus's mainline tree.

Thanks for the report.

-- 
Thanks,
Sasha
