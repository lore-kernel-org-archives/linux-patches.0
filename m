Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042319;
	b=0cGQU4oYq6mzoYhxiaMCmEZXGlE6V2S8eGKNKFYPdclVenlfKMKKd+iqGrtfdEH1dBvY
	 Yk7sDlH/AvWqnzrBrETxFFgcAjdSo8/PnOfz7gLDlt3oyQOMfuJ9qEisSw86yOmaZoFXi
	 L4BKI9LZKbmFvyaIGdVPy9BetJa7XCUTGZ6hhTh7g8XkcRh6rqWEBYzjz1tLeqnhk4v8i
	 DLd77fAWzgGwZTsVIaGCieLPNTlNUROgiHImjbK1YaBjJqoJmMjiMqOP5/1YRNA2482i+
	 21DAqGHvwqA0QuBWOPBmhFWkFMjVWYxo9EjQ13jB5sYg7SROcJkyOYM0+37ex1EvfRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ZKacpY4LvR2yYx3VVMEPeAGvGSYDzUaFC8Mo2SqIMo=;
	b=wUKIx8reSrZlgBTsd7LklWMRHqT02xOCmZnsF7TAxuxvR1an5ovS0HEKn3BJnxMFONvy
	 9F2IMxa5NN9t64SfDSN0iUQtACdkAtFwZLQH5lrAn+tt347xjz1beQE0ZnLIK34/zNn6s
	 KkcjVD5KkJgHMLPzXQyyOHM46OoBAiX8jcyG4aXneYqzrN+ujSdHjBhI8LCLE1pNgJZc2
	 DTrkRNIZ1sliMvzxwFIy2qQA9PTwkWNM7VwyQ2mxe5LJVA5b1XzPHn3v80CImCmEl23XE
	 iRPzqzuKTLLpA3tqvk01EN/27Gpm0SpiSAnLJy/jwFM/xU/Svkf1kmEnb9g5Lbv67ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KtcsH6tZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE7E606A32A;
	Wed, 18 Nov 2026 22:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KtcsH6tZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CDA1F000C4;
	Wed, 18 Nov 2026 22:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042319;
	bh=3ZKacpY4LvR2yYx3VVMEPeAGvGSYDzUaFC8Mo2SqIMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KtcsH6tZhj6eVS/8cBNqLUwRyenRok39FONTnoXH+qaZIUYINMUGkvQf7syoQe38p
	 Itcq6GJ1kL5uJwDJVbkORltq1tV6Wdg9UFmV91v3bFN9NAL92+0Y3OsqZT13zgm3gB
	 qq6zkRITOR67fgYHfNTyI61ixLrzeRNoGVFojvSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Travis Howard <thoward@lafayetteinstrument.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3129/3318] tg3: Add Datto SIRIS 5 1U Server to restart AER quirk table
Date: Wed, 18 Nov 2026 16:02:31 +0100
Message-ID: <20261118150453.782451328@linuxfoundation.org>
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

From: Travis Howard <thoward@lafayetteinstrument.com>

[ Upstream commit a55eb6a622141352131aa6156bbd6ce5da79d9b5 ]

The Datto SIRIS 5 1U Server is a Dell OEMR XL R640 (Dell's OEM-ready
variant of the PowerEdge R640) sold under Datto's identity. Its DMI
strings report sys_vendor "datto" and product_name "SIRIS 5 1U Server",
so it does not match the existing "PowerEdge R640" entry in
tg3_restart_aer_quirk_table.

As on the PowerEdge R640, a system restart triggers a fatal PCIe AER
on the BCM5720 during ACPI _PTS for S5, which the iDRAC logs as
PCI1318 and which hangs the reboot. Power off is unaffected.

Clearing the same PCI_EXP_DEVCTL error-reporting bits on both BCM5720
functions from userspace immediately before restart allows the system
to reboot normally, confirming the quirk applies to this platform.

Fixes: e0efe83ed325 ("tg3: Disable tg3 PCIe AER on system reboot")
Signed-off-by: Travis Howard <thoward@lafayetteinstrument.com>
Link: https://patch.msgid.link/20261019-tg3-datto-aer-quirk-v1-1-f0eccfb2ab5d@lafayetteinstrument.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 6983e0680e4b9..a0a191f80697d 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18139,6 +18139,12 @@ static const struct dmi_system_id tg3_restart_snp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R750"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "datto"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SIRIS 5 1U Server"),
+		},
+	},
 	{}
 };
 
-- 
2.53.0



