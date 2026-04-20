Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52DA332916;
	Mon, 20 Apr 2026 15:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700672; cv=none; b=iznhm/FGZldrNtaO0kciLDbj5RZYKEzEBJrYLo4CZTq0eRxK2gYlKbpbNHGxuhQ70KaV/MwK7d85qsIZKX8JXhjwJr/tcZHe16Wbat3AZ9xkAhafDdPt6q9rrnR326rl9Gj1/6TxpWRHp8GpxwUVISawVepUCfxw44t3GWy3/eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700672; c=relaxed/simple;
	bh=W3h1APe4lxdstAuNAbS6uBcj1bp1RtXypcGkSp1k6xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDfo7Gm623BV9qVHXv+Qr3n9Zx4Ipkv1ix8RCuQuEXLuoT5e7BQ+EXSguFcPciu+oUb+f2D2LthNPnZaZorMCSa3TD7RFmYYWS8DpPEGXdUrDggh79juCk+9es2sBdq7pu1OPEnwzJW4Re5Ol/QcoMBt54JlX9B1YLZRUNiMZtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aA8EfqZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aA8EfqZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C369C19425;
	Mon, 20 Apr 2026 15:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700672;
	bh=W3h1APe4lxdstAuNAbS6uBcj1bp1RtXypcGkSp1k6xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aA8EfqZ5z3sngDGl7eZqvz5zfCJrOhTMHPcHAa+HfRmOxkv7fyLmYC2LBEg/VQUcy
	 PxWAQft4So66YMT8Vey3kLoCoYZxp9KTjvHShbSMG01e3hOvmfcHPXfmAXvpitjKCv
	 BjCOXvSB651105FDCUyEnZNAURnZXN0kuO/wGNdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/198] pinctrl: intel: Fix the revision for new features (1kOhm PD, HW debouncer)
Date: Mon, 20 Apr 2026 17:40:14 +0200
Message-ID: <20260420153936.882596560@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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
index d68cef4ec52ac..103eccc742a53 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1606,7 +1606,7 @@ int intel_pinctrl_probe(struct platform_device *pdev,
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



