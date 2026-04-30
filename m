Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACCD3CA4A0
	for <patches@lists.linux.dev>; Thu, 30 Apr 2026 23:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777591738; cv=none; b=gpxhn/neVFtqpzG5YGCEp6I8ro/su0A+nG7VPlfgWjLfBJtCjEAPs3F00lytRzpDEqUQYtqm3p30ygmUIYzb9RU3NtOJ3cH+a6Z7jQhNJ6FoozedOQQFgmxYpiWgGUQzB+fTRlQQ79aRDEBcG9d/oaEff2twyPz44/tpoSjj8iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777591738; c=relaxed/simple;
	bh=05e4kCmh5d4jmhjGWrDP68fi2cOhrwkmP/2S+lC/vVc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DtGuabjxL1/zyevZebbk53/NPy7FNuSQ8BgRXal7Kx2XgXItV+VKgm6MLYej999bbwp54ieJT9xUyHHkotCFv/9uvhwKFbKA51iirfFmcE4UiV27yz3JnucmRagXaSxFgw77xg9H7NLT1nUPxfrgiBN9dAd6RgmcrnFm3tcW2Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PPxVgLp+; arc=none smtp.client-ip=74.125.82.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PPxVgLp+"
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12db37213daso4279165c88.1
        for <patches@lists.linux.dev>; Thu, 30 Apr 2026 16:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777591736; x=1778196536; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J7V+aJczrYa+luWKSbD/4vJrKAK9nvJvKMYrb9vqHfk=;
        b=PPxVgLp+sNHMYsQdPCiRWje18TtQLHNhZXHt11z80MsH2qokFMi+HDDD6pQhQINfYh
         tIV9HgDoOWTUK1jV1odpMhx5VVkVE5HiZ/9X4XvLPmW1EtiTQehVtOZv3OVLccODDneO
         nM5Rd5KD67XpeeWGj0IJ+5j9KX0lHP0ajwTjLrLhciKZEdR1CA0UzwMSLX6DklYgheqY
         67kX9AjiwoS7q4AWQzsT0RUASw+uqwWHKe1ID/3Deh2e1adzREbepwuSf1Z4EHT4t3xZ
         76ucLH+Iq3OHLuWv55fNDtMK4tw03MjIOKj6Lva9mtpZ1H2BS3MMEqWDiGLiZ1NM+sQA
         PIOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777591736; x=1778196536;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J7V+aJczrYa+luWKSbD/4vJrKAK9nvJvKMYrb9vqHfk=;
        b=I5GGMkxk4WrO1/CWeMpHHSK+2LFFoevjCO3rRqkfCviHcYntpWlaOyke058VlMV1fu
         zmhtGNZq+EbapTdSRbp6SXz6djcE5Dtpvt//boaCYyHMc1Voyu/Y8PlM0tWg5Z+uXbkz
         Q1ey0PamZpCdXVf0TAAjfa9RjD9B0PQkcvGJ1TMAmlB+rQRB9n6EperdyGddrh7hQuer
         QNQgrevEFdpamvDKOEuEV1/7Ogfn7R3Z9uos9TewPGpqL5HUU+sCQxMzDwLUhV26zTOy
         UzZMKhx+W0oqu+PxdqlFE7m0fuDgsbDlBy/7h1zUOzDEwnkD9xPjPFCKKwNfd58dkMil
         FHCA==
X-Forwarded-Encrypted: i=1; AFNElJ+2WqCiA6zW66zpuolJBH5xuqqFjYjx5y+Y690Z5YtDwttDHt88YZ84bE8FwlqZfzDAx1KEERIg@lists.linux.dev
X-Gm-Message-State: AOJu0YyCVVgA/YUxMSt5EhEsV2DATTq9epsTicIcr/IS4kQai+EZFXQF
	bq8gLdrttIIkpWHk0SWB7AudWnk3iM7CnaoOvXDrG4W8ikLFzYdHqBWGjMmIGenwU5E9Gy6MZBO
	w9w==
X-Received: from dldnz3.prod.google.com ([2002:a05:701a:ca03:b0:12d:bd4b:5b09])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:985:b0:12d:b7e5:a691
 with SMTP id a92af1059eb24-12df822905emr291576c88.7.1777591736300; Thu, 30
 Apr 2026 16:28:56 -0700 (PDT)
Date: Thu, 30 Apr 2026 23:28:51 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260430232851.236666-1-wnliu@google.com>
Subject: [PATCH] iommu/amd: Fix precedence order in set_dte_passthrough()
From: Weinan Liu <wnliu@google.com>
To: iommu@lists.linux.dev, jgg@nvidia.com, joro@8bytes.org, 
	suravee.suthikulpanit@amd.com
Cc: will@kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	robin.murphy@arm.com, vasant.hegde@amd.com, santosh.shukla@amd.com, 
	chrisl@kernel.org, Weinan Liu <wnliu@google.com>
Content-Type: text/plain; charset="UTF-8"

Bitwise OR | operator has a higher precedence than the ternary ?:
operatior. It will be incorrectly evaluated as:

new->data[1] |= (FIELD_PREP(...) | dev_data->ats_enabled) ? DTE_FLAG_IOTLB : 0;

Wrap the conditional operation in parentheses to enforce the
correct evaluation order.

Fixes: 93eee2a49c1b ("iommu/amd: Refactor logic to program the host page table in DTE")
Signed-off-by: Weinan Liu <wnliu@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 01171361f9bc..ccffbecb15c2 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2149,7 +2149,8 @@ static void set_dte_passthrough(struct iommu_dev_data *dev_data,
 	new->data[0] |= DTE_FLAG_TV | DTE_FLAG_IR | DTE_FLAG_IW;
 
 	new->data[1] |= FIELD_PREP(DTE_DOMID_MASK, domain->id) |
-			(dev_data->ats_enabled) ? DTE_FLAG_IOTLB : 0;
+			(dev_data->ats_enabled ? DTE_FLAG_IOTLB : 0);
+
 }
 
 static void set_dte_entry(struct amd_iommu *iommu,
-- 
2.54.0.545.g6539524ca2-goog

