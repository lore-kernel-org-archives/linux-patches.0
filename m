Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA72214813;
	Wed,  7 May 2025 19:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645162; cv=none; b=NaAYhZSZ3+d7NGZ3Z+uqxnaqwQUks34f7MNiMq9U05Dn8JoTdTgC8SF6XL9iiTh/vc3nQMDGfhXOCYwz8mePSE+ZspD6OOTffwHIqDLCVs+oUuFSGyB1Qnv7kxV4dncQGYOKmSVHMbRSozkvvdhB996oYhTOeSMAPADbzStxQP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645162; c=relaxed/simple;
	bh=g24xPwGH3NtOk4kyhkoCjftbVVpXg1FepOpkGcZBRQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLqc71M7Xuss8MNX92YZ8J44H2MmqTmv/3+cKbv3+tNxYku9z2wZcvfTHJUcZFA2QeEmEPIH6fuMmvDHyKFIOEGXgOOKt1U3hNN0cPZ2RTOOecL2mUR8IhKoFIam2FHTFrplbMR8FPH3sNdvnD11KFF7wUGjqiPD1ObjxRHPPxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXCL1k3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXCL1k3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595DCC4CEE2;
	Wed,  7 May 2025 19:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645161;
	bh=g24xPwGH3NtOk4kyhkoCjftbVVpXg1FepOpkGcZBRQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXCL1k3yBfrbYX5rtlJFFR3uTIK3aBzCc4O8laZhg0n45X8QY8IAOWOrLNl5Y9q6O
	 oQc21UdOVgVC9cRmsjZi8ktuyPPVn5qNN8r3/pj6J0fHU2bPMG7zPAbwRLnINyppof
	 SRCmSjMy/15GxuD5djFF4nVfhIfIO3mcn45KyEkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/129] xhci: Clean up stale comment on ERST_SIZE macro
Date: Wed,  7 May 2025 20:40:48 +0200
Message-ID: <20250507183818.132102546@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit c087fada0a6180ab5b88b11c1776eef02f8d556f ]

Commit ebd88cf50729 ("xhci: Remove unused defines for ERST_SIZE and
ERST_ENTRIES") removed the ERST_SIZE macro but retained a code comment
explaining the quantity chosen in the macro.

Remove the code comment as well.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20231019102924.2797346-11-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: bea5892d0ed2 ("xhci: Limit time spent with xHC interrupts disabled during bus resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 76a3010b8b74a..a49560145d78b 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1423,12 +1423,7 @@ struct urb_priv {
 	struct	xhci_td	td[];
 };
 
-/*
- * Each segment table entry is 4*32bits long.  1K seems like an ok size:
- * (1K bytes * 8bytes/bit) / (4*32 bits) = 64 segment entries in the table,
- * meaning 64 ring segments.
- * Reasonable limit for number of Event Ring segments (spec allows 32k)
- */
+/* Reasonable limit for number of Event Ring segments (spec allows 32k) */
 #define	ERST_MAX_SEGS	2
 /* Poll every 60 seconds */
 #define	POLL_TIMEOUT	60
-- 
2.39.5



