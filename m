Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE0D1E8332;
	Tue, 17 Jun 2025 15:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174908; cv=none; b=qqao2jRbYHCMmZpLARM9GU4lM++nPIFm4Si81FawIEeAAhPVzGHG13PMsyoL4DP8+SVzTlU2QF/pOnBIXbKPJx89GmVI7wWRQnk6MBKLZNgzCo2K295G4gQq08bVDPYH9ocwldjdEfb3kgy4nG4KpvNhb10YF0ueihIzgimtDyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174908; c=relaxed/simple;
	bh=Yff4nPrLdJq2tcOmNQEM12NQM3CU+5w/xzEbUYfUKk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2dqceTUQ58vfZx5gT2XzaTyo1FnNQ0lElQCQZlCRJ3ePGQBC/pa6RotWm0jHy6CJkzzAxWgkaWzpQEgx0J65rqEHj/pAff6o/qSJJsUKf4c3Rq9DTPHOHo/hNvi/chaqLaYnbKdQ3g925yYwMIl5KrMGTS/Dhqj2JD7+foFeeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqPtrUes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqPtrUes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C589C4CEE3;
	Tue, 17 Jun 2025 15:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174908;
	bh=Yff4nPrLdJq2tcOmNQEM12NQM3CU+5w/xzEbUYfUKk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqPtrUes1b08+VaRzhpqpr+6d3eLYbRyb22hrdFhPjiiadIOhS2shbfE/3ws86w8f
	 7RlpAqaHP3HKIvoYYS2VJ9QphUzfJWYXC1F8xe/bCX95915fQJ6HdCaazCGUsoIM1v
	 cb9nmDTjqSqKINP3Wcdk48b+QMg2vUGitmgl+cA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/512] drm/panthor: Fix GPU_COHERENCY_ACE[_LITE] definitions
Date: Tue, 17 Jun 2025 17:20:38 +0200
Message-ID: <20250617152422.502181774@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit d1df2907fb69df56aad8e4a0734dac0778c234a7 ]

GPU_COHERENCY_ACE and GPU_COHERENCY_ACE_LITE definitions have been
swapped.

Changes in v2:
- New patch

Changes in v3:
- Add Steve's R-b

Reported-by: Liviu Dudau <liviu.dudau@arm.com>
Fixes: 546b366600ef ("drm/panthor: Add GPU register definitions")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/r/20250404080933.2912674-2-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_regs.h b/drivers/gpu/drm/panthor/panthor_regs.h
index b7b3b3add1662..a7a323dc5cf92 100644
--- a/drivers/gpu/drm/panthor/panthor_regs.h
+++ b/drivers/gpu/drm/panthor/panthor_regs.h
@@ -133,8 +133,8 @@
 #define GPU_COHERENCY_PROT_BIT(name)			BIT(GPU_COHERENCY_  ## name)
 
 #define GPU_COHERENCY_PROTOCOL				0x304
-#define   GPU_COHERENCY_ACE				0
-#define   GPU_COHERENCY_ACE_LITE			1
+#define   GPU_COHERENCY_ACE_LITE			0
+#define   GPU_COHERENCY_ACE				1
 #define   GPU_COHERENCY_NONE				31
 
 #define MCU_CONTROL					0x700
-- 
2.39.5



