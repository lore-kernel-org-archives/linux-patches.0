Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDFE2556E;
	Sat, 14 Feb 2026 01:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031225; cv=none; b=XMlX4ctpJPoDROJp3vBsZGxqL1wH9ZOTvY9F1S0O6zkscWzvLtVJf1Wf9tN6Zq6ZyRJca3goMXKNjuEyEt2K8+SxdAiu379WKcMbP0dkRvaC9jEYKPmY2uUTOI/R9DgklMx4KQdA9Gg4/NXb0Mx9q9f9ByYSxfG7362GhH8dezY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031225; c=relaxed/simple;
	bh=rDcWMAVldkzNaS8lDSB7w2Yk/9/U2azR+6IWXKQYi50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N/XQJyMO911/p6N9LID0lOBlDeOXeS3xeLV/zsCtrWNQOUFFkaJFDJXQFyq2QbKP8D84KX3pryhQcZs1fG13hxmm6Y8Ity6UWqMEuGjcAjWl/vyAeUTqKEvG+ESdvkWEO3uRC6tf6i3R3atOyMsOprjXnVj1o9+H8VQ7dh7Ax4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODDFwlUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODDFwlUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F044DC116C6;
	Sat, 14 Feb 2026 01:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031225;
	bh=rDcWMAVldkzNaS8lDSB7w2Yk/9/U2azR+6IWXKQYi50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODDFwlURN5QaD6cm8CNWXh/XgakSO58kpoPQkT3XCs28MC3fdV5ios/DWlzP9XI/O
	 DGlSTN9hkHBOc0oZ7Pvwe5RePIzX2ngCHHWsxW++TXKmb38zMVCJ5EE3OO3c1ZYgbY
	 xjtYIbJOEXnVTuERaDFa7+tb4p0QfZZpLgX0FN1hs5Qez1kPmwiAtGmMCcrjwN16iE
	 kyiQgFxo03gi5t5GdEE/Tq2MI2t3CdqAsV/8avoyW4jbm2YoEUAJJBNcVrd3bsy8+1
	 v5vqOD7SSF/M8sYrxMhY7v573LVwX7Wpa9yjGcwEtT4ZxJDzA7Yl2Siji2L/6zL/M3
	 FBrobmJoqpLig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	neil.armstrong@linaro.org,
	nhebert@chromium.org,
	yelangyan@huaqin.corp-partner.google.com,
	sebastian.fricke@collabora.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19-6.6] media: mediatek: vcodec: Don't try to decode 422/444 VP9
Date: Fri, 13 Feb 2026 19:59:50 -0500
Message-ID: <20260214010245.3671907-110-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit 3e92d7e4935084ecdbdc88880cc4688618ae1557 ]

This is not supported by the hardware and trying to decode
these leads to LAT timeout errors.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### 1. Commit Message Analysis

The commit message is clear and direct: "Don't try to decode 422/444
VP9" with the explanation that "this is not supported by the hardware
and trying to decode these leads to LAT timeout errors." This describes
a real hardware limitation that causes a user-visible failure (decode
timeout).

### 2. Code Change Analysis

The change adds exactly 6 lines of code to the
`V4L2_CID_STATELESS_VP9_FRAME` case in `mtk_vdec_s_ctrl()`:

```496:505:drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec
_stateless.c
        case V4L2_CID_STATELESS_VP9_FRAME:
                frame = (struct v4l2_ctrl_vp9_frame *)hdr_ctrl->p_new.p;

                if (frame->bit_depth == 10) {
                        ctx->is_10bit_bitstream = true;
                } else if (frame->bit_depth != 8) {
                        mtk_v4l2_vdec_err(ctx, "VP9: bit_depth:%d",
frame->bit_depth);
                        return -EINVAL;
                }
                break;
```

The new code, inserted between the bit_depth check and the `break`,
checks the VP9 frame's subsampling flags. Both
`V4L2_VP9_FRAME_FLAG_X_SUBSAMPLING` and
`V4L2_VP9_FRAME_FLAG_Y_SUBSAMPLING` must be set (indicating 4:2:0). If
either is missing, it means the stream uses 4:2:2, 4:4:0, or 4:4:4 — all
unsupported.

### 3. The Bug Mechanism (Detailed)

The critical path that allows unsupported VP9 streams to reach the
hardware:

**Step 1**: The V4L2 core validates VP9 frame data in
`validate_vp9_frame()` (in `v4l2-ctrls-core.c`). This validates *VP9
spec compliance* — e.g., profile 0/2 must be 4:2:0, profile 1/3 must be
non-4:2:0. It does NOT enforce driver-specific hardware limitations.

