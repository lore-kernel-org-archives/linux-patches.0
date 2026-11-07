Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061088;
	b=zkp1HTXf+vLMrhiNidYoEErCIY2uuV/RTjQMC/CmySgiUw0SIXvR3SMNMtMB+jmG5doX
	 kCgmOz54zbo26xrv6ONv6/IYUgSE9qpM6wn4zo4x5EHV8u+ylm6NYgJRuNBLG/X1hip5c
	 Qgh9LBSy7bKbRQ5ctDKsB6c2F+mnpysNb1rRpN+mW1frwOPJJLQhHMLK+iCjsRZvAGSxG
	 9lDnepbq5quCAbOuqHca6kVvNper3jBuvUnfXdEB+bsIBx0ThARsEBQ9qVR/UznhdmQhD
	 5LaUfCqaEPCFs4VGNjoaT28lKCQv8qpAbi7mcFjj+ggBIifO2QXcdsAPr6NzPkc0ejg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xEOneGOlyb8/AqHw+y1j+ZsRgewJipi2enDfXh5rp44=;
	b=Fak6FY6Lwl07gxaDrsrddfD6s4VVhHZdW0oCWhd+f9FGVVNcL9ABAHUXSARTe3XgEmI5
	 dWUatdP13ha6WLwgiUJRlKnApEUmYqD8Uzbw/eH2N/Ls8KtRw1Z0ZJ6PKDE3amzMAF7gy
	 kzbOqX2NZINbXzgkGK1WkN8OgTxZ0yGuN7UCFKFlyIpzOHgZ/9ChsHzX5YQ2Ri8k7mhfy
	 RMgxR3L9sxl+nip8VnNTK0rYVypiKoWDqtk/DBHtJXSCDuc6C4cX9+OJY5ac1Hu1yg0J2
	 rNu5RGT/5GAnouepJzanFsoyx4PWA5VbFTP88yCWMVpvh/9GyKkTx3HvRmEQ9Tj8GUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F5LDtSmJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61250606D833;
	Sat,  7 Nov 2026 14:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F5LDtSmJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139081F0089F;
	Sat,  7 Nov 2026 14:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061088;
	bh=xEOneGOlyb8/AqHw+y1j+ZsRgewJipi2enDfXh5rp44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5LDtSmJpu+rBfVfSH7f6PLI4V+1rRicvbzw4IMNwGvKF4wb+1CKvc4Ph24q0ELFe
	 PK+9RbzB+Cuvz1ZB1+VZ8nXU6kMFhW1SFdNj4lFnCxukYLxUyun3gwePDV8pN+qcHi
	 bsCobxxjLTWvF3YQnxzDqYE6cOdUNt7jCgZ29NIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Moreton <andy.moreton@amd.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	Alejandro Lucero <alucerop@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0409/1536] sfc: add X4D PF support
Date: Sat,  7 Nov 2026 08:40:25 -0500
Message-ID: <20261107135009.064741986@linuxfoundation.org>
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

From: Andy Moreton <andy.moreton@amd.com>

[ Upstream commit 24fedc7a569bce181728f0dd616504bef9f1513b ]

X4D is an X4 controller instance as an IP block in an SoC.
It has the same feature set as X4.

Signed-off-by: Andy Moreton <andy.moreton@amd.com>
Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Reviewed-by: Alejandro Lucero <alucerop@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260916125641.12238-1-alucerop@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 36b3b57e20558..2784baa18b8c6 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -825,6 +825,10 @@ static const struct pci_device_id efx_pci_table[] = {
 	 .driver_data = (unsigned long)&efx_x4_nic_type},
 	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x2c03),  /* X4 PF (FF only) */
 	 .driver_data = (unsigned long)&efx_x4_nic_type},
+	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x8c03),  /* X4D PF (FF/LL) */
+	 .driver_data = (unsigned long)&efx_x4_nic_type},
+	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0xac03),  /* X4D PF (FF only) */
+	 .driver_data = (unsigned long)&efx_x4_nic_type},
 	{0}			/* end of list */
 };
 
-- 
2.53.0



