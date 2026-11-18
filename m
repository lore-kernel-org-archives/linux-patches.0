Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033853;
	b=Jpt4XZA7UEqO6L190Wie9AUPqayV6M1Pm2oe0IhAmonQuTmfsSR0IbUQ382yhMSjtqRe
	 V7UO9l25zsZdN5cQlAv6RlsoZXbiwa492gyoYRjdYZV6uzny9lnMfklbAbxmMRl88p3/x
	 Y8boSFk3tWWsQk4NfKxSDa6aGcMcBeV6e8352OnOKOgqqffV/m9iNpW//Talc7NpGsceX
	 zZodt9o22BR/vMBy2S+NpDKrW5xGJC2HZ3EOtL/h7rAvo67XBlk4be7Gp2GQm2WdsymG7
	 O9j1UiN6iWeiR1p7pb9t4OLRFlbDJcTbY/VGoAjQTYM3qbik8QFef49U3a+6zvDSXtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NQHhaVr5NjbTDtYNcOgEbzLLBk+HZ2cZGx4iRwOOVtA=;
	b=tx4QauwJF08oxMGlYJiPMvxr2u7ceN8wdhEvkuVMSxDvENC0orE3BeKprS3CsCSc6MLv
	 4LOCsdx//ezNFN4p6bPXkWGdpYACphQl1NbTpyZaCIHflXFT8JiS0cY3U82jwFkyezZ/r
	 3j8xcOMKa00tqFqOP9uzeYlvh67Hd/e62BnEslP7sBe9Lgxy2HiVcA1/Pu4+kXIqHOYhO
	 NSoveCmgHR4HXb4L5s8XNNy+0aFZn4kN3dVrA4cdlpTrLya/XbnT2mepR4svuHTpyeO8U
	 eg6XirubOy/7nU58AjtGbA2juzYsk+QHFhe2z6hERn5ansWAapeiUCgUk6wbq76fNYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QRo7hif6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABDE606A33E;
	Wed, 18 Nov 2026 20:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QRo7hif6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFE91F000C6;
	Wed, 18 Nov 2026 20:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033853;
	bh=NQHhaVr5NjbTDtYNcOgEbzLLBk+HZ2cZGx4iRwOOVtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRo7hif6DYsocHKa0DKdJCDpU4F48eCp/cC2P6qSwbLRQt7ajmVg3lG8dg5qXxjRT
	 Oag6Z41aVsJwAsP0wR4vyvBX189095G+DWXC8rhph2MjDY452a056fv2K3Fdz/AHe9
	 m87Bfb7cKZ7aVuUJm6PqSLf/tF+chR649sEIsYiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0121/3318] uio: sercos3: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:12:23 +0100
Message-ID: <20261118150317.961263910@linuxfoundation.org>
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
index b93a5f8f4cba2..20d8b5f9d0e97 100644
--- a/drivers/uio/uio_sercos3.c
+++ b/drivers/uio/uio_sercos3.c
@@ -212,6 +212,7 @@ static struct pci_device_id sercos3_pci_ids[] = {
 	},
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, sercos3_pci_ids);
 
 static struct pci_driver sercos3_pci_driver = {
 	.name = "sercos3",
-- 
2.53.0



