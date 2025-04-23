Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBD42D613;
	Wed, 23 Apr 2025 14:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419661; cv=none; b=lNpTpB+s3pRD+2rJcAUhez8Nru1/9toE883s4JzGSJXainY2NAe9+zWzCO3H1IZsBu01d6W7nvML6qPLqrSEY5HwxrSNFfCbbEWT6Rv/RBT5Z5TbmCND+mVQDBbGvG5VifS9/EezANjQU81Zek2gDf/AgpFfpIJ/XGW13R4BOMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419661; c=relaxed/simple;
	bh=fWkyQkeY7dlNfk7UCYVTXRr/4ULwnKeMmTb14WoKvHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJN5stZrtFHqH+Fh++bC3Sy2E2FcwPc0uzs5iearGdBei+iicgxTBvvlGmzxaVXKz/a743WNpLtgD5kyoHUZCAYx+0G6dPNZYpL6LPJQkkgEZNxr9EM2FzMCJsj+DO/HcxqG6fPwWVLcd6AGxTQL9lTXDjHnmrJ6FKp4qCpK8Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FD+zyuI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FD+zyuI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4C6C4CEE2;
	Wed, 23 Apr 2025 14:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419660;
	bh=fWkyQkeY7dlNfk7UCYVTXRr/4ULwnKeMmTb14WoKvHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FD+zyuI5Nv60K+b1iPShsGjmVMT/O7xSRY/ubdefvP7CyIIkpQk4Nzi767RWh+hxA
	 bToE8j03nkI/fZ84tw5SYSJgkILlT+mcEBHj79eQzNnWPt1iruC3dIxuNBrEr74RP1
	 Q/esrUi2r7ZkcVaFfC7YpIlYF/Qd+GWpS4qWRxSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher S M Hall <christopher.s.hall@intel.com>,
	Corinna Vinschen <vinschen@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/223] igc: cleanup PTP module if probe fails
Date: Wed, 23 Apr 2025 16:41:49 +0200
Message-ID: <20250423142618.640703381@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Christopher S M Hall <christopher.s.hall@intel.com>

[ Upstream commit 1f025759ba394dd53e434d2668cb0597886d9b69 ]

Make sure that the PTP module is cleaned up if the igc_probe() fails by
calling igc_ptp_stop() on exit.

Fixes: d89f88419f99 ("igc: Add skeletal frame for Intel(R) 2.5G Ethernet Controller support")
Signed-off-by: Christopher S M Hall <christopher.s.hall@intel.com>
Reviewed-by: Corinna Vinschen <vinschen@redhat.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1ec9e8cc99d94..082b0baf5d37c 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -7173,6 +7173,7 @@ static int igc_probe(struct pci_dev *pdev,
 
 err_register:
 	igc_release_hw_control(adapter);
+	igc_ptp_stop(adapter);
 err_eeprom:
 	if (!igc_check_reset_block(hw))
 		igc_reset_phy(hw);
-- 
2.39.5



