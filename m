Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560B5757FC;
	Tue, 30 Jul 2024 16:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357882; cv=none; b=E+wkDh4VZ0t/AEaeS8MvK7r51SSNL5gkARq2N5hCHJuOSKKIi6ZTgv1wWvibbIcLa/fUWuDL/z9HsPtff7l+4+e63a6/M0zMRejcfXf2DTZlWeFf/EImRlRe6/Tjnx5ulKIbnLV+YEyfy8wphzkDLcn3kecWyloD3ArEoH/yO2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357882; c=relaxed/simple;
	bh=oB/3dtC5deqGw9jkVY5xk/NOPpI1FnJlBjeVMJB0aNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEmGXKYp9Xl5pjuQ9zL19zl1OLML8KZ4a+o7tgNZbPV42AYTXvevDuLPiNVNDDdf93R2D7Rs42IcYGJPe4C6m092cUq8xqG4C3LlUTaTpT2gOzGTDh02Td8dRfzZufK1QbZZPPxmf5aBFWxIwh7HmLwheoyCgMA41mLOtSR2h0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRzFyIy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRzFyIy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC34C32782;
	Tue, 30 Jul 2024 16:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357882;
	bh=oB/3dtC5deqGw9jkVY5xk/NOPpI1FnJlBjeVMJB0aNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRzFyIy+XlY7aWVPyfHi51Rob4DJgVMjWlIA4SFFXJKmO5kriix8UuQGh06G0rEWi
	 BdO/y9hC9bfTswj/urW9uuy5WJoFU5BaeM7ZgIBSSb88KMAFC5z4RQF1HsKb5cwePm
	 EXZW26AICWrxdkWT13SrchOkDYeCKN+zjfMwyJNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Irui Wang <irui.wang@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 301/809] media: mediatek: vcodec: Handle invalid decoder vsi
Date: Tue, 30 Jul 2024 17:42:57 +0200
Message-ID: <20240730151736.483123408@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



