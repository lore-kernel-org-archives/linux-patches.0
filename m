Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045300;
	b=qn53HTv1WpRpXvShhTUwc42BfPaShcoSaimF/HMfWVOP7lSRT+iH6MQ9hSsaV8+YWWLM
	 MV8W2CaHW1yptdtXU1+ULZ4tWvPzriJeReDeEN7IJVaMUv/1GNQUk4xHe3Shj8akCmhTg
	 gX58Lt3Xz68gYZj7FK0hOOaQbtwxsIyCAKW/2Iau7KqVFENJIPDUI14wndLRaenHcbclQ
	 fzwptSqsIq+jSJ/kytp4XbP36DHm8B4eJzjR9Woi8rgbvu44N+855IoXRebi8FHxZG9GP
	 D1aJ6S/I391s9UxUCv8hyh4QDfARc0vE9YrZ+brzHW/kxHbuAbkc3+JV2N/abZHswlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Gevva4EgnUt8T8YJXOc0t0NLPaDc3MyP/E30dHo438=;
	b=aasVON6ymSrvePrHiM5XDwZff8Mg4/yWSLZ4u4MLAl3zu46utEwL7NbODncAvLgYfeTK
	 OZPVNhT6Yf0CPMvHYh4WSafKekvnAyCk/tuTz/KuzagE8XOA6sYRs6RAYS4jJsoEdHKsX
	 9V6mwBshpJKwbdUb3PcK/bodm3jyV2kX+hoaqzkJR5uZXWx9wcie+66rfizH+AhwBVWFs
	 GFZhIUYf/zK1B8SJyamdBnCH5SieejyVP4/mZq/0ZuRAenspbVxy3bZb8as4qFqL7LAFd
	 LEbtctntEvLhvVW468r/Vs43yH7LdRt8OyYE9apGoQCw1Jmm91sBkH9sh9+cYEtLhFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keX7FXvS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F08606A325;
	Wed, 18 Nov 2026 23:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keX7FXvS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31A61F000C7;
	Wed, 18 Nov 2026 23:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045300;
	bh=8Gevva4EgnUt8T8YJXOc0t0NLPaDc3MyP/E30dHo438=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=keX7FXvSyjSNjvozGHAZSFxgBcO8bHqwX6a2d7imZwJyc5zp8qYI10J/xE9fQl0GU
	 +XPWfUoDSpS/AoA6HqxMGFKLdrAB9ejQqKc08FFv3dL+mAXMjnMVQY60SCq0LjkkvX
	 7brktx/HUCNSgvRgrDZot9ZY4/6678DjzALyf9Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0873/2857] media: hantro: Harden MPEG-2 control access against NULL
Date: Wed, 18 Nov 2026 15:31:47 +0100
Message-ID: <20261118150232.995491158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9aea331e1a3c9..ffdd385ba11fb 100644
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



