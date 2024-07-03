Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADE71891D3;
	Wed,  3 Jul 2024 10:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004375; cv=none; b=g6MeJpBMXdiYNIGg2uS58y/wknhZ/bmlyIwPja/RqJKc0KtKc8ShV2OxwuPY1Qa9v6/AGBTpkVbkE9IHC96+GAq/Yub9HjXB85lSdeCQi0ke2j3EYtNz3bYQirMQzZNNwjPS3eO2MEu2Ix7JkR0GpFE4VxM2h8XtBqMuleYTcgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004375; c=relaxed/simple;
	bh=eOTGa9Sz7zMFSs8S/XwJLlmCdu9yBSqN3Xm1ophje9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R971Mb2vPOeeYhNJz/nBGL7mMafzGqRrUnl68k7fNf5l4WVt5Z3Pah/PMzOxzP12N0pb29Jvn+ogQ2TrA1qFGI4bs/1jRYHNPeaLvrAPhfj9bh0VgcanL+TnIRVDA7guu5BxaC0aW7iXGlIckLMXV+SaU09OExOLbeuM1s8AIP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwxWP9Dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwxWP9Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29F3C4AF0C;
	Wed,  3 Jul 2024 10:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004375;
	bh=eOTGa9Sz7zMFSs8S/XwJLlmCdu9yBSqN3Xm1ophje9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwxWP9DcuymAyhgdoTkQVOWYjX5PbW2dF36e0SILUrsVhApcRB/wgOJIN4P3jXnmF
	 GVzvOJmhTvlbHLm6UGfOF+u4HmilrPXc4EJ5cPLKOS3ebDMByk9WtrTkASXr/O0+7j
	 h6ewQyIA5tBJPSMRMhfCnU8voPZ6z2n4xP9bF8PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Liad Kaufman <liad.kaufman@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/290] wifi: iwlwifi: mvm: revert gen2 TX A-MPDU size to 64
Date: Wed,  3 Jul 2024 12:36:27 +0200
Message-ID: <20240703102904.420754123@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 32104c9f8f5ee..d59a47637d120 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -133,13 +133,8 @@ enum {
 
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



