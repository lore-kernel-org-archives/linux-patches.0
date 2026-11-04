Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829373;
	b=KisCn2R9cf8KzWBJzi9WyAaQCmNGHucYF7rHnv8m/Bw1QVyQfIjwFu42UMjlny9NtY33
	 m9uIx6HCA/yivyioiyiNPf5R5KY086rqUY9uQp07IcHLOF9TlL9nEzwjqqPfqskPmk1wq
	 0oeVrDv7l/pQktv0BN/EZcPpN9xVpbZ6slJ8J39K3FAiqDSXbwugyBr01VUZdoR0SWWOF
	 Pc7Kn7QP2UFmn+or+OlwwCYR98o1Ro3ILXxKR7qFksfmyljKHyQ71mj89b5kBLtVmz16d
	 gc67BKJtKQxQ6VRU835+gYAjrXNWk9qmm66lkviqwGMlvV4X+vOF79+o9EvbDfjCCMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZxpiImwRIcLExiRXI4JH7ar1G2kcJXXgMvAntwiPjuE=;
	b=oxJvXoBboZlACO3UD3Sob1xWQI7wCaar8+Icb+nu8MTRRX6QGDz7vEjxPiVjf7PiEpLh
	 bY70S6wBds6gtM71g4RO353X9C6MPMqBlOZ/IbGqHENCOS2cDozbvsOctAGq0yqwuVipO
	 9tzB0L6RiLZyx0wNUmXTpVKPbTXCxXlUkuPA/wNolZMbSXLEvaGXSe9OoAjRouUWfx1sr
	 dutGSdgLEfZIaw/pcNq8p/7LwPLx+F0S+6t1VEp2It6j/6DPsfA0F3Ce1POGZ/l+5LMk8
	 azUCpmDrXrMcDA8wHjuPLLcX81FVmPUXQJ+N9cDkgO8OKR9zzpLCG1dqbRi1IZNdOkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YM5WFgOJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282176070AB2;
	Wed,  4 Nov 2026 21:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YM5WFgOJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9D31F000C1;
	Wed,  4 Nov 2026 21:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829372;
	bh=ZxpiImwRIcLExiRXI4JH7ar1G2kcJXXgMvAntwiPjuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YM5WFgOJAN+SSGhnGPXtZ5KPJTUMImaRc4DqEQISstcjA1rdlbaYV7M7CGgNXuAMS
	 Hx3YAIOeOEs6yZzBj5g/YafNvg8JCG8wXIhoX2Ianiskfw4lv12hKiGjnTKxS9dV8k
	 h9RXO4+dd6IPedTcyCi1IQYHUosSDz+KSGu+N99M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0084/1005] soundwire: dmi-quirks: Disable ghost Realtek on Asus Expertbook
Date: Wed,  4 Nov 2026 15:56:57 -0500
Message-ID: <20261104211045.980625291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 90af3209742db61a7f9d7d054a16165818cfc6d8 ]

The Asus Expertbook B9406CAA also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine driver
into attempting to create DAI links for the device. Add a quirk to
remove this device.

Closes: https://github.com/thesofproject/linux/issues/5828
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260630081132.3294488-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 32a46a2d90f7c..2a98fc8c104d6 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -178,6 +178,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		.driver_data = (void *)hp_omen_16,
 	},
 	/* PTL devices */
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "B9406CAA"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
-- 
2.53.0



