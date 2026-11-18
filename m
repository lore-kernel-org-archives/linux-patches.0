Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024598;
	b=OyPk0GD9guhbTKY7L2L+TCNahzS4kxnW+8nmE5NekmdHP77pDTfOOFk3H41149AjGJ9f
	 p1OfBreHXmJsY/Z8di15eKT4YOycrQTnx4/EnALL0TLgyPLanXpsU3gIit2l/gMcKZQM8
	 LuAZKm/AvkZfJLLTAwfjovdwy8AGXzKKQ0zP9mMkLPGl4IKSU5b5O5JdZKzAUKUjQNvHs
	 CqnD9wxug7nc2alUtKRgFR7oDawuROwXhuU5aE+Alc6Qy/XMp8GgTO8aXDF3aTVsKrFow
	 Vy7qOpvbeOwIGdGMu76b/zhPbR5zq07i3nynZduvGegtfJSMet8TA/ZZNHX7/1Lk6Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TlVUF7DtHJ0UU6atR/+FJ/BJkxi/qV0M7i8Y9SnTh18=;
	b=fRiO7+KaOm7lHNj+IPq/qyVmnE8jpiZnbWxWkDIgOPmrmBxVFmduIRk2Vcei4W7371nP
	 35ceBg2P1YW7Aa3hw4pbR7iLOfPUpRzChIlnje20vzas6r4v4Wn8tgIfYSZpxTRiFpplY
	 uDZbImmfZTUmC60mnH0em4uUdEjA5PDUI8mc5j59GwczZ6gG+sZ/XhJTfaDNQmwxnhl5b
	 +xEzKI+a4W5eMjxEEmHEkuShd7UugjPrW9RwRzniJtp8tAMIu9BItKdpftyMJ72+NkImG
	 fa4mg+EaYG4ZMcT1tFr+bXVGsUc+GhoVbyJQWzPf09pYSYmHNBRNLKnAnkRk3wUCpOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUjzAYOQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1983F606A325;
	Wed, 18 Nov 2026 17:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUjzAYOQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722FF1F000C4;
	Wed, 18 Nov 2026 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024598;
	bh=TlVUF7DtHJ0UU6atR/+FJ/BJkxi/qV0M7i8Y9SnTh18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUjzAYOQg/Wtsr+PsXLwPik4jvmK1xYTp0ZSAerEk6FtdljnPuKIkgRwsW5LKrPeC
	 4lEIgWxWKiXiM1bNJLYJ3yt63qQkD97CLP9TRh1XBirkon2S6E3d7PBcKF2JlXyTBk
	 V1SF9QIKZUOt7IFXk+fS0iJ/RjKTQBqfRczmQgmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0741/2151] wifi: ath11k: fix reg_info_store leak in ath11k_service_ready_ext_event()
Date: Wed, 18 Nov 2026 15:41:16 +0100
Message-ID: <20261118150149.035842182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c6b9e84b169c9..f12c1c380ed2a 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5084,6 +5084,15 @@ static int ath11k_service_ready_ext_event(struct ath11k_base *ab,
 
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



