Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029240;
	b=pCYFsqSVumHQYkwtgar+DijS8X2SIB43Zw2CSc7iu6XAGAub7+V1c9tCdswRcoa3cpeJ
	 wM+C+njXq6VycF5ZJUWz5Y5PVkjZgdIc9Dl3ZBiLgOI56TNeulxj6WyEMZq3zAfcMEHBH
	 1I9iouuddV/4LeHD4SulM4hi06EpuvsK9HnlprPFDtyp5O2zyu9TACws/vCZfOEniZxE9
	 wcB4yncrjrWIaZkVYn6siihrtZja0A+5YZE9CBeJVeSh5q2NbyQp2UXPRQVS6rslAitXx
	 lFA9PBy92sEVWlw7NqEbn2UtgHT7vDm9ngIWae3T3KIG8r6NcHENacUnS6nlvA0txUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4kJ6K4JDNhN0l8pQKhKuY+DdoYyf5z92xgedRrtGqIk=;
	b=4ScpWkGmuvJpLAofgOVsYJsHjJNTD8QurRH/cX3OmQBT0RTHFSthCnbvp2mxIv7cHVhD
	 nQwg3Bq0p8ZI8dRSAM1tXyG3jBT+ebUv0brJsO3pZpgk4nzpKY+yCMBE2ETj9vMBSj/7i
	 GJMJKcewI+ctex2jzPS5nXOcw/19S7rhj981CG2yd0glp/T+MFwaKj8vcGu/aOziRKKO2
	 sE1XOoFhV3zu9K7kNPrpxKMFWTMXgUWRaH+XA57zCtFnqb6kVZ45wIVNZT49BVZvWWGa+
	 Ml0OH5yjyggDSoMznr2DCfhMUgBF6Roq/QLJCenFXVbvG3ExlIPrXg3IgnXqlnPC42Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gsAjVtH3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA41F606A31C;
	Wed, 18 Nov 2026 19:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gsAjVtH3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369AD1F000C4;
	Wed, 18 Nov 2026 19:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029240;
	bh=4kJ6K4JDNhN0l8pQKhKuY+DdoYyf5z92xgedRrtGqIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gsAjVtH3NdiDb1AhOwf6eKzaQNRNVW9SIthZi3XPHT6PHmFaOgsee/uvH+3j7oBtS
	 6mDISQsp1V4e0m2GPgVz4mxGf6xrr2Ypmbjvo9P/pRcLKbIDIXeW20SFkeQNKPnNE7
	 QI8yv6oXTUXMYRBAaiE38YHtfxayJvg8Pc/k4m9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Gallagher <cdine@cdine.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0281/1756] ACPI: button: Add lid_init_state quirk for Razer Blade Stealth 13 (Early 2020) RZ09-0310
Date: Wed, 18 Nov 2026 15:40:08 +0100
Message-ID: <20261118150019.604294129@linuxfoundation.org>
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

From: Ian Gallagher <cdine@cdine.org>

[ Upstream commit f16c512a07b954aa3b0b3c580e7abb5dd4f5e703 ]

This patch adds a quirk mapping for the "Blade Stealth 13 (Early 2020) -
RZ09-0310" laptop, which exhibits the same issue as the following two
related products already accounted for in this file.

 - Razer Blade Stealth 13 Late 2019
 - Blade Pro 17 (Early 2020) - RZ09-0329

Summary of the issue this fixes:
The firmware's _LID method still returns "closed" after resume when the
lid was opened during S3, causing systemd-logind to suspend the system
again within several seconds (15-40) after waking.

Signed-off-by: Ian Gallagher <cdine@cdine.org>

Link: https://patch.msgid.link/90ab9b58-da8b-4ffc-bd4b-adf7590545a9@app.fastmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 4f5b51f8114ca..94c6df4de7ff6 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -141,6 +141,18 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
 		},
 		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
 	},
+	{
+		/*
+		 * Razer Blade Stealth 13 early 2020, when the lid is opened
+		 * while suspended the open notification is lost and _LID keeps
+		 * returning closed after resume, causing spurious re-suspends.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Razer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Blade Stealth 13 (Early 2020) - RZ09-0310"),
+		},
+		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
+	},
 	{
 		/*
 		 * Samsung galaxybook2 ,initial _LID device notification returns
-- 
2.53.0



