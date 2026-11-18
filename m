Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027742;
	b=rUAR4wAGnN9PYWhEZpH8QoWzF7rbiYMECKa1ZWSrzqstSRo6BBFyFoc/S9oc6IxmXohn
	 5sNggsN8v7AKI/ylN0UoyBIBsZDNLuC5im9wZhVtagsFcbz7cuwH5MV9zlVULBoRl/Xti
	 fS//P0LpIcLkBX33+r0jHGKRY88CW+cMY1s5kZE/LzSiexuH4Jrw6eirLpiMg545NUAK9
	 ToQ9tBzrWSxT6fGbopHybfzJliuTV8ZSrtvqtiIBVtr2uYwkG1Scqn/MIEgijJb6IR6HM
	 +6xx0EiBWPkxdGZfOxdHsZko3XAZiX3swr49W7AceLOz6Fo5+UhIREZZXzRfDlBU3mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u9hMf8F2FUGxMd4oDfntc3zx8CIfjJT+aaRGjfbtI5g=;
	b=ZQcK3hhx7DYX+q7iFiGkPnRVu3A3nnq+WdNSJ4q5HWWykAv/kgQexaWLZ0E4EoY5hN47
	 Aid6qert1kZvEx1XohhElt+zJDZHG/p+X9Xn4vfxz/y6rGywwuyPc8w3wBvapO8TD6jvD
	 5lvEOQSphTK6Au/1U9yuuAq5VueK+PRPvvmDYdS1/36nQn6eMxwJgNJI1+RfHr+Yf8QXN
	 o/jKCpym1V/Qmwa01Jn+lIiX7ixipttji8rirp16Z6GMy2jAoYXAoaR4dwBaRNe3NP55c
	 GZnFvRTvxsEHpiM5ikhA+pFV6zXYPcZmg3ikvvLpEfK2AAaJIOMknYWBS77Mf+z7vDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1XdSdC+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A94C60A2603;
	Wed, 18 Nov 2026 18:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1XdSdC+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614ED1F000C6;
	Wed, 18 Nov 2026 18:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027741;
	bh=u9hMf8F2FUGxMd4oDfntc3zx8CIfjJT+aaRGjfbtI5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H1XdSdC+fT7Mtl6aOrvxR0DBmRFRfNYrpYeyptlhtvoyf1WID9F8apB1Mw3tDTf3s
	 nffnQQZIPT76Y7gqcRJAEa1kXSzTaQYhYqUMLaVV68QTuPC90YoPI7+FnWn+YkvFzD
	 XH4GTkULWnco8BdHCuSpoPR8iq2QCXtVLgX4hrKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Travis Howard <thoward@lafayetteinstrument.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1896/2151] tg3: Add Datto SIRIS 5 1U Server to restart AER quirk table
Date: Wed, 18 Nov 2026 16:00:31 +0100
Message-ID: <20261118150230.858983099@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 897bb86bedb13..f0b9392820277 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18218,6 +18218,12 @@ static const struct dmi_system_id tg3_restart_snp_quirk_table[] = {
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



