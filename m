Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043583;
	b=iKBT04GOH0Ib7nsuLnTIV3ooYO2t9gpW5V5QJQBO/fT6W8beAsvzIGrgIfBadKKsUE1W
	 szjmJET2DMxBwpdjFqMy9AERVCPkrw7cpvwheB82vchrdl3/KlKRx/Epk6nYkqOSXuRk5
	 JWIYs3RW/vEKhOK2YmyVdDsJk/7NsD/oc2tuPiUml+W+TUZiev0Hjw9y9JhzPLMZxUjfU
	 WwjoLIP92jX2rBrdcBDkUH4AUM+WswtGRuvsABmDO+4wsGw0VD90c77EJl2MRh0pTaBem
	 3QvQVlKWW5tnWxEsXO1HEe8wR3PayZmKC4lXcVfVdTbVOXi4nJT28JmZV+r+3dNqKEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V1L6OK4TGfjxKeiPal39zSvDT3DpkJgXzVr6jOj8/G0=;
	b=1Z9gJkbmSm16aa3RDn1kZgEpMgdn687xHE1zJSCSgMXgGIWxHAIaOA/fkKhFJ8OFNXfg
	 hA7SnN47SkrSizjw2nb4CGrVQTJSnh4RZgVDS8ZLtus9KjCI1AyU63ZRLDPwBlFl2TiDv
	 mZW82HHc/uyRQZ1BoQMFeqFvbTJBhRQqSLEEaDGCDG2HWVcyihEb/4nAtDkVH800Ia9U3
	 H8UepvKs4GdQ7kx48ai6F/INeN8x/IPWRz240Y1ldDJxVrz/uzn7YO84v4cWl3HwSuRkK
	 K2+Ugli2UJSZg7yF9pFJQlV0Xk5VIFidKCPU/d1XZz0EcqEZpXeM5edV2fivLWdOxEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=teoGcurN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACE2606A320;
	Wed, 18 Nov 2026 23:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=teoGcurN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFD01F000C4;
	Wed, 18 Nov 2026 23:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043583;
	bh=V1L6OK4TGfjxKeiPal39zSvDT3DpkJgXzVr6jOj8/G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=teoGcurN/ZurxK4OsxLT4RirsZtjOlkGLlh4BoZ5Y2V+MawhEwcPp16CQ9/Cfovxm
	 K3FgsCawlDcgAhn3ns885x89FnEXerakmIl9youalP4bNHcpU/MqOAd6B3OsLvRW6d
	 bJojxicimAquuEZlV82pyTzgg124x86TROU7tlQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0261/2857] rtc: ab-eoz9: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:21:35 +0100
Message-ID: <20261118150210.829313274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7490b8356e52e09c196645912f2c054f79aa5f3a ]

The driver has a match table for the i2c bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704152528.53258-1-pengpeng@iscas.ac.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ab-eoz9.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-ab-eoz9.c b/drivers/rtc/rtc-ab-eoz9.c
index da710a29e9620..70a35c0c62142 100644
--- a/drivers/rtc/rtc-ab-eoz9.c
+++ b/drivers/rtc/rtc-ab-eoz9.c
@@ -566,6 +566,7 @@ static const struct i2c_device_id abeoz9_id[] = {
 	{ "abeoz9", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, abeoz9_id);
 
 static struct i2c_driver abeoz9_driver = {
 	.driver = {
-- 
2.53.0



