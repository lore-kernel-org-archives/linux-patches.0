Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465D01946C8;
	Fri,  9 Jan 2026 12:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960297; cv=none; b=MHVchTO7Jw+UuypFTh1BYT4EavP4RcBNyajHbJujWyb/Lssevcaz3d/09flrwP5AIEkumncBFOE6Zpel46CCDbeB9cQjs646KnPe9HpOldQb8jasQLw6BwQK+/+07uzpjb5VoibY/c0W5FxZjqrhJsW8SiCYw9ZZ1c5Bq0rj83s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960297; c=relaxed/simple;
	bh=HPapXgEVqBz9ECeWhMAuhkZxuH/DL6BdfIljiiAoCmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmeeQt+Ci+mlWiBZoLQnbUavID4rL6E2tpkbHwtb++Tq5LLoaI3YI6oD4KR368gYseFyOXkrHLARkV4+91H6rtL34KIdCfmQ6eI9B2VzrGpyThP1+bBOmWMoLS4J7BH6brnZDygjw7eUhzRpxstC94E/ZLe5Vkvhbb01794AoK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEJoxux6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEJoxux6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7CAC4CEF1;
	Fri,  9 Jan 2026 12:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960297;
	bh=HPapXgEVqBz9ECeWhMAuhkZxuH/DL6BdfIljiiAoCmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEJoxux6NxSLi3oZI+f5j0IZgBsWK5lIteWxtl7atOpr/+MqCWZPrzsSKkT+YIm70
	 +8bXb+D0FSPNV2nX7hZuzKZP2j1v2caUb378tzRfVAZDylBS02UNebpeel6vfoJUah
	 o70pJe6in/n5feAlQe6Yn5UsfRmm/I6iUvpfx+ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Hans de Goede <hansg@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 322/737] wifi: brcmfmac: Add DMI nvram filename quirk for Acer A1 840 tablet
Date: Fri,  9 Jan 2026 12:37:41 +0100
Message-ID: <20260109112146.111877269@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit a8e5a110c0c38e08e5dd66356cd1156e91cf88e1 ]

The Acer A1 840 tablet contains quite generic names in the sys_vendor and
product_name DMI strings, without this patch brcmfmac will try to load:
brcmfmac43340-sdio.Insyde-BayTrail.txt as nvram file which is a bit
too generic.

Add a DMI quirk so that a unique and clearly identifiable nvram file name
is used on the Acer A1 840 tablet.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://patch.msgid.link/20251103100314.353826-1-hansg@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
index c3a602197662b..abe7f6501e5ed 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
@@ -24,6 +24,10 @@ static const struct brcmf_dmi_data acepc_t8_data = {
 	BRCM_CC_4345_CHIP_ID, 6, "acepc-t8"
 };
 
+static const struct brcmf_dmi_data acer_a1_840_data = {
+	BRCM_CC_43340_CHIP_ID, 2, "acer-a1-840"
+};
+
 /* The Chuwi Hi8 Pro uses the same Ampak AP6212 module as the Chuwi Vi8 Plus
  * and the nvram for the Vi8 Plus is already in linux-firmware, so use that.
  */
@@ -91,6 +95,16 @@ static const struct dmi_system_id dmi_platform_data[] = {
 		},
 		.driver_data = (void *)&acepc_t8_data,
 	},
+	{
+		/* Acer Iconia One 8 A1-840 (non FHD version) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "BayTrail"),
+			/* Above strings are too generic also match BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "04/01/2014"),
+		},
+		.driver_data = (void *)&acer_a1_840_data,
+	},
 	{
 		/* Chuwi Hi8 Pro with D2D3_Hi8Pro.233 BIOS */
 		.matches = {
-- 
2.51.0



