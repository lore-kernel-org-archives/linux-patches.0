Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044069;
	b=V1HnBSbmEQeVd8daAF8+evi6lQ7KtEP/rc9XVJSDDCI1yg3eXa++eEykm2BFJSSIpLH9
	 y8LMRI0Jzlhqm8BCg1XayuXMnJDGN6IV9Hp5mu/is0slWLevrIHAcM7/r+eqCPg5QIPUV
	 e0T8xhaMnGXhfmOWbDENgOS7IuYSjWbxL1mHzohFPYIjrp02dyPQte4dDUXEZ2V1lvdcD
	 UhVRgtnIpLGP2rYjhjY0iSzgUqSQmv3mFUsq1J/VVdcr26YoUPoCZqeW0/1X5MGCl2yQr
	 PVAjljuEKQdevcWhUQeqr5hJaWcjzhhu6kXZhSo8exP/iHepnBJxM/MW+kLC1pnqNiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3D+1EIkkJgOPlv6CZx5Xuv+jTFMagwSAe+eeT6rdWDI=;
	b=UIwTKN8/px/rEo4nwk+X0f8vZm616CqZowz3FwIfJ66uC9xnjGfdcViib6W0EpApPPX9
	 s1e9zwSnHDcO6Asu9wgrGsmEIkBJPdFDsK9q//fqaVDKA7u2Gyp/nLN/ngf5VBBD7aReT
	 lrsIHNiBO2msq8BBsfl1I9X9+Pmuqrk4zJu6Kz0XFDYxmDDcIBWmH7hv50mkqIYPiWwXr
	 X53WamogU2Gi6Hoymy88/LIjklnhkGCLF1NGw2IC9YUHjJfyMTzE6TTO3I4lq1OQBcAIp
	 v82YqtV8T2Zlp/iLBRV+lvKyGT4mj8xFuXNCMIg0N0O4p5elpsYLYh5PHb7SitMi6Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rl4EaKzS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8447606A320;
	Wed, 18 Nov 2026 23:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rl4EaKzS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F17F1F000C4;
	Wed, 18 Nov 2026 23:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044069;
	bh=3D+1EIkkJgOPlv6CZx5Xuv+jTFMagwSAe+eeT6rdWDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rl4EaKzSAci/2LLqbydTOMqgI1zbNA89292a0cVglSiiOypJvt5YpkmF6PB6v7Xxl
	 WvzclxnExqBUZbmtd2OFaZWm6b1KHrajMNWgb+8308FfRgNrMd9V9x4Elfwgyovy8X
	 DhMNrviJLA4p+OLP+CDDJvSIjOSay2AANiyFmapU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0436/2857] ata: libahci_platform: Fix device reference leak in ahci_platform_get_resources()
Date: Wed, 18 Nov 2026 15:24:30 +0100
Message-ID: <20261118150217.083074601@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 0d1cb83337f13af082afb68b28d3fdfe29cde7fb ]

of_find_device_by_node() takes a reference on the port platform device,
which is only used to look up its port regulator and is never released,
neither on success nor on the error paths. Drop the reference with
put_device() once the regulator has been obtained, which covers both the
success and error paths.

Fixes: c7d7ddee7e24 ("ata: libahci: Allow using multiple regulators")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/r/20260915065933.1733061-1-vulab@iscas.ac.cn
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 50aaa82d4971a..6ed700a02df43 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -622,10 +622,10 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 			of_platform_device_create(child, NULL, NULL);
 
 			port_dev = of_find_device_by_node(child);
-
 			if (port_dev) {
 				rc = ahci_platform_get_regulator(hpriv, port,
 								&port_dev->dev);
+				put_device(&port_dev->dev);
 				if (rc == -EPROBE_DEFER)
 					goto err_out;
 			}
-- 
2.53.0



