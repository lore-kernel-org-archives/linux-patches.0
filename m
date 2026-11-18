Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030115;
	b=ZCRzzfDu1E0jMtYokM9Dbzf+V8mz+YV7YgdrwasTajZxBq7wrxOU/cTZzMTaZYZZWvWb
	 rrZ/rv2NTZHq9aCW/8CJ6cMMPDUt01GPqd2jMwN2Q6OqxB67xBKWRpqpISJZXqQCNb9X5
	 fLvgBAgu54bvMKdg0AXBi30BsvpTNuN+6xZTvZRd0FNmlnEW0YrZzEcO7EZJTE9IFmyLM
	 zFmk0NjT+fVSW4+3PlwDmEu4fW+7c2LP1R6UsX+sST8MP64IM/A3evzqlVIG4cC7ajHfm
	 cbWS2IwnZh+qalxez5UBGvzU+0ctmYzqXbGeAPBJgWofos7Jz/Kr4UI1TV0ehIvPSqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oD7cX2NnMrpJ2EwBi8bu7I0Kewey16K3wlTYF9osYmk=;
	b=ar+F+oe9JcQ3Q/CD2mvcDltabntY9egThS4trHgF1EO/+a0zlSmMBe+QsBO4UJ2w1GLJ
	 JPhu5BeWNpNqD35k5/jW5V/zu07FU3B0U7yh6zsdnCbV8S7dOEsG9wnLUzvU8youvJYdg
	 kMDpIN6SnGLqAeQ0pL8hcjdhjqto7iz2sLUszSLJoVrGnB8xMwHvoCzk+UP7yWouADk1H
	 2kuM6uLtk/HWlLsvvqLlhC79goCfzoUrOmswdI4/kLjRjWFp9GdRO5bD9UEI1xiwNYDId
	 /lVwimGuVrcQ8sHXRFcJ5qMcv0Kv4lTqVhzcNOKax+9wn0onEb2kPJna+bglEui9wtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1sdlTET;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0AF6071297;
	Wed, 18 Nov 2026 19:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1sdlTET
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DF61F000C6;
	Wed, 18 Nov 2026 19:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030115;
	bh=oD7cX2NnMrpJ2EwBi8bu7I0Kewey16K3wlTYF9osYmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1sdlTETtJyPSKDkgR4MjgPQtAhfmre61rLH6/b26hocTVkPR8IJmfh0j228KnBMS
	 1kqbDrn/2UnOO02ubSX9txTNGOCeHqLNF8YPRW2uyU5xKpErH+YaQgjHpCT/a9iWBa
	 3qudvsjWgKhPkEGf3iYYIwUMpARXMIXTwAXkK+Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0589/1756] wifi: ath11k: fix reg_info_store leak in ath11k_service_ready_ext_event()
Date: Wed, 18 Nov 2026 15:45:16 +0100
Message-ID: <20261118150032.459668492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 1911b4e50abb9..5a3126fce3c73 100644
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



