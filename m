Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD6019409E;
	Wed,  2 Oct 2024 14:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879171; cv=none; b=GEEwJWJNdzGrq86bh95s6Jg7cqL7vl0MnO0YnUJFVLCqYdrdz1Yy4iUSR+vggDAN4tA10dVBmojuCuv/pMyACnla4bho79px65kfiWEKwEbOOT62sNDFkTS5QsDtjFB3OR6GiU+cWRERUAT7Uq6LJZQ6M70OUnXlSsI+A09cd8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879171; c=relaxed/simple;
	bh=QU+0NjeH/BxROTWpmOoT0ZLLYFyZOO/XL/PWuAi92uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpFllvYfPHaBZzwm+/bZiGNVnIjaB4Eun4wS4TJPbsdfp+6fbHJXlCWFJbXYxSRVjTLZT1vLG8XOTewtPHIIo+cUxfPNZnTiqQDiMcWrGECj6lUCkDANMOssgJNnMj3BeT+vC6bS0lFKwsMjdwRzFY5KKWvblpNDhSrQ9OcfYs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnrzP0L4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnrzP0L4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BD0C4CEC2;
	Wed,  2 Oct 2024 14:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879171;
	bh=QU+0NjeH/BxROTWpmOoT0ZLLYFyZOO/XL/PWuAi92uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnrzP0L4aFRuDJE0zqvMzl6v4opwCAT1GALn7/VCHm7Oq5aQ4zLbKFOWKsyd4iStQ
	 A9j/AukX++OFGDZF+P3S56cJbDgn0Ef/darasq5hDehGsbfFhDZQpsFWMYjz92L70m
	 x9Z7s9WfU214a9yfbIMP1QCW/Z5TQnZlejp5/i9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/538] wifi: brcmfmac: export firmware interface functions
Date: Wed,  2 Oct 2024 14:54:05 +0200
Message-ID: <20241002125752.234629942@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Arend van Spriel <arend.vanspriel@broadcom.com>

[ Upstream commit 31343230abb1683e8afb254e6b13a7a7fd01fcac ]

