Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060873;
	b=Rn33ifS8nOf9d/2ZhdH8DhzrYjKhpmpmYk4BBkNJifSqjjtUg92OkQoi4WssgjvfYJFx
	 v37X8cQMfTCaVeFzxrdDBfZzmPZ8Krg41DLJgk/d7UamDdP8E+I++79ikIkoumEQILU1L
	 zFqdMz9v2xgt5SSEjeU8iZkLmM1NkVIftY9NPyEWWb6Er2+aBAP6L66kK7wD1LLBUGmQP
	 tY5LxA6oJlowvdgxUPvg6LBk2qlTv6bdNSTfhuhesgLLOgZko1wiMYqDVFb3S/5e1d7ax
	 UCYKqUqK+OvbYXE+XaiuWV5kNsJT61l9PPqETagaIyBDl9ilx/zP9QGtwXiqL2mvOUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xRQtj3hpC/8HaAV8cwQ6DNsvkMO17wqc3M+w9pAwnuo=;
	b=AOxETw/DA/m1mS5rLq2k3n8BibzMK6tiR7Px1M/QOLx5kCwiLhxSH4kTVCO/5ATxA3JH
	 9S60/qRKYOmWGbMERFowvfvkSqCXa/JlwjWxzZzCp0RabFcKdQV4jUbKWTwzIgxbG/RRu
	 ZH7NRoiCmVV+D6XffDRZAAg0k8miIMC6wtMzAnZu9xUCp41u5wqhRx8LjiXBLd0qLhh0O
	 5EjhvZD693/AOhtZcIdCdo/+2aOfzqmvnM8okbj6HQxKFaf4clutazZP6ZjeYDaNC2vBc
	 CquF21aIS7rEPWhDk4LNyKKj9eWqHQLozqfN/gGmgmo4K218PUNvnGxLTggX8f4kfew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SVHsWJgb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC61606D827;
	Sat,  7 Nov 2026 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SVHsWJgb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0291F008A1;
	Sat,  7 Nov 2026 14:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060873;
	bh=xRQtj3hpC/8HaAV8cwQ6DNsvkMO17wqc3M+w9pAwnuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SVHsWJgbnaH1RxcbBiSSxotSZjjQmlKaKgCHUJ2tENfGr7BVqf9ecBJ3vqqx2oBt2
	 wyZ96V1Vw4dXThVU3jPnH4yO2maRcYaQhZ/Jwc3Jg+9mOYThhsESJlq/AX2fNjh6qW
	 CuNsBAtMi+2uwVwgwwbuQmrzcL4gJyNSehxUMFe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0214/1536] hsi: omap_ssi: remove debugfs on port creation failure
Date: Sat,  7 Nov 2026 08:37:10 -0500
Message-ID: <20261107135003.666369858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 8a60c6e10d079..ef6640e54ef85 100644
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



