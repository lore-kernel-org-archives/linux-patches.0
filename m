Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2367B27FD72;
	Tue, 11 Nov 2025 01:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824494; cv=none; b=mIjCZcyrkZ/CvbngcL6IWPhwpaFzR1k0OlUpW9X69yiBFYOe+ZpnbTXiPhXOcDNNbZtb6ahjxJrOF7ACuhIuovizbH3PwiXPeOpCIIchHt97qcG3FJt57V750LmRHbJ1jNTvy89WlnGa4GnRQRFFjlJ7Z2x9OuDEHI2aytPPdPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824494; c=relaxed/simple;
	bh=h16vDmFO4eHp4x83KJ83auzZ47rPNf71RkNCtSIEkwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UR87/vzNhJu/bYv+j6tff+6xyiYl2DSkJk2g76loc7sEdx1KZwQwzJ8NqPU1ADojowLVr/14gxBi2Ya7/F8+jm8RPT+3noMGojbsrVv9y2UxQrzttnlLdlaHI+yXn1giIiDe3EhT7jl8T9nxzuQO7dUzCVEMvhQPBeoS+6YZx+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxizTPRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxizTPRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B212FC113D0;
	Tue, 11 Nov 2025 01:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824494;
	bh=h16vDmFO4eHp4x83KJ83auzZ47rPNf71RkNCtSIEkwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxizTPROt7sUkj9LgeEORWv8+G+eBiBFW8v6qKY2jA+hCT/jM440YbjehmKtEjt0N
	 WYH42oPV/vanhISac2zv1HiE0C9sjUf1blBxg2tafcP5ISSr1orBRB24e6Lso8iCAP
	 EReGiEUaeqVxg9AxS9FmWe4lW6jzRKeuYOpXsnkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 511/849] media: redrat3: use int type to store negative error codes
Date: Tue, 11 Nov 2025 09:41:21 +0900
Message-ID: <20251111004548.783353303@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



