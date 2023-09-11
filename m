Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1D611715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F15EC433C7;
	Mon, 11 Sep 2023 15:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444931;
	bh=sQYf2cgNvQ13DDNyHbedCL+OCcuvnQSI1chG0JY5vdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpL6Pak9mSFFiRsgs554JMA0CbizWTCw/BKIjFB5uOzsTK7IJ/RbVsDar73nI6mxw
	 pJ78Ps1MsQOhkafOHfi/FMrfH8g4F/CqBeiLbdu9YJE6XDQqPglIWpYtKswyJ9sM3Q
	 xFyk1FjhPDS+6pivlTySB0686jT/LbG3AwJ3+ic8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/600] irqchip/loongson-eiointc: Fix return value checking of eiointc_index
Date: Mon, 11 Sep 2023 15:42:41 +0200
Message-ID: <20230911134637.395363092@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 2e99b73afde18853754c5fae8e8d1a66fe5e3f64 ]

Return value of function eiointc_index is int, however it is converted
into uint32_t and then compared smaller than zero, this will cause logic
problem.

Fixes: dd281e1a1a93 ("irqchip: Add Loongson Extended I/O interrupt controller support")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230811095805.2974722-2-maobibo@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-eiointc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-eiointc.c b/drivers/irqchip/irq-loongson-eiointc.c
index ac04aeaa2d308..3d99b8bdd8ef1 100644
--- a/drivers/irqchip/irq-loongson-eiointc.c
+++ b/drivers/irqchip/irq-loongson-eiointc.c
@@ -145,7 +145,7 @@ static int eiointc_router_init(unsigned int cpu)
 	int i, bit;
 	uint32_t data;
 	uint32_t node = cpu_to_eio_node(cpu);
-	uint32_t index = eiointc_index(node);
+	int index = eiointc_index(node);
 
 	if (index < 0) {
 		pr_err("Error: invalid nodemap!\n");
-- 
2.40.1



