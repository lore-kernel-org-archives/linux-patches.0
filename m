Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033867;
	b=U5yFVucD1q8DctiJYKEQXHliRjVh4p8Hz+I191Sm4nHMLhzBObdeOw3m+NsyKMPgfXRA
	 twwmmQM6ja/7LbXil78vtmIPtfOawmRhIkme/P02IPzAbRd6diSaVu+1GKopbr/FbnDIc
	 IJyK2hTtnBVOplq1yTeT67UZGA915pQkQ4kSbg5C6p6QKvFImFiwJzsP7YymzsKX4zidC
	 /e1+JxchBP1ZDNVCGhOmUE8m1K3ehe9yfMob9mE6UptaPZJaX0kYKCu43DZbngx76ynPM
	 LkFno2o14HKduMlgVbGb11rA3OOlxELi2pQ/2nCXWF2G+5uj175VWnPXaDq70al3Dtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4YC09msTdgV/jT/FEVA7jnRmnqEtNCOTiIxsxcDOFlI=;
	b=CoFnoDgYEbqGeBcE1kOMkEZW/MPvS+2mdDpSmhoSpi2o2Pb64OoQzbWTjXc7CWapm6tn
	 4f+8sc5oIye7G2dwtmh7z6fChYYBl1psSFz3r9yKZGdyW/oqZFMlURoGxdcSor1Gr7LX0
	 iA+xszlsTMufPh25WSGbXdfNLVs8XuGo+MtuQgbx0q+ugKTYb2U7yY9tBxcHwOIzmcaR+
	 aKOnTlIYAFpv90E4k4rW0qRq4Tp5HXvCoxtI7ieR0GO186W6mQ0LfPoXndi+3Y6dxDFXp
	 CL2en0Yv8LGZ3b5wkSv1R9aHBjpxN5kp/O4gex8Z1QqbFlvjpjNXDz3viqmHUPQrDgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lqL9p1HZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55955606A332;
	Wed, 18 Nov 2026 20:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lqL9p1HZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4D61F000C4;
	Wed, 18 Nov 2026 20:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033867;
	bh=4YC09msTdgV/jT/FEVA7jnRmnqEtNCOTiIxsxcDOFlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lqL9p1HZFErCn+XDTWGTBogCacjs8+0rLaOerqTJd4RGChN3p6qDe1zuZoXsYTWBQ
	 COyE+eqCs16+3Vd5Qb/dboplEi97Ikbo+1n7RVwF+N6/pVypEnnZ8yfjImPV+RPnX7
	 /jOBqmvy32rkVC+QTYRsa14ktSJQZGYtEdTr5lq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wilhelm <alexander.wilhelm@westermo.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0168/3318] wifi: ath12k: fix scan command endianness on big endian
Date: Wed, 18 Nov 2026 15:13:10 +0100
Message-ID: <20261118150319.672171493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Wilhelm <alexander.wilhelm@westermo.com>

[ Upstream commit 6c90f68f97de591e0413f7d2de59449a0388bbab ]

ath12k_wmi_scan_req_arg stores scan parameters in CPU-native byte order,
while ath12k_wmi_send_scan_start_cmd() writes them into a WMI command
buffer whose contents must be in little-endian format. The existing code
copies the channel list and writes s_ssid and hint_bssid related values to
the command buffer without endian conversion. As a result, scan requests
contain invalid parameters on big-endian systems and fail.

Convert the channel list as well as the s_ssid and hint_bssid related
values to little-endian before writing them to the WMI command buffer. This
preserves the existing behaviour on little-endian systems while fixing scan
requests on big-endian architectures.

Signed-off-by: Alexander Wilhelm <alexander.wilhelm@westermo.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260703-fix-channel-list-copy-v2-1-372c39306d79@westermo.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 20 ++++++++++++--------
 drivers/net/wireless/ath/ath12k/wmi.h | 10 ++++++++++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 183ac212bb037..3f66f4a4dd47f 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -2241,9 +2241,10 @@ int ath12k_wmi_send_scan_start_cmd(struct ath12k *ar,
 	struct wmi_tlv *tlv;
 	void *ptr;
 	int i, ret, len;
-	u32 *tmp_ptr, extraie_len_with_pad = 0;
-	struct ath12k_wmi_hint_short_ssid_arg *s_ssid = NULL;
-	struct ath12k_wmi_hint_bssid_arg *hint_bssid = NULL;
+	__le32 *tmp_ptr;
+	u32 extraie_len_with_pad = 0;
+	struct ath12k_wmi_hint_short_ssid_params *s_ssid = NULL;
+	struct ath12k_wmi_hint_bssid_params *hint_bssid = NULL;
 
 	len = sizeof(*cmd);
 
@@ -2323,9 +2324,10 @@ int ath12k_wmi_send_scan_start_cmd(struct ath12k *ar,
 	tlv = ptr;
 	tlv->header = ath12k_wmi_tlv_hdr(WMI_TAG_ARRAY_UINT32, len);
 	ptr += TLV_HDR_SIZE;
-	tmp_ptr = (u32 *)ptr;
+	tmp_ptr = (__le32 *)ptr;
 
-	memcpy(tmp_ptr, arg->chan_list, arg->num_chan * 4);
+	for (i = 0; i < arg->num_chan; i++)
+		tmp_ptr[i] = cpu_to_le32(arg->chan_list[i]);
 
 	ptr += len;
 
@@ -2381,8 +2383,10 @@ int ath12k_wmi_send_scan_start_cmd(struct ath12k *ar,
 		ptr += TLV_HDR_SIZE;
 		s_ssid = ptr;
 		for (i = 0; i < arg->num_hint_s_ssid; ++i) {
-			s_ssid->freq_flags = arg->hint_s_ssid[i].freq_flags;
-			s_ssid->short_ssid = arg->hint_s_ssid[i].short_ssid;
+			s_ssid->freq_flags =
+				cpu_to_le32(arg->hint_s_ssid[i].freq_flags);
+			s_ssid->short_ssid =
+				cpu_to_le32(arg->hint_s_ssid[i].short_ssid);
 			s_ssid++;
 		}
 		ptr += len;
@@ -2396,7 +2400,7 @@ int ath12k_wmi_send_scan_start_cmd(struct ath12k *ar,
 		hint_bssid = ptr;
 		for (i = 0; i < arg->num_hint_bssid; ++i) {
 			hint_bssid->freq_flags =
-				arg->hint_bssid[i].freq_flags;
+				cpu_to_le32(arg->hint_bssid[i].freq_flags);
 			ether_addr_copy(&hint_bssid->bssid.addr[0],
 					&arg->hint_bssid[i].bssid.addr[0]);
 			hint_bssid++;
diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index 4cfcc83f52269..cae2840480582 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -3259,6 +3259,16 @@ struct ath12k_wmi_hint_bssid_arg {
 	struct ath12k_wmi_mac_addr_params bssid;
 };
 
+struct ath12k_wmi_hint_short_ssid_params {
+	__le32 freq_flags;
+	__le32 short_ssid;
+};
+
+struct ath12k_wmi_hint_bssid_params {
+	__le32 freq_flags;
+	struct ath12k_wmi_mac_addr_params bssid;
+};
+
 struct ath12k_wmi_scan_req_arg {
 	u32 scan_id;
 	u32 scan_req_id;
-- 
2.53.0



