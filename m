Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03491C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3097DC433EF;
	Wed, 28 Dec 2022 16:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245937;
	bh=SlFOvmMdVICDIUhdLCEFcFnIe5h4iszNQXPFJAN9MsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulUF3a0OLvV1bGL0bDo1tWAoGEiBmUOeHr8CI/kVPRcw6DJrOp1E/6Zh03diiSbse
	 /FP9fgnymEsh/s+b8ZpfrvOLb/YXuncn/ILGfqozBnabZ+hUYZ5UNJR7mULZfuakhr
	 LuG7/LSyvZy78SPN/T5G8xoq5JglCXU72m6IJW1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mia Kanashi <chad@redpilled.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0950/1146] ACPI: EC: Add quirk for the HP Pavilion Gaming 15-cx0041ur
Date: Wed, 28 Dec 2022 15:41:29 +0100
Message-Id: <20221228144356.122717490@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mia Kanashi <chad@redpilled.dev>

[ Upstream commit b423f240a66ad928c4cb5ec6055dfc90ce8d894e ]

Added GPE quirk entry for the HP Pavilion Gaming 15-cx0041ur.
There is a quirk entry for the 15-cx0xxx laptops, but this one has
different DMI_PRODUCT_NAME.

Notably backlight keys and other ACPI events now function correctly.

Signed-off-by: Mia Kanashi <chad@redpilled.dev>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 9b42628cf21b..9751b84c1b22 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1875,6 +1875,16 @@ static const struct dmi_system_id ec_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Gaming Laptop 15-cx0xxx"),
 		},
 	},
+	{
+		/*
+		 * HP Pavilion Gaming Laptop 15-cx0041ur
+		 */
+		.callback = ec_honor_dsdt_gpe,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP 15-cx0041ur"),
+		},
+	},
 	{
 		/*
 		 * Samsung hardware
-- 
2.35.1



