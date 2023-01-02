Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604F028EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC033C433EF;
	Mon,  2 Jan 2023 11:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658719;
	bh=3QDNcA21QCnR1DC4bGdk3/adqpLYR6KL7E3lGorFlRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfz7/TZQ2N2V1hD00EA4ul2lDnGMNGmCwLLnORQPXGucSzmcrOSbjmPAyeWFaX8kU
	 VpYUK1HV6oIWr34PdZx947h7zyvHyrhDFH/WAhkFP/xCi/yl5fFbrrNWFtLbu7ZM5S
	 iFn87VlOAScJSZnAB2JV3Li9lmTed/JJfsSgmRFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 09/71] ACPI: resource: Add Asus ExpertBook B2502 to Asus quirks
Date: Mon,  2 Jan 2023 12:21:34 +0100
Message-Id: <20230102110551.866404538@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
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

[ Upstream commit 7203481fd12b1257938519efb2460ea02b9236ee ]

The Asus ExpertBook B2502 has the same keyboard issue as Asus Vivobook
K3402ZA/K3502ZA. The kernel overrides IRQ 1 to Edge_High when it
should be Active_Low.

This patch adds the ExpertBook B2502 model to the existing
quirk list of Asus laptops with this issue.

Fixes: b5f9223a105d ("ACPI: resource: Skip IRQ override on Asus Vivobook S5602ZA")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2142574
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index d0c92422e206..16dcd31d124f 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -432,6 +432,13 @@ static const struct dmi_system_id asus_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "S5602ZA"),
 		},
 	},
+	{
+		.ident = "Asus ExpertBook B2502",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "B2502CBA"),
+		},
+	},
 	{ }
 };
 
-- 
2.35.1



