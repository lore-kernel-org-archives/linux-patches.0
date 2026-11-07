Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060790;
	b=sqA5uYi6nM8X/ZE1MPMYlQiN7VSw/qd3xy9ujV866prAFau7LmT2vm76cHzR9ZSimSZm
	 LGLQcmolhY0BYyy1I/qYR73Vmm24qUrSUreYlX2KShTKBCnMQ2A87vcrjKfQ2MZDym/hO
	 kCiMB0/oK9xagLidOkTwLUCFQZCfbcOYwz2kjSC2021J5LUNqaFYMAXTOaUVHvlJK3FuZ
	 RF39kXvThUyB3C12iFOfTUS/MmV4nUP72QtHtgiUg+sa4dMm1RjCLrKv3SNDH4zGKqArM
	 jnOgEi6xU1xnhTMicZ7jRKnM6BbhfMZ7Zu04X8GjN8m+SPfp5YD8v3pV2CxHTBySgZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hdnWm08/x37FubN3wyuJSzeO/6iXih+oQ7yDIMlWWTw=;
	b=3BhNjXjnzl5kjgDXrXMe2Gyj33/VVHO0brJm9UHLxkxbXhz8/K8Q9W+mrTab/CpT059l
	 5orCELGShWiSyP8TBP0Dj0Sit0UEQixNnYbe/zjjjvqVwJYujmDu9MeyeT7jepp23cyle
	 1IgAAFDWGMR7qeqUTQzEdGIWGi3/bVN+TAdv57jHyrbdx93+zqVkVi/lHwBzCXZMAVkF2
	 fScfcL3gIFyduVhpY3v117UtlNoci0NYn3orUpm/54trSC4J3onGAJkKr5u3lxPbayOH4
	 JdqKyU+PWASY/fWa3ao5P2YSb1/un1NMV2WaTQzbTxXPpjxuDfejV2XozFtxJChK3Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxtCgjjH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A47606A332;
	Sat,  7 Nov 2026 14:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxtCgjjH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AAA1F0089F;
	Sat,  7 Nov 2026 14:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060790;
	bh=hdnWm08/x37FubN3wyuJSzeO/6iXih+oQ7yDIMlWWTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxtCgjjHFmU/PVb8nyFHsxveZM2PjyynPGd0vqh/I4obkVuy0W5KzlChUTMTVkI3A
	 uOl1YWTDf5snKzu48TYXKg/QUrcATw6iyGnmebOkHIAr483wUL3VXvWbGhX7KC5DS0
	 FGOUXZ/XnpZpraTbz+pwmt9Eo3c4FMW8EXyWa7Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0193/1536] wifi: ath11k: validate regulatory capability phy_id
Date: Sat,  7 Nov 2026 08:36:49 -0500
Message-ID: <20261107135003.081638383@linuxfoundation.org>
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
index a184a7e3452c0..1911b4e50abb9 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4816,6 +4816,12 @@ static int ath11k_wmi_tlv_ext_hal_reg_caps(struct ath11k_base *soc,
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



