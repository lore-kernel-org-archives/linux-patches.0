Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043192;
	b=slN2Okx2GUVBoKKnX3Z9HbDzSmPmgJTcbT8qPyiiR6BGByTfW1SeKmKgSYY1TYCEyJwB
	 phFY8WhBWxfGFpMII8LGqVEvyj1zGTeK3svWbNzGzMh3JziuCX5sjbT6zTVnGMgYiaXJ1
	 gFfS6Ss5/RtUNzLorU96oT9FnetBVqVJzn1fnJ/vt4V9eGWvtaPbZFkOqgpMtP90hsprh
	 7ttMTev0mV/ghuQ8zoQ74oW0domoKvYkBl47+7tjXYdTuCVmRrXihWDLuShA1u1QxM7pp
	 fj3W8KuSA7yhZDevKbsiRI2r1nusz1Q7vvYzmTHcWDpSPRN2UAqJeyT7MtK8NTU3m6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CoLCb3xknDPXqw183AKymnuuJzOOGzrgJ4XhWuPK6MI=;
	b=u65SKa/rTX4BpHzYioMF72ygHX+8ooc6RgPB3a+aZV89YkxpO47YS3lH0BTxBk1Kcxus
	 HpILMy3mf/IDXyFpB0w2LSD0v27InmpWOiPYsxpMwKte+IiWtFH74lI3URGiXktntvRqr
	 oVBndinGNDUklgI3EzQuUvA6hpeJJIbHLYalzei/kX/HUlkQfdwqxEqXHXjsLOklA56Xf
	 CfLud4pf8P/ZTHtX8SKM10QKDOcSzctSGcCp0iodlmjG4XnxfIQ+P+NU2I5p1FfIUG/fe
	 E36+POhCB8nTtWniBvYm0CplkSjoHtC6E4Z8RyI1w0jk3Kft6tIZE5hHa2ns0VtH4UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p8IHjY4t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCA4606A325;
	Wed, 18 Nov 2026 23:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p8IHjY4t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBCE1F000C5;
	Wed, 18 Nov 2026 23:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043192;
	bh=CoLCb3xknDPXqw183AKymnuuJzOOGzrgJ4XhWuPK6MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p8IHjY4t9xI3EsXO5vE1g3sCs7n5t7mmJGvtfVDz/ihZT/yNM2rMwXcgQOj9GbcOH
	 0T4g8F8OShmyAnb6FLDwf4TPygY1SUU60+/hMFdK8Vy6WvMyXsGpbrBF9gxanHlDqu
	 +ER7BxS25splaeTenTqw1pvSg4Dw4vdJCI45muNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0123/2857] PCI: switchtec: Add Microchip PCI1008 to NTB DMA alias quirk
Date: Wed, 18 Nov 2026 15:19:17 +0100
Message-ID: <20261118150205.774834856@linuxfoundation.org>
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

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 00a479ba1d01249d43ca5e453380d1ed60946f8a ]

Add the PCI1008 device ID to the quirk_switchtec_ntb_dma_alias PCI fixup
table. Without it, DMA transactions from a PCI1008 switch's NTB function
are not given the correct requester ID alias, which can misdirect them
under an IOMMU.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260714212010.230606-4-logang@deltatee.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index a9c5dfdd11a85..8cb96ffa04510 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5936,6 +5936,7 @@ SWITCHTEC_PCI100X_QUIRK(0x1003);  /* PCI1003XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1004);  /* PCI1004XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1005);  /* PCI1005XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1006);  /* PCI1006XG4 */
+SWITCHTEC_PCI100X_QUIRK(0x1008);  /* PCI1008XG4 */
 
 
 /*
-- 
2.53.0



