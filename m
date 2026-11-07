Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064581;
	b=vcxxjFJVLDrKQRkpE3hy4olDZ1apBzZNJ8vLD6cUxFuWCxUGJ90x9CT6964a4f3iPPl3
	 2xgXYTCN39xO7FgVQhrIB+O2f4/Yt6pY1L813C5DUBUTVUzDf9nM5/qRmLD8mMCsHBhW0
	 44+tUTAh41REy2Pz5QbKJnyHBGQMdVn64V8EVDAEIlvfxmSXN6GEnFKf2M21fmO9GWbpH
	 WLeMD/j3JzgJKoq8ZoXPxCXbshgKZNzibwEwgRDMJXAfOyXFjnirz0gsRmHK5Bs5ZmYvR
	 3FdQdb6ZFjTMVvu58HartEamUGHtffsOdSP9Sz9YkDKr3dq3t6u3rGbl9qKTDVoiEMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M6f+k1u7QUaqroyAXIj7KmIKERC+rrkLuTsLYGnTBvI=;
	b=DHUKN7F4RIv897NI4ofnLpujnCn+rnLjTIBJUTfC6/mb3X8KkFwZ7JbRJi6+H8xCEoDu
	 A/BJxOyxgp9hY1aQYpiCNW06XwZP8xFcYbRj/WtqrgJ6yL4vxXP+05L5mLI/0zkVNfwJc
	 AxcLweUdb0RwoA8K6JIzdZoEPt+H82w5b90eaUveFqHmxzmK2mHnh4+CkgGQ41O5dk4LD
	 1+QFyHIatnamNxFAcmRyvOdhwdcSM5GF781NKw6JwjcoCSckIprXu+AgBUQiMFx52HGJH
	 8oZ+greDhST63lnK7TZlGV8Kqc4cnqDtocn528o7tHlDTRK8SB3Lf1ms/i3hjN1F0OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UijXboqr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5C2606D83C;
	Sat,  7 Nov 2026 15:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UijXboqr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489021F0089F;
	Sat,  7 Nov 2026 15:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064581;
	bh=M6f+k1u7QUaqroyAXIj7KmIKERC+rrkLuTsLYGnTBvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UijXboqro/BEMWeXQGlZGX2FbSLBnoMrOm9SpH3P40VBR2l2+ZkV7dpJg4cM/GllZ
	 9n3RmDU+0hY6OUdarlBVJwKsbMWNvawQpQnyKKpeS2IUxr0Hl7tR5DU7jhpQkB4Pac
	 fSuq34p7Tj+uuAZLRF3bL7Wfs/XrTWnl2uRBctzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0600/1257] wifi: ath12k: validate MAC/PHY capability count before saving
Date: Sat,  7 Nov 2026 08:48:16 -0500
Message-ID: <20261107134955.892247597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 86f2537877d6029487811bc3e0cd9e086a196000 ]

Firmware supplies the hardware mode count and the PHY bitmap for each
mode in the service-ready-ext event. ath12k_wmi_save_all_mac_phy_info()
uses those bitmaps to populate svc_ext_info->mac_phy_info, but the
destination is a fixed array of ATH12K_MAX_MAC_PHY_CAP elements.

If the total number of advertised PHY entries exceeds that limit, the
loop writes beyond mac_phy_info and corrupts adjacent memory.

ath12k_wmi_mac_phy_caps_parse() allocates the source array for
tot_phy_id entries and rejects excess capability TLVs. However, if the
event contains fewer capability TLVs than advertised, the remaining
allocated entries stay zeroed and are saved as invalid PHY information.

After parsing the MAC/PHY capability TLVs, validate the destination
capacity and reject an incomplete capability list before saving any
entries.

Fixes: 062ade23991e ("wifi: ath12k: parse and save hardware mode info from WMI_SERVICE_READY_EXT_EVENTID event for later use")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20261003101944.596546-1-yaojiale02@163.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index d5160af60e00d..3e812c79a649d 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -5050,6 +5050,7 @@ static int ath12k_wmi_svc_rdy_ext_parse(struct ath12k_base *ab,
 					u16 tag, u16 len,
 					const void *ptr, void *data)
 {
+	struct ath12k_svc_ext_info *svc_ext_info = &ab->wmi_ab.svc_ext_info;
 	struct ath12k_wmi_pdev *wmi_handle = &ab->wmi_ab.wmi[0];
 	struct ath12k_wmi_svc_rdy_ext_parse *svc_rdy_ext = data;
 	int ret;
@@ -5094,6 +5095,22 @@ static int ath12k_wmi_svc_rdy_ext_parse(struct ath12k_base *ab,
 				return ret;
 			}
 
+			if (svc_rdy_ext->tot_phy_id >
+			    ARRAY_SIZE(svc_ext_info->mac_phy_info)) {
+				ath12k_warn(ab, "too many PHY entries %u (max %zu)\n",
+					    svc_rdy_ext->tot_phy_id,
+					    ARRAY_SIZE(svc_ext_info->mac_phy_info));
+				return -EINVAL;
+			}
+
+			if (svc_rdy_ext->n_mac_phy_caps < svc_rdy_ext->tot_phy_id) {
+				ath12k_warn(ab,
+					    "not enough MAC/PHY caps %u, expected %u\n",
+					    svc_rdy_ext->n_mac_phy_caps,
+					    svc_rdy_ext->tot_phy_id);
+				return -EINVAL;
+			}
+
 			ath12k_wmi_save_all_mac_phy_info(ab, svc_rdy_ext);
 
 			svc_rdy_ext->mac_phy_done = true;
-- 
2.53.0



