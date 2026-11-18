Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043406;
	b=0uHEi6CggRYIuyXphjkg14m+HUGfa+haBhjPtNLv/GThQsRmk4DdNMNqn7WisQ7rSBck
	 t+MvjOkij/K25FPvEfMBTXZ5dBxxIsQ+jCwafkksq+nGNH+VYbHse+eM1XckNcxFHZXE3
	 F/N0KbR78hJYeROakag8R34UL1Yw7wUtdH4YiLLmRehLCytG053KQy0KJDep0TR/XKN1B
	 ouuiXx8oFg3mfWfF0C8LfivxPe5/t1q8MRheNwMpK8hfMYMWkH2AwQWkuV0j/JnppONu0
	 YbazWYDNfh8zP7Db3X2wP68MSL5MOQKuKjmOAlMXWe5KS30o9i9WmQX8yyiSRHjp0Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oeDZHVjwMwP47TJGg2LodWYB4z7TBIsC5LSE65E0kcI=;
	b=0mTbtaR7uzSYpCybQvEaQMDYBUXwQS4owKU7rgx5GmFvDEZ7cw6qRUB+p2w0+GEF6KPV
	 vHeVoTEMVCxw2/XusmdWOFIxKtOjubmfTGThwcpUPwwEZ2dw/0os88LNXBcmIRUBNDHOl
	 rly0VZhCMXN+CrEmyChiSS7TGLk2L2b0tyXf3JE57tOfUJudXtx9nxslx6nN/VSqhy5zX
	 JN3htlm/Q9aJs0dmJlRHFuAK43JRsYSiAljvTClyVPpjrHwmUmgbg8mayOxxtpazzyEjK
	 hmBO/zqWI3koLrUDyq2ud3yFOxFppwFhDCsPAvdzakeF+diRSVWqvd84dwMdgtALaUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4TmD85S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34480606A320;
	Wed, 18 Nov 2026 23:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4TmD85S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8887A1F000C4;
	Wed, 18 Nov 2026 23:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043406;
	bh=oeDZHVjwMwP47TJGg2LodWYB4z7TBIsC5LSE65E0kcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4TmD85S+OYlj3ZGodIR39SCSO7OG8RK8KWVxLlQNasiI8m5g9owHJavR2Pa5YAAF
	 rImZjcyLrxK7vCENuUWR2ZvSoICV2gsfjdGYIBz1MBYVZz0zolPOL1vKFk2smyXZDC
	 wmCiQsT6+pENYdy3rAOxT9sJWPWCC4Ap4MGg5auo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0147/2857] soc: ixp4xx: qmgr: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:19:41 +0100
Message-ID: <20261118150206.641314655@linuxfoundation.org>
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

[ Upstream commit 01479280fa5d4691013bcd64fdfd935117b69769 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Message-ID: <20260704121851.63805-1-pengpeng@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ixp4xx/ixp4xx-qmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/ixp4xx/ixp4xx-qmgr.c b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
index 291086bb9313e..db3683300f315 100644
--- a/drivers/soc/ixp4xx/ixp4xx-qmgr.c
+++ b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
@@ -455,6 +455,7 @@ static const struct of_device_id ixp4xx_qmgr_of_match[] = {
         },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ixp4xx_qmgr_of_match);
 
 static struct platform_driver ixp4xx_qmgr_driver = {
 	.driver = {
-- 
2.53.0



