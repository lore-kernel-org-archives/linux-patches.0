Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF0A6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DB3C433D2;
	Tue, 10 Jan 2023 18:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374968;
	bh=o6g9l9ORX07x3MLjJfjiyDud8sF9OMV8+J2VkIaZV1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXR9AqROXkRz8CgpdZ+HQQ9JxyqvMJR80aVSdGMDtnIY3i1ZUaInQFD7lsSBBhUch
	 z8OXye7/JYkK6apPg/1LRsIHsjF/zBZqqyQLtNfhJcsoJP5JeuX8OCQDWwc0EpSkC6
	 Y63P+nF0p36Z4VY63sZ2xbK6XzxgcojfR2YPil18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Schumacher <ofenfisch@googlemail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/290] ACPI: resource: do IRQ override on XMG Core 15
Date: Tue, 10 Jan 2023 19:01:41 +0100
Message-Id: <20230110180031.944877491@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Erik Schumacher <ofenfisch@googlemail.com>

[ Upstream commit 7592b79ba4a91350b38469e05238308bcfe1019b ]

The Schenker XMG CORE 15 (M22) is Ryzen-6 based and needs IRQ overriding
for the keyboard to work. Adding an entry for this laptop to the
override_table makes the internal keyboard functional again.

Signed-off-by: Erik Schumacher <ofenfisch@googlemail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: f3cb9b740869 ("ACPI: resource: do IRQ override on Lenovo 14ALC7")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 5154c9861ece..d0bed7e66a33 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -428,6 +428,17 @@ static const struct dmi_system_id lenovo_82ra[] = {
 	{ }
 };
 
+static const struct dmi_system_id schenker_gm_rg[] = {
+	{
+		.ident = "XMG CORE 15 (M22)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
+			DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
+		},
+	},
+	{ }
+};
+
 struct irq_override_cmp {
 	const struct dmi_system_id *system;
 	unsigned char irq;
@@ -442,6 +453,7 @@ static const struct irq_override_cmp override_table[] = {
 	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
 	{ lenovo_82ra, 6, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
 	{ lenovo_82ra, 10, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
+	{ schenker_gm_rg, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
 };
 
 static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
-- 
2.35.1



