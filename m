Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829644;
	b=sx84xlAY+snVb3dJi65GNX8BvhYS4R/xwszyt9GKuSTR4tPoCzYI0YYkMGe4Ixtf0wC8
	 6DKCYDYqCplnRFe3nSt7InvJ1ZlmLiRYJ7nqAUO/Hsj49T8M78b3r9l4WJj/jarB4OzWN
	 f8XLpT7fw4Un+oiqeV+sLiQ9Ur/ZWLlu/3h9qNbBo5ciRjBMQTwnkDSKNKLaRIbEt+IpM
	 5dlgiWJinS3+eaTfsnCnMFLGXUxReIc7jNb0hv3n2qe+fHodCDaKjrEk4jZfTWo5y15qV
	 HcKa5QMyb/J+xcRlUffwuZ85P/9iz2OAYiguYRlE9buRGwGNlbDbHZjXYF2LR4nxxqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D1oBDAP19hYHtfBmn47m/yrrXHWnhUjmY10v5uZnHsw=;
	b=uAfkHcRDMfoWttFa+F6JFvEQJQWCrkDCv31SQrvUV/UUdzu1ID94NCcu+37hI2yFdR17
	 BCf+oXQ2UDLoyJVP2261y9VjutQ8j4uhuMs95XYtd4rXTceJs1uQlBLO2C+zBYUujvnWC
	 npWnRNmHeIR1C7oxKHMFcoSv3zHPI07pjD/X6gRYi3p8L64anNFecsRJunvJL/4oCoY9Y
	 t7ZwM74UzWKdpUzXnxdIA1dUamHAzrawab9etf17uRmOxOpc0HiV5ZBeUvIznFLZKAQNt
	 9ozh7gWEWbQNC9rH8PNaMNmBrmt5ABuEcorKqkW2ZhjF3rsSLXfXfVahBvBuo+wBckQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTXvHc6C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46125606AC27;
	Wed,  4 Nov 2026 22:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTXvHc6C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50E31F000C1;
	Wed,  4 Nov 2026 22:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829644;
	bh=D1oBDAP19hYHtfBmn47m/yrrXHWnhUjmY10v5uZnHsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTXvHc6CnBrFm0q4RSmfYRsgaQRDTWCtQjjpx1/rrfUrumnWNtAfRZEmxyYMoElot
	 jq06/1f5zxBIiy76E+ybiS5DU8BnpqNlGG99JHHBu1ACe2gXdI3nfe4YQvVnYn7kpt
	 ofiGJb+tZVTPoVY6K9TRhaP1MdbuMBdoKVWp1ZBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0252/1005] hsi: omap_ssi: remove debugfs on port creation failure
Date: Wed,  4 Nov 2026 15:59:45 -0500
Message-ID: <20261104211050.920923183@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 760318e2e69857214314e94ac477219f0c89106b ]

ssi_probe() creates the controller debugfs tree before creating the SSI
port child devices. If a port device cannot be created, the error path
removes any children and tears down the controller, but leaves the
debugfs tree behind.

Remove the controller debugfs tree on the port creation failure path,
matching the normal remove path.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260616004348.97684-1-pengpeng@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index 47826315d7d62..3163a063aaa23 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -535,6 +535,9 @@ static int ssi_probe(struct platform_device *pd)
 	return err;
 out3:
 	device_for_each_child(&pd->dev, NULL, ssi_remove_ports);
+#ifdef CONFIG_DEBUG_FS
+	ssi_debug_remove_ctrl(ssi);
+#endif
 out2:
 	ssi_remove_controller(ssi);
 	pm_runtime_disable(&pd->dev);
-- 
2.53.0



