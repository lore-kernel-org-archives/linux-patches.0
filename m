Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829595;
	b=ipeBZ34v1eNpqfqBvohZIw3B+JwjQta4rmCUBYCrj0jcistNj5W5fUN0uive67BSK7w1
	 5MFgu8OxwwPQEe91W4AqL8weEntS0l3p5yTFc/EGty+1Nsy5eRi/uP5Sh8Hb+g4TdSo+Q
	 uLf5VbhJT1x6dnq3njJmN8KV2FEFPt6cp9lny78M557u8DghtXTSkozFAVfs9Xj882zC7
	 2Isq6IBQX5XVrGe3ZS0tzoOJp2I+Bh7WRb2C7qC3srBH/SGRy7yjd76Y21gO72u5VDxYy
	 OXZuWpG5SaxhZ/dgqnLv4zJ7EN7s7UGwpb4UXtm7D73spXjcrOoPuUF8KwJmMFUKvog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qEzi563bCPQ8ndRWlhrYL+hMeDMPS3Gp6OO0AyW550k=;
	b=4wjQowXmS/exsVJwve0a/L2IZSf7eymsuQOezecskzZDxAzyu6p7zVYX5W7ERtdr5HdA
	 ZSF0VLtAxBkzlqy2TFLoJWhwsqyGCtwDCySxiZ9f2Sc5kGtOFof5kXqVvtn7d2iFczlhz
	 jC+NsARGIKdqqrLF7/0iIxymyM2lJTF3uo59J3MpMjGJ1SkO84GsbqwwNyF5k5bBJGeaR
	 nb4hvOaxQLaOOpOAc42xqe50qz4hBwcRwt4zLum5Xn6XrT+zIoQ+dV8OhwC40LMikL7Xk
	 EQXocyHVv0KsoeGUQpJEvDGVxfi2G0E9rYvdUjUpbUZDuLuZ3QGPDOEZjlnt+/ZkSIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WniIk3XT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AFF607525D;
	Wed,  4 Nov 2026 21:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WniIk3XT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5A31F00A15;
	Wed,  4 Nov 2026 21:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829594;
	bh=qEzi563bCPQ8ndRWlhrYL+hMeDMPS3Gp6OO0AyW550k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WniIk3XT32lpHOUC9GM8mqeLAdNMmH0+VgAmFZaibNaalXwvVY0Rfel/F3Hrkt3pp
	 637ZRa7Qoz3PHyqOpx7vj9QK4fX2i9fOeot7Pp74h5Fwhthz1j6fE6HlaLovWHDsUi
	 2txbk9ejT5BmKKAhmx8L7elNYySf3dcUocvxTDME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0175/1005] uio: sercos3: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:58:28 -0500
Message-ID: <20261104211048.677435495@linuxfoundation.org>
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

[ Upstream commit a432f68c51fc6761658445e80a798b8425fdb3dc ]

The driver has a match table for the pci bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704152642.54769-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio_sercos3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/uio/uio_sercos3.c b/drivers/uio/uio_sercos3.c
index 12afc2fa1a0bb..80087897f9b86 100644
--- a/drivers/uio/uio_sercos3.c
+++ b/drivers/uio/uio_sercos3.c
@@ -212,6 +212,7 @@ static const struct pci_device_id sercos3_pci_ids[] = {
 	},
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, sercos3_pci_ids);
 
 static struct pci_driver sercos3_pci_driver = {
 	.name = "sercos3",
-- 
2.53.0



