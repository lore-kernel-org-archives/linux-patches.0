Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD5970838;
	Mon, 23 Jun 2025 21:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712866; cv=none; b=eXW3EV/4lSPhSH2DnsS+/1uKZOP9sObZCOWTKBp/qy8hTCQo1KemPZ4kVWWPaTaD/7c5XDW+br1VHpWFyUNPBCm0XbM72y/IAetQNE+BLsZfJxyLiH5G2wTZqhi/SnWED+u5/VC7dlLCoZAZJTtq5xswttaCKmdFWzq7bT5rUdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712866; c=relaxed/simple;
	bh=/rxYUFcOvPqxRRlW04/Z9nAitDtxEoHuyBDMSFOd/DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npELrbjBHAsQJcjLvfOdaXwF0I8dmlcsWdmga8fUJoiBm0QH5NcuiK5uEuHkAAIqPKSrzs0bw3M0CXEv+gBMqBbaQOi7QbunqWvxt4s1PvWxLNY+IvazVryjQR6Am9z48SyqqLtVW4OAlMa5wZLHb5A6eMdyq9II8ct3HU9uIG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z78g4u6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z78g4u6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B63C4CEEA;
	Mon, 23 Jun 2025 21:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712866;
	bh=/rxYUFcOvPqxRRlW04/Z9nAitDtxEoHuyBDMSFOd/DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z78g4u6F3DDWGsSug3oeZRtwnkgr3cF7Z9+jhpMBMGWV3cAaziZmK+CEqiFjjeGnS
	 2D0N3AZPygA4vhDHY7BMWDE+VxzMpqQKguO60RqRX5bHu02AscKoriOv9/9IrjdtIn
	 4zX+WhlIWCJD8SU6cyFZp+hsMPs6uRfGadgWFi70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 035/290] media: mediatek: vcodec: Correct vsi_core framebuffer size
Date: Mon, 23 Jun 2025 15:04:56 +0200
Message-ID: <20250623130628.052308224@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fei Shao <fshao@chromium.org>

commit f19035b86382f635a0d13d177b601babaf263a12 upstream.

The framebuffer size for decoder instances was being incorrectly set -
inst->vsi_core->fb.y.size was assigned twice consecutively.

Assign the second picinfo framebuffer size to the C framebuffer instead,
which appears to be the intended target based on the surrounding code.

Fixes: 2674486aac7d ("media: mediatek: vcodec: support stateless hevc decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Fei Shao <fshao@chromium.org>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_hevc_req_multi_if.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_hevc_req_multi_if.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_hevc_req_multi_if.c
@@ -821,7 +821,7 @@ static int vdec_hevc_slice_setup_core_bu
 	inst->vsi_core->fb.y.dma_addr = y_fb_dma;
 	inst->vsi_core->fb.y.size = ctx->picinfo.fb_sz[0];
 	inst->vsi_core->fb.c.dma_addr = c_fb_dma;
-	inst->vsi_core->fb.y.size = ctx->picinfo.fb_sz[1];
+	inst->vsi_core->fb.c.size = ctx->picinfo.fb_sz[1];
 
 	inst->vsi_core->dec.vdec_fb_va = (unsigned long)fb;
 


