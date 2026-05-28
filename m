Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C4C30F535
	for <patches@lists.linux.dev>; Thu, 28 May 2026 22:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780007517; cv=none; b=coMZ4KcGn9lhvaBpqGxI9MjB0boRqR1x7mfoeABVcmcajua583TObCzm2PVm3BNcuem22Ughwv1tsIWuIqssMR8+1L4tf5xtDJLj6ouqwA+0AU6S8QQRsZEA1nY7QWeWTFr/WOpay2pSAuOBn2BgsBl/DICbY+T7BcMtpCJ8Ap8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780007517; c=relaxed/simple;
	bh=fewyrO7jRSDRezpROiazTrcQjh82K+907ZqYYNd/aeo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dTym1MwdfPVt9XuDcwMM/pcX2YnzWp98f0vAcI0PrgRnTSYUyWfxnllnfxxoXpAzlIxbwvhYuXO9P1DfROvTFmBp6nPiyenDF+3F7yaMkfkqJG3quYLn/295l4i4iEOHCj63ZJbn47iKewIr40AfnlU/QbVIW1vNGAhjYwNtfuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HcvpQw7e; arc=none smtp.client-ip=74.125.82.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HcvpQw7e"
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-3041ab826ddso13605815eec.0
        for <patches@lists.linux.dev>; Thu, 28 May 2026 15:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780007515; x=1780612315; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lA9n52XOp29AfkFZf1NgzFL5E2eupZtzE4Xy3Kjuzc8=;
        b=HcvpQw7ehVKMTtKxJmbO/8ECoSE5KO7txG5/5JjdF1+qk/qO5jyyAjW6eL5WADSmn3
         0SH1zriNCvHgRWriAnLhDwKITnDSDMS+zQrRcztmu6XJee5yo+1VYGd7yb4EizjN4u/a
         iyUsJcPaKCuJp6fltFYCyWJ3m0wJSMVXg/pqx5PVVjudABxNLRbKSqMtUhfZCMKkfbCV
         KRtcoCLeyN6IxH3JYLGYnOEOW/W7sKfCFAng/EXFu9DrNTpuXTTkfEjbebKjzgnffMiO
         xtHqNPkySAq+T2qZOi767xwR1ds319dQvPtF5kuDucpsEsMbeu+MaNqkAiXN6+ipqhM4
         IzuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780007515; x=1780612315;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lA9n52XOp29AfkFZf1NgzFL5E2eupZtzE4Xy3Kjuzc8=;
        b=mk8/V4YvcaMrtmRSHSewLEabfSWN7xNfHVVpiBmV03FGR4LBJLy+hpnbnUOs3eJsrL
         X2PEIEMSvJIYOm0XZG99Sdx0Vo3gYhLjlg4cPF7f9krNtFBH8mVip4limKVUDZlOzTCf
         q4yuWrVe0ikYzUlGJP5DR4xwHVAr5RE6mM7MZOsswAHux6OPB8GKcsNrW5alcTvZW2Bb
         kKIPH6IIAaB4oVUDa2+wJ5Mck7njHhu8sgmCXVxtJVnkimv3eTEyryMx9smeSj3OZRxi
         /6NBcm8Qq9qupsbEmtLZRdEWBxaC+FSB2oL5wixSJxXB7wpsFA23V4nj+eD8azyf2D2I
         BwEw==
X-Forwarded-Encrypted: i=1; AFNElJ+iYnQbf0I+yXn91jLhDItMhG12tzEsvCof8N79EzqH0cgVO1Zl3dLTlXRX2YVaXDIa3iHCPrmV@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/ia/GSYeFEfsix5tpFLC++1arEm1QJO29p/UI/1lN3ljNU9KD
	nbxvDs+89B7LkgnKQ8+HN7M11fprT7P6zsrysSXtt69daVVfIW65TxTuPXq3mPpo99vkJcuBn9w
	crw==
X-Received: from dyx4.prod.google.com ([2002:a05:693c:8204:b0:304:eb73:cff1])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:7f9f:b0:2f2:6dde:df50
 with SMTP id 5a478bee46e88-304eb0d30ffmr188430eec.17.1780007515107; Thu, 28
 May 2026 15:31:55 -0700 (PDT)
Date: Thu, 28 May 2026 22:31:46 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260528223147.750229-1-wnliu@google.com>
Subject: [PATCH v2 0/1] Don't split flush for amd_iommu_domain_flush_all()
From: Weinan Liu <wnliu@google.com>
To: iommu@lists.linux.dev, jgg@nvidia.com, joro@8bytes.org, 
	suravee.suthikulpanit@amd.com
Cc: will@kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	robin.murphy@arm.com, vasant.hegde@amd.com, santosh.shukla@amd.com, 
	chrisl@kernel.org, josef@toxicpanda.com, Weinan Liu <wnliu@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch is a respin of Josef Bacik's original work[1] to fix the
performance issues and soft lockups in the AMD IOMMU driver when running
within a VM. I am taking over the respin as Josef currently has limited
time for this

[1]:https://lore.kernel.org/linux-iommu/ad8652c5e9f8aeee05e2103f4987589cdd4a3fd0.1772659768.git.josef@toxicpanda.com

Changes in v2:
* Update the patch according to comments of v1

Weinan Liu (1):
  iommu/amd: Don't split flush for amd_iommu_domain_flush_all()

 drivers/iommu/amd/iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.54.0.823.g6e5bcc1fc9-goog

