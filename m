Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551BE6A03B;
	Tue, 23 Jan 2024 02:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975331; cv=none; b=n3TbPeGlufGUYz8qBYTM+mLRvBtj05cW2+G6Ewyy5cTA6gS/O6Qi23O/Xk9+uPCwwVUF9wsf2iLOKuOOBJB2vWtM3pClxCVcefL9r6waXM25le2YtP9bTSh7wMHvrvdF9IAWeGIbWSWmoomfM5Bmlkg3SJJVHV6ndIuHJc9JWBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975331; c=relaxed/simple;
	bh=YR5rpRPsa7zqZMJvazJAfbqyu09rqQI3/vyhSr92dzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WePxZfI1SD9goVYAiIzZvdHKmYvvbV4hd9wsxf04hJeBMtngXBDcRaiOSpDnU39Z/7sIXdAmWljq+3QKxR72nEazasFnMWxikIEmOeWlsyfs5OxN+DY4My60FKlJf/5E45N8XHc5DIStli6ovggmP6NMRI59zXk9NdnPQkU8DQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V77X7gFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V77X7gFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DECC43394;
	Tue, 23 Jan 2024 02:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975331;
	bh=YR5rpRPsa7zqZMJvazJAfbqyu09rqQI3/vyhSr92dzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V77X7gFh+VWjZQ3NQPad7E1UoO7HEVsgzyltjTe5xehfAIJWQMG4f+hPn5r1n2NYF
	 CwTAmiFVoUnB2SpDETggBqk7nae6A1QMySQ5hRNcE/MAC53zxgIk5sEG2bM/xOLPm+
	 9vshumRkM0VFM99VNR3QIRSX87JxXPAijXcgJneo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 294/583] dt-bindings: clock: Update the videocc resets for sm8150
Date: Mon, 22 Jan 2024 15:55:45 -0800
Message-ID: <20240122235821.010007775@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

[ Upstream commit 3185f96968eedd117ec72ee7b87ead44b6d1bbbd ]

Add all the available resets for the video clock controller
on sm8150.

Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20231201-videocc-8150-v3-1-56bec3a5e443@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 1fd9a939db24 ("clk: qcom: videocc-sm8150: Update the videocc resets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/qcom,videocc-sm8150.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/dt-bindings/clock/qcom,videocc-sm8150.h b/include/dt-bindings/clock/qcom,videocc-sm8150.h
index e24ee840cfdb..c557b78dc572 100644
--- a/include/dt-bindings/clock/qcom,videocc-sm8150.h
+++ b/include/dt-bindings/clock/qcom,videocc-sm8150.h
@@ -16,6 +16,10 @@
 
 /* VIDEO_CC Resets */
 #define VIDEO_CC_MVSC_CORE_CLK_BCR	0
+#define VIDEO_CC_INTERFACE_BCR		1
+#define VIDEO_CC_MVS0_BCR		2
+#define VIDEO_CC_MVS1_BCR		3
+#define VIDEO_CC_MVSC_BCR		4
 
 /* VIDEO_CC GDSCRs */
 #define VENUS_GDSC			0
-- 
2.43.0



