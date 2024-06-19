Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585A94D9EA;
	Wed, 19 Jun 2024 13:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803586; cv=none; b=dkW7bvvOUyiwigaHkg5aG4a0V6vIMTbsWNAAuuQlTKsTfG2KUssCFVXIl0Vcw59tWpsMjYjd1Gi0SPXFGSgB6s8NAwRV41cNn2us6/IogsYQ2o48Vlvkath8dgHt3VDkYaW+0ocZUi+R9gpKvfgv4tBH6Uj4MW0vkutUv2JgJzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803586; c=relaxed/simple;
	bh=QVEt0jS8yKgcYRGK4eoxS8B3eFteVMjcajqDwimHo9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kdt379K9kNHBJP0oNSvhEnvASzKN23GZBkmB0ZGowpeZVfPM86bMG07xzd4p/nvHI6bjQDEisT/swWaRn2adTdf4zkXjJLQlK1+PvbAkVn2PjuB4yXDOKHT2DKj5SYWX7AHW/8fyv2xK65bLeAofM2Je+LicvepK9nkgo6bPRK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvJSoaTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvJSoaTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D321EC2BBFC;
	Wed, 19 Jun 2024 13:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803586;
	bh=QVEt0jS8yKgcYRGK4eoxS8B3eFteVMjcajqDwimHo9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvJSoaTt82kEmlYblaJPOiFjVvZe2IlP3Vas/7qj1X/JreXBczU1hTadE5AgVnaYI
	 5V76wrvaLO8+Z+u9xSQlCUwA7/DMU7/qib9MGIsv7k9PSncvHdN6cF7A33oX0UYF8K
	 Cuys/13fTKVsN49FqCiEXpbgf8tt5KEG2JKeVcpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Liad Kaufman <liad.kaufman@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/217] wifi: iwlwifi: mvm: revert gen2 TX A-MPDU size to 64
Date: Wed, 19 Jun 2024 14:54:09 +0200
Message-ID: <20240619125556.745971715@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b7bc8c1b2ddae..00f04f675cbbb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -123,13 +123,8 @@ enum {
 
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



