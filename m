Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FCC1C4A24;
	Mon, 10 Mar 2025 17:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629476; cv=none; b=j2Yn6nX1pKx10nUYWJEwbEyWn0za1N0dYg/b/T4FexSU/fqXgVRRV5HcBniagNLpicQsmxcCfOXrZ/3QRmhAOABoYX/whUrb9bT0g9KUinlihCGFL3FqnRX3/nG0VttX8lC9kDkKrn6b2A3Xf3kjWzdpJNwkdGkYWJCZPbGsCUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629476; c=relaxed/simple;
	bh=lnFvfk0qg3VNdwdp5lGHklcmti48l/YJnzIsP2vo+G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgdbpEqZ6KqdH9eAwSh32uahk370K+OoKKTVOHxo7ES3rTM8tnhpdttBgB1wXkfCuNoFPPP815rRxLhCc+2MZpLKFQhxwcCQ1iIjHzQFmkSYht2zwfpE4tfMLFZ9d+hkQa3oJt9zT1+XVht3QgO6pAZkwBejS3MZBXmCzUZ/iuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOFtOcR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOFtOcR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E7CC4CEE5;
	Mon, 10 Mar 2025 17:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629476;
	bh=lnFvfk0qg3VNdwdp5lGHklcmti48l/YJnzIsP2vo+G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOFtOcR8/1maHz4L6zoGY9Jp9oZI+XkFAO1jE1AoYQs0/fcDhFmOMO8EnrtbWGnDj
	 P0rc6OONTGuf08VDHAvXlJX/HV3WeGCzBM7uIHd/btmTMwDdXORpgcz+RTtY7a3bct
	 A0ghN66CrURZueSifTafs9VpBvNkZ6XesosOIBKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 307/620] media: mc: fix endpoint iteration
Date: Mon, 10 Mar 2025 18:02:33 +0100
Message-ID: <20250310170557.737138522@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


