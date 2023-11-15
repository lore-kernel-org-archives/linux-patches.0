Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999E941A80
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K683PcNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A28DC433C9;
	Wed, 15 Nov 2023 19:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076956;
	bh=SoKgti6ewAMotgn32FdjM3RpDB8gtMwDMr69+2aw2Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K683PcNwKDdhMwBYuCYkkv5TShfYZXyPd1d2uTXaygnpiSBvZt/SOUVMoS7upWAq2
	 3ZEnF0qvAN8tuZ/14nJ3E8o9nZvo5VWXLD3f+H6rdPqQ04GBmb/FTnkSc0y87OWg/T
	 ya8SS8EeV0KQ3zRUCXkzh7fKSsl7x+fJTgcfOodg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 475/550] media: i2c: max9286: Fix some redundant of_node_put() calls
Date: Wed, 15 Nov 2023 14:17:39 -0500
Message-ID: <20231115191633.787638027@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 0822315e46b400f611cba1193456ee6a5dc3e41d ]

This is odd to have a of_node_put() just after a for_each_child_of_node()
or a for_each_endpoint_of_node() loop. It should already be called
during the last iteration.

Remove these calls.

Fixes: 66d8c9d2422d ("media: i2c: Add MAX9286 driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/max9286.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/max9286.c b/drivers/media/i2c/max9286.c
index 88c58e0c49aab..e265e94ca3de4 100644
--- a/drivers/media/i2c/max9286.c
+++ b/drivers/media/i2c/max9286.c
@@ -1461,7 +1461,6 @@ static int max9286_parse_dt(struct max9286_priv *priv)
 
 		i2c_mux_mask |= BIT(id);
 	}
-	of_node_put(node);
 	of_node_put(i2c_mux);
 
 	/* Parse the endpoints */
@@ -1525,7 +1524,6 @@ static int max9286_parse_dt(struct max9286_priv *priv)
 		priv->source_mask |= BIT(ep.port);
 		priv->nsources++;
 	}
-	of_node_put(node);
 
 	of_property_read_u32(dev->of_node, "maxim,bus-width", &priv->bus_width);
 	switch (priv->bus_width) {
-- 
2.42.0



