Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017367;
	b=vHA0VH1IUtg8U8iUJ9z0A1qcSRsTtECz+5SiNt03ezZBl4ZB1qaOJ3B9q794FzX81hjx
	 equtuKJzhLq/5HmWBqSlCrHyNBZ8BJ7CK6gnxZdO48KdQc9IRnk0EySRb5Z0gzfm6ypfS
	 CcM2Xo1rT1Nnb0ydvpdr0DHQGQa7fHJGE27AQrwNRVw0NKATU7pcGHkZGkFRAAYkob2DZ
	 Xl7bIY/bu1v/+5rHnPb5/tml0IXVO+pTVEyERbVFPwERcmUuBTFkQ51D6+XSR/YR03gOj
	 z4uzXYB+WO0v8ghcAOmT39AYfcZbTT9b6bnFE6n6Sp03BydHlld6k07MQcUDOnHvvQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wzJA1Akba978TnMsFKiRarpKBtiEkEv9pi4Z6jf4vDE=;
	b=fU2J2HvO1/GOYmaeNwI7N5BcMlcaK1sOULCEq1uU3p0rv97nhg0ptj9LEQwWcIdjAkhQ
	 4ueQU4LXFsm4nC4pZV+AxiOLDBSoa0pwhk2wPOMr/QF6+809+19RuZlwrjVi6FUKBHsrK
	 7YPDdeBaqVkRvQ196+bz4sMfzzlP8zSxcqtmK5OLFbdZF3FMTGEHDUA4wIVh8PSnAkeL7
	 YWNP06ozjv+pdcQpiR8jQN1QgbDyeq121QkWGCYD6UJUYTALkElWfsDRa1fAzCiskHDeU
	 2dm2qcSCPKCBtkSe3qnHh9GSyKx4HRQu17F4gLSRk1CtER2VrHzPgZFj+2uIJyKwlkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d510XPwh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D8B606A31C;
	Wed, 18 Nov 2026 15:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d510XPwh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F01D1F000C4;
	Wed, 18 Nov 2026 15:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017366;
	bh=wzJA1Akba978TnMsFKiRarpKBtiEkEv9pi4Z6jf4vDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d510XPwhleuoBJbGqfzXXr3NqPVsZ5DDi0qFsxyWTEwYtgjOPU4g10qOvUTlhj9+2
	 oFbq6cf+qQQ9TDdZkEYeUHFnSdGdz/cPyQnub1J7khtp7wvh52s6Mvzf6R/pcgUqic
	 h+RoWiEZUtRYFZn5/0PqweYwEGkCv6ZwNl+jpz8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0858/2651] wifi: ath11k: fix reg_info_store leak in ath11k_service_ready_ext_event()
Date: Wed, 18 Nov 2026 15:34:58 +0100
Message-ID: <20261118150318.754004267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit 64828f091c7de5c1324427b140fb545f93ef073f ]

Currently, while processing the WMI Service Ready Ext event, the iterator
in ath11k_service_ready_ext_event() can dispatch the HAL Regulatory
Capabilities handler ath11k_wmi_tlv_ext_soc_hal_reg_caps_parse() which can
allocate ab->reg_info_store.

If a subsequent failure occurs during iteration, the ab->reg_info_store
allocation is leaked.

Directly free and clear the pointer on the error path.

Note that the normal cleanup function ath11k_reg_free() cannot be used
since other regulatory-related fields are not yet populated at this point.

Compile tested only.

Fixes: 7004bdceef60 ("wifi: ath11k: store cur_regulatory_info for each radio")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260817-reg_info_store-leak-v1-1-77025a99b074@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index bbca275a8289a..08fd6795ed9e7 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5136,6 +5136,15 @@ static int ath11k_service_ready_ext_event(struct ath11k_base *ab,
 
 err:
 	kfree(svc_rdy_ext.mac_phy_caps);
+
+	/*
+	 * During TLV iteration the WMI_TAG_SOC_HAL_REG_CAPABILITIES
+	 * handler may have allocated ab->reg_info_store, so free it
+	 * on error to avoid a memory leak
+	 */
+	kfree(ab->reg_info_store);
+	ab->reg_info_store = NULL;
+
 	ath11k_wmi_free_dbring_caps(ab);
 	return ret;
 }
-- 
2.53.0



