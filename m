Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033979;
	b=YjwfgXF6YI7A+bcMsgRSUElOTvyqYLp1CftfMnjjgW623gHNmlckfs1LXKZFMqXzuOFY
	 N1i+dr4dzqDTz1jbWPYxsyh7mT+lVxNJXpDBCd3TIgRM310cmmgxvNvmkj+4MVEjPG9wn
	 kSP+pgZWdOg93UPCliLdJKGGwyqARe+zLAaWzGWRdM4ZbA+yN7rSxhOR8nEHetDhUJdfI
	 PB4C3gbRSzccRIoxeFWFFhU870FykcA8T/TjjMMIc+fTQCn0C81ggHvHxWBfHMNbOPrsV
	 3cv3b8yD8zKvETf0tOBhTPyES9Z8YGTrJVDTEkxDejWLMPEPG2lfo4NXxNfAEvVKyuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6n6Taq2HksIMXWnMMZa8IE2AcxERzePWaSY7BMXg0T4=;
	b=lb/jTEEHOtnutKsuD2Yll7nkqDjI6rSiHC+zSBKaSeLjmOogSV2Pbe6KFhUJUDk/B6AV
	 JziiwgXkJvhAKTufsCbvMsCKzedECBzxiCWeO62DJlcPrVEvYgjzgEa8AHSDR1a9QIoOB
	 qpWkBmK7B8FLHRyuTVTHNqzGj2ftjPKUeIi47rFgcUTIG3BdmseQqV+xKNpYDow0xmvda
	 Th2n6J2eEJ0jjXTw2VsiqGX5CTrx510uA7CidQ+FapvGDw3fY3anrBtPLkN6HxDFjJ+Fv
	 aeWanRzyUkLNaAsynvxphh9D2B97NkX7gZVpH7wANkK6As0/cTsqFGEfEG0qDBQsW7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hvLb3NCJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A860606A32A;
	Wed, 18 Nov 2026 20:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hvLb3NCJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D61C1F000D1;
	Wed, 18 Nov 2026 20:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033979;
	bh=6n6Taq2HksIMXWnMMZa8IE2AcxERzePWaSY7BMXg0T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hvLb3NCJ/t+yMsogGXhbhXd0zGsTwuQ+uDtV5orLHUj9EsX1qVVDQEbxM9CBrxtq9
	 VrJ8EQKOuYO8sqzzRgSuwKdFLe9qUsoBolxWXqxrBgUXyNT2QldjTGpxBbgEKUAhYZ
	 X/EOGHXGheuNF+hBvq4SztolCcQJ1Y4WetkZPxhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0166/3318] wifi: ath11k: validate regulatory capability phy_id
Date: Wed, 18 Nov 2026 15:13:08 +0100
Message-ID: <20261118150319.591861822@linuxfoundation.org>
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
index 2fc9b7a86b8c6..3845f51b1ae5f 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4709,6 +4709,12 @@ static int ath11k_wmi_tlv_ext_hal_reg_caps(struct ath11k_base *soc,
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



