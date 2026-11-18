Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036292;
	b=Dum3kCf8otHPJel5J/0nCYgU/D51mqlv5zLbv314xq5Y8LoHgPwJjE0zH9qQ/g73oALL
	 RijDZRmgIWAOgxZqGgrvZ09ud3skQCqZLR89a29mKZyrwy0+ex6AqkUh++L0s2kCc3MJ5
	 lP90BUKK+dJLMkVoOgpVxLavDlqhuF8Ah7lKZYyPmEcfAKG40MYLKODX0uM+ZUmxykPPp
	 PYBfFv9SWO9unSMlLm/e4cBVJWV55S8+KvuHbIxxV/v0mBi7IxW7Qn/2RnDTn0SqtUcTD
	 i4zqJpLMhSZv+GCTR8ilfYlyzGKMpfspkOyGx0wRamcLrgPgJAfGf9qMIRwgapsf3Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KytZQHI1PXcbfqjs/B1+aML3Pc5Up3ucUzK0x1s/N2Y=;
	b=qXpJxJDgBjSThfjKX7PMnd1rKoJ9xv6LZdwF1tWqSFcn0/c8SQtlsO42bpFIhFvmngZu
	 yvJXMBoeVE2rJdyiQfXlLR7Ip65SJOobv8+RQa2xYdPByDZ9zRQ1yDZnQXyTE4HZEPI0j
	 nl5VbqLXM8f/cyo8b3DIIatf0/R69zUlucHyJ2SrUnY9y5ZNLZFIraBnS+1LxoO6PewGY
	 JjbIGyR02ZWLVi5rDedUnkBLi8Vsv/K2twvLQdNdK6MlP0fPtV1SGadkZonwqiJliUB4e
	 KP+t0vj9SlSV+zD7saJCNaZFDKc2wUkMosuf/YeLl6on0FaeP+1PmaNw3NljgxMmTqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WHrCYP+L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F886606A325;
	Wed, 18 Nov 2026 21:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WHrCYP+L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E30D1F000CC;
	Wed, 18 Nov 2026 21:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036292;
	bh=KytZQHI1PXcbfqjs/B1+aML3Pc5Up3ucUzK0x1s/N2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHrCYP+L+M/fDVZegAiHEhFAw/Em2j/sHKa6rLR4c3HvEJ/xZbX7lDg5/BfXlBnHi
	 wpoZM7XnHhzO2+VT3pm4GnkXpCRolFiYUjIQoAs/HG9w3LUC9Cltgv6MbLMnCAbb43
	 MTbH4YXyQ80Zjh7Sp+8k203ZbX3rMdyAdvpDYe0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1006/3318] media: hantro: Harden MPEG-2 control access against NULL
Date: Wed, 18 Nov 2026 15:27:08 +0100
Message-ID: <20261118150350.059130469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



