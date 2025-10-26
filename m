Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072C22E8E11;
	Sun, 26 Oct 2025 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490294; cv=none; b=V4ncbqNZi9RNmCD6cuP/PKUyMusy0NZ567DtmaUeebHzHPY+2v4DXQ+MwQa8fKNW4Sz5gkkj4MvSFNzY8PliqfaT1Kzx11QbBBQq6ZR87OKbYX9iXGtaixUpN+xaULH8u/uoAugeoRaF8cFafEHJyiRrFMncp1ocdOz2ksLaDek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490294; c=relaxed/simple;
	bh=fY3bO3hEigomiCqYnPJcfKwveNBMLO73W1Mb3J4iJsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pe5ouDdVDIhR2SGMcn/vxs5zu31G9iSQ5MCQsPSxx5jQuuMpLtWVG498KxvLKQxYXPB1hqPzRxjGeBrHAHtjkeREhOFzff22jLanB9fsQv0d21zg+SKjU4yzMjGZRBUXItbPPwCbt+PBp1qR3HQfA3ZrgUKZiCDxPdxz54OjDbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oHLFifWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oHLFifWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7819C4CEFB;
	Sun, 26 Oct 2025 14:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490293;
	bh=fY3bO3hEigomiCqYnPJcfKwveNBMLO73W1Mb3J4iJsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHLFifWFRE2a3vtWkdDczvYPVkSTJ8MFu3vzNOlny7Uk5JHPChXfYgcy/JtKSStEK
	 DEFYU4tFL4NoVnHAczuc9cBaY+XDEBfrF5/dOJ996c/jcmOA6PWfweCleKQa5VgsRF
	 GM+fWBqaFES6U8VhTYcwcfSEE4d1+RQHrubJNucv2CKdn2UTkybE6REgzPh0imFGPb
	 z8wncx0YIo4KVEOHIZ9Qdw6cP2csq+qhe9JHOCX2fxsDByF9YWYrKQD0O3QvVjisEE
	 zMbCmlvrOFqc+NIJ87H0b4WEGRzKIYRMffmHNVYPgdmDsSwK2hNa/0rbi7emo+Xfcs
	 1xnH1VDGrNNEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sammy Hsu <zelda3121@gmail.com>,
	Sammy Hsu <sammy.hsu@wnc.com.tw>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	chandrashekar.devegowda@intel.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] net: wwan: t7xx: add support for HP DRMR-H01
Date: Sun, 26 Oct 2025 10:49:23 -0400
Message-ID: <20251026144958.26750-45-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sammy Hsu <zelda3121@gmail.com>

[ Upstream commit 370e98728bda92b1bdffb448d1acdcbe19dadb4c ]

add support for HP DRMR-H01 (0x03f0, 0x09c8)

Signed-off-by: Sammy Hsu <sammy.hsu@wnc.com.tw>
Link: https://patch.msgid.link/20251002024841.5979-1-sammy.hsu@wnc.com.tw
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – adding the HP DRMR-H01 PCI ID lets existing t7xx hardware autoload
the driver without touching any other logic, so it is a low-risk
usability fix that fits stable policy.

- The change only extends the match table with `{ PCI_DEVICE(0x03f0,
  0x09c8) }` in `drivers/net/wwan/t7xx/t7xx_pci.c:940-944`, mirroring
  the existing Dell-specific entry and leaving probe/remove logic
  untouched.
- `t7xx_pci_probe()` (drivers/net/wwan/t7xx/t7xx_pci.c:834-917) runs the
  same initialization path for all matched devices; no vendor-based
  branching exists, so the new ID simply enables already-tested code on
  this HP-branded modem.
- Without this entry, kernels cannot bind the built-in driver to
  DRMR-H01 hardware, which is a clear user-visible malfunction for any
  system shipping with that modem.
- The modification is self-contained, has no architectural impact, and
  aligns with prior stable-acceptable device-ID additions for the same
  subsystem.

Backporting will restore driver functionality on new HP platforms with
virtually zero regression risk. Potential next step: 1) Queue it for the
maintained stable branches that carry the t7xx driver.

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

