Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA8F2D97BF;
	Tue, 12 Aug 2025 18:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022039; cv=none; b=jfUqz/CXLoVOthRsF6lgS+tM3K/p5pI+tg+d0lNjofK4BJeK1Ynb+Ikmr5/6KXxODLYlVr6T5lCitCPn2ABFeUMjX9b9rg5olfsP9SUjb1iSmj4BkqbcGfjpeVMAybh1neVPN3QKh5iJV+o9kUfNGEXa5PCGQpybUBP+bNSajUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022039; c=relaxed/simple;
	bh=dZurd/66WjPN6fXwFfQYY25O5f3mCXyL3YVUQKHDjq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PO9D5J4m0i5G5/jNzP3jeUOFaf++JQDRyP0ENbC8GrCnCMUO5a0V7CJpKAQr/FL+Pa4fWdpfiETei9Rlss2HVXQSlrnljgBkJSmjXMkghyaTCeeDdkugaboBJSf4vhkYKq65DKf9l/DCrrS8SWLfkfs674q45nbgFek2+zHQQSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rh1v0Q8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rh1v0Q8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC43C4CEF0;
	Tue, 12 Aug 2025 18:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022038;
	bh=dZurd/66WjPN6fXwFfQYY25O5f3mCXyL3YVUQKHDjq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rh1v0Q8J2C3u35++ndNRXZLI15n8s09Vv+/F7qPZXH3e1OSiqMig/AWjQTOYalpYF
	 tEZRKZkkfj1DkmRfgZmf2MvuTfXUvoe+FgWJi915G7VWlfn5zrXP7314TwLQtXNtZl
	 0K+lf2aC/URTLQ7AS4+BTBgRrqQk086rdOTnu4Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/369] usb: host: xhci-plat: fix incorrect type for of_match variable in xhci_plat_probe()
Date: Tue, 12 Aug 2025 19:25:27 +0200
Message-ID: <20250812173015.886910667@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3a9bdf916755..8cf278a40bd9 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -152,7 +152,7 @@ int xhci_plat_probe(struct platform_device *pdev, struct device *sysdev, const s
 	int			ret;
 	int			irq;
 	struct xhci_plat_priv	*priv = NULL;
-	bool			of_match;
+	const struct of_device_id *of_match;
 
 	if (usb_disabled())
 		return -ENODEV;
-- 
2.39.5



