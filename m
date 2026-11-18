Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016561;
	b=V0EC/6T5g0Ero0E1Z8oOxGqUivkyi3qlR6EzwEhfBPl11J5pVKm2rh4lerbMeImYxskl
	 yugcJR9BJe+EEZqi4II/zTFfg4rPR3HcZ7GTtsNroeBXqYTQM6GySfUFD/cHRnpVhetIp
	 QvLSaFSKOiHeXgqnAmaJn28TfdO1/OjsR5B7x6lLwYrd6+tJuzgqF9k2sfxGf+tR/9CBI
	 y7dRcblKQiQp2AFraBK0CbX1Uqem5pHb2lSFDVA6DK8iGti3u6mJ4kdQV75MSpyMElkC5
	 cGzGOv+wdJf4FFam83kMqGqbYna3193OIMALe2PIy5PvJ7gE8RiWSXcgC0fcmjntfqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wuveWfvcHN3KRoBvKcrlg8KV9UvKDgArd4ySQkcPvLw=;
	b=hqYV/YHQCB6fdvVFkoVRijUIuhOeKq8Zt3kmmAhwyfGwWkBsOEXzLhviLdiblDhr7Jxx
	 QwX2NNdbAOO11nsQGgVWAQtrUdccUxbUUEuuBOB2jYlO4UA5uz9Wp7Ey0HZYH+jajZ9+I
	 gY16gFvTr8QleI4AhQh/NtAriEhqgQNzl2N5ibthO4sDOjPQW8VZQi1Pff+KlyKltWyOo
	 bSszu/09OcCZmJpsBVZwYHk4ioQFBGX5Pa5fXavpYL6EARJKlEh9Zghc+nCnhMVj3wbXO
	 ibJsgPDURg7Xjisa+TBrMu82TRxz7ETZCOZSDUN5REfN7ibxZJjp1I2+x7HHKYcL1QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZClXmcX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CAA606A337;
	Wed, 18 Nov 2026 15:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZClXmcX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18621F000CB;
	Wed, 18 Nov 2026 15:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016561;
	bh=wuveWfvcHN3KRoBvKcrlg8KV9UvKDgArd4ySQkcPvLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZClXmcXOZLzfELawtg9IDxsFM5UiGXckwzZK4RXsAg7R1OHl/armp4qENHuZAbZ9
	 ubjuO0gK7QkD1DBBLhXRviPIDBT4DS6JjcHU8xWpyDpic+/c2p2Kx/RFL5JMgdlmDv
	 CRan+MIKedSGgj/AfllEkt3gw1M3hrjtA3ENcvbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0573/2651] interconnect: qcom: icc-rpm: Handle icc_link_create() failures
Date: Wed, 18 Nov 2026 15:30:13 +0100
Message-ID: <20261118150308.362440317@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit b2079a6b8e8b92c6c45a22930e5b68a9c5c34645 ]

icc_link_create() can return errors. Don't ignore them.

Assisted-by: LLM
Fixes: 30c8fa3ec61a ("interconnect: qcom: Add MSM8916 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260909-topic-icc_rpm_smd_qol-v1-3-6dc5b5e97626@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/icc-rpm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
index f571f002ccbd2..fa69418818d64 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -583,8 +583,15 @@ int qnoc_probe(struct platform_device *pdev)
 		node->data = qnodes[i];
 		icc_node_add(node, provider);
 
-		for (j = 0; j < qnodes[i]->num_links; j++)
-			icc_link_create(node, qnodes[i]->links[j]);
+		for (j = 0; j < qnodes[i]->num_links; j++) {
+			ret = icc_link_create(node, qnodes[i]->links[j]);
+			if (ret) {
+				icc_nodes_remove(provider);
+				clk_bulk_disable_unprepare(qp->num_intf_clks,
+							   qp->intf_clks);
+				goto err_disable_unprepare_clk;
+			}
+		}
 
 		/* Set QoS registers (we only need to do it once, generally) */
 		if (qnodes[i]->qos.ap_owned &&
-- 
2.53.0



