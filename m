Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B742175A6B;
	Sat, 28 Feb 2026 17:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301382; cv=none; b=Na0upI+YgqOps45iSwDVPjmgkCHPw9cV/mJzPJm8o76L6KFzwkceQqqj1btcpb2KttjapCq5qZOukomPri1qFt+30cCR98JidnvfqqaxLJGa9PXoMtQl2HG+xseQyL/QrZR7/EdWUnpdVHu04MZITsfXvMXQaU4WSHd7njohppM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301382; c=relaxed/simple;
	bh=WUsRuruEkxpAMqh0Uu3xdJSu86ZQCYJ04nhKUOAW3EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snvD0H4DWx2tZo4vzbtyXbhZ55rMhj1bPMTHC9vEWhyGbaL3GMSrgFSo1OgXrcdoeGdVGR589r8jVPar+AIjr8x9WDXxKlGDpo+lm6u4rXq+PlTaoHZje5UHeuVk2D6zgdioQMjFygqMZu53LBO3CrJrSwRVeHLfWyQjxosSQ3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qSmlUx+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qSmlUx+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5162C19424;
	Sat, 28 Feb 2026 17:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301382;
	bh=WUsRuruEkxpAMqh0Uu3xdJSu86ZQCYJ04nhKUOAW3EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSmlUx+3Rgqazr1HoxDGaFvUYgYOYQB3IowMSCoNW8728SC2wfisWyunQECgkjdrm
	 HS85uEP911OYSQ4/yEiCb6qhykSgocnBwdgrfbDDDpi0djxdl/HpSagZiOBh/n+u4g
	 wrmJMC+DHXcnzECeuspVLlYk9Qag9STRvwTwepbKRqCVcaj2ifAvzGM/yCyqEIrcFP
	 3ewWw3KzdSCf16H6LH41eB1XqLwMxn5r5qIt8Q3Zjlv8398eQrUu4zuqljDa/fkbOQ
	 XQZzFnJqJ7G/Nl3yxJjh7cNB6Q+gT8fzKXS/H5DTAxZlFqAJffljf5VfSB8kYoucyt
	 4tQ0UAG8F9OTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bryan O'Donoghue <bod@kernel.org>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	stable@vger.kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 571/752] media: iris: Skip resolution set on first IPSC
Date: Sat, 28 Feb 2026 12:44:42 -0500
Message-ID: <20260228174750.1542406-571-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>

[ Upstream commit 811dbc546f47559dc9d2098c612acfd47e32479e ]

The resolution property is not supposed to be set during reconfig.
Existing iris_drc_pending(inst) check is insufficient, as it doesn't
cover the first port setting change.

Extend the conditional check to also skip resolution setting when
the instance is in IRIS_INST_SUB_FIRST_IPSC.

Fixes: caf205548769 ("media: iris: Avoid updating frame size to firmware during reconfig")
Reviewed-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c b/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
index 4de03f31eaf38..ffb50c98a5b6f 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
@@ -733,7 +733,7 @@ static int iris_hfi_gen1_set_resolution(struct iris_inst *inst, u32 plane)
 	struct hfi_framesize fs;
 	int ret;
 
-	if (!iris_drc_pending(inst)) {
+	if (!iris_drc_pending(inst) && !(inst->sub_state & IRIS_INST_SUB_FIRST_IPSC)) {
 		fs.buffer_type = HFI_BUFFER_INPUT;
 		fs.width = inst->fmt_src->fmt.pix_mp.width;
 		fs.height = inst->fmt_src->fmt.pix_mp.height;
-- 
2.51.0

