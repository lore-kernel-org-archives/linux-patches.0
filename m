Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216691;
	b=203m6SYYJ3HOTmXh5pb16T6WinLZu7yC8pEjAj+U6fsp0dy/HcQWSTjHRBEMyyISujWV
	 cDLSWDNh9DzV3IZM5KA4I8GRPLFrhSzjYP5Wtfltpufl11FIbN+rxbJBCUEpGP1MfhxrZ
	 ujKnGoIbexOgw5NbXFssC1OxpHwOfsNOHGbd2+ZdIf5b/bpK3btZVf/SdmURQvxfdSlOR
	 NYltYmNu8oMTexJBCCPJhOI0Mj8wWVDPdCtoLgOmc3QzrT4PmfY5+9p/Azqw+kQdak9k9
	 /st/Bhne/8xwVy33fZzS985JOKvPJb9sX91Q1tCdE3CwkPQF+4Tt1KiDjia/NNsoWjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b4f5Stt/mw+XlHK2LRkkvvZId4SnhXnFOtGDAS+k1Wg=;
	b=eajtIgHNTJYrnXloYk6K+4yE577J8LtxP/dZ3orenjsSABEy1lgqiCNvyybsLVvSF6BL
	 i/LABrvuLhWskpelZBLKnvEMEScYJy1B9bOG5qmsU0DJW+BBnKDyaK8MkH8TBzThBGDHD
	 XkqHpbUJINCrhQNNVImVdKfTAqIcpa5vbUV+J8Sr3rFOUFtsgstxRP+BrCrKCT2gvYH5c
	 SA3ZHJHb663RgkajQtyowgbvKSTiddmX6hMwm2Y6cxlS6L1uAOsJSfCdpTjU82WcCe8Dq
	 2yKArh64MxQZ3+NGCpG9qNksFhrf/iBv4mh6oIXISZkR2a+aSY0OfwunGIdAhYOwQcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxqtruKx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B39F606A31A;
	Wed, 28 Oct 2026 19:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxqtruKx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5AF1F01825;
	Wed, 28 Oct 2026 19:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216691;
	bh=b4f5Stt/mw+XlHK2LRkkvvZId4SnhXnFOtGDAS+k1Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxqtruKx38dUoMCRwoFrKOSwtty5syr+nK0qKP+53fdA+8zypQJHHvBuwesjQIBv3
	 MY/UZShaT8/vlxdCt5ssQPL8Xfnix8Kjj6HOYcT3qbAPtEfPqYBhuJER7Zq23W0gbe
	 T6c3MGnxOl3Uik0WwFkjb/LwP5JOvNv7iAfaxst0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1602/1887] wifi: ath11k: fix stride mismatch in mac_phy_caps_parse()
Date: Wed, 28 Oct 2026 18:01:38 +0100
Message-ID: <20261028170535.924616238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit 7a246c72132eb943b5844ba79dad597b47429dba ]

Currently, in ath11k_wmi_tlv_mac_phy_caps_parse(), kcalloc() sizes the
mac_phy_caps buffer as tot_phy_id * len, where len is clamped to
min(firmware_len, sizeof(struct wmi_mac_phy_capabilities)). The subsequent
memcpy() destination advances by sizeof(full struct) per slot via C
pointer arithmetic, not by the clamped len. When firmware sends short
TLVs, the second and later slots are written past the end of the
allocation.

The reader in ath11k_pull_mac_phy_cap_svc_ready_ext() also indexes the
buffer with full-struct pointer arithmetic, so the allocation must match
that stride.

Fix by using kzalloc_objs(), which derives the element size from the
pointer type, making allocation size and pointer stride provably
consistent regardless of what len the firmware provides.

Compile tested only.

Fixes: 5b90fc760db5 ("ath11k: fix wmi service ready ext tlv parsing")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260728-mac_phy_caps_parse-stride-mismatch-v1-2-27a9c1a3fbd0@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index c3f440cae0bfd..b58c84c2f9dd3 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4513,14 +4513,16 @@ static int ath11k_wmi_tlv_mac_phy_caps_parse(struct ath11k_base *soc,
 	if (svc_rdy_ext->n_mac_phy_caps >= svc_rdy_ext->tot_phy_id)
 		return -ENOBUFS;
 
-	len = min_t(u16, len, sizeof(struct wmi_mac_phy_capabilities));
 	if (!svc_rdy_ext->n_mac_phy_caps) {
-		svc_rdy_ext->mac_phy_caps = kcalloc(svc_rdy_ext->tot_phy_id,
-						    len, GFP_ATOMIC);
+		svc_rdy_ext->mac_phy_caps =
+			kcalloc(svc_rdy_ext->tot_phy_id,
+				sizeof(*svc_rdy_ext->mac_phy_caps),
+				GFP_ATOMIC);
 		if (!svc_rdy_ext->mac_phy_caps)
 			return -ENOMEM;
 	}
 
+	len = min_t(u16, len, sizeof(struct wmi_mac_phy_capabilities));
 	memcpy(svc_rdy_ext->mac_phy_caps + svc_rdy_ext->n_mac_phy_caps, ptr, len);
 	svc_rdy_ext->n_mac_phy_caps++;
 	return 0;
-- 
2.53.0



