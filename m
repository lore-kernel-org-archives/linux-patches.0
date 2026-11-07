Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060793;
	b=v05KU0G8TsD2PXPbgKvR6vbxQeVzTBtTWX5l2houzBkhW1wtvqLROHuqd3pLF0qrHBOz
	 RUfOGDXCW+jcMD7qpQ+s8mQ8XVjAxAnnzImmrgDImrUmGxTRenIFZVj1nk0SvP51j4ceo
	 pBNiqk89GynQDMW5dVG/gU3oJ8dGoCwutpYMug2FtpsWtzBoyx37yUtf5oj+vvVpnZPG3
	 o6dru8E8/96CyXAfCA0ht4i9HMn56Vt3aiLkNZ+Qksv2DCFJscjeJiJZgVVdT97ghI3OW
	 FzRWvgCAsYfjAkNG36QoDn3h13l42ZKwx7gFtB/G5zeWd+IvjXXxmA5Gv3+lxqoPX+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8ikhxr8ZARA+dCmXkFyNFDyzjZoYXRB1rv1SBGF/qN4=;
	b=pNIIgl9K4WCl6j4spbPpHXJFq7EbOHnohRpQ65OdQ1v438gnGMEtYrBplSOwABC1nNqZ
	 KUS7bxJBDP48cNxyh1xPfc0+P2jMa7Gdu5qb1JKKpOmghgQDik7A1kLsh5kQ708BiePEW
	 YonGzdG2t0rzAgvTvJeVUSJpUTUEaQbHmjAAMC3O2vy+QaE4uilWSNa+NncKJEbDQ5DZQ
	 BYqxjrF9f726dlE/fxfsV6Bg83bP74w5tnzXjJ906zlbumlJAkPCS3Nxwnyk/ZL+lGP5c
	 0OA92BlvrUUm+xB4sjfjb3KUtkCaFBlsxuo2e9wKviQKmKYjS65Hbdp+a+KDpOcDeeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IO6lpAdo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3780606A332;
	Sat,  7 Nov 2026 14:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IO6lpAdo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786701F0089F;
	Sat,  7 Nov 2026 14:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060792;
	bh=8ikhxr8ZARA+dCmXkFyNFDyzjZoYXRB1rv1SBGF/qN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IO6lpAdo9kPfcbEtGQZqdWrlyO5r/NH1NpUVGGzNFtGK1G2+XZZtw1NhIE2MHaQK3
	 wRXXGbJcgYj7UiOiNxWap/XUWgVl4+rryTQVR1gVFmUg1hjT+NzsKzriuw1Fgnt46X
	 H/euKkT2jONYYnJUIpHeXbyaSh0tExl3uddHolDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wilhelm <alexander.wilhelm@westermo.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0195/1536] wifi: ath12k: fix scan command endianness on big endian
Date: Sat,  7 Nov 2026 08:36:51 -0500
Message-ID: <20261107135003.140044587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e70a1e3fef04e..558ce211a5ce9 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -2332,9 +2332,10 @@ int ath12k_wmi_send_scan_start_cmd(struct ath12k *ar,
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
 
@@ -2414,9 +2415,10 @@ int ath12k_wmi_send_scan_start_cmd(struct ath12k *ar,
 	tlv = ptr;
 	tlv->header = ath12k_wmi_tlv_hdr(WMI_TAG_ARRAY_UINT32, len);
 	ptr += TLV_HDR_SIZE;
-	tmp_ptr = (u32 *)ptr;
+	tmp_ptr = (__le32 *)ptr;
 
-	memcpy(tmp_ptr, arg->chan_list, arg->num_chan * 4);
+	for (i = 0; i < arg->num_chan; i++)
+		tmp_ptr[i] = cpu_to_le32(arg->chan_list[i]);
 
 	ptr += len;
 
@@ -2472,8 +2474,10 @@ int ath12k_wmi_send_scan_start_cmd(struct ath12k *ar,
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
@@ -2487,7 +2491,7 @@ int ath12k_wmi_send_scan_start_cmd(struct ath12k *ar,
 		hint_bssid = ptr;
 		for (i = 0; i < arg->num_hint_bssid; ++i) {
 			hint_bssid->freq_flags =
-				arg->hint_bssid[i].freq_flags;
+				cpu_to_le32(arg->hint_bssid[i].freq_flags);
 			ether_addr_copy(&hint_bssid->bssid.addr[0],
 					&arg->hint_bssid[i].bssid.addr[0]);
 			hint_bssid++;
diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index b495cdea7111c..3935a9405b3f8 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -3322,6 +3322,16 @@ struct ath12k_wmi_hint_bssid_arg {
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



