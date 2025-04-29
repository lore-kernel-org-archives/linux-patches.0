Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C6525335B;
	Tue, 29 Apr 2025 17:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946924; cv=none; b=ikQ+7f3FqBZwXyaL3yAZh5DgLj1Dj7nYpG99NWHIj37ppWxsSj8RFkUZvMe+7V1hmshNEzgCkG4OE994dAeNULrPwQmQXmkgUMTcct62Q2CMFBFr8z5HZ3sHcFL398NJGWCvdyV0HBRQN59VwgMHoipRT1tyGZz2Nv9+ebpmKFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946924; c=relaxed/simple;
	bh=W6huTy9JSgHofTCF9+MDUB0DBOOC4lgtbvXAmKVVNB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdnUTYQliIgity9g0DnmjhmlfogZDBeLSnFoPUi/UdZk4TQlrt6x1kZsPPgufA9kPSvVvjRfwjSR10fdNLDqlb4Gk2hVSmyRrPBAJIlzRR3v6xKpoK8aJSnsPUNEFBuowd5aeCufP0kRcFoqEHsSC4+TMk28IVZhPv/9KrZ8bqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HE6fuQnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HE6fuQnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1945FC4CEEA;
	Tue, 29 Apr 2025 17:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946924;
	bh=W6huTy9JSgHofTCF9+MDUB0DBOOC4lgtbvXAmKVVNB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HE6fuQnuozOfgByrRB3TY3VBWJbP4DfrMnMFQPfrnC7TTWQ2LW7AO7W/BurLKPNRr
	 1f3odGWdS+HFIZJ1tzXMg1w8InrDlQ/yOUE7JCdc3/KgdEaU2x2H0w6MkyKmn8wIKa
	 Ilj5a6yd0MQSgXj8zcchtUz9UlG9r1+ZohoAdMCA=
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
Subject: [PATCH 5.10 114/286] igc: cleanup PTP module if probe fails
Date: Tue, 29 Apr 2025 18:40:18 +0200
Message-ID: <20250429161112.546874614@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 65cf7035b02d5..7593e8b7469c5 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5405,6 +5405,7 @@ static int igc_probe(struct pci_dev *pdev,
 
 err_register:
 	igc_release_hw_control(adapter);
+	igc_ptp_stop(adapter);
 err_eeprom:
 	if (!igc_check_reset_block(hw))
 		igc_reset_phy(hw);
-- 
2.39.5



