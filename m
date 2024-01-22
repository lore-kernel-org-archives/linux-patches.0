Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F8C5C915;
	Tue, 23 Jan 2024 01:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974377; cv=none; b=BrBXHywHF439LjVO/AiV92sMzYlx8BZzEFwxSIgSAhelayImfzgnqtsLTyCXHSCDgOAvbphcYhLSWmiCnj9j5KIOij4DjJ0k9yd54S9c2xAXPyc5DEXFNhto0jkPUcE9q/OQ24lnsC5kFYIbkUHI1vcDQTAEYB0vT8e51vQDmRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974377; c=relaxed/simple;
	bh=TXWxnDqzeOUYSFDfrW/v9QEnwfJjC0r9KG3lL9jpZX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWG9KK8BhxHpHB5/Ec0JPxTYRRnPt2XQdwR1zMiFsevrWE8EgK1ih4c+KGO4ns+wINX17w2TP+FZl0NK2+//HJGh4c9hwzEKeiO02DsiXbdcdAkdMHQCIC8+WS+OmcFYyvBjFnjIgOH5oazsDdzZgomyBAjFxdWT1LyqZBG7SWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwhzwyLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwhzwyLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C117C433F1;
	Tue, 23 Jan 2024 01:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974377;
	bh=TXWxnDqzeOUYSFDfrW/v9QEnwfJjC0r9KG3lL9jpZX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwhzwyLVnEjS2UoXB1RK1uAuXqagjiFWAe3I9iXe2sRhz8e9kjsJDVRl5vwzs2xuT
	 tOhS7YxnoOhJtSmX6hzf+1nfd4xFZVmcO0SW3ATEnjlRN9kQvtWm85Cdw1T1bmWYox
	 btG30/+FZgbxGmPu6zQGHAojHRn5BjyZ77KE0yq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 198/374] drm/bridge: cdns-mhdp8546: Fix use of uninitialized variable
Date: Mon, 22 Jan 2024 15:57:34 -0800
Message-ID: <20240122235751.493934917@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
index fccd6fbcc257..29c04012b701 100644
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



