Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9740C47A7C;
	Mon,  1 Apr 2024 16:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987893; cv=none; b=Epe1l9yVc1PSf1k7SqTYmSrMxK52shlz9zMh6y8vPOtcJCDV0bdHMCZAVCEFOPPFqnyQhfI6axR1ykUJejSnJ/TcTxWo64R1Q+22MAab7meogHBS6PKOUVhQGSqiNgcKYky+qYyGUYhWINp1fPLLrdMWAWDXNyX59rF7aEVMLec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987893; c=relaxed/simple;
	bh=nLBpAJI/mJcOv7QfpYkXteSl+YO7fOhydfcOo0xIk1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sa+ys713xd+uSdQbSJl1CVeoOZauVgyL927ukpRGV9kGq5DnR0b0+Cc4GZU0rkj0GaRC6QwKpZNJdI1ztGs6+kjR1NJFPzjDC+PcW0K+SW5L7lvIAnmIGmV5DfJZQZBwJJuHVm3lFM44JYqknz40k+KglENVACs8DhbOJ1DlZ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/I0NX7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/I0NX7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79112C433F1;
	Mon,  1 Apr 2024 16:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987893;
	bh=nLBpAJI/mJcOv7QfpYkXteSl+YO7fOhydfcOo0xIk1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/I0NX7CZgGdbptJkcpOndgteKU5lBPEoJajdKtECbwKRDrMJt6zgaSYrvQ7LeSf1
	 3S9swAl993jCi/via/bQL49pnVJgRuZ+bhno/ElIbNatrSintpEdkmWiIbuyG77n/M
	 Fu8tnjnDRgu3VIkX+dK+P9yrZ7mWfsWXevCL+/1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 023/432] media: mc: Rename pad variable to clarify intent
Date: Mon,  1 Apr 2024 17:40:10 +0200
Message-ID: <20240401152553.822940551@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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
index c2d8f59b62c12..5907925ffd891 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -605,13 +605,13 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
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
 
@@ -621,7 +621,7 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
 		link->sink->entity->name, link->sink->index);
 
 	/* Get the local pad and remote pad. */
-	if (link->source->entity == pad->entity) {
+	if (link->source->entity == origin->entity) {
 		local = link->source;
 		remote = link->sink;
 	} else {
@@ -633,8 +633,9 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
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



