Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043397;
	b=lmDBICJURDAmzy3GGTpO0aJEvNpox+7nmhYgSeS7gDicAY8DuOl8o9pkXk1r8XAlHoxL
	 b3D12j5LZbvv4yfPnMVZvBE70C2THGVWsnDF/FlDZZPll7e2rgeZ0SEyf+l+kaI+JZnb/
	 zPsM9UCsbBmYsBBt3Bi2LvJ9Rlnty59p4blGkRaF0ATwYy+bKkiZTWI1V/WXWAHDRJrHp
	 v7hA7ijaSPGdfXVvD00DCWOoRRlxyqXihtWpQEXuY3sM8Q1nbsF+A85d3BgnoPf6+i2JC
	 YT8SniiO9+ct8gpMgi8lp+MT/W7qq8jq9grJkG0rkyT4/mErFCbWLgnzK5AeOfMlTcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TX8/wATuNJx/tekjvJOxX4wVIFcNfflWgCt4KjBhfLQ=;
	b=xIo3r3mUOdzS1aU/X86J8SNlruyRpSKhyn2jkFjksww74ZewlGynfVZMDZo5fdSaRgIS
	 ZU+u3Tw8rzIYrlrJjKEnsTWK+jpNjKsyGUMmfBGy01Vwv2uu6Jp+bJDA4tETS9MKYMV5x
	 1V9yEOqYKTWAz7CVCr75iRpuN6mxH7I6VlVZwdf0QdR20sPxniXqr7vKFEB5at07JuQiY
	 IzgjiGT5ovnEsbUIKN902PZ1nZGQ3eTum/lVdu18c0WbgR9X4IhhtidRyd4XhlQBfToJ4
	 yylIrs2O2YgtbUf78AU8jKB0Z7+Emo6NHSJ5wBSR+JRqw+yYGFWG64cnSqRWvALImnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8kIXQ4u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE38B606A31C;
	Wed, 18 Nov 2026 23:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8kIXQ4u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1B91F000C4;
	Wed, 18 Nov 2026 23:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043397;
	bh=TX8/wATuNJx/tekjvJOxX4wVIFcNfflWgCt4KjBhfLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8kIXQ4u6MOv7a2O5K8Mwr9uUEhHAoHuLafRW/H4Qq5FAPY+sk7I5OltUuv0jU/jM
	 TbESsFzbe8U7sDx9mkcjlgXEIoEf9THUVqqUoUzkWN7T8ODDvaGPn6BQOOJxfzOWqh
	 7ZnTiOjlrhE74qZ04TBiHVIVt7gXWslKfw2oAbEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0154/2857] hsi: omap_ssi: remove debugfs on port creation failure
Date: Wed, 18 Nov 2026 15:19:48 +0100
Message-ID: <20261118150206.890584019@linuxfoundation.org>
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



