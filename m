Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FBB15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81ED7C433D6;
	Mon,  5 Dec 2022 19:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267741;
	bh=uLK2qBqWH04pfEpnLVKNF8keNq7GOfn5celNQqw6U94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmdkglUSTFoKV0b4G4FHA14Fed3Z/DtEn8nmbnD+LAM9x4/qhCTaZJ9VZqkvcgoFw
	 JxpcCuQaaOuvV4/cbQ9fQ+fCsQj9V8RERFtXCXBejgOp/xHq/CmWPk3kfkf7eCZsOO
	 QdWiPOGI6tPMgrX1boNrDJes422ds3teX1FJxftI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rudolf Polzer <rpolzer@google.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 34/77] platform/x86: acer-wmi: Enable SW_TABLET_MODE on Switch V 10 (SW5-017)
Date: Mon,  5 Dec 2022 20:09:25 +0100
Message-Id: <20221205190802.081199579@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1e817b889c7d8c14e7005258e15fec62edafe03c ]

Like the Acer Switch 10 (SW5-012) and Acer Switch 10 (S1003) models
the Acer Switch V 10 (SW5-017) supports reporting SW_TABLET_MODE
through acer-wmi.

Add a DMI quirk for the SW5-017 setting force_caps to ACER_CAP_KBD_DOCK
(these devices have no other acer-wmi based functionality).

Cc: Rudolf Polzer <rpolzer@google.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221111111639.35730-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 8b4af118ff94..e2f054112fba 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -549,6 +549,15 @@ static const struct dmi_system_id acer_quirks[] __initconst = {
 		},
 		.driver_data = (void *)ACER_CAP_KBD_DOCK,
 	},
+	{
+		.callback = set_force_caps,
+		.ident = "Acer Aspire Switch V 10 SW5-017",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "SW5-017"),
+		},
+		.driver_data = (void *)ACER_CAP_KBD_DOCK,
+	},
 	{
 		.callback = set_force_caps,
 		.ident = "Acer One 10 (S1003)",
-- 
2.35.1



