Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB960217722;
	Fri, 17 Oct 2025 15:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714608; cv=none; b=d6hTiRi6n03x5HbPpM1wpjReTg+c9XqUfGNtZx0FKaGlmQ/B5uCnnVmTWDEUEjw5yzoN5K8XExZntJORFP9C2z1T+4/ZNCzOQNUYxzWCZPLrpyi9odwi79qxPzQJ9NkGcdd6wE6C+x3u1j4YyWGp1SMMnFkp0ZsUlaw8kXny5UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714608; c=relaxed/simple;
	bh=5bPAKVlUCU2QoUIehdc5YwOKV2EIInZ4XUQjDawJTHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ke/s+c5KeZmjGRhSoPmtSZx+q1m+MQMn580RY6ey8FfEgj0gSkyv59sYRkgiViUKYrx14M6zjwGPsvsfGoa7OVYeSF8IqRUEEVfOw2FDff/JGmOp5dOWoKavqssk2tVQXggPjYN/DfzEEuubAjvg1UA4tTdFOJo1TSKrkRiPB/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHLKwWzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHLKwWzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A50C4CEE7;
	Fri, 17 Oct 2025 15:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714608;
	bh=5bPAKVlUCU2QoUIehdc5YwOKV2EIInZ4XUQjDawJTHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHLKwWzOvfb622RJKBOj2bhcBfv+lxbm37vQQ4XqoZkf4vYWvFTskRHnhv7I9Z7Ql
	 gxvHMocHLmUbwQ5c2QF1GRKkVfpiP0pARx2SBh1fZBtN8dubp35dxs+wrxqFqkAy2Z
	 AcFxUZYP2288srYdYKkgRRiGsc3trGjXcNGHYqT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Morrow <morrownr@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 203/277] wifi: mt76: mt7925u: Add VID/PID for Netgear A9000
Date: Fri, 17 Oct 2025 16:53:30 +0200
Message-ID: <20251017145154.534810770@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Nick Morrow <morrownr@gmail.com>

commit f6159b2051e157550d7609e19d04471609c6050b upstream.

Add VID/PID 0846/9072 for recently released Netgear A9000.

Signed-off-by: Nick Morrow <morrownr@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/7afd3c3c-e7cf-4bd9-801d-bdfc76def506@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
@@ -12,6 +12,9 @@
 static const struct usb_device_id mt7925u_device_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0e8d, 0x7925, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7925_FIRMWARE_WM },
+	/* Netgear, Inc. A9000 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9072, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)MT7925_FIRMWARE_WM },
 	{ },
 };
 


