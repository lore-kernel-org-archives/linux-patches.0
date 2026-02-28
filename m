Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30704340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301080; cv=none; b=MVwmC7TGQELvxcjAtMD3RDfwABgOqGaBoVdWtdwDR5GiH1MKwlte18I/whAkwQ/vUrOdSKgYo8tAgCMOTQ6u4wIhokcWbOjZzPsQR0kVOf3YZkjTgNae7L/5cvyvCrJzGriOujwHjdglhQQoCutnSxMru6Wzf879dYK/OIliU6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301080; c=relaxed/simple;
	bh=1eJRIi7rZxnG0yH3rK9b/31SZFamPACMOK8xQRNA2Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCDy0AtFVWNzF1fayaGygjppQP6R97NLlVPvSTiB3ypNrhFHY4nqZOpbM4PQbxk++BrjzvBfamfZYBMObcRvcxL9jHxycFshRwRCjnxe3KLj7Rv1z/Q+udtUQCGZxw2kEa0tgjefeYqeCR0YNfevCyTeuGfOA91TcDKD2GmOg0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tq6R4QpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tq6R4QpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9509EC19423;
	Sat, 28 Feb 2026 17:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301080;
	bh=1eJRIi7rZxnG0yH3rK9b/31SZFamPACMOK8xQRNA2Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tq6R4QpKy2owxZ2xEoe3J+RBz0odwk/UrFD4/An5z9oxlM3h6PyIbNbCaJZRxVwy1
	 ZflGw97o33wHvAV/Wsw6am07XxE6PwLek9Untp1refy+TmnLxBrwKglsel9dN5QgwN
	 THsJTZDGKBQV2Qt5Iles00G6b3TfgXyGUj4ZAUEREAz9ciWUVpGTgfwc5JciuLIft7
	 DnpuyxprTUd6qURWU5FOAqK/NXDMd9bEDg2FdEnrITE/6+7NZ7vN906KQcvockKcdK
	 O4IHcR93k+dKSCE/t+uJpv55mfrzXp7OpnzIcgsyKuyJUl34BxKeBAbsRbuLDq6EOA
	 I0iTAgUrkqUAw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Slark Xiao <slark_xiao@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 227/752] net: wwan: mhi: Add network support for Foxconn T99W760
Date: Sat, 28 Feb 2026 12:38:58 -0500
Message-ID: <20260228174750.1542406-227-sashal@kernel.org>
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

From: Slark Xiao <slark_xiao@163.com>

[ Upstream commit 915a5f60ad947e8dd515d2cc77a96a14dffb3f15 ]

T99W760 is designed based on Qualcomm SDX35 chip. It use similar
architecture with SDX72/SDX75 chip. So we need to assign initial
link id for this device to make sure network available.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
Link: https://patch.msgid.link/20260105022646.10630-1-slark_xiao@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/mhi_wwan_mbim.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_mbim.c
index f8bc9a39bfa30..1d7e3ad900c12 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -98,7 +98,8 @@ static struct mhi_mbim_link *mhi_mbim_get_link_rcu(struct mhi_mbim_context *mbim
 static int mhi_mbim_get_link_mux_id(struct mhi_controller *cntrl)
 {
 	if (strcmp(cntrl->name, "foxconn-dw5934e") == 0 ||
-	    strcmp(cntrl->name, "foxconn-t99w640") == 0)
+	    strcmp(cntrl->name, "foxconn-t99w640") == 0 ||
+	    strcmp(cntrl->name, "foxconn-t99w760") == 0)
 		return WDS_BIND_MUX_DATA_PORT_MUX_ID;
 
 	return 0;
-- 
2.51.0

