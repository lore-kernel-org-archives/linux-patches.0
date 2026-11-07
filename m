Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063177;
	b=GDHxxa92/YMyedqJrHt05cZLDPhs8scHuZNCBOSBp1RNdPmB86oaLmzyzKWE6NdZPV6B
	 YqJAR4YVWSDwhtKLbUEoefm15+MvNx+oaQBBN4qtsqp6WngY+glKQlI9vo+/xyBogbfo9
	 xLhosgNPmkWJS7P7w72O55FHvrEGXlvgv00gi3wBNLKSC5iG/i6RrX6o35/QqOhOtOQdu
	 CxEfZKrQUtSo1unnQNomyOaup9+MkzF58j4KQuZ5nCj7T3wGbUDSiksnQp8+gXt9Z34P2
	 DnBzzES5K259KfmNrl0BeSLkDfPIgeAgeaUNlgnv/8ePpsa96w/xZbwSXB13N/dz3zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LaBOZuWmpGyKl/Njbgwk5GhZ2z7Pq9A7vsdH4V3Wmgg=;
	b=dnAZ7Kl6O1ysDxq12uLUu1r9iwZKemPcK+qGu/NpjZC9p/B99yL/4BogdfLlxry3emro
	 EyLvXlw5YwNiVs6JLU0+gEYN29fx5ZmEuS+l4mFABGsx27xwYI5wNikA0/Ss0Jn2e95YG
	 6/OrofDH8rg0k0P6u0nvrEoNxytdqDj/G3aZgb8NG7noYAsd2M99kHpIMFyHPu09srAPA
	 eIkbU7fm+axuJ0LIOpj67lLJddv/yQvnzted6XDIWpHjhfzZG1CFMnSbzJqUgIUHbxw8Z
	 iBQjyNnpCF2Krl7/mGJvMGyEXS5fj8bcB2wOieQjW9AAnqQQRv3xCoMI/s6n/Vd3+fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xTaAzUDZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F08606A330;
	Sat,  7 Nov 2026 14:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xTaAzUDZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617A41F0089F;
	Sat,  7 Nov 2026 14:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063176;
	bh=LaBOZuWmpGyKl/Njbgwk5GhZ2z7Pq9A7vsdH4V3Wmgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xTaAzUDZA2UDMBBHxCZHwrdscDImScFM8DHfilqx0z0c2YG/kJO4DAx1pp4bgcUbx
	 bEKoidWtOi0CrI8lX07WyqipNE2lNWf9AU/v16ctM7cyCr3WQjS6Jesd2LY5yrphya
	 j8pGDkcC5p5OqVjb9DhmmUwijhxd5QJUSlh9LNTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 356/869] media: hantro: Harden MPEG-2 control access against NULL
Date: Sat,  7 Nov 2026 08:50:38 -0500
Message-ID: <20261107134904.481121082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tharit Tangkijwanichakul <tharitt97@gmail.com>

[ Upstream commit 2b685dba4226792933f45b1cbf8991e89ccd21ce ]

The MPEG-2 sequence and picture controls are validated
before a job is queued, so hantro_get_ctrl() is not expected to return
NULL in hantro_g1_mpeg2_dec_run(). The controls are nonetheless
dereferenced unconditionally.

Harden the invariant by checking the sequence and picture controls with
WARN_ON().

Found by code inspection.

Fixes: f329e21e9dad ("media: uapi: mpeg2: Split sequence and picture parameters")
Cc: stable@vger.kernel.org
Signed-off-by: Tharit Tangkijwanichakul <tharitt97@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c b/drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c
index e0d6bd0a6e44f..6a942f4b8a2dd 100644
--- a/drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c
+++ b/drivers/media/platform/verisilicon/hantro_g1_mpeg2_dec.c
@@ -161,8 +161,13 @@ int hantro_g1_mpeg2_dec_run(struct hantro_ctx *ctx)
 
 	seq = hantro_get_ctrl(ctx,
 			      V4L2_CID_STATELESS_MPEG2_SEQUENCE);
+	if (WARN_ON(!seq))
+		return -EINVAL;
+
 	pic = hantro_get_ctrl(ctx,
 			      V4L2_CID_STATELESS_MPEG2_PICTURE);
+	if (WARN_ON(!pic))
+		return -EINVAL;
 
 	reg = G1_REG_DEC_AXI_RD_ID(0) |
 	      G1_REG_DEC_TIMEOUT_E(1) |
-- 
2.53.0



