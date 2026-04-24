Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131553D5241;
	Fri, 24 Apr 2026 13:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037744; cv=none; b=LS4eREC0F6FXZ1rfqYTxj/vdYdk5sqsJ0wwKivynRBfpenEgfNikHlavKdkcSGtifoL0e7P9tzheI43xZRrBXl4noOTnZszv8zJ5rD7tA3Y1FXoj5vi/UwaBXNmQFUFfkCns1LCc2pZoOdkQvKKJ7SRrh3lsIAhmbW3DVGb5cDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037744; c=relaxed/simple;
	bh=G0eMZ+zS7t230uFuiqRB007VQzlGU9CmMjGNENfrJx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UL1XrXkWce7Emit1IU6VC5FYd+jvNQnbML6dyQXYha4XJf1Ou9AcGNLkdOVjVEW+5Urh797YrGvjsX/dcK60PmvgWbOgxZZVIdb0SI0DH6w4cjjogPboM1th1kpbiUBjC59tuRRg2K36Ff0bOxNbLtnwAbxDerSJyu0LstBhXFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uD6Ifqtd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uD6Ifqtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976ADC19425;
	Fri, 24 Apr 2026 13:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037743;
	bh=G0eMZ+zS7t230uFuiqRB007VQzlGU9CmMjGNENfrJx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uD6IfqtdnTZNAX27GgE/gsEjGNH3Ize8odgfmCJ+yPcr8HItF18Ubi1nccrVkvzXO
	 vwx5HtmpMn6c0CUiHYRgZ8mLJHHOM2XHhYQUFMX9NjkBHSZs9zVJoayS4dcJfv+eT+
	 Cr026swtdtzYI1yOP3Vg0jbrQr5kP0H+OBVw0F+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/166] pinctrl: intel: Fix the revision for new features (1kOhm PD, HW debouncer)
Date: Fri, 24 Apr 2026 15:28:53 +0200
Message-ID: <20260424132536.793193187@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a4337a24d13e9e3b98a113e71d6b80dc5ed5f8c4 ]

The 1kOhm pull down and hardware debouncer are features of the revision 0.92
of the Chassis specification. Fix that in the code accordingly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 9775f6be1c1e6..b1ce3daae8e85 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1581,7 +1581,7 @@ static int intel_pinctrl_probe(struct platform_device *pdev,
 		value = readl(regs + REVID);
 		if (value == ~0u)
 			return -ENODEV;
-		if (((value & REVID_MASK) >> REVID_SHIFT) >= 0x94) {
+		if (((value & REVID_MASK) >> REVID_SHIFT) >= 0x92) {
 			community->features |= PINCTRL_FEATURE_DEBOUNCE;
 			community->features |= PINCTRL_FEATURE_1K_PD;
 		}
-- 
2.53.0



