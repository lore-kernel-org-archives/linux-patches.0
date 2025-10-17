Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D5533290B;
	Fri, 17 Oct 2025 15:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715611; cv=none; b=qN0M3FGEsPJwZIERLepWxr2zLMXpE8LsEZ3Wj7/AOapIL9kLPlFggiVPzqW2SgYalvRIPH3pAcp8cqGJrhKOjLHcd8UKGcyZgFB2pCqut45/eRfAc6HmPb5tyM730oA4woebxZTFQrvSu+ICvjuIOr6SOud+fOcGiLgMfcnyp9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715611; c=relaxed/simple;
	bh=1A2S8ghDJ8TW+ZRqaSS27HQUcka5Nny7bzp2xI/ujtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKxc6SJA9d/zYsVBQWOye7iJi3CVRhvel+plcYJTG+rMNW50iBYiOLUcbZ+EnQHBBk4U4TcmTW5/ygSdtqYL3rOEiiBUVCEqnqQ867m5E6olsnAC/F5YanupHk2WT9XzxEATTPiDoLCoNXwnAhKl5hBn7le5g/dbXfgORnT8yuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ldn704uU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ldn704uU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA30C4CEE7;
	Fri, 17 Oct 2025 15:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715611;
	bh=1A2S8ghDJ8TW+ZRqaSS27HQUcka5Nny7bzp2xI/ujtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ldn704uUWAu0MxwLhg8Mi8FDPi8t9bUpVmdnBUmZqEW1dr0/FYpNAO8hpgrtAVxfm
	 YYppBoSWhs28GzQXD4yAJltMgep5bwgHTrWoW8RXRXCdpld86BMyogp4BWuyoBYdLb
	 cH8Gd1ycERY3tTOneEdlqF+amRJxJGANBm951Mqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.17 269/371] memory: stm32_omm: Fix req2ack update test
Date: Fri, 17 Oct 2025 16:54:04 +0200
Message-ID: <20251017145211.809442628@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrice Chotard <patrice.chotard@foss.st.com>

commit d140f3ba76ac98faad7f9b37ef5a3dcbd57f59e2 upstream.

If "st,omm-req2ack-ns" property is found and its value is not 0,
the current test doesn't allow to compute and set req2ack value,
Fix this test.

Fixes: 8181d061dcff ("memory: Add STM32 Octo Memory Manager driver")
Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://lore.kernel.org/r/20250807-upstream_omm_fix_req2ack_test_condition-v2-1-d7df4af2b48b@foss.st.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memory/stm32_omm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/stm32_omm.c b/drivers/memory/stm32_omm.c
index bee2ecc8c2b9..5d06623f3f68 100644
--- a/drivers/memory/stm32_omm.c
+++ b/drivers/memory/stm32_omm.c
@@ -238,7 +238,7 @@ static int stm32_omm_configure(struct device *dev)
 		if (mux & CR_MUXEN) {
 			ret = of_property_read_u32(dev->of_node, "st,omm-req2ack-ns",
 						   &req2ack);
-			if (!ret && !req2ack) {
+			if (!ret && req2ack) {
 				req2ack = DIV_ROUND_UP(req2ack, NSEC_PER_SEC / clk_rate_max) - 1;
 
 				if (req2ack > 256)
-- 
2.51.0



