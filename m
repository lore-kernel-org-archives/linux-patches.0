Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829606;
	b=TxD0o1EhYBvil+0zVJVarhSpTAzmXuuzwBCl0anPZuQg8oRiQwouYruFLpObCsA1uMGv
	 RdiFJfxc9eyoE+HqEU49YRF2Kare9eVcZzr+pfZIGTwqWpR1Ajy/TBBww3hnQruB++J+F
	 6V4hJ8zCy9BJ6GD0ONmSBiYFCWm6NcK/NuW15rWYmd9w+N63oA3jOznxtnJUo7XMDT5nr
	 TvYPE0Zppj5jIwYqqld2GBz73esPO37lkqoQnABjImGSzWKH9nGDXYSgtuBWTbucua5PF
	 oOj29Xs8AMdPdS8kTB7nEoCrSixBRCn57Z4WlTjj5e4RVzPkV5+ilRMJMrCmSk2a/2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=98LzNV5fhHHaY7JM8J6Ad2kTAM+ck/CN5+PkC3IHaoQ=;
	b=Dj9g63z8Y4uvD6Zjw0ecP3EEtHT3Wq8ocFIjAOHs6kLatqcieDQEmtqJoQfk8JeWRFJw
	 nYkPtGKe4Og4K19c1c6Bg4R7XAFkUfi68FEZAUX3zemvmUI2Ebwcuddh7Hf6NN6kWBcAd
	 +CmqTv1G+pE8Uehy7YQlpkuCLzD6wJ+JbwYelgvR0NDzf2GdJ9Fu7tovqdzOiBSzgOyEM
	 suSHK+syBsrkLWuUCjT1f4WtzULdU4QWR3XyBRIr5mzUsF8bn9MyFooC/VEZLkOrV/Xai
	 TIBoAFLeiKtCHLQkaL66Qa6K+4OGa4wsW0hppppvBSeCq7MIZXDVdbmPnmnk1v3WiWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bO2nv2BU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D7F6075DD3;
	Wed,  4 Nov 2026 22:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bO2nv2BU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CAF1F00A02;
	Wed,  4 Nov 2026 22:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829605;
	bh=98LzNV5fhHHaY7JM8J6Ad2kTAM+ck/CN5+PkC3IHaoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bO2nv2BU+muewMzMgxZ9hU3ZbP6omVPqNjul+GMxtzdm+RcPw7LTcLS0JOVGHs5F8
	 GZ2XnKiO6VNYkQvmAcWifKK8Am/UZC/oU6aVr39ErlulAbOb28Kh33u4KRtjal60vN
	 xKzB32hi1ZA4xwbfhLoJBiuo6JrWSnRKBpVV6IiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0231/1005] wifi: ath11k: validate regulatory capability phy_id
Date: Wed,  4 Nov 2026 15:59:24 -0500
Message-ID: <20261104211050.315430681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 3305ec66ddbf2..c6b9e84b169c9 100644
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



