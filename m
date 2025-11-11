Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FF4344031;
	Tue, 11 Nov 2025 01:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825255; cv=none; b=uADju4WAPSC0rnd7hYOhecgO+BcbhKZGTa+aTg/fDSt4y7EQesrBSNPTCUSfQPWf5prlbY1ewsZOvUdrh61SP2Rb2E5G+eHxu0DKMjghdHGUtWJL6+c/78kXDJXFRYd+bPctJYZciXq+en+d7WwsYDZBGmBCnnsK9SaPKZAEivo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825255; c=relaxed/simple;
	bh=6zNkdzcaf3cHNNUaNbRjB51nNx/I9vRHJ6aipbUrzzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqSPTthU/SmFy5cFBKug1Rr+7b3Prez5aqAXlorDBaBnMLGRLfOhLXf99lahk5kOd+/uzWgOo4sMgLnsLegf+X7aTTtQoPs5m3CE/xxPqhRWK/npwhP6QssvOLB7l3kw19Nr3B3Hb1AWJjp2iVUyL4RtGf0pttkz195rZ0gPWRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLpcK0sB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLpcK0sB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B3AC2BCAF;
	Tue, 11 Nov 2025 01:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825255;
	bh=6zNkdzcaf3cHNNUaNbRjB51nNx/I9vRHJ6aipbUrzzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLpcK0sB6zpOqfEuZwlmsMl+VwZKb68m3lO6oGddCyr4NO2yEsHGUOITxvdj+0Irh
	 Liw7ze4JkLgx4+6Y7/8+JnjvqfTGUv/61u54aBH6vFM7V2+TzGKXeA6bvoIYhZHd83
	 a9OlQDqQGi64oBmqQ9zGV2YCBXqngKmzj0CBQFkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sammy Hsu <sammy.hsu@wnc.com.tw>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 727/849] net: wwan: t7xx: add support for HP DRMR-H01
Date: Tue, 11 Nov 2025 09:44:57 +0900
Message-ID: <20251111004554.011512582@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sammy Hsu <zelda3121@gmail.com>

[ Upstream commit 370e98728bda92b1bdffb448d1acdcbe19dadb4c ]

add support for HP DRMR-H01 (0x03f0, 0x09c8)

Signed-off-by: Sammy Hsu <sammy.hsu@wnc.com.tw>
Link: https://patch.msgid.link/20251002024841.5979-1-sammy.hsu@wnc.com.tw
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index 8bf63f2dcbbfd..eb137e0784232 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -939,6 +939,7 @@ static void t7xx_pci_remove(struct pci_dev *pdev)
 
 static const struct pci_device_id t7xx_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x4d75) },
+	{ PCI_DEVICE(0x03f0, 0x09c8) }, // HP DRMR-H01
 	{ PCI_DEVICE(0x14c0, 0x4d75) }, // Dell DW5933e
 	{ }
 };
-- 
2.51.0



