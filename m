Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCF84E36F7;
	Thu, 17 Sep 2026 16:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663902; cv=none; b=Tl2ZO1C4Z8/6yVozl4xGwApjLqU5EH6d2KuX+mK0B8s7Rt9loU76tT/B1k/1raKTLLU3jNRBAz0GNiHkiQajJ1p5GBaC+MipgZovKkjedPY9ADqpTsshgSMH1VjK7ZyBa6Re9vWBGruLw2K83MeRmbULkNfv4j8c12XNAgoqJMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663902; c=relaxed/simple;
	bh=vng9JcahfHbhbSgPeV6+duOe+u6CSvn2TPpjqikQv10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKKQmkwiE2RjUO2A+7ZriKaCvs1t9D5j63P3cp8MnsDU2UYcyfSxMEwjJ6AChhJ0A4OkC1h2Ws9yzSBhmCdLx14+Alo+qyW0GB8FvfzCe9+3RU35RZ9AJPSVZ34dnkrl5cI63OCo6JhoBd4NgxcHr40XGNpTlEgE4zl0oLuwnzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czYjLzIR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czYjLzIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411BD1F000FF;
	Thu, 17 Sep 2026 16:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663900;
	bh=0k/22hgKZg5ydu/wmiRFGQl2okM+NBq3/ttx3ZyYqtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=czYjLzIR9Sid3Uyn7EopTGZsthgmdgiU60WjRNx5IW2wuK7hcvzLIXqSwrV0qVqHJ
	 06nELBOIOTCEmZhvU8z4B324UIYpD72XCdi8g1cqntsBE+XNK3YK6CVTcoCXx2aJUP
	 nsnr9mwRbTwvPLoeznHlFOoEp2Y5jZvWWZj/c/KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0192/1250] usb: host: add ARCH_AIROHA in XHCI MTK dependency
Date: Thu, 17 Sep 2026 15:59:47 +0100
Message-ID: <20260917151557.318391306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit ffeaf31f05d664581aa436d9cb92b4d1d8d301ce ]

Airoha SoC use the same register map and logic of the Mediatek xHCI
driver, hence add it to the dependency list to permit compilation also
on this ARCH.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://patch.msgid.link/20260519164903.31258-1-ansuelsmth@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index c4f17ce5c77b1..87103b868032d 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -71,7 +71,7 @@ config USB_XHCI_HISTB
 config USB_XHCI_MTK
 	tristate "xHCI support for MediaTek SoCs"
 	select MFD_SYSCON
-	depends on (MIPS && SOC_MT7621) || ARCH_MEDIATEK || COMPILE_TEST
+	depends on (MIPS && SOC_MT7621) || ARCH_MEDIATEK || ARCH_AIROHA || COMPILE_TEST
 	help
 	  Say 'Y' to enable the support for the xHCI host controller
 	  found in MediaTek SoCs.
-- 
2.53.0



