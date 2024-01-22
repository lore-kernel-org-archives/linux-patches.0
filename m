Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A256967A14;
	Tue, 23 Jan 2024 02:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975298; cv=none; b=peuHl8/AfTwjqR3wZWNGuNnnaH2UDnuXrd7jStpeM7Vf2PndR9MIB57hGycDYzDMCA08vXh927jkmAd2TbSyrS8Tyo1XvVq6kdltPSR1kRS2lnWZrlVuTG4KDXAiivDRPp8s88x7PAe8AsZbxgJM/zKhYsoXajPpHY2FiaauXSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975298; c=relaxed/simple;
	bh=RwP2lAC96xhtVjefW+soERTpCcUMr8XzG77LbVDgqZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cG8+LRkOvSB8FGkpS03rjGjdfIiPNXNRBuB4v5PjqDLTtw26pOPK7o3lnP78BL+mpYPa7p+gonHRzohI6s/5GIuU5YR1OJ9NmkbrF1g/z5OdPTYNyw8te9K9h1jtSl9wV7oPeomuDRZ3iQfNcHun30A+e7rdEnZ5vnQmhd/7Ch8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKgWYerD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKgWYerD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6874CC43394;
	Tue, 23 Jan 2024 02:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975298;
	bh=RwP2lAC96xhtVjefW+soERTpCcUMr8XzG77LbVDgqZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKgWYerDr8Vbrne8rCTBs/CLUYM9C8bJRyVFogppNsAYdJOEYP2vVwzyYULJO58qI
	 youzRco+suWAcNXk5dSKHt9Y2jYMklixqWNOR91mUX7cJyAxAsdgzcPRaX0WybkJAs
	 yKKt9aKIDqFTu/601Djy0YjERJB491c1Ttw2kmAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 263/583] drm/bridge: cdns-mhdp8546: Fix use of uninitialized variable
Date: Mon, 22 Jan 2024 15:55:14 -0800
Message-ID: <20240122235820.052405690@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 155d6fb61270dd297f128731cd155080deee8f3a ]

'ret' could be uninitialized at the end of the function, although it's
not clear if that can happen in practice.

Fixes: 6a3608eae6d3 ("drm: bridge: cdns-mhdp8546: Enable HDCP")
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231103-uninit-fixes-v2-3-c22b2444f5f5@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c
index 946212a95598..5e3b8edcf794 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c
@@ -403,7 +403,8 @@ static int _cdns_mhdp_hdcp_disable(struct cdns_mhdp_device *mhdp)
 
 static int _cdns_mhdp_hdcp_enable(struct cdns_mhdp_device *mhdp, u8 content_type)
 {
-	int ret, tries = 3;
+	int ret = -EINVAL;
+	int tries = 3;
 	u32 i;
 
 	for (i = 0; i < tries; i++) {
-- 
2.43.0



