Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEC82FD1D1;
	Tue, 12 Aug 2025 17:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020418; cv=none; b=BPiTugA6ErSZLmis63d2sQgPckSqdoKzNjF++P6iGM43BbWmQEi1mWkQirwy6DzHnG3X1H4SwIFa9XfL/Zbm9pSVFno4E73/uEYU+Yp13bByEZyDZhgygkcw7yVqJLozoHJnQMtimpC16+JxFPvsTxYIfwq9mKPuJ67X7HIbl0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020418; c=relaxed/simple;
	bh=2vz2VvxOvRQS/5Mk0jNrw8mnmBSFHw/H28yGCbswQWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJPoXOnv0gwLuVQIFSAAORkoYDmbxZgdP/2oi5R4PTXMt81hikG9VF/zwFE9bRUL9KiaKetrPigQIi3cHRz29jujUNnlJMH6aLhG0Io/i4PM8pVM4A6THRZT+SJJc4th3H73Df/6gqcgUPKdnFyy3OsA/i5BpgsLd2bPfFX13yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7l3GkTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7l3GkTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2FAC4CEF0;
	Tue, 12 Aug 2025 17:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020418;
	bh=2vz2VvxOvRQS/5Mk0jNrw8mnmBSFHw/H28yGCbswQWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7l3GkTYcUT7LMj97lns9nQ3BxnttBot2a9Bx4+PfuJsMnYqOajZxjDGcqZVWNWty
	 a/OtYwBJMV1B49gcOcOU4B786Fx+Ud3uKXNnrAt5qqbnD+Tx+wLszXWxnrj6TC68d5
	 cpBukyCU6e7FSmFzqN0u27E10aaq26340SKbP71w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/253] usb: host: xhci-plat: fix incorrect type for of_match variable in xhci_plat_probe()
Date: Tue, 12 Aug 2025 19:27:43 +0200
Message-ID: <20250812172951.923841368@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6704bd76e157..7ec4c38c3cee 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -184,7 +184,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	int			ret;
 	int			irq;
 	struct xhci_plat_priv	*priv = NULL;
-	bool			of_match;
+	const struct of_device_id *of_match;
 
 	if (usb_disabled())
 		return -ENODEV;
-- 
2.39.5



