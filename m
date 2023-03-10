Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF238821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C74C4339B;
	Fri, 10 Mar 2023 14:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460141;
	bh=dIfUaTX4+2FYgIWui3EoZeecaamXQdEPJOtt7ji54b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHWmcKeK2wtN+Dmpkmb0Kt21hUco5VMBdAe4TN75gm2OrdElBMdyVFzHqWkyZkFw4
	 P4inhThJnPYWZl0+QFpktI6RYw6io5IUw2vL9cCkP5HVtF07saPg3I4RNEdHaDABXH
	 n95AzmcIQof3QLiFIAp7y9hzrMriZldvR91wfINQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Mattijs Korpershoek <mkorpershoek@baylibre.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 236/529] Input: iqs269a - increase interrupt handler return delay
Date: Fri, 10 Mar 2023 14:36:19 +0100
Message-Id: <20230310133815.926529901@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit e023cc4abde3c01b895660b0e5a8488deb36b8c1 ]

The time the device takes to deassert its RDY output following an
I2C stop condition scales with the core clock frequency.

To prevent level-triggered interrupts from being reasserted after
the interrupt handler returns, increase the time before returning
to account for the worst-case delay (~140 us) plus margin.

Fixes: 04e49867fad1 ("Input: add support for Azoteq IQS269A")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Link: https://lore.kernel.org/r/Y7Rs484ypy4dab5G@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs269a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/iqs269a.c b/drivers/input/misc/iqs269a.c
index ea3c97c5f764f..ea3401a1000f0 100644
--- a/drivers/input/misc/iqs269a.c
+++ b/drivers/input/misc/iqs269a.c
@@ -153,7 +153,7 @@
 #define IQS269_PWR_MODE_POLL_SLEEP_US		IQS269_ATI_POLL_SLEEP_US
 #define IQS269_PWR_MODE_POLL_TIMEOUT_US		IQS269_ATI_POLL_TIMEOUT_US
 
-#define iqs269_irq_wait()			usleep_range(100, 150)
+#define iqs269_irq_wait()			usleep_range(200, 250)
 
 enum iqs269_local_cap_size {
 	IQS269_LOCAL_CAP_SIZE_0,
-- 
2.39.2



