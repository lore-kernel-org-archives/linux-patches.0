Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEE47C6C0;
	Wed, 21 Feb 2024 14:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524326; cv=none; b=om8wrHtjLkwo5zZGOvRf62R0VHoMN14/zwGz6sy3YAlqcs8xrQb5stSwetHIJWvHjz8vtMHRL9L6CiCLWWAs4hGLHm/rX+lWN9VmcEKOyS77bRDub97VfBxN//O3oZ1w2hhb9DeA64P5/ztz6TD5YnvSRLx6m7nmXEbp2KmPUKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524326; c=relaxed/simple;
	bh=J8l4JK05Ou/CxZa335wf5JVfHg56LSGaEo/cxd9Hn0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvLX4XCPGs4Gevn8F6/Ph+DMt7e/bL6k2NIW5Xnv3jFW9dV33ltLs1/3u9i5851KBzXlfDlime8ehPhO995dVVshdjeinM7ZBZiLiBu7v9Ss3QJdL3/tWGHkPYaRb/0McIlnHqek3smJ6mAjUVAKbaqoPdQcYLHHXoiK0pOXW8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jznhORk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jznhORk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66ACAC433C7;
	Wed, 21 Feb 2024 14:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524325;
	bh=J8l4JK05Ou/CxZa335wf5JVfHg56LSGaEo/cxd9Hn0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1jznhORkD7OHkxZBLo7AU9xRVVPyoww35JVOtWLsC7r7eaH5bmiEg0MhMnQiPI3FL
	 0BJujUzYVekX5zF2tqAJjDTuBbnemm5nDD1/5n/5W7+bOjFh7QAjL5gIbVyPXsAJ0T
	 lsV0E9hPpyeqCRPK+7hB8itJoMA2N58Gmz7hdpnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hardik Gajjar <hgajjar@de.adit-jv.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 209/379] usb: hub: Replace hardcoded quirk value with BIT() macro
Date: Wed, 21 Feb 2024 14:06:28 +0100
Message-ID: <20240221130001.084278308@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Hardik Gajjar <hgajjar@de.adit-jv.com>

[ Upstream commit 6666ea93d2c422ebeb8039d11e642552da682070 ]

This patch replaces the hardcoded quirk value in the macro with
BIT().

Signed-off-by: Hardik Gajjar <hgajjar@de.adit-jv.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20231205181829.127353-1-hgajjar@de.adit-jv.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 331f41c6cc75..a3a7dd7d3326 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -46,8 +46,8 @@
 #define USB_VENDOR_TEXAS_INSTRUMENTS		0x0451
 #define USB_PRODUCT_TUSB8041_USB3		0x8140
 #define USB_PRODUCT_TUSB8041_USB2		0x8142
-#define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
-#define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
+#define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	BIT(0)
+#define HUB_QUIRK_DISABLE_AUTOSUSPEND		BIT(1)
 
 #define USB_TP_TRANSMISSION_DELAY	40	/* ns */
 #define USB_TP_TRANSMISSION_DELAY_MAX	65535	/* ns */
-- 
2.43.0



