Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021547;
	b=gxUsTFutn15L3cMYKUdlDMJf2jPiYHqm9OjIXtzNOEJ/yJujv02t0F0zu7442p3NFe/N
	 i5x8Uk8IKcTHTD+qD5mOpdyNQ/IOVJwULaDLIH6pfrIcHWvrAvqr02gejYwypphSyYlDc
	 +cfVqxyArPXqf38w4jvuIjpAXtoF70IvI57KWaxr2ajPT5ubOBjfNnCvE86n7xmI6fNK8
	 LZPJ5qwaIxWbNbdm3buTIBEV0/IdjQeYO2ovLp++c3OJnvrWWAeemMHb92Wi2oK4N5/yj
	 2NF5cKYc8Jie8YEabOiLxM4VmX1MOu4Tq+mbknNVJLV8goCwYty1AcjuWYkBmdft5TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nlWBCU1MtJmzFR2k6OnbETcYW1yUGBm+iZS91U98mXs=;
	b=RnnePTzYAc1vwlYHHfoImki98Su8/d94soI0SZrvNxdkxzUbD6Ggvc+ewoMZ0sRB9PUj
	 +S4orkrSxLAkmKtdjyqbN2Yq/mvrBaeqMSbCAboyvx9yGEyUBYeBSBANBLKi4EU98p4kv
	 171X0zZHrbLSBwRFzZVrR5bjUzCEeoYH211s4mmS1WlFzNYWtQi15KjtfVvOAFzHfpxWE
	 ttuJFYRjDBwwy7fsmIpxoN7iSlPiK56YlxibSx62Wm/GiyMr5ymLql0Ni7OVKkLN8D8Hv
	 0girl8dgxdKYUPmRMcZ1jUSkmRi0CzWtFBtk112osiOdn5n3LGkHOsDJ0+XfAlijJKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gW17mw2j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDC7606A32F;
	Wed, 18 Nov 2026 17:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gW17mw2j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB78A1F000C4;
	Wed, 18 Nov 2026 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021547;
	bh=nlWBCU1MtJmzFR2k6OnbETcYW1yUGBm+iZS91U98mXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gW17mw2jTo9pFv6579QBwu9u1avdLaIQSleWagXc+J8vBrHx2uCljqlNNQ50rMFya
	 S++v8jyzFlJcxE4/p9yxGMv1o6oF4SCoW9O12aUhTFZBfyuAG1ryIj3K0QdWzx7cBb
	 hlPpiuMxZHXH8aPj4/zHq8zCk7r5TBHrZVZndooY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Travis Howard <thoward@lafayetteinstrument.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2345/2651] tg3: Add Datto SIRIS 5 1U Server to restart AER quirk table
Date: Wed, 18 Nov 2026 15:59:45 +0100
Message-ID: <20261118150409.499913676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index fd1c95f1111c5..e85f7e909a839 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18205,6 +18205,12 @@ static const struct dmi_system_id tg3_restart_snp_quirk_table[] = {
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



