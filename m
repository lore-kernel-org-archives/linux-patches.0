Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80476125B3
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AE3C433D2;
	Mon,  8 May 2023 10:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541307;
	bh=bKVfZbGQbbaMi1wWv8cFTLl9g6aqz5vdDPmG5B9/lzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylALwRzVIHKChQgDZ+p/gixFceiyUKBM0TrthNbqesHqaASWQXk6vCjvAki8hi1Q/
	 Hra/tVJ9uR9ktvDnKAnYRide57VaUnPIkkEP1c2QIiBX7op+Gzb+u16lQL1n52UbUE
	 EIU6/pU6mJn5EhRDu31TU95CaZfAkT4tahQivTOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.2 073/663] crypto: ccp - Dont initialize CCP for PSP 0x1649
Date: Mon,  8 May 2023 11:38:19 +0200
Message-Id: <20230508094430.834661031@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit c79a3169b9f3633c215b55857eba5921e5b49217 upstream.

A number of platforms are emitting the error:
```ccp: unable to access the device: you might be running a broken BIOS.```

This is expected behavior as CCP is no longer accessible from the PSP's
PCIe BAR so stop trying to probe CCP for 0x1649.

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sp-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -451,9 +451,9 @@ static const struct pci_device_id sp_pci
 	{ PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&dev_vdata[2] },
 	{ PCI_VDEVICE(AMD, 0x1486), (kernel_ulong_t)&dev_vdata[3] },
 	{ PCI_VDEVICE(AMD, 0x15DF), (kernel_ulong_t)&dev_vdata[4] },
-	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[4] },
 	{ PCI_VDEVICE(AMD, 0x14CA), (kernel_ulong_t)&dev_vdata[5] },
 	{ PCI_VDEVICE(AMD, 0x15C7), (kernel_ulong_t)&dev_vdata[6] },
+	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[6] },
 	/* Last entry must be zero */
 	{ 0, }
 };


