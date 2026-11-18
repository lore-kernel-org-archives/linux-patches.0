Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051227;
	b=WB7f8nwV61fWQU7/Z+OpS8D+fabM0A5j/YKgZAkbR8my+G9msoGZiYYnIp+HzNzyh9Bn
	 CuRCk/RaaG7iWCnWRUFCsi/qKIHAkh9c2Bkm9Q4BlxFbVtmG6qg5qyu9xVORPvXsENl/h
	 apD8eo34abKS0FpSrPHVxSuG66wx+FHdShlYvGx0snONRpr19tDAQF9HqtKB9D+CxhHXy
	 EpfrLSoqdxW3CZMwvlPr9MeBr3i8ECU0mPYSdStgTgy61x5MwunzacLS5JWqQH+Hj+G/6
	 TJ94r/E1KAxcmRLN6ZGFjm6YlNUiNxgSQC3U2BnyXM+4gLWRSCtjNcvSG/e1DsJOZ8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BzSorhOLrCe7K9XDGgUZmi8AmFRTQvQV5QDD3LE0aXU=;
	b=NQcGKKWmwriiNRTcOGtaTmV8UaS89rRjIw+TmAk6EDuiYNvlh8faSUXE8sUTwI+dA/uw
	 5pnttKo1YvBxcFloqSCFETVQmGokHXvLO+mYfB5l48bVouE/0SMyBuDYWX66MWCuGSYrJ
	 l6LmXEnrBjxP8ECppBylBurFtJuKwSsxlu4cyzlw4CDK86vTNEwsYWdKt/7HfTlCkCC//
	 gyAr7mVxIVukLVS7tGO+0Cw+JhxdJqYY/vcTtZ7wMhivRiIHyiUELxpodhTcNm5m1jMKI
	 GyF6sJIioWloaCvLYvenl0P2i5Ne//e7PakWAivuslDb+WGPR6ODGcJaImpHOEYes6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gLth4naN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8F3606A31C;
	Thu, 19 Nov 2026 01:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gLth4naN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE63E1F000C4;
	Thu, 19 Nov 2026 01:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051227;
	bh=BzSorhOLrCe7K9XDGgUZmi8AmFRTQvQV5QDD3LE0aXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLth4naNLzOToxIFWCEhllYjW8RY9Zhhwez3PVvg/FvFGay8Zj9jmHkQvaKBYmki3
	 P0EO3qJeNchBxXLAzMs218fSAuonXjDyRlwrPw7MrDmJ4fKfWZgrUupIYU8zuZKU4k
	 hu6brwc8SuTAh1r0JMpl462xysLLVnlMbrcOO+8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0127/2214] wifi: ath11k: validate regulatory capability phy_id
Date: Wed, 18 Nov 2026 15:30:03 +0100
Message-ID: <20261118150015.313337607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit f8729a40ebcc94d164be8f154483a21669f3ab52 ]

ath11k_wmi_tlv_ext_hal_reg_caps() copies firmware regulatory
capability records into soc->hal_reg_cap[] using reg_cap.phy_id as
the destination index.  The loop count is bounded by num_phy, but the
phy_id embedded in each record is not checked against the fixed
MAX_RADIOS-sized destination array.

Reject firmware records whose phy_id does not fit soc->hal_reg_cap[]
before copying the parsed capability.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260704011040.26233-1-pengpeng@iscas.ac.cn
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 46110169b7272..cd3a1213b6e65 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4106,6 +4106,12 @@ static int ath11k_wmi_tlv_ext_hal_reg_caps(struct ath11k_base *soc,
 			return ret;
 		}
 
+		if (reg_cap.phy_id >= ARRAY_SIZE(soc->hal_reg_cap)) {
+			ath11k_warn(soc, "invalid reg cap phy_id %u\n",
+				    reg_cap.phy_id);
+			return -EINVAL;
+		}
+
 		memcpy(&soc->hal_reg_cap[reg_cap.phy_id],
 		       &reg_cap, sizeof(reg_cap));
 	}
-- 
2.53.0



