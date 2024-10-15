Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1591C07C4;
	Tue, 15 Oct 2024 12:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996984; cv=none; b=nToB1dC/gaKs8SI84tPvk0GlnWNx/ZHSiDaRbjXDAHqoJ8JN49YwGqMPY7izdl0n49WnBXjIkUD6ep1m+oFfbubh1bWMHz32EnCbTgv4XGiZuz9K9xkEVyX2ReBslujlda1biX6LPqM6UiMVKOghkYa8FSh1hYr9Wyw7Eex4F6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996984; c=relaxed/simple;
	bh=p+Xm0qpW/azoOq4GgRxVnYemDNX71zOj7r50Ncw7oIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnRkmFXIoKcYXIIPeW6V+SMmICI+ZW9g19n4g/qKkZP8wsZigyy2IuGjM91o7T+WWI7BUAuCKElEga7Ry2uWdrQum8mJ2I29K5y3oMHmsnYQ0CGkpjGT8upyR1nJHYvcudEih9GlrMKk75Q3JNsWGjBEhstUoXnxz94OAOzy+TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUVWf6hI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUVWf6hI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D431C4CEC6;
	Tue, 15 Oct 2024 12:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996984;
	bh=p+Xm0qpW/azoOq4GgRxVnYemDNX71zOj7r50Ncw7oIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUVWf6hIzZJTBFxeaF5wx2zjzC7Ltt4NqwaFzIrQN24OgLa5P3bo+AwflsMPPwUFc
	 BwkuDyZWEPx2PnEHsK21VQBOb4EBRhYAulTf9G3Klbf+OLprXABKvdMC78b6bfT1O/
	 NFTY82PrYxnr1uMGg5AitYae+/uGTMdZeZBuNP5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 056/518] usb: dwc3: Fix a typo in field name
Date: Tue, 15 Oct 2024 14:39:20 +0200
Message-ID: <20241015123919.174145065@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>

commit 02c1820345e795148e6b497ef85090915401698e upstream.

Fix a typo inside the dwc3 struct docs.

Fixes: 63d7f9810a38 ("usb: dwc3: core: Enable GUCTL1 bit 10 for fixing termination error after resume bug")
Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20230302150706.229008-1-vincenzopalazzodev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1053,7 +1053,7 @@ struct dwc3_scratchpad_array {
  *			change quirk.
  * @dis_tx_ipgap_linecheck_quirk: set if we disable u2mac linestate
  *			check during HS transmit.
- * @resume-hs-terminations: Set if we enable quirk for fixing improper crc
+ * @resume_hs_terminations: Set if we enable quirk for fixing improper crc
  *			generation after resume from suspend.
  * @parkmode_disable_ss_quirk: set if we need to disable all SuperSpeed
  *			instances in park mode.


