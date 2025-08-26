Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60964352094;
	Tue, 26 Aug 2025 14:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219404; cv=none; b=lPtGGDbsjr5WfBQjf7wh0UKbrvc1vP49wAm9KnOD54fcrIlO5L8vFwDxXaUA/lVe3fLtX3tgAkMSsKiU7QxfJp4Iwz0QovauIocClY5dOVq+DVSGRPah7zVYFPv/wIrcIrAwH+FPg5ktpFv9/FFq52fnJGKFZ4L1Oe4CHDdG2yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219404; c=relaxed/simple;
	bh=JyKAMQqodtPFnzt68NS3Fx7U9MukBwLqhOfWBws2cdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnG9DIiOeuW3GrH6ZydudgzK0YPDA05c2PuM7TcD2i07Gazw/pcabrcCsc7rHX2/CmgCSXYkRCgwT9Qj/nFa3ppq2ckffwpEvdk/zon37GlG5HPJzicO+Xaz4fAmTWhPYsJjOpl9V0KpfOnGfLV76XxS9J/TUVbF8XmzVAWda4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDNeVnIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDNeVnIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AEEC4CEF1;
	Tue, 26 Aug 2025 14:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219404;
	bh=JyKAMQqodtPFnzt68NS3Fx7U9MukBwLqhOfWBws2cdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDNeVnItk1+wfiwRo4lDDQuVS4m+xK2fksCi2gCY+sCQCJKjz5obME6bH6zJGskK8
	 ojclJmwDfltH6Mfxgn0EJBnP42OlMzCvUUIE3nJoVoz70KYNeo/r8g/6HrFq5xFZ/H
	 N3pkRJsYjpyMEp664sYDmZDa3X/eopxjJ4K5aK5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 369/403] media: venus: vdec: Clamp param smaller than 1fps and bigger than 240.
Date: Tue, 26 Aug 2025 13:11:35 +0200
Message-ID: <20250826110917.201093723@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 377dc500d253f0b26732b2cb062e89668aef890a ]

The driver uses "whole" fps in all its calculations (e.g. in
load_per_instance()). Those calculation expect an fps bigger than 1, and
not big enough to overflow.

Clamp the value if the user provides a param that will result in an invalid
fps.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Closes: https://lore.kernel.org/linux-media/f11653a7-bc49-48cd-9cdb-1659147453e4@xs4all.nl/T/#m91cd962ac942834654f94c92206e2f85ff7d97f0
Fixes: 7472c1c69138 ("[media] media: venus: vdec: add video decoder files")
Cc: stable@vger.kernel.org
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # qrb5615-rb5
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
[bod: Change "parm" to "param"]
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[ Adjust context in header ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/core.h |    2 ++
 drivers/media/platform/qcom/venus/vdec.c |    5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -16,6 +16,8 @@
 
 #define VIDC_CLKS_NUM_MAX	4
 
+#define VENUS_MAX_FPS			240
+
 struct freq_tbl {
 	unsigned int load;
 	unsigned long freq;
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -418,11 +418,10 @@ static int vdec_s_parm(struct file *file
 	us_per_frame = timeperframe->numerator * (u64)USEC_PER_SEC;
 	do_div(us_per_frame, timeperframe->denominator);
 
-	if (!us_per_frame)
-		return -EINVAL;
-
+	us_per_frame = clamp(us_per_frame, 1, USEC_PER_SEC);
 	fps = (u64)USEC_PER_SEC;
 	do_div(fps, us_per_frame);
+	fps = min(VENUS_MAX_FPS, fps);
 
 	inst->fps = fps;
 	inst->timeperframe = *timeperframe;


