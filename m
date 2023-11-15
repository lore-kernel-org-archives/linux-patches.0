Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01CF43AD2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYat4TQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F855C4E75F;
	Wed, 15 Nov 2023 20:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081515;
	bh=I+Mp1ZqAZPT82vL+7h8XB1jJHpHXqmrAUFo0dSYA7/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYat4TQ2aNcczo/A6uCcpCBCQUzHYJABac+8XuE/tuax4AxBsKKrbrP98y7s9tyKp
	 t/xlqqIc8C2iPvUWUsUU9dLR6NN6ZjFd8xkUws1tYG6iQ6Dfkv2c9qBDoJjtH1Tlkb
	 qf4l0gazNIeAj6ytWhIaP7FN+eKJpMKjjrf8PrLY=
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
Subject: [PATCH 5.15 201/244] media: i2c: max9286: Fix some redundant of_node_put() calls
Date: Wed, 15 Nov 2023 15:36:33 -0500
Message-ID: <20231115203600.427470170@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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
index 404a03f48b976..1b9beaee6bea7 100644
--- a/drivers/media/i2c/max9286.c
+++ b/drivers/media/i2c/max9286.c
@@ -1231,7 +1231,6 @@ static int max9286_parse_dt(struct max9286_priv *priv)
 
 		i2c_mux_mask |= BIT(id);
 	}
-	of_node_put(node);
 	of_node_put(i2c_mux);
 
 	/* Parse the endpoints */
@@ -1295,7 +1294,6 @@ static int max9286_parse_dt(struct max9286_priv *priv)
 		priv->source_mask |= BIT(ep.port);
 		priv->nsources++;
 	}
-	of_node_put(node);
 
 	/*
 	 * Parse the initial value of the reverse channel amplitude from
-- 
2.42.0



