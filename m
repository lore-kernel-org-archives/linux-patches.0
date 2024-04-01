Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1DF1C0DE7;
	Mon,  1 Apr 2024 16:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989350; cv=none; b=PDetb0w/7SgPTOZNAzC3VZki6eXojqSLZvFGh/VlM6nsmfyTVaEFETxwTU86LrmE1lacXpQaLPi/e4RiGcwuKBLpXSUwGGqRoDDS+IeLG+7HhWAWpW2Yfl4gmaiEDrzWmJcUXGw/o990rXSG9RV9scoolJs8jgH0a0+owdwVFmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989350; c=relaxed/simple;
	bh=KJFtnc7kwrmeO1tAKCTWyhfRWEhlWFgNDWVz9eVbom4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAu8E18czvzHHDDa51bZUrpXA8yzK280yhZCbi1NhoAQsKLlSbJpHaT7wSE7iyYVkWLL2vPOSi3svaVyh10YtN6Fsu2lEAZwM9VoncRKDBEXuBXdD3iB/2FTIfhlAzRft181xmTxK2gLdX3A0BOxrkmVq/vIafY/B+g4fD/90l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zcso1FUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zcso1FUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0D0C433C7;
	Mon,  1 Apr 2024 16:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989350;
	bh=KJFtnc7kwrmeO1tAKCTWyhfRWEhlWFgNDWVz9eVbom4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zcso1FUoxBbHmHFgtgjIlzfJM7ZsUp7CeK5+XDcTOSLAMw7lAEyrwo4yJvV0vir0s
	 M6vphdVWfjV6tGZL+Inz4ZDIbI5BiwBYjCHzG6lidzXm571V19c1+M659MuBWU1y9h
	 gZcAfYE95jq4emrD3RjEnhIAc5zR/eEGxzMQA508=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/396] media: mc: Rename pad variable to clarify intent
Date: Mon,  1 Apr 2024 17:41:11 +0200
Message-ID: <20240401152548.561723730@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c5f44cbf9f877..7da899bc9d08f 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -592,13 +592,13 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
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
 
@@ -608,7 +608,7 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
 		link->sink->entity->name, link->sink->index);
 
 	/* Get the local pad and remote pad. */
-	if (link->source->entity == pad->entity) {
+	if (link->source->entity == origin->entity) {
 		local = link->source;
 		remote = link->sink;
 	} else {
@@ -620,8 +620,9 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
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



