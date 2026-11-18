Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051236;
	b=eXVBaASs2BZcSnRPVhOV0me7RSRqzsMoSTmBQsFuEQZuG2ZmvSclid/4+qmgmwTO+eTY
	 EZuStvY8/B/dkfmVSkcGdc8/agBY1Ykfcgk249SX9eU98drjomilBu24VqraprxhBkN+U
	 7D+iGfkl6f8gqxf0MyV0720HdMv9sTKgLnbTMgp45J/o5/6ODpfbnnjvJHpf8Nm31H7QO
	 rpQ8eGroKkUch7sh3hz5pq5azaqE7MkGcKYZ4mwQ3/4rBtxTZMwXRL9owKW3QX9zdPynV
	 zRpES2S2OZxJJijaWwtm6KgmJv4D4J3OldDKBs9YTYJpg1TjMD9F+bPXMq9fhs6hUIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jf0T/HrccrI9pDt8PU78r5mD9ylPdeMN+b4DaeWiFVc=;
	b=0z1eGmAwD1zz8F5fw9lA+Y30uxtZuvmpc74nR/fd3m23ChGmrlEC55U3Ewape0RfDrAQ
	 MCSG0vEhn+mM4lOb2BrEn7adTMNqQooTiTtWTNnqpBW4M+DnxsQTC32/z+DedFrcOECyW
	 /VsXSQHHCcnyWX+v1hBML/q7fxaAW58e1LPpwmfnLhNvJqNIoXwiig8FNBMHGoBOyC8k9
	 ABm6961DTJ9tXbOtfouhdMZFigpdkEj42Z05eh04fvA3XBuVDn+50uRE0z5D//S8qf9lF
	 Pco/t3j4VDEPTQ5EREcFM+/c37nMoYsWQyNrMbq2YWlF0uUdW7dj00PwS2q9b3FeKyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WJcwgVjM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC3B606A31C;
	Thu, 19 Nov 2026 01:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WJcwgVjM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500901F000C4;
	Thu, 19 Nov 2026 01:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051235;
	bh=Jf0T/HrccrI9pDt8PU78r5mD9ylPdeMN+b4DaeWiFVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJcwgVjMJPj8i2nYmTuvHZGHnq4JuOp2vSXSnqk7M8HD9xRxCPSTIXZdowlBg1ayA
	 cI4FRoLvyCAdYru3M9Arsoco2eHBauyIDc9MHQmlAjpP9tQuJZcGIWNc7cxyXb5BJ9
	 IsJF72MOqGx89oIBdFLC0Het6VBp7lQ6W8X+sjMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0138/2214] hsi: omap_ssi: remove debugfs on port creation failure
Date: Wed, 18 Nov 2026 15:30:14 +0100
Message-ID: <20261118150015.709504325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d3a34cfd5a05d..c384526eccdcb 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -542,6 +542,9 @@ static int ssi_probe(struct platform_device *pd)
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



