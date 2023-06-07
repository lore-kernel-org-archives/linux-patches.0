Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B69034CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 21:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C85C433D2;
	Wed,  7 Jun 2023 21:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171647;
	bh=x9I+mP7q2Y5v2IAomGu1k9FrDjK3hjenaJlu4HSWBPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JymAT1IX+P1BgWf42e04mRd3crGtnziIh2M11nsX7DKxkaT3u2jW8NJuqTOdpPbPy
	 vLXF5kCo2Xa90HLNS+1vW0VjcDvlr4qyozWTPiDK+kbwTqQnRhF5LuckKU4aCi6q4l
	 G256tQykIk1zGahPPgVGaoRRFB7+hMDZ0vPZzegk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rub=C3=A9n=20G=C3=B3mez=20Agudo?= <mrgommer@proton.me>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/159] ACPI: resource: Add IRQ override quirk for LG UltraPC 17U70P
Date: Wed,  7 Jun 2023 22:16:23 +0200
Message-ID: <20230607200906.295285335@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rubén Gómez <mrgommer@proton.me>

[ Upstream commit 71a485624c4cbb144169852d7bb8ca8c0667d7a3 ]

Add an ACPI IRQ override quirk for LG UltraPC 17U70P to address the
internal keyboard problem on it.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=213031
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216983
Signed-off-by: Rubén Gómez Agudo <mrgommer@proton.me>
[ rjw: Subject, changelog, white space damage fixes ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 803dc6afa6d69..b0c7ae50a8d79 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -470,6 +470,17 @@ static const struct dmi_system_id maingear_laptop[] = {
 	{ }
 };
 
+static const struct dmi_system_id lg_laptop[] = {
+	{
+		.ident = "LG Electronics 17U70P",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LG Electronics"),
+			DMI_MATCH(DMI_BOARD_NAME, "17U70P"),
+		},
+	},
+	{ }
+};
+
 struct irq_override_cmp {
 	const struct dmi_system_id *system;
 	unsigned char irq;
@@ -486,6 +497,7 @@ static const struct irq_override_cmp override_table[] = {
 	{ lenovo_laptop, 10, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
 	{ tongfang_gm_rg, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
 	{ maingear_laptop, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
+	{ lg_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
 };
 
 static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
-- 
2.39.2



