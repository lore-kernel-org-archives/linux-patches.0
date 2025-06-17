Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245BA2FA622;
	Tue, 17 Jun 2025 16:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179090; cv=none; b=KUiwc3qCz9WSLR+cLtugPUgRjieENWDhnzSrv3zFpIY2wsZTIcphp6ubN8CshK4bQf7AZtbz+dWGA3EymbT/y2F+b4kyLn/9RVJNv25XvV/KcURhXSIoLdSdOP9Cy1FevG7ZnZsc75juJRCV0Oej2SutzYacsJH8yGSv1bnw+5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179090; c=relaxed/simple;
	bh=G+KGIqxpYEdDjr0NpVyy+IERpHQHHX0vj0p5E3x6+TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i2VohlUe+nJ9UZCCSV9OYGozKqdkq8cf8h/7qYZKfI1kRrhYlafDN+GQxrv0k5N/etWxRTcH2bthlVVsCnR70xWfW5fNIpASAn4EOrEzdi0NCLctc4AMJtC1/H2BxkQszF+F0DU1N4vj8lvugUWo/IzSDPCk6X2YSIkWUtQ5fEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ME4ziLrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ME4ziLrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F8EC4CEE3;
	Tue, 17 Jun 2025 16:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179089;
	bh=G+KGIqxpYEdDjr0NpVyy+IERpHQHHX0vj0p5E3x6+TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ME4ziLrVGs0MhIwOosar6htkNSo22e7wklTTwdRz2XmoecAwO/mkPIUaKOVKLdke6
	 Ift/AP40F7j8xDjbW1sbiR+dlv9ACkjrpakwzxzwEhKew6imL/xvNnk/nF99uQhkp8
	 feDTik0yYXw5M50ud81aDvvnGUIkbqPRZylvCL7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Liam Girdwood <liam.r.girdwood@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 637/780] ALSA: hda: Allow to fetch hlink by ID
Date: Tue, 17 Jun 2025 17:25:45 +0200
Message-ID: <20250617152517.416436446@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 318c9eef63dd30b59dc8d63c7205ae997aa1e524 ]

Starting with LNL platform, Intel HDAudio Links carry IDs specifying
non-HDAudio transfer type they help facilitate e.g.: 0xC0 for I2S as
defined by AZX_REG_ML_LEPTR_ID_INTEL_SSP.

The mechanism accounts for LEPTR register as it is Reserved if
LCAP.ALT for given Link equals 0.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Acked-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Link: https://patch.msgid.link/20250407112352.3720779-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 347c8d6db7c9 ("ASoC: Intel: avs: Fix PPLCxFMT calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hdaudio_ext.h         |  5 +++++
 sound/hda/ext/hdac_ext_controller.c | 18 ++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/sound/hdaudio_ext.h b/include/sound/hdaudio_ext.h
index 4c7a40e149a59..60ec12e3b72f8 100644
--- a/include/sound/hdaudio_ext.h
+++ b/include/sound/hdaudio_ext.h
@@ -22,6 +22,7 @@ void snd_hdac_ext_bus_ppcap_enable(struct hdac_bus *chip, bool enable);
 void snd_hdac_ext_bus_ppcap_int_enable(struct hdac_bus *chip, bool enable);
 
 int snd_hdac_ext_bus_get_ml_capabilities(struct hdac_bus *bus);
+struct hdac_ext_link *snd_hdac_ext_bus_get_hlink_by_id(struct hdac_bus *bus, u32 id);
 struct hdac_ext_link *snd_hdac_ext_bus_get_hlink_by_addr(struct hdac_bus *bus, int addr);
 struct hdac_ext_link *snd_hdac_ext_bus_get_hlink_by_name(struct hdac_bus *bus,
 							 const char *codec_name);
@@ -97,12 +98,16 @@ struct hdac_ext_link {
 	void __iomem *ml_addr; /* link output stream reg pointer */
 	u32 lcaps;   /* link capablities */
 	u16 lsdiid;  /* link sdi identifier */
+	u32 id;
 
 	int ref_count;
 
 	struct list_head list;
 };
 
+#define hdac_ext_link_alt(link)		((link)->lcaps & AZX_ML_HDA_LCAP_ALT)
+#define hdac_ext_link_ofls(link)	((link)->lcaps & AZX_ML_HDA_LCAP_OFLS)
+
 int snd_hdac_ext_bus_link_power_up(struct hdac_ext_link *hlink);
 int snd_hdac_ext_bus_link_power_down(struct hdac_ext_link *hlink);
 int snd_hdac_ext_bus_link_power_up_all(struct hdac_bus *bus);
diff --git a/sound/hda/ext/hdac_ext_controller.c b/sound/hda/ext/hdac_ext_controller.c
index 6199bb60ccf00..2ec1531d1c1b5 100644
--- a/sound/hda/ext/hdac_ext_controller.c
+++ b/sound/hda/ext/hdac_ext_controller.c
@@ -9,6 +9,7 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <sound/hda_register.h>
@@ -81,6 +82,7 @@ int snd_hdac_ext_bus_get_ml_capabilities(struct hdac_bus *bus)
 	int idx;
 	u32 link_count;
 	struct hdac_ext_link *hlink;
+	u32 leptr;
 
 	link_count = readl(bus->mlcap + AZX_REG_ML_MLCD) + 1;
 
@@ -97,6 +99,11 @@ int snd_hdac_ext_bus_get_ml_capabilities(struct hdac_bus *bus)
 		hlink->lcaps  = readl(hlink->ml_addr + AZX_REG_ML_LCAP);
 		hlink->lsdiid = readw(hlink->ml_addr + AZX_REG_ML_LSDIID);
 
+		if (hdac_ext_link_alt(hlink)) {
+			leptr = readl(hlink->ml_addr + AZX_REG_ML_LEPTR);
+			hlink->id = FIELD_GET(AZX_REG_ML_LEPTR_ID, leptr);
+		}
+
 		/* since link in On, update the ref */
 		hlink->ref_count = 1;
 
@@ -125,6 +132,17 @@ void snd_hdac_ext_link_free_all(struct hdac_bus *bus)
 }
 EXPORT_SYMBOL_GPL(snd_hdac_ext_link_free_all);
 
+struct hdac_ext_link *snd_hdac_ext_bus_get_hlink_by_id(struct hdac_bus *bus, u32 id)
+{
+	struct hdac_ext_link *hlink;
+
+	list_for_each_entry(hlink, &bus->hlink_list, list)
+		if (hdac_ext_link_alt(hlink) && hlink->id == id)
+			return hlink;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(snd_hdac_ext_bus_get_hlink_by_id);
+
 /**
  * snd_hdac_ext_bus_get_hlink_by_addr - get hlink at specified address
  * @bus: hlink's parent bus device
-- 
2.39.5



