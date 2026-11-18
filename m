Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050392;
	b=TA9AOT2J6OAtgenaj4MeeWA5SaLcXqYh/jQS1MJlDLeZ/WOAPpJt2Y1SgWoCGVjg6hZe
	 Akh8pLpHKVNOmmHNiT4KJ4QkBG8oXh8dtmHVgQvMHHQvqxr2KWQrhXEje2b9YwM+XKdSR
	 Ptc2rSpHmppegD9bFjpjVpgMMtN/sUQeaIII10EXvkUCdosN1/roDcBXeBoJTnpLWQund
	 2Zgs7VB1X4BuuIYwSqRvXSC9N5/VN4qUldxxM08Ps43rxJL7BSyEuTRs5bS3XRD1enGns
	 pq0U/QMJaIVUSiY/6pr6eFIq5vdXGPi5p+YZ7Y+BFoVZA6tAPFtaaDNuf43qEE9hDFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7wbFzVbrkP2wiEQmFMRY/FIsJTagGcRnTyVS+lYVuDI=;
	b=P488QD0NwBp/PIznq2v80WpV98jEyA0GDBZbN81I0xjJlpTAKudSc7osVqPBBRG8+57g
	 WvXZS57d+T9BDMfLyciXQvauPFOnMbg9MH+1W5k94A6OZWuX0Leh94ELK+rAtf89J7DJi
	 MOJmEqIJ8CimsfErW9R9cViW+q7tlAYZ2v/KXNBk+Qg1/ZzEOLBW63MzIrfPbDW8hXMGL
	 drATIgPPLde+SaWUU6kYAnITZa9C0eYPiM+/FK/BG4uWs/35VzmSHQmlRaVNx5CiYO/F7
	 p3ljINA4M61qD3bY1aqV6N4pDiL/GZAd0TWabyWh3xMZ3MpdTrv7h5EMIY33VwovGWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=alg2Sq5w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A005606A32F;
	Thu, 19 Nov 2026 01:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=alg2Sq5w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7261F000C4;
	Thu, 19 Nov 2026 01:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050392;
	bh=7wbFzVbrkP2wiEQmFMRY/FIsJTagGcRnTyVS+lYVuDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alg2Sq5wKVQwK7qOcE9bQMdeVRwHKddxeBL3Ex5pEM4hRYE5TwFT14LR6Vjyn3kFu
	 fpM6wAZQJ/fOcBfP98eybWeHMFKVktoa/Nvr8NH53MIwbQ09ubTV7pGUCkzF8mzk1f
	 sB+CjiVwwXmUVleDxN426a65jrmBQgrv2qG6tIC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Travis Howard <thoward@lafayetteinstrument.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2691/2857] tg3: Add Datto SIRIS 5 1U Server to restart AER quirk table
Date: Wed, 18 Nov 2026 16:02:05 +0100
Message-ID: <20261118150338.462059296@linuxfoundation.org>
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
index e983e1bca561a..eaf37041f6ce6 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18147,6 +18147,12 @@ static const struct dmi_system_id tg3_restart_snp_quirk_table[] = {
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



