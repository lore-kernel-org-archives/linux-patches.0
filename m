Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2C133D6C0;
	Tue, 16 Dec 2025 11:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883925; cv=none; b=LQdinbxb2tro0PZ5Vr36RVRZnbJHX/dz8gleXC4T2/7aeZl17XoSAzXnwlxc5Ny7QRX44TlTxPk3QEbxWisKEpbdT6lpRtxrIXgPp7sY+qTCuKMFtuk+zG9tNqVGJp0S2ERQwJJ3+Uu0kpBv/BrotPnPOqupNTeZzqHM1wNgKPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883925; c=relaxed/simple;
	bh=zlPsRTRNPxQ2nXmWtAHtm1gNwvPSJBnqc57MWht2Qi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+/maGuaCcP2INbPXSBB4IvM88Dn+PJMH/BGbCdhvyn/3+7w9t3mW9Sgx0F1UWEq8GMWM3hhqD7cIFtE8oDhGCWUpz4FJgQ0qfsFBedwlysb8FklZlkrQ92hLV0UJIpZ8IeD5aUnIZxnbkQFEJz4/aH4Dql6rOJKvHFHUSbtdrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ED/Ezyqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ED/Ezyqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3EEC4CEF1;
	Tue, 16 Dec 2025 11:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883925;
	bh=zlPsRTRNPxQ2nXmWtAHtm1gNwvPSJBnqc57MWht2Qi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ED/EzyqeH/mCc8XqZY9dMAd38vRJXP5/PPQ8KPzTawmP9zxbjXTQbGNwY2dnZYRSG
	 TkczxEv1xwqW0piN6f9RxumrSMkXSO5SXEYexf6bcWWHkp7fn45VEnoho7nA9ie8sM
	 ZN6fVwRC1czlHEXu8QBLDW5EDJPcL9IDlZWjrWu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/354] dt-bindings: clock: qcom,x1e80100-gcc: Add missing video resets
Date: Tue, 16 Dec 2025 12:10:07 +0100
Message-ID: <20251216111322.366741646@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

[ Upstream commit d0b706509fb04449add5446e51a494bfeadcac10 ]

Add the missing video resets that are needed for the iris video codec.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20250709-x1e-videocc-v2-4-ad1acf5674b4@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 8abe970efea5 ("clk: qcom: gcc-x1e80100: Add missing USB4 clocks/resets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/qcom,x1e80100-gcc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/dt-bindings/clock/qcom,x1e80100-gcc.h b/include/dt-bindings/clock/qcom,x1e80100-gcc.h
index 24ba9e2a5cf6c..710c340f24a57 100644
--- a/include/dt-bindings/clock/qcom,x1e80100-gcc.h
+++ b/include/dt-bindings/clock/qcom,x1e80100-gcc.h
@@ -482,4 +482,6 @@
 #define GCC_USB_1_PHY_BCR					85
 #define GCC_USB_2_PHY_BCR					86
 #define GCC_VIDEO_BCR						87
+#define GCC_VIDEO_AXI0_CLK_ARES					88
+#define GCC_VIDEO_AXI1_CLK_ARES					89
 #endif
-- 
2.51.0



