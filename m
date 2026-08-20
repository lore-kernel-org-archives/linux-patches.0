Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B519F47DD48;
	Thu, 20 Aug 2026 16:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244439; cv=none; b=uTlNYiNGAj2SqsZdTLqo2vgC/M+WDq4TfImrt9JfwO/vWLwDNXO3uZOwBKAq8mM+eKrF2ysKDxsRB3a9v/rNa73wmIRHAdhlNPq+JzW3oRDFkMSIxgKzwit8u+E4itfOHAqdiJ/u4rHYDrkYN0E7GWNAZctCQazJVEcAIc4pRuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244439; c=relaxed/simple;
	bh=RMwjlhR+ASC8hrxdWXFYtwmQwXBKN7vf8wi878JvbpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7SHeXyG49dZIhUbgCxPqtrNeK4eqRqTgk1N4gxrNQvw1zUuea9Cb0VcInoOnB34RSxEJHdIazXpsq707m3MEkqe/SBQ2UPg/A8RfseJl/FD7h0OtcmV2BGJKWnOemZhAVEuYR9f13u4NIR1LIiAdR2nv3KPdcUjbv51DRx4VMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjBJEcVs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjBJEcVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5F61F000E9;
	Thu, 20 Aug 2026 16:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244438;
	bh=1MX54q2O3J6gIlvSnu12mCuJL3yZoYzRv8mSFs2HOH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjBJEcVsuo8I8ss3SaAJw1wgH3H6ndVXVUcrm+jXQMF0wuxgBAEznhFm6Uu1DLAxw
	 PhyWYXL/bg1vuc3ATBA4mhPxcFNSVjfLAMafoKoVZzdzRMc3NLrPOciYuAAOnQ1MqN
	 /zClUf+APrz7HwoQDncVcjmWsAZ2pEbyPPQqdAuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/235] serial: 8250_mid: Remove unneeded test for ->setup() presence
Date: Thu, 20 Aug 2026 16:56:44 +0200
Message-ID: <20260820145221.597454918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 324facd1ccb353a213ea2c2785604f2507f79297 ]

All supported platforms by this driver require ->setup() and ->exit().
Remove unneeded test for ->setup() presence.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220215101111.47250-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 7fb13fd7e9a5 ("serial: 8250_mid: Fix NULL function pointer dereference on DNV/ICX-D/SNR platforms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mid.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/8250/8250_mid.c
+++ b/drivers/tty/serial/8250/8250_mid.c
@@ -319,11 +319,9 @@ static int mid8250_probe(struct pci_dev
 	if (!uart.port.membase)
 		return -ENOMEM;
 
-	if (mid->board->setup) {
-		ret = mid->board->setup(mid, &uart.port);
-		if (ret)
-			return ret;
-	}
+	ret = mid->board->setup(mid, &uart.port);
+	if (ret)
+		return ret;
 
 	ret = mid8250_dma_setup(mid, &uart);
 	if (ret)


