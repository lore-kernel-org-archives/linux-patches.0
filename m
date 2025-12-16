Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D853358A8;
	Tue, 16 Dec 2025 11:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884015; cv=none; b=HmWf39Eqf1slOicS77aLfxHxhfuDRzxI+0GmWTYRqlCjmkJrhB1o0nwh1H7BL/4mT6HUhhCIYp3ev8750PtRcAoyssNb1fle8N4UaYyKIfYeatSunl0hIoAyJbMR1YGKfMorV25tihEEPnkS5gaYZEeEat7N82k00HvwPcFiadM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884015; c=relaxed/simple;
	bh=U+46lR4LBPHA5uEgxk0y5ukYx/VgjemVyOk5W6Z6POU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Riym9zh5Pilrx7kGr4JV0Pc1vEQtb60c8NUuQzc1DBzs5/4mnZ2CLu5LO4Vb4qaPJ3EYf2curKfhVJFKJyu86ChI9DwwXq4aFY3BrgGk6/BKt9jpzaTJa17D7OM9gE8c9KTWcpQCpbf0x6Tbw5lJKEPKQ6ArOyYIjUtX0CBV4LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV8lUPPh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV8lUPPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8C2C4CEF1;
	Tue, 16 Dec 2025 11:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884014;
	bh=U+46lR4LBPHA5uEgxk0y5ukYx/VgjemVyOk5W6Z6POU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nV8lUPPh9TvPjWZ3/BZvCEhHOt1hG8fydfCAXyBpA9hW9zQOkfgPyeKk4yP2rUptY
	 /O61P7US5tF9GsehOCkW7LIAoCdmgu0d+6aZyBA3cNRIh/5A2aJutrTj0Sn+KeT936
	 UYnCxoGX/zZpS9Nc9ROS0AHybLN7cSbYKInoyzTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/354] irqchip/renesas-rzg2l: Fix section mismatch
Date: Tue, 16 Dec 2025 12:10:01 +0100
Message-ID: <20251216111322.149082177@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 5b338fbb2b5b21d61a9eaba14dcf43108de30258 ]

Platform drivers can be probed after their init sections have been
discarded so the irqchip init callbacks must not live in init.

Fixes: d011c022efe27579 ("irqchip/renesas-rzg2l: Add support for RZ/Five SoC")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index 99e27e01b0b19..d83dfc10ff49e 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -613,14 +613,12 @@ static int rzg2l_irqc_common_init(struct device_node *node, struct device_node *
 	return ret;
 }
 
-static int __init rzg2l_irqc_init(struct device_node *node,
-				  struct device_node *parent)
+static int rzg2l_irqc_init(struct device_node *node, struct device_node *parent)
 {
 	return rzg2l_irqc_common_init(node, parent, &rzg2l_irqc_chip);
 }
 
-static int __init rzfive_irqc_init(struct device_node *node,
-				   struct device_node *parent)
+static int rzfive_irqc_init(struct device_node *node, struct device_node *parent)
 {
 	return rzg2l_irqc_common_init(node, parent, &rzfive_irqc_chip);
 }
-- 
2.51.0



