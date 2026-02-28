Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5564733F8A1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300936; cv=none; b=b0cDtUHMVoQcyakTz4lQ3yAemtwT5ysSX+cuDXE8bO/jwCPnVLHf4k+pQeRO4zMosGU1Vq52Dlrr9JxchFrgwRfPrUoFfHmi6oPLgUSOddOq7lk8wyfDpZO1dCN7ZB8ihjcsAi9KZvJ9XjRsoO8g+jDM0eEVutk/vdvF8XPGMUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300936; c=relaxed/simple;
	bh=HawuXlsx55D4Kfk39pDirEMY1A8otxhSLro4Pg4y1uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjjKMUhu6NGTrTdc7U53t/Cyges/OVS408Yt5u/n3gcSsneDogsIeBvyNBm9PPr4tTguaKDuwgHPiib5pKc+6rFULRA3P8uEExZquBeVPwMyHHFimpb/Oqk+fM+iR6nDlycmc7kkNUS6toIF/GwH+J5kC9Pb8NcQiN2KoJUcen8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WlBgoqN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WlBgoqN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB333C19423;
	Sat, 28 Feb 2026 17:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300936;
	bh=HawuXlsx55D4Kfk39pDirEMY1A8otxhSLro4Pg4y1uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlBgoqN+DjqyMWyeoXshA0klIQ+arjKrL9VzWWFWt9RzHRT6yK0n9qE6FB08c2oAt
	 jCK3F31oGcxotODII57K5/jbENDnpw/fx5sfM1c5pm2dCUg2/wNG2LJIXWsOdjoLS/
	 CWFnHO9a5ios59nIncICfnmhVcHw9oYTTnmnBz93SUqjBKTxUekE6hf6G8GUWrZ+uZ
	 RH/kAttkWYENGoXfSjBO7mEI/1wtZ3NToHwsQTgGDlo4TdEFObFbAPreqVrnjShoCI
	 3FKHG6Es5+l/mO1NQ34cm8kr0hXDh4HNGAPwcPB9c6UFu+EQFL6z1fc2L+H1S1raK0
	 A2u3pxjO5dqPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ai Chao <aichao@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/752] ACPI: resource: Add JWIPC JVC9100 to irq1_level_low_skip_override[]
Date: Sat, 28 Feb 2026 12:36:07 -0500
Message-ID: <20260228174750.1542406-56-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ai Chao <aichao@kylinos.cn>

[ Upstream commit ba6ded26dffe511b862a98a25955955e7154bfa8 ]

Like the JWIPC JVC9100 has its serial IRQ (10 and 11) described
as ActiveLow in the DSDT, which the kernel overrides to EdgeHigh which
breaks the serial.

irq 10, level, active-low, shared, skip-override
irq 11, level, active-low, shared, skip-override

Add the JVC9100 to the irq1_level_low_skip_override[] quirk table to fix
this.

Signed-off-by: Ai Chao <aichao@kylinos.cn>
Link: https://patch.msgid.link/20260113072719.4154485-1-aichao@kylinos.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index d16906f46484d..bc8050d8a6f51 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -532,6 +532,12 @@ static const struct dmi_system_id irq1_level_low_skip_override[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "16T90SP"),
 		},
 	},
+	{
+		/* JWIPC JVC9100 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "JVC9100"),
+		},
+	},
 	{ }
 };
 
@@ -706,6 +712,8 @@ struct irq_override_cmp {
 
 static const struct irq_override_cmp override_table[] = {
 	{ irq1_level_low_skip_override, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
+	{ irq1_level_low_skip_override, 10, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 1, false },
+	{ irq1_level_low_skip_override, 11, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 1, false },
 	{ irq1_edge_low_force_override, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
 };
 
-- 
2.51.0

