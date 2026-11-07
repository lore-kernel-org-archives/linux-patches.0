Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060808;
	b=SAS3gLeR0kEP0V5Zu9zOahLAS3ahYnRLHyAlk3+grOThAJUvVGZiJdZuVH6d09nJcsKw
	 70tpLshP4zS/7AwhS0X41O0PRaT29Jv9Hpbcy0mA9U9tPBcGFYkONzDAMcC0lCFNaXYBL
	 mHe6YpZvL1dsVV5KGm4N5brS5HB6qw+iLOHXiQTm21MskfYiruzfb9f2sxZleO4t3hW9S
	 WxVU/Oe0QQmfCw2jL0nw9HSZF/hQNR2JQcUc0NPk8fOMmyjnj/3kzI/+DnulrdtrLju4f
	 5gFDX/hHvcMYH7nxhIjsCaCoOI9MxQ1oEgWGyzo5Wd9fyqGOcQV5xSZMau0hwb1+kiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r9ZA0ej7cQdSgO6HNUnK5SNvQYGroFsCiOzHtHZKNdo=;
	b=Lx9UNRV59ZLLoxKanSbLkQ2Fi+j3o5ICW995GRtPt55WzbK2csfmApY5iEA3ObBas+sg
	 svlveO4GiruI52fofHac3CP0HyCMZQbKiA0iu4/t9LvccQ1hWYWi8LkVTK1lFMRcqTe0m
	 zohwD49lmWHPQ218JGJ2e7NtPUkmkh6xoKy9iGWD8Gn+pDm0GuofjX8whWO3ZKe1k+3ch
	 w3tVDwgWryUDri3ErzKyuIKyzK8klUSEwPt+xZWme1kMyHwfscFZfgWsOIBddyCiDSi02
	 ltaffjZlTVS6skmFF6pKb2/4F0SJ49TV20JW9a4Cpw0vlw1vAlGoPxKU23YxFNWBE/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mr83nHA5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A78606A32F;
	Sat,  7 Nov 2026 14:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mr83nHA5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C263E1F0089F;
	Sat,  7 Nov 2026 14:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060808;
	bh=r9ZA0ej7cQdSgO6HNUnK5SNvQYGroFsCiOzHtHZKNdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mr83nHA5MuzK26ZqY9le+jYiWXmszhFPFYO2HLncaG8bD9R1tG5/C2vC1aldWIlTv
	 jk8p/QFsLEMTakVq348brxRb4elGg53Qm8zRjaPmsoo4AAxAsgeDJSCd36NmLkR5+r
	 9h50J2OFMCwwuAkNeBYvWs4fSmBo4WTFSuZv4FnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0168/1536] media: go7007: s2250: propagate control I/O failures
Date: Sat,  7 Nov 2026 08:36:24 -0500
Message-ID: <20261107135002.384326784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



