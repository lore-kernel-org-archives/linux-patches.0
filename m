Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD40C3B2FCA;
	Sat, 17 Oct 2026 17:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258470; cv=none; b=CLWkpTiU1q3Ltm/eNOrSHSgkKzIY7Y5+C4j8wylJTr+nsWQAMhMXmlnPMV1Vh46BR1BwnWPs7ZNPkF5QsX3NtClvhhCG0ARZ2FKUt3AHaVKszfIjwo4NE9PA72mWhdhx5ZdINAG5SDZxvp0bvBn91+Nd9DbHjujjMNsJ232E7BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258470; c=relaxed/simple;
	bh=CWbbas2t2ls1ysZrGTnO3Ba/LlEgagsOz0c9sphvZgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAHLI2akHvPN27xRZIckSOxeaYi7G04ldwACJEaqfKTzWLNIBmXNmhbnDU3RQCZdyu8BO/9eUHPCYF3lTOVzR/MWJYMsJEh+YRyHHGGsCRu1WYbqVwcK85OXWmVwFmYntS5eOyDrik+pDGJse/NTOSCwmfGuCYX5EYYrfuivuhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7BLWMJD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7BLWMJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BBB1F000C4;
	Sat, 17 Oct 2026 17:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258469;
	bh=mAXTBGydqq0JV7UaaswqGYxzor4pkgQAqOC+36FiMg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r7BLWMJDQJQGnbCXJtf7aC8wt+zBdy+gTxwEnDwIZpjdTQmoXCZIXvkx+R7m6y105
	 eWVIMGNKF30xVEnhcYQaWvTAx6qNXvxJFbbKwEDVTOEKOnQfNEA1JBk8msqF5yvWGI
	 AfurwVIansgvRuJpsM658arUKMgj8gm6wOJ5MoZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0896/1674] ALSA: ctxfi: Add hw parameter to daio_mgr_dao_init()
Date: Sat, 17 Oct 2026 17:52:48 +0200
Message-ID: <20261017160454.128327119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Harin Lee <me@harin.net>

[ Upstream commit 5ebd054272718334c543998a6d0b77a9846c16d9 ]

Add a hw parameter to the daio_mgr_dao_init() function to provide
access to model-specific information. This is necessary for proper
configuration of S/PDIF and I2S output ports on different hardware
variants.

Signed-off-by: Harin Lee <me@harin.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251124180501.2760421-2-me@harin.net
Stable-dep-of: 277c6960d4dd ("ALSA: ctxfi: Check the error for index mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ctxfi/ctdaio.c     | 2 +-
 sound/pci/ctxfi/cthardware.h | 2 +-
 sound/pci/ctxfi/cthw20k1.c   | 2 +-
 sound/pci/ctxfi/cthw20k2.c   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index 4e4c780bfa9d3..ea2914c7736ea 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -413,7 +413,7 @@ static int dao_rsc_init(struct dao *dao,
 	hw->daio_mgr_commit_write(hw, mgr->mgr.ctrl_blk);
 
 	conf = (desc->msr & 0x7) | (desc->passthru << 3);
-	hw->daio_mgr_dao_init(mgr->mgr.ctrl_blk,
+	hw->daio_mgr_dao_init(hw, mgr->mgr.ctrl_blk,
 			daio_device_index(dao->daio.type, hw), conf);
 	hw->daio_mgr_enb_dao(mgr->mgr.ctrl_blk,
 			daio_device_index(dao->daio.type, hw));
diff --git a/sound/pci/ctxfi/cthardware.h b/sound/pci/ctxfi/cthardware.h
index 2875cec83b8f2..d29b4e5b3fcc4 100644
--- a/sound/pci/ctxfi/cthardware.h
+++ b/sound/pci/ctxfi/cthardware.h
@@ -167,7 +167,7 @@ struct hw {
 	int (*daio_mgr_dsb_dai)(void *blk, unsigned int idx);
 	int (*daio_mgr_enb_dao)(void *blk, unsigned int idx);
 	int (*daio_mgr_dsb_dao)(void *blk, unsigned int idx);
-	int (*daio_mgr_dao_init)(void *blk, unsigned int idx,
+	int (*daio_mgr_dao_init)(struct hw *hw, void *blk, unsigned int idx,
 						unsigned int conf);
 	int (*daio_mgr_set_imaparc)(void *blk, unsigned int slot);
 	int (*daio_mgr_set_imapnxt)(void *blk, unsigned int next);
diff --git a/sound/pci/ctxfi/cthw20k1.c b/sound/pci/ctxfi/cthw20k1.c
index 9edbf5d8c3c70..7b41e1ffda082 100644
--- a/sound/pci/ctxfi/cthw20k1.c
+++ b/sound/pci/ctxfi/cthw20k1.c
@@ -1031,7 +1031,7 @@ static int daio_mgr_dsb_dao(void *blk, unsigned int idx)
 	return 0;
 }
 
-static int daio_mgr_dao_init(void *blk, unsigned int idx, unsigned int conf)
+static int daio_mgr_dao_init(struct hw *hw __maybe_unused, void *blk, unsigned int idx, unsigned int conf)
 {
 	struct daio_mgr_ctrl_blk *ctl = blk;
 
diff --git a/sound/pci/ctxfi/cthw20k2.c b/sound/pci/ctxfi/cthw20k2.c
index 4d970f25a2c6c..e45c655528f51 100644
--- a/sound/pci/ctxfi/cthw20k2.c
+++ b/sound/pci/ctxfi/cthw20k2.c
@@ -985,7 +985,7 @@ static int daio_mgr_dsb_dao(void *blk, unsigned int idx)
 	return 0;
 }
 
-static int daio_mgr_dao_init(void *blk, unsigned int idx, unsigned int conf)
+static int daio_mgr_dao_init(struct hw *hw __maybe_unused, void *blk, unsigned int idx, unsigned int conf)
 {
 	struct daio_mgr_ctrl_blk *ctl = blk;
 
-- 
2.53.0



