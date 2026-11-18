Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043253;
	b=o9fjtqd6e5uDmol6wH54kX6jQnYzX64bSgctCP1JgXT3RkPRUIuS0FfWUXTnQ7zcHYiW
	 ja4jOLgwecqeUadKSI5XH9alnR3JHqv1HW7sYQwSKp4jpGS2xljLPKlA4QSr9WhWa9IwJ
	 CMMpOqJCIZo+WI/tZ3ietWrYxiEZU/26T3dzPdg0u0o6jZF40mXkoRsaCKSDDSHb3LRdu
	 BK3+DrVTpOlKkkrICiGyVzOfG2rh8U+thOTPnC/jbLcyAoztRgTthI8ug6Se6daPUC+T/
	 w3qELqYM6aXcGwSbnw+rUB9jzguxnlld5BNFcdSrpmMQDYhBUEYIfHEPzm0cS/CFUDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iLPaF6Ndnl0AQBHfKaKCwjM4ErfpeocnY4Bv/NUyFA0=;
	b=b8spr9rOoKvPaOECYVo787Qqxg2dvpGCxFmEfmPNM01IxPmSvV1gew5Ta5rQOFmuTTuc
	 FKG5umwJWRycJutcypdURhzfx98aNmykZioCBfm2zFZqzp4QRkSg2N866ZBRtP1OOmEUy
	 Uy7FiSi/Hrq+ybJ0YR9P87CHIYVgzp/+fH87xrtSkLorLianZGVMTkohYbSo7sj8gTMF+
	 9uA88WYScPzb3qvFSmqJPqrJLhzkcIWwYxAT6jbUNIji22Mhflz5tzALjKK8eXH+pZuwQ
	 8BhlgNGw87HEper8BQx1CiC6Tm/b38QBPt494YpHJdqt2rtNAueq9hNI6cJraeJy6vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dzheUYgp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58EE606A325;
	Wed, 18 Nov 2026 23:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dzheUYgp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A041F000C4;
	Wed, 18 Nov 2026 23:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043253;
	bh=iLPaF6Ndnl0AQBHfKaKCwjM4ErfpeocnY4Bv/NUyFA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzheUYgpNBEN8vUnwno5D7EshO/tpKwWAh20J59RhG36MxAl0cDJK5XoH1b8sLJv9
	 OYGr/boFw4Mu/1f+AbBx37ekXZDX1USNhzfjoz6CTRSuqOrc5lpb5HGfgO0IdS9LGL
	 iAiBh8D5VrV6Kzen+ekZMZWiEtJRWi+mT9Ge8CDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0143/2857] wifi: ath11k: validate regulatory capability phy_id
Date: Wed, 18 Nov 2026 15:19:37 +0100
Message-ID: <20261118150206.497396869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 579cd7a2d4279..8b218259ff895 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4582,6 +4582,12 @@ static int ath11k_wmi_tlv_ext_hal_reg_caps(struct ath11k_base *soc,
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



