Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C644FE2D6;
	Tue, 13 Oct 2026 12:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893259; cv=none; b=fwqYOYtDKRYq+iYxkBlMlzhRvBrEjl8HDDO10EbuXd/rasIujxKwkdUI5xMpluFqrmSrQEK0x6qSKixgNjhE/wp1gjBHH4r8w5YilYJDdP9ydjOUa3CxL//Jwk+tboNXM7+iUtpBFcOa6yDpbZ8fqEIDcGDxBGOPmP4OsDevV24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893259; c=relaxed/simple;
	bh=h6r+qBWdqZyat60WLnQY5glR6CWmZjXhpcOSY0enuNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThOmDP8e7qejpvCNzf+OIpjCSQ59i1A0cj89yitwiHB14IfnBVsA9HcHU9WCL9/b5OyZq2OmnshA8M+kbUvRxfXS3tSqcnNNBFTW+snPBY72UPorXSxgysspy98TP4asqBuFTq4AWTQiMbY0Ze423qHioUq8rkB3h0nqtvdX2BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1pXKM19; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1pXKM19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0FA1F000FF;
	Tue, 13 Oct 2026 12:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893258;
	bh=2RNYO++fbEOi3NrRlqpINAYuGmJj5pDe/KYkKJ6gRnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1pXKM192HAFaKuhDjt88DHeC01PvR6ksl/jxSkOQdY2xm8RfKXIXtjT/j55LmTC9
	 PvZrr6za2fGWNuLqbr+d/bNgKD6evFE8bbLQjNYglEF+0aCOUYC0Mkd2Mg+VleaMXK
	 u+Y56+7oxQ0fOhqazw728dPPJ1mOMPhFxhfJ76iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 167/621] ALSA: ctxfi: Add hw parameter to daio_mgr_dao_init()
Date: Tue, 13 Oct 2026 13:32:42 +0200
Message-ID: <20261013112924.825936509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 220b7a53da220..9fd4f18a867e4 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -395,7 +395,7 @@ static int dao_rsc_init(struct dao *dao,
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
index 42b90c9b2ee9f..60cc1d14453a4 100644
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



