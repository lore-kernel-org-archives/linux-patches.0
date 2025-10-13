Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FBA241695;
	Mon, 13 Oct 2025 15:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369481; cv=none; b=hXGZMm0PCYG152gZwPFub0WOdrkD5k73Q5y/GgJsfC+2EhfgoPTyCUE/Z2K/3KdoL/IHk1cCwfdNHZtfAioHZrQoFVbOS9t0t+bCDq2t0lpTBMYtmOKUCyHTErFPAM6DcQ/45e2ylV6oVYzEuGtPvMc/FPuDMPEb/RlLuHajBsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369481; c=relaxed/simple;
	bh=dimR5xKpyn9TNf4PAOg/XcfwuyMaXIeFbpuzMPr0Deo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3QXYGu0rRUfP0pL9W9xTqAyzGGfB8VaygRbFGyFpdgx5jEKCvfW5MmyHiEDR/NY9+xY4l8VTIRTJ5DKA5kd4GDFL0P4ouUTE3Li6mJp2t/5X/k8zbiL2GKsYHYRQ1TcgEG1cuEgf9BBdF9YUOC70fLKJZsJ1AYELTNI3oMv7bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvhZVG8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvhZVG8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD553C4CEFE;
	Mon, 13 Oct 2025 15:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369481;
	bh=dimR5xKpyn9TNf4PAOg/XcfwuyMaXIeFbpuzMPr0Deo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvhZVG8UvU18Ki/GU0nID9v722c7bjTJIPIn7qdwLnpTeKA9kbyMSiLT81cRnPkBk
	 YKscKPWpWhrUYQFnoc0rpaG8roO5ZT9guD3geAdaIIflJMZCvwtzCPRG6G7NEZyP6C
	 aPGq8fcJT8WiKIcemhovigRhIPqMWLmCvvlYCzwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 261/563] media: staging/ipu7: Dont set name for IPU7 PCI device
Date: Mon, 13 Oct 2025 16:42:02 +0200
Message-ID: <20251013144420.732592659@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Bingbu Cao <bingbu.cao@intel.com>

[ Upstream commit 8abb489f9aa181882ece7c24712ad39cbb9dab81 ]

Driver better not dev_set_name() to change the PCI device
name, so remove it.

Fixes: b7fe4c0019b1 ("media: staging/ipu7: add Intel IPU7 PCI device driver")
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu7/ipu7.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/ipu7/ipu7.c b/drivers/staging/media/ipu7/ipu7.c
index a8e8b0e231989..aef931d235108 100644
--- a/drivers/staging/media/ipu7/ipu7.c
+++ b/drivers/staging/media/ipu7/ipu7.c
@@ -2428,7 +2428,6 @@ static int ipu7_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!isp)
 		return -ENOMEM;
 
-	dev_set_name(dev, "intel-ipu7");
 	isp->pdev = pdev;
 	INIT_LIST_HEAD(&isp->devices);
 
-- 
2.51.0



