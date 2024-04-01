Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3D8BA3F;
	Mon,  1 Apr 2024 16:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990744; cv=none; b=ayhuAyfTrYCI58KJi82LCQR2B04/Y1LjS6PixDabEHbUCoW4sAQ4qOvhoyQmTv0J2/WHTpkdsepkK78GQIMTaNXeAZTwuOVFV8LpzppcfGGrBb4YAbBgu4V9EjdKUK0rtIpDaHhqgJ1iTL8GZaMytBVEhkGVkd7mJiqApX2GxMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990744; c=relaxed/simple;
	bh=Ln3/0S259vEIHfHnLsoBQs7u6ADZimFiI2YVQfFn5MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOoNQP3VV1aaVwrHznq6M/k2g1Gu24/pgscrZq0zMR5GcGuCGzEg+bM3ZWB/IBJL+AdL1K+L8+w/VDFFpn3JTo3iM/aOd8QqC4IOurKPCQU5zq/O/EWvGqgTUZID2yVnW4yKZFMelQdPw7bECX7E0KqdaKy1vvyukkRq1tI+db0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fv0eeyFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fv0eeyFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230F0C433C7;
	Mon,  1 Apr 2024 16:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990744;
	bh=Ln3/0S259vEIHfHnLsoBQs7u6ADZimFiI2YVQfFn5MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fv0eeyFFNKoJ/Q0P9wbWUHUxco7PW1mIkf3OuJP5V4ZeSL/ERyiehq8pRP+VYOwhp
	 6mrDuUxiu8UG00lQSLz6abnr0gNyIHWxRuZhrw/0cf0vT0RwOdBlASALhsVtnS8hE2
	 hNjQ9dfh6OVL8F1/+KgAFHq4C5qRtYzST/gJz4QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/272] media: mc: Rename pad variable to clarify intent
Date: Mon,  1 Apr 2024 17:43:34 +0200
Message-ID: <20240401152531.108424070@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 9ec9109cf9f611e3ec9ed0355afcc7aae5e73176 ]

The pad local variable in the media_pipeline_explore_next_link()
function is used to store the pad through which the entity has been
reached. Rename it to origin to reflect that and make the code easier to
read. This will be even more important in subsequent commits when
expanding the function with additional logic.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/mc/mc-entity.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/mc/mc-entity.c b/drivers/media/mc/mc-entity.c
index c7cb49205b017..50b68b4dde5d0 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -579,13 +579,13 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
 					    struct media_pipeline_walk *walk)
 {
 	struct media_pipeline_walk_entry *entry = media_pipeline_walk_top(walk);
-	struct media_pad *pad;
+	struct media_pad *origin;
 	struct media_link *link;
 	struct media_pad *local;
 	struct media_pad *remote;
 	int ret;
 
-	pad = entry->pad;
+	origin = entry->pad;
 	link = list_entry(entry->links, typeof(*link), list);
 	media_pipeline_walk_pop(walk);
 
@@ -595,7 +595,7 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
 		link->sink->entity->name, link->sink->index);
 
 	/* Get the local pad and remote pad. */
-	if (link->source->entity == pad->entity) {
+	if (link->source->entity == origin->entity) {
 		local = link->source;
 		remote = link->sink;
 	} else {
@@ -607,8 +607,9 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
 	 * Skip links that originate from a different pad than the incoming pad
 	 * that is not connected internally in the entity to the incoming pad.
 	 */
-	if (pad != local &&
-	    !media_entity_has_pad_interdep(pad->entity, pad->index, local->index)) {
+	if (origin != local &&
+	    !media_entity_has_pad_interdep(origin->entity, origin->index,
+					   local->index)) {
 		dev_dbg(walk->mdev->dev,
 			"media pipeline: skipping link (no route)\n");
 		return 0;
-- 
2.43.0



