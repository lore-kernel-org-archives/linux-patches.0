Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFED155730;
	Thu,  5 Sep 2024 09:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529590; cv=none; b=euFijqEk4sUN+ry+K+0kMkn+P1yESo/9ME3+PyN3jJngQRVhM4CTHjiwBQS67EyF7O2ovVFXUUG3Irx+EZK0WaAHZXPCKCE7MD8kOYjo2H/MUio0yjUN2tnl9mnFlFXow25+R5QSDITCYqAQG2dubdzYtiiYRBXX7jBh5nlLyls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529590; c=relaxed/simple;
	bh=6oyG2xG7vme2ucmIrbDfvrNumJ4YdhKegTGx7xoUQrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4CTmaCcM16ZF93McOKTKW+o29r1rHAlliXJaDwrljah2a0xH/g0KwIf/l4/LsF6W64FFysEXQo6OWG7PRLJruD1MKvJIKhYbpmI1zSslyvu5MYVBpA6lk0s4lGsgjt2R+T2r9GYdHJpF8XShwuSAnv24AWt9yjRSu0aOSSzKro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eH/H58l2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eH/H58l2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C256AC4CEC3;
	Thu,  5 Sep 2024 09:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529590;
	bh=6oyG2xG7vme2ucmIrbDfvrNumJ4YdhKegTGx7xoUQrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eH/H58l29Wtrm6lqe4IqpmhXwJmBHaG6JRSEzUD5U6YFJhm+PlguBBmShgqoWIad5
	 rBfuPSXnC6CcatG8I9156UCNl6RpafHLDUWu+YVZyCWwffkoZ5FuWj0yDnv+8n0vxR
	 vIqP07oaeQ4dwRYum5rtIhbqL07to38t5fk/XjuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 081/184] drm/drm-bridge: Drop conditionals around of_node pointers
Date: Thu,  5 Sep 2024 11:39:54 +0200
Message-ID: <20240905093735.405735823@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sui Jingfeng <sui.jingfeng@linux.dev>

[ Upstream commit ad3323a6ccb7d43bbeeaa46d5311c43d5d361fc7 ]

Having conditional around the of_node pointer of the drm_bridge structure
is not necessary, since drm_bridge structure always has the of_node as its
member.

Let's drop the conditional to get a better looks, please also note that
this is following the already accepted commitments. see commit d8dfccde2709
("drm/bridge: Drop conditionals around of_node pointers") for reference.

Signed-off-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240507180001.1358816-1-sui.jingfeng@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_bridge.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_bridge.c b/drivers/gpu/drm/drm_bridge.c
index 28abe9aa99ca..584d109330ab 100644
--- a/drivers/gpu/drm/drm_bridge.c
+++ b/drivers/gpu/drm/drm_bridge.c
@@ -353,13 +353,8 @@ int drm_bridge_attach(struct drm_encoder *encoder, struct drm_bridge *bridge,
 	bridge->encoder = NULL;
 	list_del(&bridge->chain_node);
 
-#ifdef CONFIG_OF
 	DRM_ERROR("failed to attach bridge %pOF to encoder %s: %d\n",
 		  bridge->of_node, encoder->name, ret);
-#else
-	DRM_ERROR("failed to attach bridge to encoder %s: %d\n",
-		  encoder->name, ret);
-#endif
 
 	return ret;
 }
-- 
2.43.0



