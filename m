Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D84A16B3A1;
	Thu, 13 Feb 2025 15:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460783; cv=none; b=lVUqu1udiHudvVk5+vNhAY/soLmP3hGiAwe9fBAFFe0RmajqrNwLKD+y3KBPNK4z7lTf0/rc9QO6UZu3yoqSLrlsjLSzRzx68R+3N+nSskgdtqtuAO/7E4LRD6ST02xMlGwU3vZkYB5pUCRssLr9o7Qw5liO7pXKlves/UOGYYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460783; c=relaxed/simple;
	bh=XbGh7qG8DnB1Q3tzNf8RsqsbYtsOupeNSkwN/Sd51YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lir/jQTtRRHdpL3F5yTC6JEhejJ1RWuOEBypttpj73hJ67KhqQob62GB7/pnAnkNabNcbLWUqJrqcbTGblLTeUgA0/KBIwiz+MPfCfAtUITNAZerFX/1mMC9tav6vqTeiF/l+pzBqGc3hIp2FYjzlGeYLr8099v67ewCvoRz9nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kh26isBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kh26isBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0453C4CEE5;
	Thu, 13 Feb 2025 15:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460783;
	bh=XbGh7qG8DnB1Q3tzNf8RsqsbYtsOupeNSkwN/Sd51YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kh26isBCfXhzroCEh/pFv6Rin6UihUSElkNvtRxuLSGyYeTVH1poZE7xPgXjo5fOZ
	 jT5bIiU2RuwPzK8odDQj6jYKvWnbTpCNxIHTly4cDklRbT8LAaFpcYkN7x+yA5iM6y
	 pS5L/SSvaYzJqrR0JOaJ8K/9Y4+r7/pG7SUj3uRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 204/273] media: mc: fix endpoint iteration
Date: Thu, 13 Feb 2025 15:29:36 +0100
Message-ID: <20250213142415.382718019@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -329,7 +329,7 @@ int v4l2_create_fwnode_links_to_pad(stru
 	if (!(sink->flags & MEDIA_PAD_FL_SINK))
 		return -EINVAL;
 
-	fwnode_graph_for_each_endpoint(dev_fwnode(src_sd->dev), endpoint) {
+	fwnode_graph_for_each_endpoint(src_sd->fwnode, endpoint) {
 		struct fwnode_handle *remote_ep;
 		int src_idx, sink_idx, ret;
 		struct media_pad *src;


