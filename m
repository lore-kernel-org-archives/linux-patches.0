Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831F23C3F;
	Tue, 23 Jan 2024 00:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969552; cv=none; b=iq8eTBTZnLEfnMjoW0ZmOXqqdL9ttwkMtbIDA4NWpD9FiR1e+F8zojXvcXvWlL8DXgR8LlanNiVvVNwHecemXnaXi/VK43f9bKHhU7CYECNhjcnwxSurkoexG968sRmGJ7YvVGi+QCMbOtRk1TZzRQYkzea813H4crqgKUtq8yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969552; c=relaxed/simple;
	bh=zUw+LkY7nS/BESefmM/7glKtNlB3ooHIaO/JiWK1OGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMHkzijBiKC/GGEu5arQH5IbQdmf1guSCeBB5fZXj8dXy6QVyyDJ3dgkU8jwPef7jJonH+qKz/KRYIjTffjf81KNV7Usz1W+fbDxASapw+zaAGXLt3LAzJgQU4l1+/+DzhDjiNaUVkw9o7RSNd9pcYxOcemmkTije2j6myebGcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U04UrNsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U04UrNsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CCEC43390;
	Tue, 23 Jan 2024 00:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969552;
	bh=zUw+LkY7nS/BESefmM/7glKtNlB3ooHIaO/JiWK1OGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U04UrNsxfxv9F5uQTwW2EdlJiNgyUKZVhPefhhZkWrpjkvLjl1f7vQKh0jyrHmZRy
	 Wc6yF6arW14Tb+wLV9oiv/i0nbP/IZDvA87Br0ibBH6v94n8a9yrFfSMZra51C8YFV
	 KJFGMBCawt09GqjSyz5WM4av2kzHFVOFF1sYIkIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 297/641] drm/bridge: cdns-mhdp8546: Fix use of uninitialized variable
Date: Mon, 22 Jan 2024 15:53:21 -0800
Message-ID: <20240122235827.202824192@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



