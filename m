Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060904;
	b=eRtCNH7wuG9JKo0QaL2TxnmDOJO3XPz8G8VYUrQtF2leBbBp0jbpz6bThfjTzc9xuJ/X
	 Xat7kEZbJlkE24+LmpQNc+dZDvQeUgpNynXp9jXkD1tLjVzLnFowTcPG6p10bnERMBIyH
	 TIztj9pJo6J+9RlJ3D2uVu5+kMEymO+m2YfbHWkCTV5N7fL5nZ5lAfC4RatTxdFa4Zf+I
	 yCHBBNp+YxMJNT+dvkea2cLDy6N1fJrft0W7WeAA/VYhftaKoYWpuCrgbogwn4m1XY1Cr
	 8ORhdCoLjBnqxLlnsyzA9V2YS4ADurX8+FGAMO1iIHN2V43fxudw6mTOpG1X7JWD0sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bltoo7kJ6SoNb9/UgBqEuf/dCjbUqiEi1yRfnP1s/hM=;
	b=XTZnKvWF5l51WRhvo45D+U601BKYUU6IRhPNSg8UQ75tANVUuhbMjppBycAOITV0YVRZ
	 KkXt0M/QqihAgU1odiAKOimmjCfjcn8fxyAgJHC6CrkYUXdwVvvlgDGSNLSncP9xbQoQe
	 LIkf4uA5x6ZmmvO8G6BOFnI5wmgFcJGKJGNxaYfDu1U3553lNDrqVw+m9hjCzt/ZbFSC6
	 IyGLVCRaO4gtaxhjhhCeMOZ7lE+bBRR+k8bTDjgFUiMQEwcagaDIdnck3qFE8DIaOHO3C
	 hVP/s+125OfVh2+CsckStNjhNqYKrnkoy/aFsN70DkmwJtN5WLWizbIIGb5eMmI4hmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecwEpnH8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1966606D806;
	Sat,  7 Nov 2026 14:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecwEpnH8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9CB1F0089F;
	Sat,  7 Nov 2026 14:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060903;
	bh=bltoo7kJ6SoNb9/UgBqEuf/dCjbUqiEi1yRfnP1s/hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecwEpnH8EW/rI/ki+3NsSX21mly3CcqHhn+ERwYZMGlqMtoODOXXZd/ZTRpwFsTOX
	 zTI48oOmH8kiWl+S5xP35qM64S+ddOFfhvyHsCAUrNE3S4mOcmArku1GfSBOeRl37v
	 3zYpC5FNs3W23JjRNvSWr3g/OmxmStFKj8FYPKqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0276/1536] soundwire: dmi-quirks: Disable ghost Realtek on Asus Zenbook Duo
Date: Sat,  7 Nov 2026 08:38:12 -0500
Message-ID: <20261107135005.422471585@linuxfoundation.org>
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