With multi-vendor support the vendor-specific module may need to use
the firmware interface functions so export them using the macro
BRCMF_EXPORT_SYMBOL_GPL() which exports them to driver namespace.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240103095704.135651-2-arend.vanspriel@broadcom.com
Stable-dep-of: c6002b6c05f3 ("wifi: brcmfmac: introducing fwil query functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    |   4 +-
 .../broadcom/brcm80211/brcmfmac/core.c        |   2 +-
 .../broadcom/brcm80211/brcmfmac/feature.c     |   2 +-
 .../broadcom/brcm80211/brcmfmac/fwil.c        | 115 +---------------
 .../broadcom/brcm80211/brcmfmac/fwil.h        | 127 +++++++++++++++---
 5 files changed, 121 insertions(+), 129 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index da4968e66725b..fb91ebe5553e1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3067,7 +3067,7 @@ brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 	struct brcmf_scb_val_le scbval;
 	struct brcmf_pktcnt_le pktcnt;
 	s32 err;
-	u32 rate;
+	u32 rate = 0;
 	u32 rssi;
 
 	/* Get the current tx rate */
@@ -7269,7 +7269,7 @@ static int brcmf_setup_wiphybands(struct brcmf_cfg80211_info *cfg)
 	u32 nmode = 0;
 	u32 vhtmode = 0;
 	u32 bw_cap[2] = { WLC_BW_20MHZ_BIT, WLC_BW_20MHZ_BIT };
-	u32 rxchain;
+	u32 rxchain = 0;
 	u32 nchain;
 	int err;
 	s32 i;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index f599d5f896e89..a92f78026cfda 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -691,7 +691,7 @@ static int brcmf_net_mon_open(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
-	u32 monitor;
+	u32 monitor = 0;
 	int err;
 
 	brcmf_dbg(TRACE, "Enter\n");
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 909a34a1ab503..7fef93ede0fb3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -184,7 +184,7 @@ static void brcmf_feat_wlc_version_overrides(struct brcmf_pub *drv)
 static void brcmf_feat_iovar_int_get(struct brcmf_if *ifp,
 				     enum brcmf_feat_id id, char *name)
 {
-	u32 data;
+	u32 data = 0;
 	int err;
 
 	/* we need to know firmware error */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
index a9514d72f770b..bc1c6b5a6e316 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
@@ -142,6 +142,7 @@ brcmf_fil_cmd_data_set(struct brcmf_if *ifp, u32 cmd, void *data, u32 len)
 
 	return err;
 }
+BRCMF_EXPORT_SYMBOL_GPL(brcmf_fil_cmd_data_set);
 
 s32
 brcmf_fil_cmd_data_get(struct brcmf_if *ifp, u32 cmd, void *data, u32 len)
@@ -160,36 +161,7 @@ brcmf_fil_cmd_data_get(struct brcmf_if *ifp, u32 cmd, void *data, u32 len)
 
 	return err;
 }
-
-
-s32
-brcmf_fil_cmd_int_set(struct brcmf_if *ifp, u32 cmd, u32 data)
-{
-	s32 err;
-	__le32 data_le = cpu_to_le32(data);
-
-	mutex_lock(&ifp->drvr->proto_block);
-	brcmf_dbg(FIL, "ifidx=%d, cmd=%d, value=%d\n", ifp->ifidx, cmd, data);
-	err = brcmf_fil_cmd_data(ifp, cmd, &data_le, sizeof(data_le), true);
-	mutex_unlock(&ifp->drvr->proto_block);
-
-	return err;
-}
-
-s32
-brcmf_fil_cmd_int_get(struct brcmf_if *ifp, u32 cmd, u32 *data)
-{
-	s32 err;
-	__le32 data_le = cpu_to_le32(*data);
-
-	mutex_lock(&ifp->drvr->proto_block);
-	err = brcmf_fil_cmd_data(ifp, cmd, &data_le, sizeof(data_le), false);
-	mutex_unlock(&ifp->drvr->proto_block);
-	*data = le32_to_cpu(data_le);
-	brcmf_dbg(FIL, "ifidx=%d, cmd=%d, value=%d\n", ifp->ifidx, cmd, *data);
-
-	return err;
-}
+BRCMF_EXPORT_SYMBOL_GPL(brcmf_fil_cmd_data_get);
 
 static u32
 brcmf_create_iovar(const char *name, const char *data, u32 datalen,
@@ -271,26 +243,7 @@ brcmf_fil_iovar_data_get(struct brcmf_if *ifp, const char *name, void *data,
 	mutex_unlock(&drvr->proto_block);
 	return err;
 }
-
-s32
-brcmf_fil_iovar_int_set(struct brcmf_if *ifp, const char *name, u32 data)
-{
-	__le32 data_le = cpu_to_le32(data);
-
-	return brcmf_fil_iovar_data_set(ifp, name, &data_le, sizeof(data_le));
-}
-
-s32
-brcmf_fil_iovar_int_get(struct brcmf_if *ifp, const char *name, u32 *data)
-{
-	__le32 data_le = cpu_to_le32(*data);
-	s32 err;
-
-	err = brcmf_fil_iovar_data_get(ifp, name, &data_le, sizeof(data_le));
-	if (err == 0)
-		*data = le32_to_cpu(data_le);
-	return err;
-}
+BRCMF_EXPORT_SYMBOL_GPL(brcmf_fil_iovar_data_get);
 
 static u32
 brcmf_create_bsscfg(s32 bsscfgidx, const char *name, char *data, u32 datalen,
@@ -365,6 +318,7 @@ brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, const char *name,
 	mutex_unlock(&drvr->proto_block);
 	return err;
 }
+BRCMF_EXPORT_SYMBOL_GPL(brcmf_fil_bsscfg_data_set);
 
 s32
 brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, const char *name,
@@ -395,28 +349,7 @@ brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, const char *name,
 	mutex_unlock(&drvr->proto_block);
 	return err;
 }
-
-s32
-brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, const char *name, u32 data)
-{
-	__le32 data_le = cpu_to_le32(data);
-
-	return brcmf_fil_bsscfg_data_set(ifp, name, &data_le,
-					 sizeof(data_le));
-}
-
-s32
-brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, const char *name, u32 *data)
-{
-	__le32 data_le = cpu_to_le32(*data);
-	s32 err;
-
-	err = brcmf_fil_bsscfg_data_get(ifp, name, &data_le,
-					sizeof(data_le));
-	if (err == 0)
-		*data = le32_to_cpu(data_le);
-	return err;
-}
+BRCMF_EXPORT_SYMBOL_GPL(brcmf_fil_bsscfg_data_get);
 
 static u32 brcmf_create_xtlv(const char *name, u16 id, char *data, u32 len,
 			     char *buf, u32 buflen)
