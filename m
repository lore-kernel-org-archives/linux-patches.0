Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043513;
	b=JSXSvqV0NfQgxv/7mwm2jxuJ3RAc93hhZ+XnydFUgQBzazUwrnwQ5mE5fFSG43rgSoFC
	 byTpBxCSlXjs4bJckKR+yy8N1S2QCot1WgsuzFoEIcA0QIr6PQEPXyFSoLU8WaatrSIYN
	 dqvPHhwHTfueoSJM5P7Jpcn/Ycgf1xwzBzprM4GVAqSA0oO9BF2Iq7DKR4Z3d2RYgbeZW
	 YYyKKkkKa0QMVrud45dptvmxTjZ5FKflFljOsnh/xQpQHW+ZxvZFVNaSRuddz2tVnoZvz
	 cNfFoRYkyLrk7GO9slpk0CErB4RqYaRR8VER0H1uVi0Zzz/PTppjSzu0L4DJrElwi9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y4y+cICMcD36g+CbCGJWW4g1Wcrl3liuKotAUBe/gr0=;
	b=2FTKNjoeZnwWY7pLApzQQNZt1jndDlji8fdJQOXK0FgWdA7G47e7QKdUqSHT9bpdz7gm
	 1FXhuF5ewqpQAModzRv6pgN0fIHxFHuF8/xqit2ETTwjjyMS2D9u1WPOOMC4uZUCDyL2w
	 JZfjDluHe2WloK9hiLj/bZMzsn3R2JlwTt3HoVe5b6G1Szlrp+YIXmkTGGS4os85ptu0S
	 jA4e9vV+gWVAeEBDKP/dBMCvKcX0elbuGnMODxWyPs24VGawet6Eb16NVtK1dgwbU41mK
	 L1SOQebQbffLoSFEld5hZD3CuGz875DCNLz/mrOzh3framBdLM6MGTee28dK0QUHzyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qffHoDNT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32FD606A32A;
	Wed, 18 Nov 2026 23:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qffHoDNT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08711F000C4;
	Wed, 18 Nov 2026 23:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043513;
	bh=Y4y+cICMcD36g+CbCGJWW4g1Wcrl3liuKotAUBe/gr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qffHoDNTl2HQCvc4g7+i9ft4C+J0MxwojAdvvSXvqQJtmE65jheXQQ/OGf8iqFnO8
	 IVGYlxnp4iqGNTAsFDpC9suo2lKd/pMjP3aFlKzmPsOhLrlOqW6I4qkcrN45Vtnbhg
	 uFjt6NDjT7JkM1o29wMnu/cVBtxS1GrtPDrJhk6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0201/2857] soundwire: dmi-quirks: Disable ghost Realtek on Asus Zenbook Duo
Date: Wed, 18 Nov 2026 15:20:35 +0100
Message-ID: <20261118150208.589981970@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit ca02ffd4975ca5249abf0cfb750a495d23b453ee ]

The Asus Zenbook Duo also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine
driver into attempting to create DAI links for the device. Add a
quirk to remove this device.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260720095741.3592825-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 62cee6e2179da..f738e547a1f30 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -200,6 +200,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)ghost_realtek,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "UX8407AA"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-- 
2.53.0



