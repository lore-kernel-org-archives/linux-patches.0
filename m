Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060625;
	b=TazPhawgv+fAtXbUmHYTcFGTbqsicOtJPXnsqNTwRZqoyBA2JmFLsaVSrw5e6bs0bE6D
	 1whEzAuTaSUUmhNWm5QE/IEQ1pxwJxq5Qj0woQi1J3U7CBVyANW8z9iFrQIZ3kSJRboPg
	 RMonquwYbwhA8tfmGIWrMOWk5JdQL1vQJjHXyp5DetpW1le7jicv2qbPsY2ox9Wd7w7u3
	 272IDP4GI73IqbCjZrFrRUgiu0+06zRhqZW6Tk2KUkHklZCHp6tCga0hStTNnNInRUStl
	 +OHchsRXye/adsT4z/tcMwisUdxcwDxEuwPiud1ItMdQ5+1qPV1/eEdf6dT1t/sM4cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FzU+BQ3ae1C6brBZzin1CuYUEANEmnjlXsy4zYdp2So=;
	b=q7s4GRyGmvuBU14W+Eqv0bIWhOSXEjU8e2Q04QlW+EwG2s3r+BGIHXSvUewHHZcao1p0
	 bgZhWkLmcnVIR4up5+Ro5/ahehub/RJOIGQDCanTJ31RPWnZ0MD6W5Y5oslJlmApGcdb+
	 4vIlKHrFvsxVL+ba5PtYPQbbLLY6rJe9c4A6oIw787OAgSaSs3lR/U5V7zBXnE28IkLDS
	 pOfx0OoK2CErn65buaY+pwJdd9t4GIMy/S/q1mlSKClq2j4zDc1+EfmMqo4pNNuk2ljBo
	 mTtiXUPbrNrmbnJVawpfsv96xLC9/UoA4TjpY1OeQBiMKClS9FY6RTeEJ3UdZNVvzfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TkRyGCda;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE92606A32C;
	Sat,  7 Nov 2026 14:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TkRyGCda
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F831F008A1;
	Sat,  7 Nov 2026 14:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060625;
	bh=FzU+BQ3ae1C6brBZzin1CuYUEANEmnjlXsy4zYdp2So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TkRyGCdaYY7eSGWagCO16gNscwD209ofTfkjoAQld36Vv9/C0C6LcNzGqeTPds9Y3
	 qMYlorVt5FQ5DGtVmgOrZY4oy7RufFbg3H6+ScBN/M8vwbMv8UVOc82wSv6lUcGf3D
	 4DeMGlWZc0g2kcePz2NAzUJKyt01ySDpw5yU/88c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0071/1536] soundwire: dmi-quirks: Disable ghost Realtek on Asus Expertbook
Date: Sat,  7 Nov 2026 08:34:47 -0500
Message-ID: <20261107134959.665240698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



