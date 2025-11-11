Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FB441C69;
	Tue, 11 Nov 2025 01:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823851; cv=none; b=kIoRNqO3ggLI3XkB8x8bs3RSzE1bnj5xLjXjCKoH70QSVh12ye0eFAA8+ggpaSjQ0j023gJcg68hLNAcwX7Ycf18lem8SCMKnatQM1H2M8vcEj8wpcangkM8lBtWFxhnCJPYHNpTanFLpazMonmuYVhBfdHsGaOhdPTnLYa/mj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823851; c=relaxed/simple;
	bh=7+94AZvIdZ0KnrqRriL86IwUR24O4C/AqjCAeDmuPS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oI4Rl6PFpcZ5pmtJKCAh5cDT4pBynVALg3Kbv2Ay4FAmyGwl9VQVms2CCHNXtXp2PHIiRkxXUmNzSaXeutKQ4WNvhqaph0FstE5wVGfqwsxPr58G94ft0UVdQNK06Q/RK1nzngByb05aRzjdc5PDaKbfOJ7uIYxv+LplGinGqP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPRS1ua6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPRS1ua6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48840C2BC86;
	Tue, 11 Nov 2025 01:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823851;
	bh=7+94AZvIdZ0KnrqRriL86IwUR24O4C/AqjCAeDmuPS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPRS1ua6m6B6IYKpZSFygQdxb8dtgDz5Vstqp6+OwmirPWxzCHX982g3h4479e+xs
	 3VhCQcf0v48dw7PDF+Wb130y2qEdqas0rDfzbkUo5Xvma1FemtsQyEIsMYLS37T1lt
	 2HFrUc7YbsfUiLB50tFlk47kc78wYXjoST2JBLMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 337/565] media: redrat3: use int type to store negative error codes
Date: Tue, 11 Nov 2025 09:43:13 +0900
Message-ID: <20251111004534.462656928@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit ecba852dc9f4993f4f894ea1f352564560e19a3e ]

Change "ret" from u8 to int type in redrat3_enable_detector() to store
negative error codes or zero returned by redrat3_send_cmd() and
usb_submit_urb() - this better aligns with the coding standards and
maintains code consistency.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index d89a4cfe3c895..a49173f54a4d0 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -422,7 +422,7 @@ static int redrat3_send_cmd(int cmd, struct redrat3_dev *rr3)
 static int redrat3_enable_detector(struct redrat3_dev *rr3)
 {
 	struct device *dev = rr3->dev;
-	u8 ret;
+	int ret;
 
 	ret = redrat3_send_cmd(RR3_RC_DET_ENABLE, rr3);
 	if (ret != 0)
-- 
2.51.0



