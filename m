Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FC5168C1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C433C4339B;
	Mon,  8 May 2023 10:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541125;
	bh=5vqbd4Txx8kCdaB9dLAkT+Z+RBu68zGJQwt8bbN78+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHv4tCxJF3QJxjgoIWmRa+LD0RuPR0Q9BGG9CqRxBwUIAWdo8Pd2328z8v+XMiAJM
	 9cq7yNQaI2muXYUdlLIQDBpHh0QrFAb9Jo8bkIj++jFPBE4nxOY+7Obgq1vhQqculU
	 L/QUflCwwBz+KlnOZNsWKkVJ21IVcYWAE4U4vnR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Asbach <asbachb.kernel@impl.it>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 014/663] platform/x86: thinkpad_acpi: Add missing T14s Gen1 type to s2idle quirk list
Date: Mon,  8 May 2023 11:37:20 +0200
Message-Id: <20230508094428.890855916@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Asbach <asbachb.kernel@impl.it>

[ Upstream commit 9a469c6dfab38326f99f105386db84230be09ee3 ]

>From the commit message adding the first s2idle quirks:

> Lenovo laptops that contain NVME SSDs across a variety of generations have
> trouble resuming from suspend to idle when the IOMMU translation layer is
> active for the NVME storage device.
>
> This generally manifests as a large resume delay or page faults. These
> delays and page faults occur as a result of a Lenovo BIOS specific SMI
> that runs during the D3->D0 transition on NVME devices.

Add the DMI ids for another variant of the T14s Gen1, which also needs
the s2idle quirk.

Link: https://lore.kernel.org/all/20220503183420.348-1-mario.limonciello@amd.com/
Link: https://bbs.archlinux.org/viewtopic.php?pid=2084655#p2084655
Signed-off-by: Benjamin Asbach <asbachb.kernel@impl.it>
Tested-by: Benjamin Asbach <asbachb.kernel@impl.it>
Link: https://lore.kernel.org/r/20230331232447.37204-1-asbachb.kernel@impl.it
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 32c10457399e4..7191ff2625b1e 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -4478,6 +4478,14 @@ static const struct dmi_system_id fwbug_list[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "20UH"),
 		}
 	},
+	{
+		.ident = "T14s Gen1 AMD",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "20UJ"),
+		}
+	},
 	{
 		.ident = "P14s Gen1 AMD",
 		.driver_data = &quirk_s2idle_bug,
-- 
2.39.2



