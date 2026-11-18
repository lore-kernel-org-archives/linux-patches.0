Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015119;
	b=pVQE7SE/p5V7FKJ5FJhiFLVaknzinvogwqii622N+5+eaUKEMAu63wZk67Pfxypg45+I
	 SmZvtDJEd8f15yaCtBLhHIpJ0sMEUvF5aSump1Aj81kT8hLMa6p7FZBtfpeBx1Idt2w58
	 lYKiqrLqCpdJ1p38uUrv7xjS+1gzlLrEQpiIMgi9v783DzDBUEh+VINwfK+mj7pC/vFl3
	 PPYMQd8JSFV7rj3U37tU//+oJI4l5AJLpXSu61f7oOES4WrDcvn2oNh2WNsRfuWYi3+oW
	 cNpQegSQWdrMSupbxDaIIw+fG4sR4zuqC+YR7o39Q27e7Zf+/wyuxxoshb/DsPbeSPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2p8eKbTTDp4WAwWu3B8ZJpEOh2siURSuM9mkfNxXvyY=;
	b=i9VyW5sDpF9DGBxZHNPhqQz0Pgic5aFOMWlRFje7y8tetUXGQG8T7ha+Zrg/t4284YOV
	 zvodj+SxVQawp8zk1dZfvErb8n9DaYMXj/QY3B4awVQrfV/qvr4LJouSOfBEorIfTIMod
	 dquteLS2uoZ0HB8mwI3yXPbCBADLM3cruFBCjZusy3YcEOUxK1KZYZimANpx+K2xtHc75
	 SLYtdchq+RS9Mr3fc/LI4Q6DY1f1kGBTpyZ5/Iexm+MHNwH+AGTOfWMCmbnknJTAiL0ag
	 IEkTUHOgJaKijdo7gfZeEDsdxKlTGorf+Xr4L5jtd2642/vU7tm+9E634N+/Dx67vJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LK16faIs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B272606A336;
	Wed, 18 Nov 2026 15:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LK16faIs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369F91F000C4;
	Wed, 18 Nov 2026 15:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015118;
	bh=2p8eKbTTDp4WAwWu3B8ZJpEOh2siURSuM9mkfNxXvyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LK16faIs5CrSPPouBVz0Vmc4GtUCBpn6pPsFTaQ0jSFyvBhuL8VKQr2GRhiBM5xbD
	 B6fqT8M365cCbfmFqOqk3Ct+CcOS56oWCAIWsNCDTNhsR+leq9hZ5tU64cV7PQi9Jr
	 /vPvVGRZJeJGuMGsPXZTvHh1x0KJG306zZJ/ppv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0058/2651] accel/qaic: Add <linux/device-id/mhi.h> to qaic_ras.c
Date: Wed, 18 Nov 2026 15:21:38 +0100
Message-ID: <20261118150250.036853561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>

[ Upstream commit 7de023a5a251b6599ca767415e07a0ea79fc2dcb ]

qaic_ras.c uses mhi_device_id implicitly. Include <linux/device-id/mhi.h>.

Fixes: c11a50b170e7 ("accel/qaic: Add Reliability, Accessibility, Serviceability (RAS)")
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Reviewd-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260727173326.2219191-5-youssef.abdulrahman@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_ras.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/accel/qaic/qaic_ras.c b/drivers/accel/qaic/qaic_ras.c
index e0205c2cda3df..236e520f708f7 100644
--- a/drivers/accel/qaic/qaic_ras.c
+++ b/drivers/accel/qaic/qaic_ras.c
@@ -5,6 +5,7 @@
 
 #include <asm/byteorder.h>
 #include <linux/device.h>
+#include <linux/device-id/mhi.h>
 #include <linux/kernel.h>
 #include <linux/mhi.h>
 
-- 
2.53.0



