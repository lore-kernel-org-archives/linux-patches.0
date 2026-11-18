Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033901;
	b=OSWv+Me2D9N5EWEyN1+oLwE6QKdE6YDoXLqYgua1YCGIeIskMnSwAwTQh9SsIrya4C/b
	 dNvk7cCap+naOUyK0BwLXphBbJFrv6HdlZRBS+loJAF+SZpXhLt/+6CdLt9ZbCdoqWlxw
	 b7bZbg6RmGouE5eAjnn7o6iAfGP7/L/OkZhAT/cFMnWpvITdwMJ/2LB2DB127q/lQQPJ4
	 fxnm270r5eE6JBSn3kXSKM8g7aY1x834pxD48HDCowIlPzKqi8H8sc6Yyy4rwPvfo+soZ
	 ovZ5C1h5kZ5pZqWPCGpCI+k/yjX3+REAVrUa7tdz06LCtMXJRu6vMqFqI4oA5UefiOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/f8wR74F/6EORTSlOT6z18pFp9VBqLucLJrKPybARvA=;
	b=Uq2hCg8e1CIdZNJTFTEK9W87puvahfqCFUw6DrWL9Y+mvzoLvX3E1C6hoMstHZ6E2VSm
	 Mny6gbYZN4wwNk0P/UtCyFFCggtS0aFkIg0YtWB4GOg5980JrZoNrVMJ+dqxuOjfZFH7b
	 Mm3tvEmLuZRgPUsA4FtkWFkuod/jOfrRzZJMrXjrCGijUne4ZM0CRqDkiCdsKxqt6J/ey
	 YpH69soF5WFFvAimR4oaqzEdA3Yt3x4msro+xQpbcZtP2ipfvk10nRZ8RUxzApBoTkAv6
	 uqKI8vZU9PHcGQ1KwPVrcqNJSCdb8YVjXR2f6jUwDlfmcAt0pAT0o0z5fc6uq3Tuf3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G/8iUpqc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4C2606A320;
	Wed, 18 Nov 2026 20:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G/8iUpqc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767BB1F000C4;
	Wed, 18 Nov 2026 20:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033901;
	bh=/f8wR74F/6EORTSlOT6z18pFp9VBqLucLJrKPybARvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/8iUpqcRuDWGduIp9lNnq82FP+HjlmBr5ypP9fdpJWwRkowA2QrU2lYvTfX00MqN
	 ma2Y7JONzAFewdUuUVoezYQ6XfEJHMvs2S9jyXYvbLlpcUh+HQMWkwkFK9M4xdIfn+
	 japwbOSjfeZr5aUUhZelUkJA1SLWhhno+MciF2Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0179/3318] hsi: omap_ssi: remove debugfs on port creation failure
Date: Wed, 18 Nov 2026 15:13:21 +0100
Message-ID: <20261118150320.080251733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f2d14631f1e5f..78e31211b353c 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -544,6 +544,9 @@ static int ssi_probe(struct platform_device *pd)
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