@@ -466,6 +399,7 @@ s32 brcmf_fil_xtlv_data_set(struct brcmf_if *ifp, const char *name, u16 id,
 	mutex_unlock(&drvr->proto_block);
 	return err;
 }
+BRCMF_EXPORT_SYMBOL_GPL(brcmf_fil_xtlv_data_set);
 
 s32 brcmf_fil_xtlv_data_get(struct brcmf_if *ifp, const char *name, u16 id,
 			    void *data, u32 len)
@@ -495,39 +429,4 @@ s32 brcmf_fil_xtlv_data_get(struct brcmf_if *ifp, const char *name, u16 id,
 	mutex_unlock(&drvr->proto_block);
 	return err;
 }
-
-s32 brcmf_fil_xtlv_int_set(struct brcmf_if *ifp, const char *name, u16 id, u32 data)
-{
-	__le32 data_le = cpu_to_le32(data);
-
-	return brcmf_fil_xtlv_data_set(ifp, name, id, &data_le,
-					 sizeof(data_le));
-}
-
-s32 brcmf_fil_xtlv_int_get(struct brcmf_if *ifp, const char *name, u16 id, u32 *data)
-{
-	__le32 data_le = cpu_to_le32(*data);
-	s32 err;
-
-	err = brcmf_fil_xtlv_data_get(ifp, name, id, &data_le, sizeof(data_le));
-	if (err == 0)
-		*data = le32_to_cpu(data_le);
-	return err;
-}
-
-s32 brcmf_fil_xtlv_int8_get(struct brcmf_if *ifp, const char *name, u16 id, u8 *data)
-{
-	return brcmf_fil_xtlv_data_get(ifp, name, id, data, sizeof(*data));
-}
-
-s32 brcmf_fil_xtlv_int16_get(struct brcmf_if *ifp, const char *name, u16 id, u16 *data)
-{
-	__le16 data_le = cpu_to_le16(*data);
-	s32 err;
-
-	err = brcmf_fil_xtlv_data_get(ifp, name, id, &data_le, sizeof(data_le));
-	if (err == 0)
-		*data = le16_to_cpu(data_le);
-	return err;
-}
-
+BRCMF_EXPORT_SYMBOL_GPL(brcmf_fil_xtlv_data_get);
\ No newline at end of file
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
index bc693157c4b1c..a315a7fac6a06 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
@@ -81,29 +81,122 @@
 
 s32 brcmf_fil_cmd_data_set(struct brcmf_if *ifp, u32 cmd, void *data, u32 len);
 s32 brcmf_fil_cmd_data_get(struct brcmf_if *ifp, u32 cmd, void *data, u32 len);
-s32 brcmf_fil_cmd_int_set(struct brcmf_if *ifp, u32 cmd, u32 data);
-s32 brcmf_fil_cmd_int_get(struct brcmf_if *ifp, u32 cmd, u32 *data);
+static inline
+s32 brcmf_fil_cmd_int_set(struct brcmf_if *ifp, u32 cmd, u32 data)
+{
+	s32 err;
+	__le32 data_le = cpu_to_le32(data);
 
-s32 brcmf_fil_iovar_data_set(struct brcmf_if *ifp, const char *name, const void *data,
-			     u32 len);
+	brcmf_dbg(FIL, "ifidx=%d, cmd=%d, value=%d\n", ifp->ifidx, cmd, data);
+	err = brcmf_fil_cmd_data_set(ifp, cmd, &data_le, sizeof(data_le));
+
+	return err;
+}
+static inline
+s32 brcmf_fil_cmd_int_get(struct brcmf_if *ifp, u32 cmd, u32 *data)
+{
+	s32 err;
+	__le32 data_le = cpu_to_le32(*data);
+
+	err = brcmf_fil_cmd_data_get(ifp, cmd, &data_le, sizeof(data_le));
+	if (err == 0)
+		*data = le32_to_cpu(data_le);
+	brcmf_dbg(FIL, "ifidx=%d, cmd=%d, value=%d\n", ifp->ifidx, cmd, *data);
+
+	return err;
+}
+
+s32 brcmf_fil_iovar_data_set(struct brcmf_if *ifp, const char *name,
+			     const void *data, u32 len);
 s32 brcmf_fil_iovar_data_get(struct brcmf_if *ifp, const char *name, void *data,
 			     u32 len);
