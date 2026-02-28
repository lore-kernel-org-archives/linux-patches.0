Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A03A3603DE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300916; cv=none; b=OPIUuDSqJRkxSGWl00pB8gdK9mTIN5wSxBwbJny8/hxa0LvjHOk94rHfxTEP+4G08z8G/3QOg05O7A2KoNcRBeri4FQgpWJyUnXh73jOkZHRYd9V05YKyJ90qjtAJdIVGnSkadcCzGOk/8H5njzVIQAEqjpaRZQ+EnDZH6M42M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300916; c=relaxed/simple;
	bh=iv7VVudKM1I3hlT9k5+PCMCP6tgXzG9LZ2Dv/FdCcbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUUx98g050mF7ZeqcWH6k3bbje7SthufNLdBdsBZBq+4SV9bkgn9WkJDBq2iQVtenfwiHOTaQnu0YxT70RaIIih4qTGPakqU3IMAdo6vW8ohyosUhPT1Vz9qxwdCHXuHY9NZVPnj7ytINixloc2L5GJ5MTrKWPaDXmiCZ4kmoew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OCW5rLNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OCW5rLNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F27C116D0;
	Sat, 28 Feb 2026 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300916;
	bh=iv7VVudKM1I3hlT9k5+PCMCP6tgXzG9LZ2Dv/FdCcbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCW5rLNP3wbpd4tDunrjjKrzRoEiBOYCgTg+DbndZEwqSqX/lgYqV3VAcPG+9gpI9
	 e83aaindbgdimGcMCXcoDD17i2Dqna2A5Ss6rIgOTypWP2dJvuU/d7XucVUbeZdSID
	 3oQFPBT944XUoQApRLYK9IPppVwLFwRxTfmRYWPTpXaEy6twkmSkMtgCLeXQNScwsy
	 D8RZ+O4t/KXOaIQWkpOqUnkJUD8s5u2sMDiEulJ+BiB5Yv/1VYBl+7qIHXg6Pf4m3r
	 f8ZRtpfrxuluaDExJxtjOsgH3QT6V4l0dguPvZBTYLHxHf0BlOkxcT/FLztoMBOryb
	 HzRytuH1OMmoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/752] i3c: mipi-i3c-hci: Reset RING_OPERATION1 fields during init
Date: Sat, 28 Feb 2026 12:35:43 -0500
Message-ID: <20260228174750.1542406-32-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 78f63ae4a82db173f93adca462e63d11ba06b126 ]

The MIPI I3C HCI specification does not define reset values for
RING_OPERATION1 fields, and some controllers (e.g., Intel) do not clear
them during a software reset.  Ensure the ring pointers are explicitly
set to zero during bus initialization to avoid inconsistent state.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260113072702.16268-2-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index c401a9425cdc5..951abfea5a6fd 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -342,6 +342,14 @@ static int hci_dma_init(struct i3c_hci *hci)
 		rh_reg_write(INTR_SIGNAL_ENABLE, regval);
 
 ring_ready:
+		/*
+		 * The MIPI I3C HCI specification does not document reset values for
+		 * RING_OPERATION1 fields and some controllers (e.g. Intel controllers)
+		 * do not reset the values, so ensure the ring pointers are set to zero
+		 * here.
+		 */
+		rh_reg_write(RING_OPERATION1, 0);
+
 		rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE |
 					   RING_CTRL_RUN_STOP);
 	}
-- 
2.51.0

