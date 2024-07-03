Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575C216EC0C;
	Wed,  3 Jul 2024 11:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005233; cv=none; b=GSCn0lIBKU6yVCtxv/wmgDrSsZyJVR7nVsiraKMn+k8m6W5DqBXauBdYI3yXJZC8iGIDymCLvxzBl5MH09J9uRnVJlrsPR9vLlnFIToACK4KLQn9ww3+hDB2j4M78lbYbPxHvcUWv/rTZus5uihvPdKqsPBpWZpr2zahRzfgeHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005233; c=relaxed/simple;
	bh=Hwjl51vearaWGvFU7vWGyMHrsFhv6eL3Y+kEQ+kmAkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmAhzZNhOiAq20l0rL7vuIW8bQZR+YRiemPVH7Cqz2FNOE4DJJyoIUz8rwKhapAH/ufFvvg2N3nYdb/h3GizY7rjwJuoCRCmR/xZYaM+gA0cgQhcmMbKIgCpqsfGf6/UXyY+9duR0w8GC6KTj4HCfWzElgxwMoVL2FsiFs+vihU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yV48+kuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yV48+kuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD2DC2BD10;
	Wed,  3 Jul 2024 11:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005233;
	bh=Hwjl51vearaWGvFU7vWGyMHrsFhv6eL3Y+kEQ+kmAkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yV48+kuXryzcqGzhFiyobxW2p+n2TGAiqW/hPe8/LZPFhLDybHeNXEVptzFQyNc4e
	 pDS0FYW9QvW1xKpnU2d1ae3IEGSQ96VWbWSalWhq5mM+9qF+63/lGMU7qzWE9bqx6p
	 hCvH5B0DQN+cCfwcGrtQHeMUPF6QtyNJdl61CKmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Liad Kaufman <liad.kaufman@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/356] wifi: iwlwifi: mvm: revert gen2 TX A-MPDU size to 64
Date: Wed,  3 Jul 2024 12:35:41 +0200
Message-ID: <20240703102913.303739853@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



