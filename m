Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376091442F1;
	Wed, 19 Jun 2024 12:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801913; cv=none; b=dgWCvFCNfY50J00l68eneRiXah4FJQvKQd2Vvj/DpBBEAT5r34P24GrxLhx8TLOj2Tyodl/8zZXJkMBhRdc7AywgQzvNu60nhf3BWFjR8iaH4Szl94UlJLZRWFVmxp4Jmna2EqHH8CWoQKQ7ev/lRYJUPa5Qk1UngtyQ4dRGGG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801913; c=relaxed/simple;
	bh=tMshOxDbmlQlJgjMOoEkgDyGsCJxmC2+yKONV0/w1Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ss5jUCHCVsqjNDhGc4jyT2XAvydjOYUi37Ceauos/FrDesASAcdfo3Xm6Ru0t+xrYeKPem1uHPbyMlHr6JtMvUqB6ka48NqwCII2YT05ug73Xpe7jsxfWuqs9xdRuyxbRv9UfEqWot5L21jz1PxPaqVSttnm8FLXH+cxsBlXIsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wiztK9MI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wiztK9MI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA0DC2BBFC;
	Wed, 19 Jun 2024 12:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801912;
	bh=tMshOxDbmlQlJgjMOoEkgDyGsCJxmC2+yKONV0/w1Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wiztK9MI7QEVSL5sePIp8N3CRMcVU/5hr0SBPMzvAMxnzGDDpKiOEkRmvqlGGbSyv
	 u2oo9HNJB347GU8C/9BCnFKxThRrFi5NmlBMCBGvkpc6rfKKwdvG0pAV0ilH8myRFe
	 gLfYg2OS8zQQF4b0zhRfcn29NsOHHnWjGNlfi5BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Liad Kaufman <liad.kaufman@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/267] wifi: iwlwifi: mvm: revert gen2 TX A-MPDU size to 64
Date: Wed, 19 Jun 2024 14:52:38 +0200
Message-ID: <20240619125606.634881314@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 4a7aace2899711592327463c1a29ffee44fcc66e ]

We don't actually support >64 even for HE devices, so revert
back to 64. This fixes an issue where the session is refused
because the queue is configured differently from the actual
session later.

Fixes: 514c30696fbc ("iwlwifi: add support for IEEE802.11ax")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240510170500.52f7b4cf83aa.If47e43adddf7fe250ed7f5571fbb35d8221c7c47@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
index 1ca375a5cf6b5..639cecc7a6e60 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -122,13 +122,8 @@ enum {
 
 #define LINK_QUAL_AGG_FRAME_LIMIT_DEF	(63)
 #define LINK_QUAL_AGG_FRAME_LIMIT_MAX	(63)
-/*
- * FIXME - various places in firmware API still use u8,
- * e.g. LQ command and SCD config command.
- * This should be 256 instead.
- */
-#define LINK_QUAL_AGG_FRAME_LIMIT_GEN2_DEF	(255)
-#define LINK_QUAL_AGG_FRAME_LIMIT_GEN2_MAX	(255)
+#define LINK_QUAL_AGG_FRAME_LIMIT_GEN2_DEF	(64)
+#define LINK_QUAL_AGG_FRAME_LIMIT_GEN2_MAX	(64)
 #define LINK_QUAL_AGG_FRAME_LIMIT_MIN	(0)
 
 #define LQ_SIZE		2	/* 2 mode tables:  "Active" and "Search" */
-- 
2.43.0



