Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573ED26B0A5;
	Thu, 13 Feb 2025 15:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459763; cv=none; b=BjX2apUL+iQrdQ9kcSkwwhjY9WduaYkekEhHq1oi/FlOrny+K6hEucSKUadFn3daP/RhFkDCEOAl65UaWFk4hI9MEZYelI2063NcBr6KWu0F/mElHxgyaHlIsG1y5Bezi3NfaJkOE7YphGrTtFay+xPv3r2nIl3xojLM6ZiigzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459763; c=relaxed/simple;
	bh=VkW2NkiNgOjVt64zEhR+Yfv4ZkplcLQSsKxQTamCt74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghy3ALRQz9RLVKDsxARgl9w5o8BzSn+tSmGuwBMs2ndemUNXYGLEzvlScGfqIaq8yD9XtpOKS0FGRbakIeELtdoegue4Gd6A2/bFcRp83JWD+Lf/b4+YdPV7wy2C6lYK5iK1mUO5SRWktt9dWTNqZ+Dx/kDwMGFBor304ACtAYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMwX9Po+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMwX9Po+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8DAC4CED1;
	Thu, 13 Feb 2025 15:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459763;
	bh=VkW2NkiNgOjVt64zEhR+Yfv4ZkplcLQSsKxQTamCt74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMwX9Po+bVOoStGeZ1Rt7+wSn6kF8MJzWwDmaO7xXD671K/mbr5KZLaMH50B9TZeg
	 pjgJmmQSQ9SKc1Bs6mI3nnvSiqkSF+HmAb9O4MSsXENANcIPKiN0oL3hQOn4SrEWSx
	 VgEkK4PMr8XbetXaD8LPGt3QV7bMnuKuxf1xjaHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.13 358/443] media: mc: fix endpoint iteration
Date: Thu, 13 Feb 2025 15:28:43 +0100
Message-ID: <20250213142454.430183002@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


