Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8673587B0;
	Wed,  3 Dec 2025 16:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779403; cv=none; b=a92gbgDscuYROBGJvlaghk24DFzosu+umJ97JlDMPKn8QF5iRsGYARbFe5f4OPVx5z4PAXXIXdqMjuZVOSwqcJwrYUvHhAo9kRXs3+1QZZMpxHRjaMQexnxoiOX/4j1mvdP7W4SZzjZhuiftP/JaA5/oM4HHnTYr5FQPbUeVgPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779403; c=relaxed/simple;
	bh=TTp+MbvrzU7ylTUOZoAt9GpTFybFm1h1GJCe/nKLNq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHi0fW/uOOdN/qyqz0i6yOy7yYIkRQAi7W7if0F2LkBSBQqtAnvsIgjGHe+LKBUiAv4VBYK7VF98QT0PxUGuowK6dQuiEZXsGPZ/pXs2EV4IfSR2gbGGPNSSUFmfVYEaV7u17Mikanjct1MLvD4WDxfVLNsBfBcrKzSB2Eg/m3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4uztFba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4uztFba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248E2C116B1;
	Wed,  3 Dec 2025 16:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779403;
	bh=TTp+MbvrzU7ylTUOZoAt9GpTFybFm1h1GJCe/nKLNq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4uztFbavQZpmER/hKHxvq2u6BJNuE32h+ypw0PPQYfZyt1OxTeShk7GD5o+QZ6rf
	 OmfGSAiub3lI1IVdsDPawFUR7iPF/39UGFHezAxW5bU7fP11ShHzwLT8BWekFRMe48
	 ORCB1jXYOdb8puCuOiCEUD1QsLGVhkVtyFjPc9dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 214/568] media: redrat3: use int type to store negative error codes
Date: Wed,  3 Dec 2025 16:23:36 +0100
Message-ID: <20251203152448.560928283@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9f2947af33aa7..880981e1c507e 100644
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



