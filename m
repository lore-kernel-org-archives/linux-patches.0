Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051110;
	b=UZpe65FYXjzEgx+4H62m1mH3fPNRwtdrxPrJ5L1vCytQj6UZnk4C8DozupAhfzbEB9iO
	 4D7pwaime9pM7qmHp6chztNhj4tonpm/YkhXM3AwHfvNjeW+Zu1zIKTZts95O3SWcDeXk
	 4S/ZMdQw/j1HefSeuVGoyaS9mAzoJxEMKMFo2WlkLOo3xAaIibUl1Kyb51BjC87pzZOQ2
	 0ZGSqdaLYASJinBqv2XRP4cl5K0gCZ0j2UEvTI7xhvKcYoazL3Z+9CSyIxIGlrG7xSPN/
	 5aHqa7+Vr2M8HvyxqM5/bPgd27nSDrzzIERysGb8jZocT9XecJaHduFnr8gK8tTjbVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1A4je/Daod98yRelYvFME8g987MQLwkpykB2WrlXm/8=;
	b=M6ggaqK76krb5tADiZIUWX4cpWTNTkayDT8jG8xvb9ZaP40Lw579b0kv3LmPq6VfhA6U
	 Pn+oLMDQS2hZoSIaqHQKaT0XrNp9PJiHy0zcHE0dVtgmxsGsK5EzVbkJ7Yfl3TdyUkN84
	 QS1885wh4b0Vn9sBrGcX2EbhYhvpay5dPcXRDlroN872dCw0NAsLcybNEYmghCsadg+qB
	 SBRLjcWe3U4Os2sI/7fdWdQ7JF3IL9m9PL+Ilc7EC6nL0KxZwlgzfAm6Qy14/skg3bk4X
	 5M6pdr1/5b0atLj7JWCFmYfR2SfRHaUywvHX9MKoG0Qp5Me/HwfDOXFKS+sMqr5s9tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFK0Qrit;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CE5606A31C;
	Thu, 19 Nov 2026 01:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFK0Qrit
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBC51F000C4;
	Thu, 19 Nov 2026 01:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051110;
	bh=1A4je/Daod98yRelYvFME8g987MQLwkpykB2WrlXm/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFK0QritFVXfbdDlrU9BpLFUkgWjfqYKEEOQTerB5ni+Z0uOeVtWIyUvefW/Cp1/W
	 JeMihBGpZoaBAWRIjLmmARWJDcId/cqbipwiCA0QSIAmnaTAqh72dUJPnOdbfZaKbO
	 2+vRKvJ01TWxzIZyeScdEUSOg6x8CDU/RSTBN4ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0093/2214] uio: sercos3: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:29:29 +0100
Message-ID: <20261118150013.685694440@linuxfoundation.org>
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



