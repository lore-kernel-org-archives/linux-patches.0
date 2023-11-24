Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617F339FC3;
	Fri, 24 Nov 2023 18:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRy9l9Oo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F5CC433C7;
	Fri, 24 Nov 2023 18:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850412;
	bh=+lZ1xhwHtyhNTHIkzhFAaOjBlVnVEKIxx+YiUS0OS8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRy9l9OofLuS8v5oGS68lJZkJ1xA0z0AgtTxYczoIBwaatsdwnxNofIO5OSrN9Ry9
	 OtwYebsRHppzVkJ7CJISzTcp3+0Tk+dQZA5bPky6K445gAlR3cfDxOZOx0ysJ5endG
	 kbZ/kkg1KCmsE3Uwxore0lfSu14XDecHt4O/cAP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Denose <jdenose@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 039/491] ACPI: EC: Add quirk for HP 250 G7 Notebook PC
Date: Fri, 24 Nov 2023 17:44:35 +0000
Message-ID: <20231124172025.864122477@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Denose <jdenose@chromium.org>

[ Upstream commit 891ddc03e2f4395e24795596e032f57d5ab37fe7 ]

Add GPE quirk entry for HP 250 G7 Notebook PC.

This change allows the lid switch to be identified as the lid switch
and not a keyboard button. With the lid switch properly identified, the
device triggers suspend correctly on lid close.

Signed-off-by: Jonathan Denose <jdenose@google.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index c95d0edb0be9e..a59c11df73754 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1924,6 +1924,16 @@ static const struct dmi_system_id ec_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Gaming Laptop 15-dk1xxx"),
 		},
 	},
+	{
+		/*
+		 * HP 250 G7 Notebook PC
+		 */
+		.callback = ec_honor_dsdt_gpe,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP 250 G7 Notebook PC"),
+		},
+	},
 	{
 		/*
 		 * Samsung hardware
-- 
2.42.0



