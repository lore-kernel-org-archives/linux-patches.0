Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7D226B2C8;
	Tue, 12 Aug 2025 17:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020853; cv=none; b=mrulHFmWqvwiQ6d0rFH6/NKq5ySUDzFt8R0wSp8hf2fEmLf8sSj7Zb7DGlopCvXzQov3ONqW/TtXzPHp2GopjxjAYx74hFMUb+f+j9Ft1fWP3tHg3IOl1Mz12+AyGO+xH5ATDK4dY3eInk6ymgPKl/nc0PRSND8Nwx9wl0xxdPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020853; c=relaxed/simple;
	bh=Ixv9V7KrEQ2ZUg3ix3nMzr0bDsjNpFCMxeJxi0KKIVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FthRyJ1++AGIvfvvGIad3ZxEaLzDxTHWkEwtb0XTxwp08qTXj43cUNC6r3GOq1cJh5NoiTXIGgQisoJFhJPcSbv6SCTuIbCddM9PcJ8xAzJwZO3eoUapDTf7ofqqRLhF4Ps+p31JewUS9qUunVmvrx7cCLAvLmqBQYlu4JAYMX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAnR39IZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAnR39IZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E08FC4CEF0;
	Tue, 12 Aug 2025 17:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020853;
	bh=Ixv9V7KrEQ2ZUg3ix3nMzr0bDsjNpFCMxeJxi0KKIVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAnR39IZvJuQXzqUy4gj1KGq3Tuzt49jHIuuuCqiOGh9PhOctslUUT6JDgpljWHyX
	 ysX2JvqYr/CfIahwTC12JYL1rqTq4gu94nLsJaHnTIXxNXG3C/xYew4cw3P3UTPs31
	 82PESmNJMenXOGUz6CwB1dd3eqGNW8T9iVGb0DMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/262] usb: host: xhci-plat: fix incorrect type for of_match variable in xhci_plat_probe()
Date: Tue, 12 Aug 2025 19:26:52 +0200
Message-ID: <20250812172954.001900272@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

From: Seungjin Bae <eeodqql09@gmail.com>

[ Upstream commit d9e496a9fb4021a9e6b11e7ba221a41a2597ac27 ]

The variable `of_match` was incorrectly declared as a `bool`.
It is assigned the return value of of_match_device(), which is a pointer of
type `const struct of_device_id *`.

Fixes: 16b7e0cccb243 ("USB: xhci-plat: fix legacy PHY double init")
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
Link: https://lore.kernel.org/r/20250619055746.176112-2-eeodqql09@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-plat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 749ba3596c2b..b350ee080236 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -149,7 +149,7 @@ int xhci_plat_probe(struct platform_device *pdev, struct device *sysdev, const s
 	int			ret;
 	int			irq;
 	struct xhci_plat_priv	*priv = NULL;
-	bool			of_match;
+	const struct of_device_id *of_match;
 
 	if (usb_disabled())
 		return -ENODEV;
-- 
2.39.5



