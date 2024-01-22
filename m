Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DF24E1AD;
	Tue, 23 Jan 2024 00:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971383; cv=none; b=mLstWytdM90ILTlO7M1qm1OYJSlRb+/Q5raDCf955EnBwHDSDY5iaw+Bc2vcWUvIYNyWvCSISMqzjiERMbSBQvtuAQDxRLzHwlh9LqzitQltrVag3Y0x23qftQ//aioIcBe3cWTuLPiCBa1cLHmR57MQ+uhyczCgOu4BLSZUPxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971383; c=relaxed/simple;
	bh=+fIvsgkVJgS64TAIyjqNwXz6qO2hYgnGudANt2C5OXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pj8ZQJ6NmQSxs1bl2SUq4vR+DeXPJndK6JDBicKQj/oIQze0f+XN+uj8SiKXagLn4/bmcK6wfzgKo2K/sYz3AH0i0pcqiJo4YFK/IZebx0njizrSJsQjz6mgZM708lVcVztn1xR3CLuZNsmHa78/RYH/LM4xo6/7gk60DHX7Caw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQr2qmVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQr2qmVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08407C433F1;
	Tue, 23 Jan 2024 00:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971383;
	bh=+fIvsgkVJgS64TAIyjqNwXz6qO2hYgnGudANt2C5OXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQr2qmVNlJI1GrFKd3EL58xIuWkb26dGb2fqmu3bYx+Iqnu1ygeQuuafVllKCLiPB
	 9eDONXeA20gM6F0zZMcoi50TGYYzykCfC0f8ut+g25AfmirXdaO6J8Ch4pc25KlOXG
	 Bxv9lqD8DSyjrgUDtNTEm9FqIxpE9v57XjcAF05E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 215/417] dt-bindings: clock: Update the videocc resets for sm8150
Date: Mon, 22 Jan 2024 15:56:23 -0800
Message-ID: <20240122235759.373006375@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



