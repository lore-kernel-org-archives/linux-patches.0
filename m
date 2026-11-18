Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057402;
	b=wy/tU632sKkXMMUgaJbG/+9KuD4KAZyKdXSfiw3Qa29p5OLhpcdSCYLgCJ9F6fKGMafg
	 kOLsA9KHvVf6W3CJf3Yp8GtLcFnr8z66bDp7rhNGmRAWdOiLNYiQYZ/OS7jDSO0LSRxdo
	 9Xh4Vu3wM6mnqWEOJSNMVQTZfMeJPVVnSHmhy3iRsmRpimqtSVhvnlEuh66KiKNL4uQWg
	 V1W47c//U1CwdfLJSpfj+3poEzRr28FABUWAqlrm3yz2sd1kSNcD7fq6cahuoqa2tdALa
	 PWDUcQSJczUW/icRoFlU8OuLQsbl1hZgx3IGCaPEclKhCfeh2Oq455vRzTNkzoRnhxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kvYmtIpmOLN6lXngUEMLZmAwUjAukzRMOxOl3XFVyFc=;
	b=PhF5mHGcElGd7AomBJ6al0zUi6v22ExWGP4AbluzzihhWXPzOBIXfc2PRRdMRmlsAi4v
	 OYXdVVo5a2Uhy/oAaNpeaaYQlJ000IskaqJRtOY5z6PIfoVOmnwIX/HqwRWNEsG5jB37D
	 v3zbVGXkERTIS6pZcJo2Gi3OgDlZzmWbxdclbrVV8PMHZsFQcxBOteRYTTNDal7+pxYmw
	 cWqllcKSCJJ0YZnkY7yFqRsEcoY8sZBi5PgybrgCHS7sfsxi3wGE/paZ2cARDLneXrTHP
	 JuYQfgM71LfBNwxysXmPypfQmLHVxPZqW0Fdk6XQyKb1B3iqtYW1zH5obqkODuh6frg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yp4tjvjN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7451460A260F;
	Thu, 19 Nov 2026 03:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yp4tjvjN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAE71F000C4;
	Thu, 19 Nov 2026 03:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057402;
	bh=kvYmtIpmOLN6lXngUEMLZmAwUjAukzRMOxOl3XFVyFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yp4tjvjNOoDcoCik0rtauXfYpcEbvPN2oxYdR1eACb5Y9tUSKYNfA2x/igxcfQThC
	 YOVAc7ged0YRwarLknc6b8odckq6B/D/4lOWmwhd4/dRwkb+VEYGQ1WsK+tYaLEyyp
	 y4BC7dKsUY/4nZ4TpzqcKQ0yuvOHZqu+8kVreqbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0118/1848] hsi: omap_ssi: remove debugfs on port creation failure
Date: Wed, 18 Nov 2026 15:35:56 +0100
Message-ID: <20261118145915.919155247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