-s32 brcmf_fil_iovar_int_set(struct brcmf_if *ifp, const char *name, u32 data);
-s32 brcmf_fil_iovar_int_get(struct brcmf_if *ifp, const char *name, u32 *data);
-
-s32 brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, const char *name, void *data,
-			      u32 len);
-s32 brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, const char *name, void *data,
-			      u32 len);
-s32 brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, const char *name, u32 data);
-s32 brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, const char *name, u32 *data);
+static inline
+s32 brcmf_fil_iovar_int_set(struct brcmf_if *ifp, const char *name, u32 data)
+{
+	__le32 data_le = cpu_to_le32(data);
+
+	return brcmf_fil_iovar_data_set(ifp, name, &data_le, sizeof(data_le));
+}
+static inline
+s32 brcmf_fil_iovar_int_get(struct brcmf_if *ifp, const char *name, u32 *data)
+{
+	__le32 data_le = cpu_to_le32(*data);
+	s32 err;
+
+	err = brcmf_fil_iovar_data_get(ifp, name, &data_le, sizeof(data_le));
+	if (err == 0)
+		*data = le32_to_cpu(data_le);
+	return err;
+}
+
+
+s32 brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, const char *name,
+			      void *data, u32 len);
+s32 brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, const char *name,
+			      void *data, u32 len);
+static inline
+s32 brcmf_fil_bsscfg_int_set(struct brcmf_if *ifp, const char *name, u32 data)
+{
+	__le32 data_le = cpu_to_le32(data);
+
+	return brcmf_fil_bsscfg_data_set(ifp, name, &data_le,
+					 sizeof(data_le));
+}
+static inline
+s32 brcmf_fil_bsscfg_int_get(struct brcmf_if *ifp, const char *name, u32 *data)
+{
+	__le32 data_le = cpu_to_le32(*data);
+	s32 err;
+
+	err = brcmf_fil_bsscfg_data_get(ifp, name, &data_le,
+					sizeof(data_le));
+	if (err == 0)
+		*data = le32_to_cpu(data_le);
+	return err;
+}
+
 s32 brcmf_fil_xtlv_data_set(struct brcmf_if *ifp, const char *name, u16 id,
 			    void *data, u32 len);
 s32 brcmf_fil_xtlv_data_get(struct brcmf_if *ifp, const char *name, u16 id,
 			    void *data, u32 len);
-s32 brcmf_fil_xtlv_int_set(struct brcmf_if *ifp, const char *name, u16 id, u32 data);
-s32 brcmf_fil_xtlv_int_get(struct brcmf_if *ifp, const char *name, u16 id, u32 *data);
-s32 brcmf_fil_xtlv_int8_get(struct brcmf_if *ifp, const char *name, u16 id, u8 *data);
-s32 brcmf_fil_xtlv_int16_get(struct brcmf_if *ifp, const char *name, u16 id, u16 *data);
+static inline
+s32 brcmf_fil_xtlv_int_set(struct brcmf_if *ifp, const char *name, u16 id,
+			   u32 data)
+{
+	__le32 data_le = cpu_to_le32(data);
+
+	return brcmf_fil_xtlv_data_set(ifp, name, id, &data_le,
+					 sizeof(data_le));
+}
+static inline
+s32 brcmf_fil_xtlv_int_get(struct brcmf_if *ifp, const char *name, u16 id,
+			   u32 *data)
+{
+	__le32 data_le = cpu_to_le32(*data);
+	s32 err;
+
+	err = brcmf_fil_xtlv_data_get(ifp, name, id, &data_le, sizeof(data_le));
+	if (err == 0)
+		*data = le32_to_cpu(data_le);
+	return err;
+}
+static inline
+s32 brcmf_fil_xtlv_int8_get(struct brcmf_if *ifp, const char *name, u16 id,
+			    u8 *data)
+{
+	return brcmf_fil_xtlv_data_get(ifp, name, id, data, sizeof(*data));
+}
+static inline
+s32 brcmf_fil_xtlv_int16_get(struct brcmf_if *ifp, const char *name, u16 id,
+			     u16 *data)
+{
+	__le16 data_le = cpu_to_le16(*data);
+	s32 err;
+
+	err = brcmf_fil_xtlv_data_get(ifp, name, id, &data_le, sizeof(data_le));
+	if (err == 0)
+		*data = le16_to_cpu(data_le);
+	return err;
+}
 
 #endif /* _fwil_h_ */
-- 
2.43.0



