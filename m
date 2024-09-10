Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B64217BEAE;
	Tue, 10 Sep 2024 09:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961685; cv=none; b=QCqS5nPFfXsKV0n3PSq2Dx1WegiAJ+R48kxmeI6jeMcvzBSt0I5iIXtcWlS/NVDKE5D6hG7a4DBrfAO59Aq4M4b4rJASOj4O7okbvdHDEzqAzeBe/sTvXGnwk6PHIaS5c5CI0mdpcnZxZJ4kbXcuJOM3RdqVY0DuJ7jln812HAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961685; c=relaxed/simple;
	bh=5GUR8WRs3AN7I85GOaQ5o/4JLjGu36wN1IcJ+dmWdwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCtZPLggIqA7OhDlE5ms0G8433wGVzDqTpA9CtaUpJRxhEkq1EYDMfiXTzg7QXxcjSHfGQnoTtQEY0t2M1sle8zJO6wLb9aQBHjA4trQWQ3NMebVeGgIEqjU3HSZemGAEZrddWGgHjEGacdKbFSeyXCuqs9DPAtzsyow+fuoW1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tt9TjRwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tt9TjRwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9439AC4CEC3;
	Tue, 10 Sep 2024 09:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961685;
	bh=5GUR8WRs3AN7I85GOaQ5o/4JLjGu36wN1IcJ+dmWdwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tt9TjRwnZNEzT6u5jkhkNr4QkhPOVZfHYUdof45V0r8/bD2dZPKI4XdJVP1JEXBgd
	 NLvcW2gll3+XsGQhM6zlDkOwlEDnIUMbfIIHHs91EXIuxJZWoDnDXwtH4Yguggw9FA
	 q/nMbyR/xlAh4lSIaWsJvGnZ3DmCvfQjmTQtqqog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 153/375] can: m_can: Reset cached active_interrupts on start
Date: Tue, 10 Sep 2024 11:29:10 +0200
Message-ID: <20240910092627.611819852@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit 733dbf556cd5b71d5e6f6aa7a93f117b438ab785 ]

To force writing the enabled interrupts, reset the active_interrupts
cache.

Fixes: 07f25091ca02 ("can: m_can: Implement receive coalescing")
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20240805183047.305630-7-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 073842ab210d..e4f0a382c216 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1505,6 +1505,7 @@ static int m_can_chip_config(struct net_device *dev)
 		else
 			interrupts &= ~(IR_ERR_LEC_31X);
 	}
+	cdev->active_interrupts = 0;
 	m_can_interrupt_enable(cdev, interrupts);
 
 	/* route all interrupts to INT0 */
-- 
2.43.0



