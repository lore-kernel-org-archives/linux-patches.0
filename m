Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE7813A26F;
	Tue, 27 Feb 2024 14:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042981; cv=none; b=psbEB/74n2YzGJPlfxtL1JNxzR+lzVLvx97IQlV4XFJJ75MUpu2yQtk949bxHR5bDGTAkhK9Z8k1t3/Cv0RxfradQ79VWBYCtyAs5UIztcl1wBRF0Ts1V8in2oYzZ2GSE2IVP4yTeGIhu+2ASe8RUMO7R6IqgcO7FCMnMm8TdDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042981; c=relaxed/simple;
	bh=ceL+e+2VY1tIlXk6NhMwPp2B2IBQ7aRUVvrCseTMHfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ma5ZsVEwrWJkLFqjpr6KdokkFhXuoJhjfn2RHLFmgsMAacws4MtvDUsIgNPJlfzpgmjUwnUVn1sdXfQXMz+zfvGzEg6ATDLHDlj6oeQt0nVcRlo2MVJPejzM9s8waNsZt4Ruj1WVcklgZIYqhEGrQIhGSy4f1RqGJsJlyueXX7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgsWnIDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgsWnIDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C689C433F1;
	Tue, 27 Feb 2024 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042981;
	bh=ceL+e+2VY1tIlXk6NhMwPp2B2IBQ7aRUVvrCseTMHfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgsWnIDs9M6nrJc+KdgIxT96ODoNrzxBd3zSCmGcr7tTHSEFPWAXuoJUHVEADMv9T
	 qb9mAYOcd4Q1cqU35VEjsGljVZ1y3kF+lisFjxSf8tgtWAQwlN/fU5AMbDxEZF404u
	 2jmz+STqtL3IznsvinRlKn6744RHE2VvnKuW0G3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/245] ACPI: resource: Add Asus ExpertBook B2502 to Asus quirks
Date: Tue, 27 Feb 2024 14:26:19 +0100
Message-ID: <20240227131621.400037196@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Stable-dep-of: 77c724888238 ("ACPI: resource: Skip IRQ override on Asus Expertbook B2402CBA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 5f56839ed71df..a5d2a81902038 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -435,6 +435,13 @@ static const struct dmi_system_id asus_laptop[] = {
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
2.43.0



