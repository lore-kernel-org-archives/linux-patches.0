Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E882E1586C1;
	Tue,  9 Jul 2024 11:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523854; cv=none; b=TOcGfDq4+QisZcj8xX/dKEX5sV3Wad80jmy2ogggRX6ZEtCNUWxiYgDX4TrHF+BZKEKRi1JY/n1CFbYlxy5EJnZYovQfeOd/ae/uS2BUnBvq3tHcFsgsnIHfl3a20JDr1VRYmodk/I7mGQdmO/GHHgBObNiIUuYYy35re3XyjhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523854; c=relaxed/simple;
	bh=en73XQC6rQU4DyOcTjaoCGj03i6vSCTpoHtix6Kd+CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThM6eh9uOxES7LQN0eXlmpjoQdDQQDTyDuaUjIlXMmeF17gic/ovDLrtYUdHZg5V7f/PNQujJlBAZGJe6vCI9nVPTtPkioX4Q3SZ5M8l66X1YvXm+rGSAXwqVMwKjWdxELDF3zvpRUqCYd3ToHht5yJ1KqQcJ62UNRWaySFnNOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHq0ezFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHq0ezFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70690C3277B;
	Tue,  9 Jul 2024 11:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523853;
	bh=en73XQC6rQU4DyOcTjaoCGj03i6vSCTpoHtix6Kd+CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHq0ezFeyuC0G31b8iMwfOOwrYqBFj0Whw9aaoCsioYP8K51lwG8hzQtv6jL8Mz25
	 KS8i5RujpMIijplMK+1biVuQzEa8SqzooK3tDkBqjt5apZ0k/FPjrS0WGSMj3eNMkk
	 e2rxV5rO2daGlLvzzCkY11L2+hpWWQszdV+sMfeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hmtheboy154 <buingoc67@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/139] platform/x86: touchscreen_dmi: Add info for GlobalSpace SolT IVW 11.6" tablet
Date: Tue,  9 Jul 2024 13:10:30 +0200
Message-ID: <20240709110703.191542814@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 630ed0515b1e9..bb1df9d03bbcd 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -902,6 +902,22 @@ static const struct ts_dmi_data schneider_sct101ctm_data = {
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
@@ -1629,6 +1645,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
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



