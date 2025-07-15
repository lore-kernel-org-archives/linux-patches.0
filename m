Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAE92E7654;
	Tue, 15 Jul 2025 13:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587586; cv=none; b=bsICV6EzFnvm3nM3sP33XKrsKGPCXTu+IqnFNTogdkhHNJsMvLWiOJlYVq3sPdP+8zqiOVvO0EhBTz8ZjdBhSi89HO5Y2H9FYpOzdzdwpTZr/MaMcXkgf8TJ+WzBCTWl9EkO0f6qPA+aU/cB6XHrWiJ/1DBGBNyBW1sUX2rmP1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587586; c=relaxed/simple;
	bh=Z5pivog5AZqZZChm3Hdeioid7BBKSvQfufK6ucpzyQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oU+bx7EHf5E0aNuEpWCJ9bV8QKEWTzgXtbdfi0c9QRZsHsFvL4W5QQeV5F2QUnDSfBRb0UmzMzakgRGGpRN6EyAzV/IY2Lbw4g6i6Gonhh4Ohhs2A9/RT5XyJM/bBuFqYiu8cKKIwQye6QlQ0dG2ys5iFVGOdv+iP8sQIYryxAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ia0WjK7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ia0WjK7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB387C4CEE3;
	Tue, 15 Jul 2025 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587586;
	bh=Z5pivog5AZqZZChm3Hdeioid7BBKSvQfufK6ucpzyQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ia0WjK7vZbNTc6z17vFVD8mu3BnMJmNiKWO4yLim94sFJiyBTTg+QHSRA+Fw7y4Y/
	 r5gs06DL4H2chZfdwy0D0WROKXIzxwdrfXm8iY7/FSjM1B3NRzhJX9RHjRAp5hjXVq
	 gQyH7SmWQn3claariTICoJV7C6uWIP1y8+hjaoqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/208] usb: typec: tcpci_maxim: Fix uninitialized return variable
Date: Tue, 15 Jul 2025 15:12:15 +0200
Message-ID: <20250715130811.882294532@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Badhri Jagan Sridharan <badhri@google.com>

[ Upstream commit 7695cae24b29edd2dbd3b3a77a7264cd6d9ca67a ]

New smatch warnings:
drivers/usb/typec/tcpm/tcpci_maxim.c:324 max_tcpci_irq() error: uninitialized symbol 'irq_return'.
drivers/usb/typec/tcpm/tcpci_maxim.c:407 max_tcpci_probe() warn: passing zero to 'PTR_ERR'

The change fixes the above warnings by initializing irq_return
and replacing IS_ERR_OR_NULL with IS_ERR.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20201029063138.1429760-11-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 0736299d090f ("usb: typec: tcpm/tcpci_maxim: Fix bounds check in process_rx()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpci_maxim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpci_maxim.c b/drivers/usb/typec/tcpm/tcpci_maxim.c
index 723d7dd38f75b..6bf0d1ebc1fae 100644
--- a/drivers/usb/typec/tcpm/tcpci_maxim.c
+++ b/drivers/usb/typec/tcpm/tcpci_maxim.c
@@ -344,7 +344,7 @@ static irqreturn_t max_tcpci_irq(int irq, void *dev_id)
 {
 	struct max_tcpci_chip *chip = dev_id;
 	u16 status;
-	irqreturn_t irq_return;
+	irqreturn_t irq_return = IRQ_HANDLED;
 	int ret;
 
 	if (!chip->port)
@@ -444,7 +444,7 @@ static int max_tcpci_probe(struct i2c_client *client, const struct i2c_device_id
 
 	max_tcpci_init_regs(chip);
 	chip->tcpci = tcpci_register_port(chip->dev, &chip->data);
-	if (IS_ERR_OR_NULL(chip->tcpci)) {
+	if (IS_ERR(chip->tcpci)) {
 		dev_err(&client->dev, "TCPCI port registration failed");
 		ret = PTR_ERR(chip->tcpci);
 		return PTR_ERR(chip->tcpci);
-- 
2.39.5



