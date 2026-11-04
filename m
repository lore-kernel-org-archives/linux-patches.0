Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826962;
	b=nOXTaW+NDzUZb55hMKSSBcqNOdzyyXWmF0rHTTsuIhJPuum2hq+u4hqdmKSAl8cI9eXj
	 lRE96wx4WAxQFwDsWuGq+7HC9YvbjIzO1EsSHS0fWejfl+/hoMywvP6p6sndMSkvB02WB
	 iqELw/H+W46ZMkAxDklhvr4VeoruVszBWcITwOcHVGC1z8uPDYHuYLLKDVmXqezko9VsE
	 6/rl5ydgzHO0/32xp8e1RCAQw4zFyVC8cSkj7UDCQUGuVIJ6rlPoK6ik/pTsfhFuYU+Mr
	 SlyG9203zj/timhJVOQbdLbX5wIu9HOCX6gjCNdkAS57qiC6ECySmfOluAcbLJ7ETCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gwad6wFe9lHTk+Af+8UCMzCmouu2GG6yaRefJmEYPA8=;
	b=OzrW0FGKoT6TFvaIwoDbknyIKKq8iLkvcoZbSyq30Wz9CWuWVdMartfzVe4gi2DOURm8
	 Qw8/aHMgmFpnzSjdnhWxjRCbRv2nJ1/Nmrms/xYHax3u/7KrSW6fa8CRrb7sWyW6gwpFR
	 mfeI5QTsoLwPHDHgmihILv+GWPWFESxy+0xRbMeazRQISrgaNdid2w/isJC+/i6r0rDl1
	 3P7Zq7BV3BoDIHVo50LTfYWChf8sHzUN64G3RZC505lmDagk/xNI7KTi6f26lchelPhV4
	 9Dhjk1tbdDL9/6K4VAAt9oAqMezqLq+QbOwldO9pstY4flYlCFTIjdN732ydX6+Fzrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMLA0ObW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354EF6073522;
	Wed,  4 Nov 2026 21:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMLA0ObW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF5D1F000C1;
	Wed,  4 Nov 2026 21:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826962;
	bh=Gwad6wFe9lHTk+Af+8UCMzCmouu2GG6yaRefJmEYPA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMLA0ObWmJVGNh3Q5Dxo025VK1vxPEP6ACj6Jv+9EcXzPufcIRVTQEGig/cznKwCZ
	 DGlF/RdHOMcs9TU0Aq+QPCb6WlMQF5MMqTo2X3JJsFxzQYm5bcF7eYchNf3Do3IjX2
	 VS7YTyICYI9Bczd2F1CwxdfoNHX/HqYp/gZLdvuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 7.3 112/547] backlight: qcom-wled: Fix WLED3 brightness register stride
Date: Wed,  4 Nov 2026 16:04:56 -0500
Message-ID: <20261104211041.389079419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

commit e60dc9c05e0f415ef8bc63b3179abdd49830a619 upstream.

WLED3 has a 16-bit brightness register pair per string, at 0x40 + 2*n,
which is what the pm8941-wled driver wrote to:

	rc = regmap_bulk_write(wled->regmap,
			wled->addr + WLED3_CTRL_REG_VAL_BASE + 2 * i,
			v, 2);

The restructuring for WLED3 turned that into WLED3_SINK_REG_BRIGHT(n),
defined as 0x40 + n, so the two byte writes for consecutive strings
overlap: string 1 overwrites the MSB of string 0 with its own LSB, and
with the default three strings only string 1 ends up with the requested
value.

Use the 2 byte stride.

Fixes: 775d2ffb4af6 ("backlight: qcom-wled: Restructure the driver for WLED3")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-qcom-wled-backlight-v4-2-bab8c7ef73cb@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/qcom-wled.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -59,7 +59,7 @@
 #define  WLED3_SINK_REG_CURR_SINK_SHFT			5
 
 /* WLED3 specific per-'string' registers below */
-#define WLED3_SINK_REG_BRIGHT(n)			(0x40 + n)
+#define WLED3_SINK_REG_BRIGHT(n)			(0x40 + (n * 0x2))
 
 #define WLED3_SINK_REG_STR_MOD_EN(n)			(0x60 + (n * 0x10))
 #define  WLED3_SINK_REG_STR_MOD_MASK			BIT(7)


