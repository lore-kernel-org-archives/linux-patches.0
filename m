Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229521CA8F;
	Mon,  1 Apr 2024 16:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988820; cv=none; b=UdYh5OVAbeRudURkCLo7SIuHCYz3nVO7HjDLz0W8QlhUF3NN1/xkMmG8RmsGU6JQWObAVotIlS63sc9gRa+XzhuFCVVSSQX+3zBYOsXTBGtbciZGLz5cneNXgQQ4iZh3Lh32A5HuEFOyBQcsYFmz0+qNSJvdxH6d0zEP+6Ti+C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988820; c=relaxed/simple;
	bh=zHTPkPzGPa5ZDc2ue5AaxnxO89hSXJsOBEgwDiNWdRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebeoAQPE4CNoOJJVw+1SrKxX3DAp6efkEVD0HkN94b5srHPgk0eBHkX/xwC9pYRLgpnKgoqyCmYVoyr1rOKKciT1Tnt89Se9Araj382NS0NoYByvvmg5OD+d4nY/eNbujHS+t/Tu69wFKDYS4WGHDWODT1ovLmpoUQTpM+LpMHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snwh/eI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snwh/eI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A12C433C7;
	Mon,  1 Apr 2024 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988820;
	bh=zHTPkPzGPa5ZDc2ue5AaxnxO89hSXJsOBEgwDiNWdRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snwh/eI/Vofu4iKwCZA55L6klMkUFRxoA9GyAGviTeDim6EoeH8qhNGI/LS4T/Fw7
	 fxhDbfzK2dQmm/u3s2dBf/0//qzxdlfakze2ZQY45SiSdrGeg/LypTxkZAeui9dqE/
	 O+JBnCAuHvQY4VWHSuDRPG10w22G1Yiy0CY1G2mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 298/432] clocksource/drivers/arm_global_timer: Fix maximum prescaler value
Date: Mon,  1 Apr 2024 17:44:45 +0200
Message-ID: <20240401152602.071700898@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit b34b9547cee41575a4fddf390f615570759dc999 ]

The prescaler in the "Global Timer Control Register bit assignments" is
documented to use bits [15:8], which means that the maximum prescaler
register value is 0xff.

Fixes: 171b45a4a70e ("clocksource/drivers/arm_global_timer: Implement rate compensation whenever source clock changes")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20240218174138.1942418-2-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/arm_global_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
index 44a61dc6f9320..e1c773bb55359 100644
--- a/drivers/clocksource/arm_global_timer.c
+++ b/drivers/clocksource/arm_global_timer.c
@@ -32,7 +32,7 @@
 #define GT_CONTROL_IRQ_ENABLE		BIT(2)	/* banked */
 #define GT_CONTROL_AUTO_INC		BIT(3)	/* banked */
 #define GT_CONTROL_PRESCALER_SHIFT      8
-#define GT_CONTROL_PRESCALER_MAX        0xF
+#define GT_CONTROL_PRESCALER_MAX        0xFF
 #define GT_CONTROL_PRESCALER_MASK       (GT_CONTROL_PRESCALER_MAX << \
 					 GT_CONTROL_PRESCALER_SHIFT)
 
-- 
2.43.0



