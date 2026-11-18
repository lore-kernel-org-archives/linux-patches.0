Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016570;
	b=xKgZcjMzoEYtzFihw4Xwl2Go0zJdRucm/4H8ADEAJiK+e8QokQJusGHtzXsBHURBv3/b
	 KqZq1jDwgqzMy6tqpmkcTqDNzMReMksh4C2ZPScs0K68oYNgXTk0+AEOdI1ZBq5ZcujWu
	 JrRDf5sbDg7DB9okN2hoUQCrZJ53jYvtHyrpkAW2f8kigyYwFmBTw8ytPtJw6f49cKimR
	 OanJxN1Wkynea/sQAAohU7R34UyuMninr5J1rA/Fp4faoerSieonGw97gEV0hN9N92a3h
	 faCh9AnpuNlDoE5TFNFfgl90aADEaLBb3DyLSJJLKHxx4zx9+R+C3lLbxB++lipTV0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e6RH2nUe8x45sOQ6ImpaAjBpQdAO34xaA3kibQVC7qI=;
	b=P1SqNgtpgtv74sa3HrspKa2cqJ1hpbkFD801OAwnzD4jJx0ll329QnEB3XrQP4sRsgx+
	 2z79vkJGRzpd+zvMUNXuIgrqPxqcPHGZkv1PBCTUyW776+FY6HBypERFZK9DMl418fmFv
	 UQq2WSgzCt5EDNKn28D4ChOSNIZvRg6eIPAwpfIzZ/Gp5FjdQdWk4dWm1XHdcCeM6dP3G
	 ncfG83+aRjBCxAessxXLV2kThLxbQcM3+4EmYFy4MCblX9ehXqO0Geh4M2AOhW50X1+eT
	 yXP6p14X2zV0Qyj4ediDPzCwenNlKYk5V19HUzw7uz2LcC7UwtzxquuVIs0XQMh1IPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G62FIDht;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5306F60A2609;
	Wed, 18 Nov 2026 15:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G62FIDht
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0761F000C4;
	Wed, 18 Nov 2026 15:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016569;
	bh=e6RH2nUe8x45sOQ6ImpaAjBpQdAO34xaA3kibQVC7qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G62FIDhtbb0wGZ9newjRLpKY9CxZnSZA7y8vJgGjeui00Hln6J0vpRI3uQK4XgAJI
	 Eiop5/5aO3WJi1tMaj/0pCFsV4mhHr15iM5n2GglR3qp6+1nDq2ICLyN2s9eq/tAHA
	 XG0W3nFVhXGRJtWv3JIDA3uaruQoDv08Z20LQFx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0576/2651] interconnect: qcom: msm8976: Configure auxiliary GPU QoS port
Date: Wed, 18 Nov 2026 15:30:16 +0100
Message-ID: <20261118150308.470270283@linuxfoundation.org>
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

[ Upstream commit cc91c1b99101f2dcd2f624a27bec6f6f557e5421 ]

Enable the secondary QoS port used by the MSM8976 GPU node.

Assisted-by: LLM
Fixes: 6e3ea1f36b10 ("interconnect: qcom: Add MSM8976 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260909-topic-icc_rpm_smd_qol-v1-6-6dc5b5e97626@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/msm8976.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/interconnect/qcom/msm8976.c b/drivers/interconnect/qcom/msm8976.c
index c219dcfd43b6c..11100264ef691 100644
--- a/drivers/interconnect/qcom/msm8976.c
+++ b/drivers/interconnect/qcom/msm8976.c
@@ -454,7 +454,8 @@ static struct qcom_icc_node mas_oxili = {
 	.qos.qos_mode = NOC_QOS_MODE_BYPASS,
 	.qos.areq_prio = 0,
 	.qos.prio_level = 0,
-	.qos.qos_port = 16, /* [16, 17] */
+	.qos.qos_port = 16,
+	.qos.aux_qos_port = 17,
 	.num_links = ARRAY_SIZE(mas_oxili_links),
 	.links = mas_oxili_links,
 };
-- 
2.53.0



