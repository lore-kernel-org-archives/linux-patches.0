Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD301494BB;
	Tue, 11 Mar 2025 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706895; cv=none; b=YJMOGN6EjcFiEdtDeensyJLgshs5xUcfdj+4vuizhDIUlh0damFO97vdTJlguX6UsU7CvDxdOHfDto2N6sAKbc3+CDXfQuBnrUtG4UV8N1esWoYoHDqF1uLanCJO6XJRXySbxd7G6fesd37nFrW9iwhvC81nl28HMHhDfFpVEs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706895; c=relaxed/simple;
	bh=4yZqwseOsZpkqDKxw3afWnaYvBj+nWe63iEuE61PyMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8pJ0GXsgs/tIUzxCZdCmuDHtqYAxquqZrW6Qfm9cO7finZ9pKbvyM7jy3EjzvC5w4dGlO0bd2ivMs7fmyFnWkTW48V+/0RI4cwyimtdmnMj17Ewk2QZCe/41ymgysGJIzLDB8wWlzDbd4Oh6wgvwr7yJXw/sQJAU/qWTEF0LIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1E0ZfO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1E0ZfO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B27C4CEE9;
	Tue, 11 Mar 2025 15:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706895;
	bh=4yZqwseOsZpkqDKxw3afWnaYvBj+nWe63iEuE61PyMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1E0ZfO7RHtPsFC4QslrZufG2xa1gl/JyXnQ4duOa7jVsvXekGD+1uRxnAnKRdnXV
	 3pygT9OVPaRDNoN4Ik/4kmy8dYFZ3z+drTJObcCYIPx/+lCCE6ra1HnPeg9lHcUcBl
	 pQfHSM43ohrN9phs1q1VuBTEIU5+IHalMGXDpPAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 204/462] media: mc: fix endpoint iteration
Date: Tue, 11 Mar 2025 15:57:50 +0100
Message-ID: <20250311145806.413096547@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Tanislav <demonsingur@gmail.com>

commit fb2bd86270cd0ad004f4c614ba4f8c63a5720e25 upstream.

When creating links from a subdev to a sink, the current logic tries to
iterate over the endpoints of dev's fwnode.

This might not be correct when the subdev uses a different fwnode
compared to the dev's fwnode.

If, when registering, the subdev's fwnode is not set, the code inside
v4l2_async_register_subdev will set it to the dev's fwnode.

To fix this, just use the subdev's fwnode.

Signed-off-by: Cosmin Tanislav <demonsingur@gmail.com>
Fixes: 0d3c81e82da9 ("media: v4l2-mc: add v4l2_create_fwnode_links helpers")
Cc: stable@vger.kernel.org
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-mc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -321,7 +321,7 @@ int v4l2_create_fwnode_links_to_pad(stru
 
 	sink_sd = media_entity_to_v4l2_subdev(sink->entity);
 
-	fwnode_graph_for_each_endpoint(dev_fwnode(src_sd->dev), endpoint) {
+	fwnode_graph_for_each_endpoint(src_sd->fwnode, endpoint) {
 		struct fwnode_handle *remote_ep;
 		int src_idx, sink_idx, ret;
 		struct media_pad *src;


