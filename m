Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EC235DA40;
	Tue, 21 Jul 2026 19:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662389; cv=none; b=nWZIBozwlJ2xSt+zjVRCj4ZDYNErvxTFRp95LnyiRyPo79GweZS/rF/RzkYuIERFn2vUGyLKnBYhLevkwf4yeDNJ//6HkAG0P/fYZl91jcXD4cAFx0T/4ZtelVLaXe/7cSn4j9DPKeUhYLJwQvElB4rcgDNBZFe36Uzy09qJSKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662389; c=relaxed/simple;
	bh=puni2tKkMfJBQmI53kSGiRgzSnbwNk4YhQ+aHrSTD6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W12ppWi+RUbntOfO1pT57/68kuXrh5qy75UQkZnXR7PWCq3NhlP/rtzQXp5aU33WCy19/I86vQmyrQiYtwJ2SAGEDvNiEiOPw5hSqYTARW1qBUJw/i+ZlkT2QLnoj54RtlRxIHI/isQiawuC9VBnpkJgpvUDsyY8vX7hEjKF+B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSZgnaYk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSZgnaYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F1A1F000E9;
	Tue, 21 Jul 2026 19:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662388;
	bh=dSwiMsC/r/rxkKSIk9QcpRZD5d5taRXfwB8jJ4IGvzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tSZgnaYk7INUNKIVAuqmJ7YNc59XKbrvRqRHShyTwAATF0MlmESHOqkzkjzPKB5Dg
	 4CAVd7vSrzwJ60Gs1kPRMoTQOHZ8njwD9FBPGrtE2Bp36g7SECHFWe6W5nRx3RLKTC
	 u6WwyNQqKG7JbdO3dgmCxk1S+CthdkpcGeBS2XSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0427/1276] phy: phy-can-transceiver: Check driver match and driver data against NULL
Date: Tue, 21 Jul 2026 17:14:30 +0200
Message-ID: <20260721152455.658388363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit ebee9004cc0200b2b708ebf7ac625d35c71c049f ]

Every platform driver can be forced to match a device that doesn't
match its list of device IDs because of device_match_driver_override()
so platform drivers that rely on the existence of a device's driver
data need to verify its presence.

Accordingly, add requisite match and driver data checks against NULL
to the driver where they are missing.

Fixes: a4a86d273ff1 ("phy: phy-can-transceiver: Add support for generic CAN transceiver driver")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260513220336.369628-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-can-transceiver.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/phy-can-transceiver.c b/drivers/phy/phy-can-transceiver.c
index ee4ce42496985d..95a02705bf2ad9 100644
--- a/drivers/phy/phy-can-transceiver.c
+++ b/drivers/phy/phy-can-transceiver.c
@@ -111,6 +111,9 @@ static int can_transceiver_phy_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	match = of_match_node(can_transceiver_phy_ids, pdev->dev.of_node);
+	if (!match || !match->data)
+		return -ENODEV;
+
 	drvdata = match->data;
 
 	if (of_property_read_bool(dev->of_node, "mux-states")) {
-- 
2.53.0



