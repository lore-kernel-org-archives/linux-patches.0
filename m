Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AFB4EFFA2;
	Tue, 13 Oct 2026 12:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894524; cv=none; b=qEaSThIRHEobGfBk41HDzGhwaWd6jNvKWiCVjQsYbHlu99jhLmirW9LZojlu0HwmoBNv9QUPDQBBFvYhg9UvhJCVLkH8qBzG6tTVaRTCwUwW1YqoGe6LEDhemlZC5z8tCtiXMyKxaMfuDjyEBKAPRimwg7C7ufHstYlFUqIeDCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894524; c=relaxed/simple;
	bh=g6jLVy4yQA4Xgc9CJQjsCBVlaYP5WnmPB+5zAQcXiKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZ2mpxCoK9fmlQQhkHYB1vQL3kewB7wfcs3iFk9JHPy2p3N4bE8DwTvNOoCatXaQ2d448LrgRu9kNp/bBgrsI2mlHHi40w0dhY/xq9qpBx/eWvQ1IovxjD1amDRDhryauEl5eY7hYq0GjBMGajixgqKdKj7HDhA8rt3ublVqacQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkfT3bbo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkfT3bbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563331F000FF;
	Tue, 13 Oct 2026 12:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894522;
	bh=4mIZI/xcHoT8OoxMTAhAR2L9/3ekrabuR0VWGgbd1DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fkfT3bboTQZtD1LNoNiK9lfJALFBKQgl7lZVhcwBd1w+HI/c28MEtR0zEqMLRODxK
	 UnSXKmGGj65/jvlafXXflOO+W0jpVw5qXaEHWDd+YatC4C6MLILQIqZhJo/h1EG1sl
	 jsBHKz2A/wgZy6AqaURxlf9viFWgGFF5LFuha5BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 590/621] bnxt_en: Drop pci_save_state() after pci_restore_state()
Date: Tue, 13 Oct 2026 13:39:45 +0200
Message-ID: <20261013112934.804354175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 04ae0d54c1b11a622b8b0f502675135c7d9dab61 ]

Commit 383d89699c50 ("treewide: Drop pci_save_state() after
pci_restore_state()") sought to purge all superfluous invocations of
pci_save_state() from the tree.

Unfortunately the commit missed one invocation in the Broadcom
NetXtreme-C/E driver.  Drop it.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/39de1b025928d9a457976010b2324e7e99baa92a.1778158755.git.lukas@wunner.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2e52da27096d ("bnxt_en: Re-write the BARs following any type of PCIe errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1426023bc80d3..3c8346a5dd858 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -17380,7 +17380,6 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 				       &bp->state))
 			bnxt_clear_bars(pdev);
 		pci_restore_state(pdev);
-		pci_save_state(pdev);
 
 		bnxt_inv_fw_health_reg(bp);
 		bnxt_try_map_fw_health_reg(bp);
-- 
2.53.0



