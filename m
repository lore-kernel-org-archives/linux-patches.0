Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051168;
	b=nxZylJGI/sQAB6R/mi7bBZftuLZbf3okNIn/Izmhh3/kmanA9EVDat6JtuxVTYHa9Yse
	 luvBgb86JeRiMy+CMzSwoo3zPM8hqs2nnbT5t0yQqY9mU/HRqCZdfJEOKTV21WuG8zeEw
	 j97IKml7fXA5+2XPE88iAUtLChJcWdhrjBXuiLYKIAiTTVAxduHijayz+mxLqDWtJLeJ1
	 F6zWEinkhQRk/xUAlrHVxm44MhraKLDqy6cEvs2kVji/pOHOqn1vq7vynAZmQ2jmKBuc7
	 8aadrUGzOxKXkqD5jwiysOfZuy+GNU3ol8xgpXfFIeclOpecdFEyoVlA9/X7cK7bB/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ZWvrw0EUEsg19RgVoyKoW/0FJqKNUAsloBKa+To+x8=;
	b=KqhhPUZB4nt7OAyAqz1FohT4UyNf4ZpCE/7LxN/W7Guyrz1RL42VuIXtHuENM4LV5jm9
	 URi2x52cBFYbMM75U5mvRW/Lgo9u89A7QUd/TPtiW12SNWg5zXYec0UX46b/rLezp+JT/
	 9BIfl1a0jikiXSFXPenHmyRATaejCS/Ild0iuOjjHvIm1ztGHqMu3O3txaIw3BrNP7lo3
	 AGBALtW9UyCv6WEBskNnTTjOegsCVoyVKOq4vxkxdElNu0/OOmccSFX1jgnHBSUB2jnh6
	 dLKvi8wpsypt+4qldiu9Zg3a5wKE/4Z2yYiFjJERYv8btfjdP2IkZwdwhbFig3uOLXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=psEnBCYC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB807606A31C;
	Thu, 19 Nov 2026 01:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=psEnBCYC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B8F1F000C4;
	Thu, 19 Nov 2026 01:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051168;
	bh=7ZWvrw0EUEsg19RgVoyKoW/0FJqKNUAsloBKa+To+x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psEnBCYCsiNF/NcuS11Bpt2KOZVBImkQzlrhH2G8Js81clb+ymZPJjtbhvME4dZpy
	 pBSJVNLodbU6VkMJJIb9MPGaOX22eZPVKWQdFYKdZTNFegkJWB6awq1qZ2v20WOC+S
	 z8IyWoe8zAlbCR0g2K5mOEh9xZ8RdoXvcl19FU+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0112/2214] media: go7007: s2250: propagate control I/O failures
Date: Wed, 18 Nov 2026 15:29:48 +0100
Message-ID: <20261118150014.388115361@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1fa6f10ee157b..8aa6d7773e904 100644
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



