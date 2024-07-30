Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0441A6192;
	Tue, 30 Jul 2024 16:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357133; cv=none; b=Wpyje2ydT5AX7fh4YTCQbZLt2Xxr6k502QXZo7wg4eDa9xZvS1P14WpR13JwEqIO3TTGE9VVeuV4e9DURnW4hsnc2Nr8taIcd+rbRkwUPPm3SXL50ea9RZecAUq8xJBO6LY9rsAyb2WLsUtp+Zhxc9rGIu/r+tAm4KJc1j/A7Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357133; c=relaxed/simple;
	bh=XCRwtwoTz6MqeH0lfTg2JNY4iVtIvw9XrMRgAJLE9Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJKPni9c3Zij4qZT2zo19G5beSelw9qcW+tVEuqKqX77P3TiUyQSmTaDyJeYVkyGdvHi+Ju754R7mS9CDSxRW2Q7EgSr5axgBK4KvIm6DAqrsmCTRr+hs43rI481gCcFbwlTNLkEkKt8fi1H1vQkCo3Qzf4vVHiT3Tj1MxKKg/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+VADFPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+VADFPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95611C4AF0C;
	Tue, 30 Jul 2024 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357133;
	bh=XCRwtwoTz6MqeH0lfTg2JNY4iVtIvw9XrMRgAJLE9Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+VADFPWNosiH7ohpLDzaHsTbIoc/Ws79hIUN6hQHoDOhAw1devijAxzxAX7+tcfA
	 mdr+SQSyT5Rto61/n8SftiQDWwPGyHh6YPHhdH1+xyTgRoe3KuCe1FRKzK6YH/BxjN
	 tudFLf09EUDXCu9/UqzuK8rWieYaRcDfbtfW+e18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Irui Wang <irui.wang@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/568] media: mediatek: vcodec: Handle invalid decoder vsi
Date: Tue, 30 Jul 2024 17:45:04 +0200
Message-ID: <20240730151647.578091383@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Irui Wang <irui.wang@mediatek.com>

[ Upstream commit 59d438f8e02ca641c58d77e1feffa000ff809e9f ]

Handle an invalid decoder vsi in vpu_dec_init to ensure the decoder vsi
is valid for future use.

Fixes: 590577a4e525 ("[media] vcodec: mediatek: Add Mediatek V4L2 Video Decoder Driver")

Signed-off-by: Irui Wang <irui.wang@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/mediatek/vcodec/decoder/vdec_vpu_if.c    | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/decoder/vdec_vpu_if.c b/drivers/media/platform/mediatek/vcodec/decoder/vdec_vpu_if.c
index da6be556727bb..145958206e38a 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/vdec_vpu_if.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/vdec_vpu_if.c
@@ -233,6 +233,12 @@ int vpu_dec_init(struct vdec_vpu_inst *vpu)
 	mtk_vdec_debug(vpu->ctx, "vdec_inst=%p", vpu);
 
 	err = vcodec_vpu_send_msg(vpu, (void *)&msg, sizeof(msg));
+
+	if (IS_ERR_OR_NULL(vpu->vsi)) {
+		mtk_vdec_err(vpu->ctx, "invalid vdec vsi, status=%d", err);
+		return -EINVAL;
+	}
+
 	mtk_vdec_debug(vpu->ctx, "- ret=%d", err);
 	return err;
 }
-- 
2.43.0



