Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EB6583ABD;
	Wed,  9 Sep 2026 14:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964134; cv=none; b=X9nwQGeXrEFKIHb/s3u+RhXWb29wGXZ1VsNlZGAH6mXf+AInQcZ+ZoweWIjLrDT/HcMwMaAzAxzQudGMTANXmUm0L5qJmkkcX9nEROuSSQlFpBQ3xILl7LaL6m2JqOj4MnWdLvcZ7almE+Xzq+J9l1tINsTKQlk8Lb/wzCLwmbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964134; c=relaxed/simple;
	bh=S+7Vg9kBTpdUWh8K4OMxfWDTXa6hQelVqPEf2r6VpQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXoXTcI6mA0m8D5gMSIPXYztG+/FyvSsFyv0qykVbTZfGhe7re6rJXScFoDYGmdvaRuDJrPvwtB28049FLxDaRUFrk2oIewuSoBDlPM1CiSUiYqoel1eur/9PRbccVEBVFBZUPr5YfH+wB5mUDo1FN4qxu2BSOLue+sVhaAd7AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AArYsxEd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AArYsxEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7241F00A3D;
	Wed,  9 Sep 2026 14:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964133;
	bh=DlHp7YTAwZIyDDK55wJ87nIYYQMsye2FFC12A6btn9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AArYsxEdRNrntB5swzkXVx4MVoyqVojHJjRm3lkfrYircX9KDiuNSAfMLj3W25mvy
	 /sgSL+KI7QEFnMb74BH4jx2fSiSwnlYwTRS5n4DpeBTmFWFNAwi+aJ6Hsjq7+O/ngt
	 d6fF8zgKwOIo9xG1x+yIy/JymKpXDSGePlqTU/Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 275/583] media: amphion: Remove obsolete frame_count check in venc_start_session
Date: Wed,  9 Sep 2026 15:39:20 +0200
Message-ID: <20260909134247.598447578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

commit 2be6ee86385badab95b1bace984735bde6e0fec0 upstream.

The dev_err() log warning about no input when starting was originally
meaningful when min_queued_buffers was set, as it indicated an abnormal
condition. However, since commit 5633ec763a2a ("media: amphion: Drop
min_queued_buffers assignment") removed the min_queued_buffers
assignment, having frame_count == 0 at start is a normal condition.

Remove this misleading log that no longer serves any purpose.

Fixes: 5633ec763a2a ("media: amphion: Drop min_queued_buffers assignment")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/amphion/venc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/media/platform/amphion/venc.c
+++ b/drivers/media/platform/amphion/venc.c
@@ -977,8 +977,6 @@ static int venc_start_session(struct vpu
 	venc->ready_count = 0;
 	venc->stopped = false;
 	vpu_process_output_buffer(inst);
-	if (venc->frame_count == 0)
-		dev_err(inst->dev, "[%d] there is no input when starting\n", inst->id);
 
 	return 0;
 error:


