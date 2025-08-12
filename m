Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833A71EBFE0;
	Tue, 12 Aug 2025 18:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022897; cv=none; b=XrDVSOQ296pXZDjozK7j0y+5xNhGy9VcsffQvTkIjAdkVhfN/VcSyJ0GkgSoShntoPeKDQUOCETIaVsjtnxMKniF6wb9IHBDI9527wrMkz0Fi+PATZTcYXnGhuvja3utLJa5GJA4eQGxOQMyMfiwSG6OTLDBru77TuHBI+bBGbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022897; c=relaxed/simple;
	bh=gWW5C6ARQLcXgCpt7FifOhOuHh5hAWI7VAZySc9sMOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cr4TKczxd5/J5t+9GB6bWC5+qpRsOqLO0BgtD0QNdD1S2zFKqiMRrEXqbYwuUJIJrxC/mBSNeDhxVcUhz5guTVsvCb36YZLRyzA7zPVdNL3jftslycvnt5+g71Ypof4ZjE9k2zGD8fe6bfI0iI856LA7/2ZxaRFWkmZ+4OaJABQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jn8Q471; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jn8Q471"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93716C4CEF0;
	Tue, 12 Aug 2025 18:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022897;
	bh=gWW5C6ARQLcXgCpt7FifOhOuHh5hAWI7VAZySc9sMOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jn8Q471OtCvDZoGxQo43LCITHbDEi8NjRR5zJbASXa8RkOcs8Y1BRRjH7YiPOFQf
	 lwKrOo/AV/6B3Xg5iF2CRKtKiv1jdQIiJBZndUBZfraY4vIqrqK3/ZHeyFHG+jeg1u
	 FebgbPPgoDyW1sbkz4IFTMBLRuQAHx3PbqqZH1A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/369] s390/ap: Unmask SLCF bit in card and queue ap functions sysfs
Date: Tue, 12 Aug 2025 19:29:49 +0200
Message-ID: <20250812173027.716324623@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 123b7c7c2ba725daf3bfa5ce421d65b92cb5c075 ]

The SLCF bit ("stateless command filtering") introduced with
CEX8 cards was because of the function mask's default value
suppressed when user space read the ap function for an AP
card or queue. Unmask this bit so that user space applications
like lszcrypt can evaluate and list this feature.

Fixes: d4c53ae8e494 ("s390/ap: store TAPQ hwinfo in struct ap_card")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/ap.h   | 2 +-
 drivers/s390/crypto/ap_bus.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/ap.h b/arch/s390/include/asm/ap.h
index 395b02d6a133..352108727d7e 100644
--- a/arch/s390/include/asm/ap.h
+++ b/arch/s390/include/asm/ap.h
@@ -103,7 +103,7 @@ struct ap_tapq_hwinfo {
 			unsigned int accel :  1; /* A */
 			unsigned int ep11  :  1; /* X */
 			unsigned int apxa  :  1; /* APXA */
-			unsigned int	   :  1;
+			unsigned int slcf  :  1; /* Cmd filtering avail. */
 			unsigned int class :  8;
 			unsigned int bs	   :  2; /* SE bind/assoc */
 			unsigned int	   : 14;
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index f4622ee4d894..6111913c858c 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -180,7 +180,7 @@ struct ap_card {
 	atomic64_t total_request_count;	/* # requests ever for this AP device.*/
 };
 
-#define TAPQ_CARD_HWINFO_MASK 0xFEFF0000FFFF0F0FUL
+#define TAPQ_CARD_HWINFO_MASK 0xFFFF0000FFFF0F0FUL
 #define ASSOC_IDX_INVALID 0x10000
 
 #define to_ap_card(x) container_of((x), struct ap_card, ap_dev.device)
-- 
2.39.5



