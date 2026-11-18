Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057380;
	b=W/LH5kq6DXNx7jAr4wOLVjdkaHUb4SNrtVjs3SAW2+LztbzJBib8CX7YP+672n4Gqxg9
	 6nHG6yRIMjMBBu/s3q0wiSJ9b/KMkKyngDsfX/XEHQfJURBdB2kmDVkgfzYqWDbQqkFiQ
	 AZFmwlMLity5mfyd3pxF4Y1KHDlUjlNQQrznhFt6atz5Ceg67/LUss4rK1C7CRsnaMoxp
	 Oz4Uv8u1MmCuWuvv93MH0ongvFiGeY+KbSYekxcV0WCGdrHj+JLeuj5NELoEzyk0ba59i
	 6lPljGvhJKPr6ATn4FGAM5DTvVlOiT/JqLIMT6mgNwoMFk+dENXGPDhUPOPLuyEvyLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nRMJMDfPHcPxpEmeeAfY76N4qTD7DCWPz3PfRkLc9YQ=;
	b=NQOYm04/m9uYIHd8sQaAMx8kitBcWMM/ay/1tWb6bPJTw37QCa2Zln/DqlBAoWFM0LcF
	 BlFvH4in/Zls2wPsWI18pXCUr93Ap8OdpRHcqEXtFtrQwgUeC7Veh89zVNE4c56a9BXIg
	 Dil+sLmU7SgPhsQw1w3FFwvnXbfn1G5bBLpkrHMdknlVRSIsOqKV7yaxeTqPEpM88PYZf
	 dzcrGoPSL/YBXIYTtqF62fMQMShutFyGNgLB3AQ+tHKaCtSnezK09wyny7dKv5bwZTS+h
	 TmFcfh3UytCfVA44MaNjm7QOvxztS8adAsMMrJLP85eu6sQOQeTgyMgMtRPaUxO128w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u/mNr63j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B6A606A337;
	Thu, 19 Nov 2026 03:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u/mNr63j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3EA1F000C4;
	Thu, 19 Nov 2026 03:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057380;
	bh=nRMJMDfPHcPxpEmeeAfY76N4qTD7DCWPz3PfRkLc9YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/mNr63jUGRz/Y5e2uBPq7hnD11kJkKt78M60ddF9aqGIIvKplZ92O3f3JAiYf1ql
	 DzJTZlf0BD71EW9uXg+qTWADog21izjlLB79FkrgJ7Osjr16ynFKqYO6afmmcsXmOR
	 i8etGkJ1YZNe8pQw+dpaCV20FVr088PgeMZSJH0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0111/1848] wifi: ath11k: validate regulatory capability phy_id
Date: Wed, 18 Nov 2026 15:35:49 +0100
Message-ID: <20261118145915.658397301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6434d3ff0ac6d..19c0bb5ffa7ff 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -3703,6 +3703,12 @@ static int ath11k_wmi_tlv_ext_hal_reg_caps(struct ath11k_base *soc,
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



