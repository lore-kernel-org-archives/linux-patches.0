Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB4C2FF15F;
	Tue, 12 Aug 2025 18:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024947; cv=none; b=kvqG3/IgVRjntjmYTlU/dyuNBhjeDYpTWKARrpyUb58mvPT+Fn09455BwytFa0lNRRfbQOxJkR+Oy7AzBBman2TArOyHJ/lHCBGb70y36m8V7Xg71+qzUAZA4O649RDJkdh0LfotVrNOWuUWSNlXE2No1ctRkeyEzjtugQ4FtZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024947; c=relaxed/simple;
	bh=pWZ/rcd54cV4iFMYJbySXQvFbZXiryaBpUkiCGl436U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAXDuSev9w/OzdMMdxrcwiWfbb5O23yrCBDrAWaWq6DWJSLz51BQZi1hl1T5mycRNAMGNiY1OVKqENLf65xfUQDEmZiG0/rnm1rvLbSU5Hr0w2OdWL3dpBzFX5oHs3XeJgtj0oTHJX32S14QuvC51G4t/Ee8/+LKjOfNO2Rhz/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbeZbuvQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbeZbuvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B607C4CEF0;
	Tue, 12 Aug 2025 18:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024946;
	bh=pWZ/rcd54cV4iFMYJbySXQvFbZXiryaBpUkiCGl436U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbeZbuvQsTl0KMXELyNH8zobDCugRVR+6yL2uEIyE6O7F92IY8uxy+D1Ork/7y7u3
	 j9EdW0Qn8tKlkVreYK86CGhKtSFGC0lMmjbEWSLk37zjJx7RhisGipTu8DIGWePvtr
	 NfyzHDObiTEOv2ckV0+rAoQMeStD6jcf849BGZuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 522/627] s390/ap: Unmask SLCF bit in card and queue ap functions sysfs
Date: Tue, 12 Aug 2025 19:33:37 +0200
Message-ID: <20250812173451.515423312@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 88b625ba1978..4b7ffa840563 100644
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



