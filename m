Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01FF302CC9;
	Wed,  3 Dec 2025 15:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776202; cv=none; b=WO25kAMAnrD08P8TIvn5nkym3fqgPfAfkmWraCMsYmO6feNLqP2MAVmiIH8kKPKF7wtEvEL8ljj2+jRun36MG0goSAxEovNOshCyvPtDNzCRI+WTL3nWFi9IufVjDlVLOUXFzR+B788SZR5qF7lTFHlUaezdLQFxJihqU0MvTHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776202; c=relaxed/simple;
	bh=nDYIIFMutm+m9hJPftde2bwELBSOttLNx3wVhBPCVE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uyg0b5QAbg1Wgw1TFHj8hl3Tx3lATaAYpnbjCIstl0X9nZXFxGbl6ahN6wwenbDQRWVd9I7mM91NWPb5ZKVpqfDt3ya9iJ7EheHzrTs4n05jDPrX4Zp+aQ7shG1jfwwdd9fEalTYtg2QihX8tdS3wGX25bck9XvRv84iQXdzLt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLh4iAf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLh4iAf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CB0C4CEF5;
	Wed,  3 Dec 2025 15:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776202;
	bh=nDYIIFMutm+m9hJPftde2bwELBSOttLNx3wVhBPCVE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLh4iAf9kCwUiNSwvmM+BwSOIn12ujxgpTQPnyGoh+w0DYq05vPUxazXd6YpINLDC
	 HGWYCE/9xH8pjNKOj7LJAo0EjKHUgYCM2OVjbcwwwOIN4ldsXKS6zljVOVklzgY/rj
	 XWLB2uGsnM6C4oL0BvJC4bamEWIdUic6Op+D5jI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/300] media: redrat3: use int type to store negative error codes
Date: Wed,  3 Dec 2025 16:25:16 +0100
Message-ID: <20251203152404.770080345@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a61f9820ade95..dc4e9b14baa9f 100644
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