```606:616:drivers/media/v4l2-core/v4l2-ctrls-core.c
        /* Profile 0 and 2 only accept YUV 4:2:0. */
        if ((frame->profile == 0 || frame->profile == 2) &&
            (!(frame->flags & V4L2_VP9_FRAME_FLAG_X_SUBSAMPLING) ||
             !(frame->flags & V4L2_VP9_FRAME_FLAG_Y_SUBSAMPLING)))
                return -EINVAL;

        /* Profile 1 and 3 only accept YUV 4:2:2, 4:4:0 and 4:4:4. */
        if ((frame->profile == 1 || frame->profile == 3) &&
            ((frame->flags & V4L2_VP9_FRAME_FLAG_X_SUBSAMPLING) &&
             (frame->flags & V4L2_VP9_FRAME_FLAG_Y_SUBSAMPLING)))
                return -EINVAL;
```

**Step 2**: The VP9 PROFILE menu control and the VP9 FRAME compound
control are **separate, independent V4L2 controls**. The profile field
inside the FRAME control is not cross-validated against the PROFILE menu
control. So userspace can submit a VP9 frame with profile=1 even if the
PROFILE control only advertises support for profiles 0 and 2.

**Step 3**: The driver's `s_ctrl` handler only checked `bit_depth`, not
subsampling. So a valid VP9 spec frame with profile 1 and 4:2:2
subsampling would pass all checks and reach the hardware.

**Step 4**: The MediaTek hardware decoder only supports 4:2:0. The VP9
LAT decoder has a `struct vdec_vp9_slice_reference` with `subsampling_x`
and `subsampling_y` fields that get passed to firmware/hardware.
Attempting to decode non-4:2:0 causes a LAT hardware timeout (1000ms via
`WAIT_INTR_TIMEOUT_MS`).

### 4. Impact on Stable Trees

**v6.6** is especially affected. I verified that:
- The file and the `mtk_vdec_s_ctrl` function exist in v6.6 (added via
  commit `9d86be9bda6cd`)
- In v6.6, the VP9 profile control allows ALL profiles 0-3 (`max =
  V4L2_MPEG_VIDEO_VP9_PROFILE_3`) with **no skip mask**. This means
  profiles 1 and 3 (which require non-4:2:0 subsampling) are explicitly
  advertised as supported, making the bug trivially reproducible with
  any VP9 4:2:2 content.
- The code context at the insertion point in v6.6 is identical to the
  diff context, so the patch applies cleanly.

**v6.12** already has the profile restriction (`menu_skip_mask =
BIT(V4L2_MPEG_VIDEO_VP9_PROFILE_1)`, `max = PROFILE_2`), which reduces
the attack surface, but the bug still exists because the FRAME control's
profile field is not validated against the PROFILE control.

**v6.1 and earlier**: The `s_ctrl` handler doesn't exist, so the patch
doesn't apply.

### 5. Patch Characteristics

- **Size**: 6 new lines
- **Self-contained**: No dependencies on any other commits
- **Pattern**: Follows the exact same validation pattern as the
  `bit_depth` check immediately above it
- **Error handling**: Standard `-EINVAL` return with diagnostic error
  message
- **Risk**: Extremely low — only rejects invalid configurations that the
  hardware cannot handle
- **Reviewed-by**: AngeloGioacchino Del Regno (Collabora, MediaTek
  subsystem maintainer)

### 6. Conclusion

This commit fixes a real, user-visible hardware bug. Without this fix,
attempting to decode VP9 4:2:2 or 4:4:4 content on MediaTek SoCs causes
a 1-second hardware timeout, resulting in decode errors. The fix is
small (6 lines), surgical, self-contained, follows existing code
patterns exactly, and has zero risk of regression (it only rejects
configurations that will always fail). It's especially important for
v6.6 where the profile control doesn't even restrict non-4:2:0 profiles.

**YES**

 .../mediatek/vcodec/decoder/mtk_vcodec_dec_stateless.c      | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_stateless.c b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_stateless.c
index d873159b9b306..9eef3ff2b1278 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_stateless.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_stateless.c
@@ -502,6 +502,12 @@ static int mtk_vdec_s_ctrl(struct v4l2_ctrl *ctrl)
 			mtk_v4l2_vdec_err(ctx, "VP9: bit_depth:%d", frame->bit_depth);
 			return -EINVAL;
 		}
+
+		if (!(frame->flags & V4L2_VP9_FRAME_FLAG_X_SUBSAMPLING) ||
+		    !(frame->flags & V4L2_VP9_FRAME_FLAG_Y_SUBSAMPLING)) {
+			mtk_v4l2_vdec_err(ctx, "VP9: only 420 subsampling is supported");
+			return -EINVAL;
+		}
 		break;
 	case V4L2_CID_STATELESS_AV1_SEQUENCE:
 		seq = (struct v4l2_ctrl_av1_sequence *)hdr_ctrl->p_new.p;
-- 
2.51.0

