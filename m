Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591632;
	b=HE0CysgY4dYkNzQ5a5QcJxQjCDKcPxbrFIASBgRjTtBmNAD3kBQGomuMcITVViktxq0t
	 KW6he2WX+1FgHLwjmLpd7LQAleSQBOT30ANVC2VQKHmNZyOCEHJQgqXwL8C7xYDbJiKg2
	 EJkp6WsfqvAk/7DQ0sl5D9NCoW6nkXvbJ8X7S54X5YmfIX/XQYcO9A0+VbruRp+KwK5k9
	 yVcZ1yTS7uBPBvR0tTHhkNq838YGG4y8/QqlgcPt90jcBIAkP/12Ps2X7Ys6TUANexe4r
	 lxr53E+4CiImGbfBMyk/HrXI2tLyuhT2lk4N4fSgxWKN3RROdFJBD6es1zuLSnI4EIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X0TJ+9Q30OMzoOop6QgbC/Ysx4H2pjBM0kRhBETYfvo=;
	b=HbvGXoFoyvWQMbBdDqqud9VwO+rcX+Se752hxmppUKjyg41ZF8ezH8X+ygsEN+QnkEKf
	 yjU5uFdpXo7GAbBD7xndojtv+YpJklqUGbobKZcujM3dVwgKUp8lV3rgnD5Ua/oGU7VNq
	 2ltl4Hv/XxAhMStdxe9eWz6Gbgt522hEFsftNUrPjl6LFmCQ5IYXomtpclRmCMfBRm+3x
	 ZHHVi4rMAQESHqz2KsNyKOqBvEexAUX3rXkQacNZuR3X5hhO+gOx7enr/eofPVG0pTMy6
	 9a/D5g2sD6bRKrRvzDHLSCFyhgmyv2rj4UJ1xdfOB+MuncgOhPyB+EidEde4/nVG45Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hIY9jdpm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3367606E672;
	Fri, 13 Nov 2026 17:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hIY9jdpm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C581F000C5;
	Fri, 13 Nov 2026 17:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591632;
	bh=X0TJ+9Q30OMzoOop6QgbC/Ysx4H2pjBM0kRhBETYfvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hIY9jdpmpaj9WFlaC7MNush4veEGtyS9cPJ4rSZvpeVmMDQ5Os4e5g71yQAcsnkFQ
	 w10bDaXxXJiHfL4A8yRjP76yDsyWOsFB1ZhlIIZ+gXMVL4wt7SYKCpg1jZ6ZGyUVjY
	 KXZJ6Jo+ucHWvgej2HFC++y6n8RmKwhYOYq/Rglo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Depeng Shao <quic_depengs@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 670/670] media: qcom: camss: vfe: suppress VFE version log spam
Date: Fri, 13 Nov 2026 10:53:54 -0500
Message-ID: <20261113153834.595035162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit b6fafb3941fa0f065def304d44d6c3c6d6ac0f64 ]

A recent commit refactored the printing of the VFE hardware version, but
(without it being mentioned) also changed the log level from debug to
info.

This results in several hundred lines of repeated log spam during boot
and use, for example, on the Lenovo ThinkPad X13s:

	qcom-camss ac5a000.camss: VFE:1 HW Version = 1.2.2
	qcom-camss ac5a000.camss: VFE:0 HW Version = 1.2.2
	qcom-camss ac5a000.camss: VFE:2 HW Version = 1.2.2
	qcom-camss ac5a000.camss: VFE:2 HW Version = 1.2.2
	qcom-camss ac5a000.camss: VFE:3 HW Version = 1.2.2
	qcom-camss ac5a000.camss: VFE:5 HW Version = 1.3.0
	qcom-camss ac5a000.camss: VFE:6 HW Version = 1.3.0
	qcom-camss ac5a000.camss: VFE:4 HW Version = 1.3.0
	qcom-camss ac5a000.camss: VFE:5 HW Version = 1.3.0
	qcom-camss ac5a000.camss: VFE:6 HW Version = 1.3.0
	qcom-camss ac5a000.camss: VFE:7 HW Version = 1.3.0
	qcom-camss ac5a000.camss: VFE:7 HW Version = 1.3.0
	qcom-camss ac5a000.camss: VFE:7 HW Version = 1.3.0
	...

Suppress the version logging by demoting to debug level again.

Fixes: 10693fed125d ("media: qcom: camss: vfe: Move common code into vfe core")
Cc: stable@vger.kernel.org
Cc: Depeng Shao <quic_depengs@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index c1c4c97609a66..e86e648d8a0d5 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -425,8 +425,8 @@ u32 vfe_hw_version(struct vfe_device *vfe)
 	u32 rev = (hw_version >> HW_VERSION_REVISION) & 0xFFF;
 	u32 step = (hw_version >> HW_VERSION_STEPPING) & 0xFFFF;
 
-	dev_info(vfe->camss->dev, "VFE:%d HW Version = %u.%u.%u\n",
-		 vfe->id, gen, rev, step);
+	dev_dbg(vfe->camss->dev, "VFE:%d HW Version = %u.%u.%u\n",
+		vfe->id, gen, rev, step);
 
 	return hw_version;
 }
-- 
2.53.0



