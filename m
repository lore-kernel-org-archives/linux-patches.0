Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0519176ADE;
	Wed, 19 Feb 2025 09:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957106; cv=none; b=ApDtaUQqVhqA4ONIaE6uHKr7hFqododt3UrEgHoXK9CS83hfeUYfZ4Xy8xjaDrh1gV3t0+WyrOzrhvNBlwQ9B3kE7T009M2X1HYLZ7WQkn6kMC3NtKD+skGtbIT/HLrWjHHzzFgIQDVm7fJNaCCgOXsE365GQdBkjI+Zv3BjlOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957106; c=relaxed/simple;
	bh=xC8Ugw2sGSTnbLcbi5F01o9J1xAsCcBoRErrAcJxsQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfqsyM6G0A/vHsh4qyKmy4l6nzsZ73LSKtbBmBLlZkliMdMcrS/wf7sY+QNefvFf/A4Wz4YmFks+5OK65RAr8kzlPVh9Nk//7HfNNHgOZCb13Y9awd63e45Nio+CjAGWOF2Jj/CN/OMPBqeSNNTgR+EDmK/LGL2x6NasVJP69aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIAEw4Le; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIAEw4Le"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37626C4CED1;
	Wed, 19 Feb 2025 09:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957106;
	bh=xC8Ugw2sGSTnbLcbi5F01o9J1xAsCcBoRErrAcJxsQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIAEw4LeMoUU7FnSvbzURNllGc/q4sp2nWKhaEAdOquGQZAZWMtjhyJP2Q/zG9XIh
	 2TN83aZ8xUjoXlogTFTSt8qem6SfzT8k9TdOgbieScQwffB/N9qTLXaKzvlmaEwes9
	 /EjyOxyZMmSsyTFXxQd4uf+bhWORs23VEhG9qRxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 410/578] media: mc: fix endpoint iteration
Date: Wed, 19 Feb 2025 09:26:54 +0100
Message-ID: <20250219082709.150991111@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


