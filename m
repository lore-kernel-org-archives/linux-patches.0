Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27152C21F7;
	Tue, 12 Aug 2025 19:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026621; cv=none; b=DIAYAvG0ukoR6UtlIQMyJxt8AFEteHl5W9+10Sh+b1eY0m+sT8gmM5Pk0YzrCmc3hmqlRWEz9sdX9KAx7SGpmiBeg8QVnS91lyPM/pTPr1dNu7+oitdhfDMl4tCKqltD9WeggFbnIYp9wcULBWBY3Xpqgw5sAGVtEz6wonVgezE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026621; c=relaxed/simple;
	bh=E0gJZgOh+F1blJWssBaoJXulI7d5CGtn6ckK1c7Wvq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/wbamX3hOApzEOPri+9i847u9SXo3XncrMaDlXdjmk6Yr/RH5awI09QWVwmPmCD6Kgy1iWH69rlD6mikUMj4pYugnTkfoubO2bj77XKfR3qu0XGq278uZm9Mcd1eRYBkN/gQxxfzGK12SmdbZhFsNXxX5bouLFVfzZnb5qSIIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8KVRa4T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8KVRa4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B02C4CEF8;
	Tue, 12 Aug 2025 19:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026621;
	bh=E0gJZgOh+F1blJWssBaoJXulI7d5CGtn6ckK1c7Wvq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8KVRa4ThvIU/zyh8Zyi+vTn7MjuCantI2kfU0WjSW5TKnuPa7FcB8CHq60RqLkQe
	 ZjDSnNUADWNqanuID4GjKTdpaPcHt1DKfENoxSANQd5vQ/lW8kuZi83KSmLNmBwd7L
	 BiqzdeHuE9lHiJ9LDxpeWKoLJGodN0ZdUp5AwQoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 391/480] s390/ap: Unmask SLCF bit in card and queue ap functions sysfs
Date: Tue, 12 Aug 2025 19:49:59 +0200
Message-ID: <20250812174413.556514674@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



