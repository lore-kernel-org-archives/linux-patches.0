Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87259353ED9
	for <patches@lists.linux.dev>; Thu, 30 Apr 2026 22:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777589659; cv=none; b=JY7hCnHA3ke151nHUYxaCKvPu5JaM40mggY547zGLjQ9gh38Xz/uaDbzXCtfy2Yk3lV8fAFDSYV5F325R9PIwwFjPx6XqaXonVeOmJ01DhPfY4Eed0LHrWR2+8Ap/3HikCUKMsWK8MYa6PBL7mHYA03xLAhki3wecrJR0uHBovw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777589659; c=relaxed/simple;
	bh=m5Oa9xrjs93ypR2Ul+XH1avEWXnt5/WG1koUdy/DN8w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Sk+zlNxh6JnhbtHn3jvV0wKfVuMfGJtMc19Qo4lM48/ZYKt6/x6jwW8O+Efv6cWolvI9yx0cnYsMHWdttPquTdTWokq7giXbn5SI0mWnUZ//gSALMSUO1+8h7Dy8ZkaDJJlp14Rpq9B0GXq+JKuz4JEyJsRpS7gtsZMrDcvrllk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bMVoMpZe; arc=none smtp.client-ip=74.125.82.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bMVoMpZe"
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2ee34588671so723227eec.0
        for <patches@lists.linux.dev>; Thu, 30 Apr 2026 15:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777589658; x=1778194458; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gZHidt1m0JlvpU+VvYCM2F4O0JmyQBeuxJIN2gPX9og=;
        b=bMVoMpZeBXf/gI+Njs5lnR8WC5Rz1JXrI70DGUt71tszJ0SmF09HhDEOED5iJK8YtZ
         892gnPvH+GDCxaXyWGSOk/FuCEVOCPB9JFwZI9HiFZO3Tl81O4jUibgVPHf3iv1QadP/
         et614JXBJmCrIqDC7ucXqKPzL3mzokWohLeae3pL9liEZ4QIbPEU0cg2ZJvtqWU6mgrM
         giy+fWnjeBS7I6UmXa/W3Mq/yxcnX3fjiTagS1QzuddyXaHA6lI5MyN0ncRm6Mz0xx/m
         UL1zO5xxodft7N4Fk8oJHpVTCRhh8lMf/6FBndRsDQiEwAiTsWZoJS0jRGZTT4qhhrBI
         EA8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777589658; x=1778194458;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gZHidt1m0JlvpU+VvYCM2F4O0JmyQBeuxJIN2gPX9og=;
        b=e0kKo1PSHlFAbmwkv5NhW1REQTDWHizXVKlTKTkLXC61lUw6xIR82kj4UGkc606DNS
         OtMWzLXfgJdiMMQCOf2PfR7HAwCmZeOcq8fmogxYB7Pz1zl6nIyGlfM69eeK7wwhPh+2
         s2kq3DcXYDFzKGtwM0ghigH4FwjF3+4e+4T6rjSGsaHfV3EwwjE7Tru/ettxGHqDjnFB
         1aZ4PHkoeKRiRjqFpL/kLMlMco1dTjooI1w170otiVLpD9vUJ1zhWqQTddgH12yonyA9
         lGLVZX3Vba1nl3TQFcg6kGhrfJz1J1oU2PV/ALlOEIYJU33SiOWb83AHZaM7lPLhtdCn
         vaaw==
X-Forwarded-Encrypted: i=1; AFNElJ9fAQf0I5Vsk0Fas2OUounQ29Eah8qlxbSV3bBf2gY9QYK/eIk57jkcYr/cpda9RjCs3H9cekyG@lists.linux.dev
X-Gm-Message-State: AOJu0YxqJj6KqjXcsVFpNKo+E4aP3N3b0/2cpZ3SbL62x3DcqDLYD8Zo
	77z8eU+aRrq8077R/yqvacUrU/0FVVwm6dJWl7aJAKe+0GHwIULD2HsAtaLXfYm6+fLuIDZO77F
	ZBA==
X-Received: from dybod18.prod.google.com ([2002:a05:7301:3f92:b0:2ed:a84e:18d3])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:901:b0:2ed:f791:3417
 with SMTP id 5a478bee46e88-2edf7a08036mr1180335eec.25.1777589657332; Thu, 30
 Apr 2026 15:54:17 -0700 (PDT)
Date: Thu, 30 Apr 2026 22:54:14 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260430225414.205094-1-wnliu@google.com>
Subject: [PATCH] iommu/amd: Fix precedence order in set_dte_passthrough()
From: Weinan Liu <wnliu@google.com>
To: iommu@lists.linux.dev, jgg@nvidia.com, joro@8bytes.org, 
	suravee.suthikulpanit@amd.com
Cc: will@kernel.org, patches@lists.linux.dev, robin.murphy@arm.com, 
	vasant.hegde@amd.com, santosh.shukla@amd.com, chrisl@kernel.org, 
	Weinan Liu <wnliu@google.com>
Content-Type: text/plain; charset="UTF-8"

Bitwise OR | operator has a higher precedence than the ternary ?:
operatior. It will be incorrectly evaluated as:

new->data[1] |= (FIELD_PREP(...) | dev_data->ats_enabled) ? DTE_FLAG_IOTLB : 0;

Wrap the conditional operation in parentheses to enforce the
correct evaluation order.

Fixes: 93eee2a49c1b ("iommu/amd: Refactor logic to program the host page table in DTE")
Signed-off-by: Weinan Liu <wnliu@google.com>
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

