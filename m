Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032850;
	b=bRXrD7PU/zq4yM91l1YaZQvyL1kYxv2L6Jg1GHOMGfIBfU9bs2xGhJhCR7aX8miG15i8
	 jz9q39h8ODru2ybqlRB+jwBuWn0BVFzBkWLzx/uckHB/lpBpzV6cNax3lIJAmjn3QQmc+
	 ZukxZk9eoXoGz3UotlOBV1WvL94jYdfiYXOP5VWIdZMnUKABEjhvyvxro7FBWkF++FBHJ
	 34/oHCPZcqg4QP9UCvx7n87EHPcsqeuRcbeI/6RYYE65IAc3d30j4cw1xUD8FoSwYBH/d
	 qmGqYfYN8FrY8uhjmZunf0k/9U/+dlQ9ujZdAQcLrvNDzlXdteRGZj2om1KiKhWYJwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hds0xyQeImCzCPa8+fH7PavgcotXZwxSw/ELaUfbVzY=;
	b=kIFefr0PH3/o1jIweKvql6RHjLxrJ0zSWyc6EW6Y3dV4EMXiProiBrBS+K7wS5/1sz2T
	 EicTCjNCmZgdtFsc6zt66ihLKGoc8Lymxke+cdT2csAxSlXfRTopOS7XOPnJlBgw/JmfH
	 sk101sEbvn7ute8I8/X4h2rPr06SNuNq/dYEjNfC//Os/0nfL6Y+u5RoTNpegbVhlrztI
	 jTfUz6Q998L+LTIB8EVEfp/ECk/6V0aLE+3610qsIBkQcTd6M9qCKMSMSfMQht2B3sbTo
	 CRq0Nw6YaVMNPM3EE//MwffZuRocJDgxVkWk+RBPJk1nX+D3zlOJ3JML6BuoVZwJh/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d7DeT8kI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FA7606A320;
	Wed, 18 Nov 2026 20:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d7DeT8kI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31ED1F000CA;
	Wed, 18 Nov 2026 20:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032850;
	bh=hds0xyQeImCzCPa8+fH7PavgcotXZwxSw/ELaUfbVzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d7DeT8kIOM2UPX70gsaut4uUBtpMCSUsk15D3dhTse4+41PJ6+4SOaHd5snhVGxTm
	 i9p22UJDWeL963J38GXHgtouxKOCifkH2FQ4ICH33ue2Ax/AxtcHeFLqKX7D0qzZBB
	 45yg2GfoDkr76+KIwmFkEFM2nnM/5J7U/hh64gqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Travis Howard <thoward@lafayetteinstrument.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1515/1756] tg3: Add Datto SIRIS 5 1U Server to restart AER quirk table
Date: Wed, 18 Nov 2026 16:00:42 +0100
Message-ID: <20261118150109.186630931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 190e7f622e7f8..d95f94e52214a 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18187,6 +18187,12 @@ static const struct dmi_system_id tg3_restart_snp_quirk_table[] = {
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



