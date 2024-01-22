Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215E6664B6;
	Tue, 23 Jan 2024 01:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971661; cv=none; b=dYqNd2a0Rms0BlArfPoM+uq9ssM0Wk8+oaJa5heoer7AX9/ibnmw98vqtOy6FP8+PTwHB/qQGYRp0dSD+zPrD7sgOt/UllLyAkIjeGJQEzCjxssTQh3SkQL+08Ea7flsyqTgpIQvDcAvz6/WbH1a99/BUki7gV9ZvMAR0ulNnJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971661; c=relaxed/simple;
	bh=pnj4pouiZD+M/yKsSvFEFmIPK4mAgKm6d44MIkH2nYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3qrPOUabs90/vGIQWC7OoR83WNkE98Sd1QXlrOuXd/pfxF9AMFKjrUESMUyN8l4w/DHig0lVE6bqsbYtO9zwdgKdwGvx+vUF0hXMk1QcykFB9Lcfa3IZ7Iqk7KdfgcdGjZJUuycA3UzZPLFiCN2aBucDST68dkNDIXlowyKiC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmfXd1/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmfXd1/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C7DC433C7;
	Tue, 23 Jan 2024 01:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971661;
	bh=pnj4pouiZD+M/yKsSvFEFmIPK4mAgKm6d44MIkH2nYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmfXd1/Gc2Or2uNiqZtGJblF7fRfnMg2YRJwEzDKhRz5k/LwlPVeNWD4ADHDZb5BO
	 9iUT4T7hy7rpTYLQ8Zazrs/kqrIf5aufcrj68iZ/gAhhJU7DOjNjDr7VkdZy5o/jrV
	 cjiU8CpGmMiVVZf9bu1MWfw50yKPTBLaLjje3Z+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/286] dt-bindings: clock: Update the videocc resets for sm8150
Date: Mon, 22 Jan 2024 15:58:01 -0800
Message-ID: <20240122235738.906629975@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



