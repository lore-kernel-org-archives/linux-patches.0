Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ADC4FDE41;
	Tue, 13 Oct 2026 12:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895500; cv=none; b=stOYQv+qg4pls1beanLrkv4DvcxtCuJ0GlDXLSk04WchWuUuQSkKJ1mu8e7XIxFEGTKmt7WAo0lJQ2NL6MF07AFb0anf/H+u6VIzVmk78Zwh8sA9UzY+a6O662Jn6DdA9lZZL203uvfe1y7KAdoLSeIEjxMP1BukIDrspdAMQng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895500; c=relaxed/simple;
	bh=waNkPDqS94BCnqx963dhcUGKG0AE62knMZYNdx5/zMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1Y5p7Vxq0MapxuIeB8GHKNDKhesA91kbxB65sfEDJCMAEqtEqPEJhrLz+wJ8XfM3jUtR/nwycCG9bb/YScRlu02VvjBLW0dTI64ZIXJ1gtbd3QS03Ut57AOO3tQAms8sCQ4FFV3yQQHb5lf00beJ3mdJ2OnDT2BjrF/bcuVjUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMvF3x5B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMvF3x5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554EF1F00898;
	Tue, 13 Oct 2026 12:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895498;
	bh=8PkHEJ9lBegmG8T7Gkhp2Ru4kCCWvHtdMAZjLyyNxW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMvF3x5BNbpN+tpSULsvnMFOjKLcdeNdB4b29kU3ahpHMKfDkvUJ5ZsNFs3Ijlp7b
	 jUm/WsuAOd2SGwmI0k7Lnjg1NI63yGeBkUjxPwXkhdEBCbtVFyRMdcB652vuum+Fx7
	 l2qGngZq79VttzkCT86a05DJUqaxZolVspq/mMaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/497] usb: ohci-spear: Remove unnecessary NULL check before clk_disable_unprepare()
Date: Tue, 13 Oct 2026 13:37:42 +0200
Message-ID: <20261013112914.899904389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit a891b9aebcc7406fe2f439d184bac3948fb08645 ]

clk_disable_unprepare() already checks NULL by using IS_ERR_OR_NULL.
Remove unneeded NULL check for clk here.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20250617042050.1930940-1-nichen@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b1b0f8bdbbc8 ("usb: ohci-spear: disable controller wakeup on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-spear.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-spear.c b/drivers/usb/host/ohci-spear.c
index 993f347c5c288..3192d7ce04fec 100644
--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -103,8 +103,7 @@ static void spear_ohci_hcd_drv_remove(struct platform_device *pdev)
 	struct spear_ohci *sohci_p = to_spear_ohci(hcd);
 
 	usb_remove_hcd(hcd);
-	if (sohci_p->clk)
-		clk_disable_unprepare(sohci_p->clk);
+	clk_disable_unprepare(sohci_p->clk);
 
 	usb_put_hcd(hcd);
 }
-- 
2.53.0



