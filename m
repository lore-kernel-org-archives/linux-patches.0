Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE26F196D90;
	Thu,  6 Jun 2024 14:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683672; cv=none; b=khXMAqYGdqvdPWy4k7laA5FWV0zJju2b9ybKuP115w9LmId3+MrgYc7qWXF08UTk20Tim7KIHWiQHNs2X1MN58XYiXZO83UuQDcGXapJ3RLELsz0Kswt7vvM61yCibyh24JkIZkEOYdPjtrbxMOYpVv3pGef9VqJiBXbEOEsJAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683672; c=relaxed/simple;
	bh=8kcvULjBdULHRcWQRHyi1/araJ5pPxOSVJCgWuMY+rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+TExLcaWNjefbi4xkuJYQaA3OE/IoUSqzAnkUdCaasXfC7v6OFvXMRRkZsSTuTcmc7bxSSKDoYi8qAbeCuALLv2ih/kOiDA5CxFmk0DKEhCfSQi7xutbVuBQfUbOzGuAvome7nB9D9LhU6CpY05aaNhHwXg39okFuYBXU4a1ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWicAOAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWicAOAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC759C2BD10;
	Thu,  6 Jun 2024 14:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683672;
	bh=8kcvULjBdULHRcWQRHyi1/araJ5pPxOSVJCgWuMY+rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWicAOAzV/rdcqLFFspGChYIKHnKX1OUYxuDyM+myVwHobysFcWpZZhJdmPOzllkQ
	 nWlMTxs3VA0Zg6O2ihb1mbhrPF25e9E3iykHP/YsC/ftKUYrZzIWUK7r11XIgfRSQv
	 2V307y2Tl/LOFKcL2jpqzudaejsF/2ieX/sOIf0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 523/744] usb: fotg210: Add missing kernel doc description
Date: Thu,  6 Jun 2024 16:03:15 +0200
Message-ID: <20240606131749.219652833@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 4b653e82ae18f2dc91c7132b54f5785c4d56bab4 ]

kernel-doc validator is not happy:

  warning: Function parameter or struct member 'fotg' not described in 'fotg210_vbus'

Add missing description.

Fixes: 3e679bde529e ("usb: fotg210-udc: Implement VBUS session")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20240510152641.2421298-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/fotg210/fotg210-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/fotg210/fotg210-core.c b/drivers/usb/fotg210/fotg210-core.c
index 958fc40eae86b..0655afe7f9779 100644
--- a/drivers/usb/fotg210/fotg210-core.c
+++ b/drivers/usb/fotg210/fotg210-core.c
@@ -95,6 +95,7 @@ static int fotg210_gemini_init(struct fotg210 *fotg, struct resource *res,
 
 /**
  * fotg210_vbus() - Called by gadget driver to enable/disable VBUS
+ * @fotg: pointer to a private fotg210 object
  * @enable: true to enable VBUS, false to disable VBUS
  */
 void fotg210_vbus(struct fotg210 *fotg, bool enable)
-- 
2.43.0



