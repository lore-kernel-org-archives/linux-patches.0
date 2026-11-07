Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060814;
	b=QaO/LYPZiPlRTiXkNhfLchvlRkT4lV0L0VLdiwWVN2BnDa3rHW7WtE8WZIiit9i60uuO
	 52NeJSLsQ2cqx9zEJZMQoNdYvuWdlCsVG9oNYbzpc7ixu4haE6AQiYyG5uWbF8ns7lLih
	 zMBXNckDHY9PNDeIQxTw8cPrFAleUx+aNxySh2MPO7A1BaHJpeqBI1sCq4LlOgP7n3A9q
	 HmBGRbu3TQiajv1+8Ik/Shi+P2sqTfzW4aLsXK8mbdCVWxRPYoAieHJ9JQx5knJzg6gPI
	 /yK1LUippc7gCAl9KikQw75r4g8r+urAWbYa7Xg1mYDQ8jBmQDzVX9gqCDLQFXR8EnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AwHfBY+pbbEUKRfz4LZOYk6VaRV6pxPQd0GPiSgCzy4=;
	b=te7Dsc4yoTTvRI2psRFNYAqwv1GtjfCAWuzSeL2Vl7IObXbvo023FnmdoL5Vovkv+gkC
	 dFYAMfSWGn9hk1DGnqZeiVAYnC1fmWRQmeLmBWPH7QX5Yj10UFU27i1lmjyKmTR96mL2D
	 E1bKTqmB4kLeUXJp7i/hIJlo+uF3qA/m3qWh6JNMtykEJt1tbnkACVaxzgaNMG9cdhlFN
	 Mfo4lJxDZxFMH+BJsotg1yQLi/v4ntx+Nx3gPC2djHxem1LwE8pTKudq4uNULJu2lSNTv
	 jGbrhdOUFrDCzVSPJi0ffNdMlibQqYUYJJNCIbtwV8SJQ+bcSmAavATLc4DZdidrrZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IvHhCdox;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE38606A326;
	Sat,  7 Nov 2026 14:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IvHhCdox
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F6F1F0089F;
	Sat,  7 Nov 2026 14:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060814;
	bh=AwHfBY+pbbEUKRfz4LZOYk6VaRV6pxPQd0GPiSgCzy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IvHhCdoxoMgxDWjMQAArHU92jwg81I+kzEfJa3svATjXE/ieJ7h8tRb7qbxIZPdnH
	 z5qQVUEspPH/9atBFAFctf5RNddo4CUHY0ieMnQBHtQoPjXDF6wIEgRR/wnXUH0+XR
	 QktKTQgeJtl1Xz+h5A5ddynkj/5Tq5Rw5wusj/lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0163/1536] PCI: switchtec: Add Microchip PCI1008 to NTB DMA alias quirk
Date: Sat,  7 Nov 2026 08:36:19 -0500
Message-ID: <20261107135002.247100491@linuxfoundation.org>
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
index ac9851e3d65b4..a71b054d5f3c9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6036,6 +6036,7 @@ SWITCHTEC_PCI100X_QUIRK(0x1003);  /* PCI1003XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1004);  /* PCI1004XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1005);  /* PCI1005XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1006);  /* PCI1006XG4 */
+SWITCHTEC_PCI100X_QUIRK(0x1008);  /* PCI1008XG4 */
 
 
 /*
-- 
2.53.0



