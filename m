Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591494;
	b=2GfVo8WLcTNmckJ91i0B8DACsAxO10uZIp0ztWeNnC8GxoTryZ1BH2WOw37ri162vgCt
	 DhHvpXY3E30emK3AyyYzm8f/tCCIAZU1K3/0Zu0TggJ8VAdKcebIL3WSPk/82ee0R77o9
	 Qap3uMy0L54r2h047tuDcXuNwTrpsc4PCC1AHs2lfxPj26KKzttDBc8cHZz514J6R21wS
	 eD5dgkAAtqJNShyTEVThoN8dJG+khHqbgNvfRopbDED1huOk5jvTkfCdKFcpP4GH/yvZv
	 bsuaNg6igpsxgnI+lp6WwXdi/8+uhMcqmnRmTUOseaAvyI/3tjxTciYWFZodxzDfTDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Di2UNrzEtjW1QQurIE9ZWfBIPbZ+5+4/GV2p4H6SSns=;
	b=kbf7YKOjRkYQ6+j85G/3jvp8kdr6e6AVpaMP5HeE1/FNbs3EA8LE9WtYjlEuypV6/i9d
	 kutGsHgvmrxcCD7Py5zXM241RQ7AsXKLEYAiyKRPFCgvHaUEwiQnOXKK8XCYamuNaYqeZ
	 PPpfI+kbvaZrAqX43y3TthpgZ+OnlHIQM3kVQtY6QUVlskQUL+Emk+f+smlhg3IYjMk0C
	 Bh5ath39e5lA5KEYwitJJcoOzabtkDv4oQT0Fesy7HOR9Ps+TQ560C29Zv/MrmGYuQ3dN
	 OB8E5N+8FJBorGha5R7Bs2EAzyQj/RjRbKFtmTGRHptCxJNqzMnoOWYAZwZli9m/gXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVuUHTsH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EDF606D483;
	Fri, 13 Nov 2026 17:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVuUHTsH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1761F000C4;
	Fri, 13 Nov 2026 17:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591494;
	bh=Di2UNrzEtjW1QQurIE9ZWfBIPbZ+5+4/GV2p4H6SSns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVuUHTsHauuJCcZ7RIabePC4O5wkE2guGJnN9mUQ/YaWyT15PfF1N6eDwGoJHyr4F
	 6C/Jsyiw6PVZOwKLae1bkDHGox3fUoJ/RcD4+vm6VXD7KEukWRm1FMJNKjV9dubo+R
	 9XNCrIsb/DLbm+5X+PgPoxL1L8BszPzJmDavS3Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hasun Park <hasunpark@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 575/670] ASoC: amd: acp: add DMI override for ACP70 flag
Date: Fri, 13 Nov 2026 10:52:19 -0500
Message-ID: <20261113153831.337373727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Hasun Park <hasunpark@gmail.com>

[ Upstream commit d0426510a9e1fabf074e274ceff26ffc6500980a ]

Some ASUS ProArt PX13 systems expose ACP ACPI config flags that can
select a non-working fallback path.

Add a DMI override in snd_amd_acp_find_config() for ACP70+ boards and
return 0 so ACP ACPI flag-based selection is skipped on this platform.

This keeps machine driver selection on the intended SoundWire path.

Signed-off-by: Hasun Park <hasunpark@gmail.com>
Link: https://patch.msgid.link/20260308151654.29059-2-hasunpark@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 38cb2ef26b64 ("ASoC: amd: acp-config: force SoundWire probe on Dell 14S DS14265")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-config.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp-config.c b/sound/soc/amd/acp-config.c
index 653e8ce946082..8d7b968c4402c 100644
--- a/sound/soc/amd/acp-config.c
+++ b/sound/soc/amd/acp-config.c
@@ -23,6 +23,16 @@
 
 static int acp_quirk_data;
 
+static const struct dmi_system_id acp70_acpi_flag_override_table[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HN7306EA"),
+		},
+	},
+	{}
+};
+
 static const struct config_entry config_table[] = {
 	{
 		.flags = FLAG_AMD_SOF,
@@ -200,8 +210,11 @@ int snd_amd_acp_find_config(struct pci_dev *pci)
 	 */
 	if (!pci->revision)
 		return 0;
-	else if (pci->revision >= ACP_7_0_REV)
+	else if (pci->revision >= ACP_7_0_REV) {
+		if (dmi_check_system(acp70_acpi_flag_override_table))
+			return 0;
 		return snd_amd_acp_acpi_find_config(pci);
+	}
 
 	for (i = 0; i < ARRAY_SIZE(config_table); i++, table++) {
 		if (table->device != device)
-- 
2.53.0



