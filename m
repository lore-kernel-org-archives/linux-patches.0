Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329AB30FF1D;
	Fri,  9 Jan 2026 11:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959471; cv=none; b=WRWPH9mQw6GFqI2oHQu1/iyUiMO1cp5i6W40OfVjEFJMCBNdYlcPJykRqZQ8V9HWTUsi6Yq3moexsZA2Weknvot8B8ajUXB9DuWcL+kdjUYeIVW/IY9IMlIe1jdytCagilpnq21xJ+FX67TcLI+jyNoNh03evsZdJarHRM36Mzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959471; c=relaxed/simple;
	bh=cS1pACqQ+Tcv2HLolleqyzGvVD+3kZsnvaQ1Dr65Wtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0xQQX9ZFne9qT1A+sGrmk8fM4dn90AtlGT7tL3CUqRf4n4ayHTOb0ijJQKrBtSeXIwVQOPokcwSVg4ykxv/DTFFONs8bq/SOaN6zRxIUSJIokkFF8XcZnMN31Rrrk8jzmHh1KGl84aylP0tJQhABV6ng9HgfmyBWCB0ExXKp9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVtrDKWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVtrDKWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DF3C4CEF1;
	Fri,  9 Jan 2026 11:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959471;
	bh=cS1pACqQ+Tcv2HLolleqyzGvVD+3kZsnvaQ1Dr65Wtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVtrDKWhPHthvAudj4ANW8nbxvnSXNTqDln9bjG1XycZa9HxyVj1IrZCfiS97MBuy
	 u0qg8jwJwFmhAo4T49vyQnRvJkcPHPrcuwGUrYmO/z958ZNDb9lz981/fk326OSvgs
	 nXYTPfF6vxouolLjMetJKB5P1Nhui10aGi/PNjU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/737] irqchip/irq-bcm7038-l1: Fix section mismatch
Date: Fri,  9 Jan 2026 12:33:22 +0100
Message-ID: <20260109112136.369574447@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit e9db5332caaf4789ae3bafe72f61ad8e6e0c2d81 ]

Platform drivers can be probed after their init sections have been
discarded so the irqchip init callback must not live in init.

Fixes: c057c799e379 ("irqchip/irq-bcm7038-l1: Switch to IRQCHIP_PLATFORM_DRIVER")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-bcm7038-l1.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-bcm7038-l1.c b/drivers/irqchip/irq-bcm7038-l1.c
index 24ca1d656adc5..51d38a92ec200 100644
--- a/drivers/irqchip/irq-bcm7038-l1.c
+++ b/drivers/irqchip/irq-bcm7038-l1.c
@@ -219,9 +219,8 @@ static int bcm7038_l1_set_affinity(struct irq_data *d,
 }
 #endif
 
-static int __init bcm7038_l1_init_one(struct device_node *dn,
-				      unsigned int idx,
-				      struct bcm7038_l1_chip *intc)
+static int bcm7038_l1_init_one(struct device_node *dn, unsigned int idx,
+			       struct bcm7038_l1_chip *intc)
 {
 	struct resource res;
 	resource_size_t sz;
@@ -395,8 +394,7 @@ static const struct irq_domain_ops bcm7038_l1_domain_ops = {
 	.map			= bcm7038_l1_map,
 };
 
-static int __init bcm7038_l1_of_init(struct device_node *dn,
-			      struct device_node *parent)
+static int bcm7038_l1_of_init(struct device_node *dn, struct device_node *parent)
 {
 	struct bcm7038_l1_chip *intc;
 	int idx, ret;
-- 
2.51.0



