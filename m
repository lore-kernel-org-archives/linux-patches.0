Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460E61DDCE;
	Tue, 16 Jul 2024 16:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146145; cv=none; b=p/R4iCWXeoS8KaqGNOOJMGovQ8TRNnVFV0iHFx4dauWusT+KcJ8tu5W9zfyL1VoetXz/XdRnBz1w2fHuY1t7FsjgKQj3j28I864uXovhyn6tvBfeCaedBZhsKCyhxyL86FG37nh3uLncYAraipXQA7wfjDuCRVm6PrHBziupQCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146145; c=relaxed/simple;
	bh=gb+MIVOjxI2kcDceQ8Hy+zZlaWq3ZFUfiwwggkDm5WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzGGo7oJbmf30/hcasrCw4BBrlfDZC3w/bgUrnvnD7EobcS5jOXgo1/qoEa+zuvvq7DI5hONR5i4Zo4hSPneVKTCPL/0WATP0zfmZjxSvphMNq+WqXpZa0OXpG+jSA+M6Y4whIKexw3PrK6PP8GcxqbICrsK9zOnO+owD66BOF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQfDrbLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQfDrbLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0631C116B1;
	Tue, 16 Jul 2024 16:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146145;
	bh=gb+MIVOjxI2kcDceQ8Hy+zZlaWq3ZFUfiwwggkDm5WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQfDrbLRwW87PsDeOMEhnloIJiJKOi2eVJlUwBnfMCrLCUqaFMve6//QaTxmFR8qh
	 iegD8IEL3SZvUfYv4RSKMT5IKQU0x9VeTNm666UHbc1rda1tQtTT8ZXZ3FTqz4QC4p
	 coiKGZOnj2MosrKP5GWNfLaiYt8Gs+8W8DVzqn4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hmtheboy154 <buingoc67@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/144] platform/x86: touchscreen_dmi: Add info for GlobalSpace SolT IVW 11.6" tablet
Date: Tue, 16 Jul 2024 17:32:21 +0200
Message-ID: <20240716152755.314259299@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

From: hmtheboy154 <buingoc67@gmail.com>

[ Upstream commit 7c8639aa41343fd7b3dbe09baf6b0791fcc407a1 ]

This is a tablet created by GlobalSpace Technologies Limited
which uses an Intel Atom x5-Z8300, 4GB of RAM & 64GB of storage.

Link: https://web.archive.org/web/20171102141952/http://globalspace.in/11.6-device.html
Signed-off-by: hmtheboy154 <buingoc67@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240527091447.248849-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 161bd19441042..c6605e0e4760e 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -874,6 +874,22 @@ static const struct ts_dmi_data schneider_sct101ctm_data = {
 	.properties	= schneider_sct101ctm_props,
 };
 
+static const struct property_entry globalspace_solt_ivw116_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 7),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 22),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1723),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1077),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-globalspace-solt-ivw116.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	PROPERTY_ENTRY_BOOL("silead,home-button"),
+	{ }
+};
+
+static const struct ts_dmi_data globalspace_solt_ivw116_data = {
+	.acpi_name	= "MSSL1680:00",
+	.properties	= globalspace_solt_ivw116_props,
+};
+
 static const struct property_entry techbite_arc_11_6_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-min-x", 5),
 	PROPERTY_ENTRY_U32("touchscreen-min-y", 7),
@@ -1569,6 +1585,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "SCT101CTM"),
 		},
 	},
+	{
+		/* GlobalSpace SoLT IVW 11.6" */
+		.driver_data = (void *)&globalspace_solt_ivw116_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Globalspace Tech Pvt Ltd"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SolTIVW"),
+			DMI_MATCH(DMI_PRODUCT_SKU, "PN20170413488"),
+		},
+	},
 	{
 		/* Techbite Arc 11.6 */
 		.driver_data = (void *)&techbite_arc_11_6_data,
-- 
2.43.0



