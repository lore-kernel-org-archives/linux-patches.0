Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEEF2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F81FC433EF;
	Tue, 18 Apr 2023 12:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821562;
	bh=BqMtq36f+7HGvPLAXLGwZSOUfHS2pj7KmuFL9BlVbdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHmavKG3DSQw1VKLg/xvSxMgoo0NqnBAQGDwqc4UYijHy4++pDJBNg6vTkXedu5H4
	 6uRYsz9KD0qqPVBGBIaloOjtFG9kCFdBC7Y+SfzQDVQCfGgBXzipgfljlMQgokV5wx
	 OfHXOE40BlM/JxiJqfVGu7odhOuKSUIzrlOVGnJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	William Breathitt Gray <vilhelm.gray@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 49/91] counter: stm32-lptimer-cnt: Provide defines for clock polarities
Date: Tue, 18 Apr 2023 14:21:53 +0200
Message-Id: <20230418120307.279136448@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: William Breathitt Gray <vilhelm.gray@gmail.com>

[ Upstream commit 05593a3fd1037b5fee85d3c8c28112f19e7baa06 ]

The STM32 low-power timer permits configuration of the clock polarity
via the LPTIMX_CFGR register CKPOL bits. This patch provides
preprocessor defines for the supported clock polarities.

Cc: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/a111c8905c467805ca530728f88189b59430f27e.1630031207.git.vilhelm.gray@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 00f4bc5184c1 ("counter: 104-quad-8: Fix Synapse action reported for Index signals")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/stm32-lptimer-cnt.c | 6 +++---
 include/linux/mfd/stm32-lptimer.h   | 5 +++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/counter/stm32-lptimer-cnt.c b/drivers/counter/stm32-lptimer-cnt.c
index fa7f86cf0ea32..a56fbe598e119 100644
--- a/drivers/counter/stm32-lptimer-cnt.c
+++ b/drivers/counter/stm32-lptimer-cnt.c
@@ -140,9 +140,9 @@ static const enum counter_function stm32_lptim_cnt_functions[] = {
 };
 
 enum stm32_lptim_synapse_action {
-	STM32_LPTIM_SYNAPSE_ACTION_RISING_EDGE,
-	STM32_LPTIM_SYNAPSE_ACTION_FALLING_EDGE,
-	STM32_LPTIM_SYNAPSE_ACTION_BOTH_EDGES,
+	STM32_LPTIM_SYNAPSE_ACTION_RISING_EDGE = STM32_LPTIM_CKPOL_RISING_EDGE,
+	STM32_LPTIM_SYNAPSE_ACTION_FALLING_EDGE = STM32_LPTIM_CKPOL_FALLING_EDGE,
+	STM32_LPTIM_SYNAPSE_ACTION_BOTH_EDGES = STM32_LPTIM_CKPOL_BOTH_EDGES,
 	STM32_LPTIM_SYNAPSE_ACTION_NONE,
 };
 
diff --git a/include/linux/mfd/stm32-lptimer.h b/include/linux/mfd/stm32-lptimer.h
index 90b20550c1c8b..06d3f11dc3c9f 100644
--- a/include/linux/mfd/stm32-lptimer.h
+++ b/include/linux/mfd/stm32-lptimer.h
@@ -45,6 +45,11 @@
 #define STM32_LPTIM_PRESC	GENMASK(11, 9)
 #define STM32_LPTIM_CKPOL	GENMASK(2, 1)
 
+/* STM32_LPTIM_CKPOL */
+#define STM32_LPTIM_CKPOL_RISING_EDGE	0
+#define STM32_LPTIM_CKPOL_FALLING_EDGE	1
+#define STM32_LPTIM_CKPOL_BOTH_EDGES	2
+
 /* STM32_LPTIM_ARR */
 #define STM32_LPTIM_MAX_ARR	0xFFFF
 
-- 
2.39.2



