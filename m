Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829561;
	b=ypvkmicbDtU2hSMv3WBzw74Ak7S58Phf/tXeoR5Lhbs+KRpK2IVJpvXDoZkTcfCJjo2S
	 9zr79xwX6p/IBt/zQPSH+7nLIsGvco/2yXwRom6bqRepCsiAShjCs4A4cMUiKLqfjw4sR
	 QR4sxS5G0LWn15t92nBqW250wL1lFgZlp0ec9xzSZxBhdSRa31lOzqZwjXPzYSRkKkQB7
	 gW3LPPqGQ9PXkx2OXi6AGZpl0BNkuSRW74iy8V6tSyj2GfzMxgY7nhIXlftkUzM/XBzd1
	 kvttvlpuPOfvFnZ5xbmj9EzhGj99kjh3uJ8K34XKhc89SvjqwToCzn65I0H0bHQCjwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kcs+TRuODpCFQCAaFMu3a5ZFffycNOJAoQbBSm20LSI=;
	b=KvFMiQYSMUaE+38+bm1tSChY+M2gaNavFjFqqAuy+Pkm8Xy9drCloyNgoHqnz2v/DFXc
	 vLLKR8mxEcOuAR/NnihvBZcZJm/gWHc6daA+Bvsrf7kvYCi6Wza4LZeJs/U7SvNbHc1kF
	 E0wjjXDbiicQosT6E45OuhBhTX8+HMzLXIgcNulBEvXj+5ihCvhDZrLqETJr+cWlNL5RB
	 +UngMnk/QPtn5Ow2yRSpikVYQjok/GpV07gOMlqt3fw7j4K+sEefPA2+dawrcP9Zxroq/
	 7yofeDIAr3bbT6Ctq50gb9vd3agcwzE7m6kYPedSpPZ7cEuoE014Mq3UzH0nbe6a6cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w/7w8yAq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE68606A843;
	Wed,  4 Nov 2026 21:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w/7w8yAq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BE21F0093A;
	Wed,  4 Nov 2026 21:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829561;
	bh=Kcs+TRuODpCFQCAaFMu3a5ZFffycNOJAoQbBSm20LSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/7w8yAqd0dzZO4Lwsm78RJfQwYkhiV0WgGPFIwZDFt25QJDNpxtDvWkoO8r3l65F
	 PK9NC2WEADpGG3v4iwUuRQA5aN73MWKgRrvjJGLMpckkRt87ecBZVUy55xTJgRAHVd
	 D/ZEqdY+NXBeFMNAiOlH7hEA93aYghl3XjZ0EJTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0203/1005] media: go7007: s2250: propagate control I/O failures
Date: Wed,  4 Nov 2026 15:58:56 -0500
Message-ID: <20261104211049.480263506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 59dc14a6cb5ff1ae5ce2f6ebf51fe0139e1c0623 ]

The brightness and contrast paths use oldvalue after read_reg_fp()
without checking whether the read succeeded.  A failed read leaves
oldvalue uninitialized and can write arbitrary reserved register bits.

Return read and write errors from every control path so failed hardware
access cannot be reported as a successful control update.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/s2250-board.c | 54 ++++++++++++++++----------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/media/usb/go7007/s2250-board.c b/drivers/media/usb/go7007/s2250-board.c
index a155b987282f8..e536964c14e6a 100644
--- a/drivers/media/usb/go7007/s2250-board.c
+++ b/drivers/media/usb/go7007/s2250-board.c
@@ -365,36 +365,48 @@ static int s2250_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct s2250 *state = container_of(ctrl->handler, struct s2250, hdl);
 	struct i2c_client *client = v4l2_get_subdevdata(&state->sd);
 	u16 oldvalue;
+	int ret;
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		read_reg_fp(client, VPX322_ADDR_BRIGHTNESS0, &oldvalue);
-		write_reg_fp(client, VPX322_ADDR_BRIGHTNESS0,
-			     ctrl->val | (oldvalue & ~0xff));
-		read_reg_fp(client, VPX322_ADDR_BRIGHTNESS1, &oldvalue);
-		write_reg_fp(client, VPX322_ADDR_BRIGHTNESS1,
-			     ctrl->val | (oldvalue & ~0xff));
-		write_reg_fp(client, 0x140, 0x60);
-		break;
+		ret = read_reg_fp(client, VPX322_ADDR_BRIGHTNESS0, &oldvalue);
+		if (ret)
+			return ret;
+		ret = write_reg_fp(client, VPX322_ADDR_BRIGHTNESS0,
+				   ctrl->val | (oldvalue & ~0xff));
+		if (ret)
+			return ret;
+		ret = read_reg_fp(client, VPX322_ADDR_BRIGHTNESS1, &oldvalue);
+		if (ret)
+			return ret;
+		ret = write_reg_fp(client, VPX322_ADDR_BRIGHTNESS1,
+				   ctrl->val | (oldvalue & ~0xff));
+		if (ret)
+			return ret;
+		return write_reg_fp(client, 0x140, 0x60);
 	case V4L2_CID_CONTRAST:
-		read_reg_fp(client, VPX322_ADDR_CONTRAST0, &oldvalue);
-		write_reg_fp(client, VPX322_ADDR_CONTRAST0,
-			     ctrl->val | (oldvalue & ~0x3f));
-		read_reg_fp(client, VPX322_ADDR_CONTRAST1, &oldvalue);
-		write_reg_fp(client, VPX322_ADDR_CONTRAST1,
-			     ctrl->val | (oldvalue & ~0x3f));
-		write_reg_fp(client, 0x140, 0x60);
-		break;
+		ret = read_reg_fp(client, VPX322_ADDR_CONTRAST0, &oldvalue);
+		if (ret)
+			return ret;
+		ret = write_reg_fp(client, VPX322_ADDR_CONTRAST0,
+				   ctrl->val | (oldvalue & ~0x3f));
+		if (ret)
+			return ret;
+		ret = read_reg_fp(client, VPX322_ADDR_CONTRAST1, &oldvalue);
+		if (ret)
+			return ret;
+		ret = write_reg_fp(client, VPX322_ADDR_CONTRAST1,
+				   ctrl->val | (oldvalue & ~0x3f));
+		if (ret)
+			return ret;
+		return write_reg_fp(client, 0x140, 0x60);
 	case V4L2_CID_SATURATION:
-		write_reg_fp(client, VPX322_ADDR_SAT, ctrl->val);
-		break;
+		return write_reg_fp(client, VPX322_ADDR_SAT, ctrl->val);
 	case V4L2_CID_HUE:
-		write_reg_fp(client, VPX322_ADDR_HUE, ctrl->val);
-		break;
+		return write_reg_fp(client, VPX322_ADDR_HUE, ctrl->val);
 	default:
 		return -EINVAL;
 	}
-	return 0;
 }
 
 static int s2250_set_fmt(struct v4l2_subdev *sd,
-- 
2.53.0



