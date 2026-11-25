Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617614;
	b=ejZFT//RuwlYW+kIreHcnqzK3K2j/0fMlpdK0ClX8F4fCFikdI0aCelURKxa0UQX3chS
	 2BOW00paNaSQ13LFCvEvn5La65R0QqNyrRlialrbJD3H4oTGJU0a3PdXC9IsysTIjcnfU
	 6gG3tRcBP00gPhwGr8EyXBUlBuxL/f83lmtKxd/vzfLO/v9g0tyWnODNq8nbKn42sCMV/
	 wVZYWN5mdQp5yM+GLg6mI6r5bTbR1U0OgdowRB+UAAm246RKDyDrO6JZ82CdTwLzH6nY8
	 sUSXMbV+WJcVJS6wvAmHuK0OSrfrWrAb+rekvEHFHPsVte2MC4084CAviwEXM8lAHRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OPV3lFuXJ+Ir81tOXhhPajLbMDyCTYGjjjak3PD/5+M=;
	b=2/RuY7puWi6KChYmyxoIz/eBdvC+/k60gezIksOpioynmEFJDWCWKfV9dhmfkWnD+UT7
	 wIzJsHbE2vkgi/h7WeQlyShUgBkM77QoalW6IJwE9fPVmAlc1/IcTZ+ywiTANlWUpFfD6
	 DOmB1XhcVYg7MYy/fq+1XRpBzmC9XbL2YoogxrfkGSTlFxQBLU0lHuc+98Y0N0qx54S9o
	 1qSw7Q2JmwVcga94vBR4Nw0WgvmS8iMEnTqTFf3Dosv/DIGL0O3OIcc/v279ghrWrhJ/l
	 3sa09LRj2JlCCu/iefOGJNaPxjxKUtwGmrl00cGH7N25VayZwaY/tFc2UNAGrZ6/fMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nhkl+5iC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C534B606A337;
	Wed, 25 Nov 2026 14:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nhkl+5iC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F2A1F000C0;
	Wed, 25 Nov 2026 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617614;
	bh=OPV3lFuXJ+Ir81tOXhhPajLbMDyCTYGjjjak3PD/5+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nhkl+5iCJO9KmwbvhOSVZPeot9iTWg9cQ/pfcpV0TSDYQt4vWn4dkPPTx+M+56ysZ
	 JdxHYNl9ZAvn3BX9e40YnOdEcPoaJyR8zUcL/DsY9LEBGmqAOQ1tu34eJs7SaMxf0d
	 kJ4VmV0wTKJV4GlwMot7rnf9J1gMzJ1NAA0Gvj8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0004/1005] soundwire: dmi-quirks: Disable ghost Realtek on Lenovo Pro 9
Date: Wed, 25 Nov 2026 15:22:22 +0100
Message-ID: <20261125143821.840713404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit a6a867552a36e647cbd35aceae24754c9bcd3661 ]

The Lenovo Pro 9 also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine
driver into attempting to create DAI links for the device. Add a
quirk to remove this device.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260903102743.3782541-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 8140f9b9db0a7..197b754068920 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -242,6 +242,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)ghost_realtek,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83U9"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{}
 };
 
-- 
2.53.0



