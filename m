Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063438;
	b=ZagyUPhalWbUrhUYZbTLXRwHlZiiKsxLqjWqxgZSSW4B77dDzA0AdvafGjX/F17YVwEk
	 2ZU4T8/tsHtLnT/txFXj7JdwpRIcmCNfeeFW+49qTEMfK4FarJ9x3GkVUEznM5CCZX+Pt
	 45jXCo3jfdDlR6xvSSLvMRBiMWsGVPUnHXx8nO4zT2iTZUMRXpmlbkdxlvjJ5axzisj8l
	 8+kctPlShmtzewNhRGK/PNCgik4G9H5o1bhbNXmigstf6Al93Qiu5XZtO9Ljoqwh2QLcd
	 Zwtun4Yp87fI97E8njVwLJlQdakicrTffUjHQQ+CAKKPjE8SwUkqz9ibJg+umb1lvTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xFGf6r1IarBulwlslHqfKHNjC3t///faw4GLK+6WL8g=;
	b=wa7bF203xSUY5zS1n/SQ8N+CtYeiCgxq+x79EWLOCVCc/rhTBzSBOYr027at1HE+kN6o
	 x2Mgf50xoUnABDUPRhevZ0iAnCBaQb+3cwxmvnNJ1/Wjstqvgw621ZmjYM95srYhwHNHu
	 HOQJlYWJrbkWLjyQkf+pP7w0VAsuRpMkRqXNNGonOHs9ox8kxQHlTfcAXE7xEYxP2XbyZ
	 YcFbL/wdFCUWeRSRwATUmaVT+YAAuwvbmL1hR7oveSoFhL1e18DH/maM+MqwJtD08bIu9
	 xsG0jQhUho9Fu7mJpvZdUjxBO4/Qi5Z2+cajglRlGPDgf8UT5HRXn4F8hTrQtJFnyIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8hd7eOY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD3F606A337;
	Sat,  7 Nov 2026 14:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8hd7eOY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEC81F0089F;
	Sat,  7 Nov 2026 14:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063437;
	bh=xFGf6r1IarBulwlslHqfKHNjC3t///faw4GLK+6WL8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8hd7eOYOVVIMKkVq1egvrvjaybkqoUtl16ViNNxvE+JORw+BmDuh9EehP3LCeaYl
	 P7MV+jXCNHvuxOn/KGc66GuZ4cdQ7UAwmxWAP89QMmTuXNx6/rTVV9mHECxNAU/npt
	 2PsJYPyTzJUc1UuAyu6buJ+ysU0nS4MsmdPJQC54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Orlando <francesco.orlando99@libero.it>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 563/869] Input: xpad - add GameSir Nova Lite support
Date: Sat,  7 Nov 2026 08:54:05 -0500
Message-ID: <20261107134912.379813828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Francesco Orlando <francesco.orlando99@libero.it>

[ Upstream commit 2e6f2e5799f328ca0879dad14d7f3709c7f7496b ]

Add vendor and product ID for GameSir Nova Lite (0x3537:0x1040) in
XInput mode to enable force feedback rumble support.

Signed-off-by: Francesco Orlando <francesco.orlando99@libero.it>
Link: https://patch.msgid.link/20261011165821.72698-1-francesco.orlando99@libero.it
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 126f99cd0b29e..716ab1c608f0b 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -442,6 +442,7 @@ static const struct xpad_device {
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x100f, "GameSir Nova 2 Lite", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
+	{ 0x3537, 0x1040, "GameSir Nova Lite", 0, XTYPE_XBOX360 },
 	{ 0x3651, 0x1000, "CRKD SG", 0, XTYPE_XBOX360 },
 	{ 0x366c, 0x0005, "ByoWave Proteus Controller", MAP_SHARE_BUTTON, XTYPE_XBOXONE, FLAG_DELAY_INIT },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
-- 
2.53.0



