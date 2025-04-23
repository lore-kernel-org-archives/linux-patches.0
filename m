Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC3829CB2E;
	Wed, 23 Apr 2025 15:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422015; cv=none; b=habrI+A0MAsr7gLO0nf1qZ4t17GX5vp4e29P162qT1M997VtbDt9YNmQgwIv8BQnebstZ8JaXbVgI9xro7WoQBHMZP4sa3CXKoRor23TypFhHScmyFKFHE7ZA1PP6xPLfp53pS+YNR8zE5g8T6rnkEMgUj2XnAcZp2KMaZxBlaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422015; c=relaxed/simple;
	bh=Tact1xaPNT9ctQOIDHP/GyMlG+V9q/v8J0CVeA+9TeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyZH4a+mMAMcH3VmmYCdNl67s3mikOt5noRTZY3ZES5/bj0xPf2m+imsYr1lJmW1q+lC7itmPBnWpRbIzo70Rmdg3Bfx2LtBszNOpBJe8kAwh6jvjYdRhRS/3SFtEVBi8ipENF7f2iv0Sn21+8CLxCrJ4haCg+7+C8e7kBjwI4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeZpC+Or; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FeZpC+Or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE24C4CEE2;
	Wed, 23 Apr 2025 15:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422015;
	bh=Tact1xaPNT9ctQOIDHP/GyMlG+V9q/v8J0CVeA+9TeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeZpC+OrNUbB0D7aNJJfLO1Swu6O/V3uZk8ZeUudqdaXlhxAgoEAplFRdh+pSYLjR
	 QsuaYisJHhSvHFY9KBHJ9OE06WvbEemPEf+ke+s/lLhqbYvpq4yEn8P/ta9jqPcEls
	 ObIDISlnv0WS1UpExd7HlVGmHqe+NYAAMrAMPty4=
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
Subject: [PATCH 6.6 263/393] igc: cleanup PTP module if probe fails
Date: Wed, 23 Apr 2025 16:42:39 +0200
Message-ID: <20250423142654.231665447@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ae93b45cf55e8..e2f5c4384455e 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6951,6 +6951,7 @@ static int igc_probe(struct pci_dev *pdev,
 
 err_register:
 	igc_release_hw_control(adapter);
+	igc_ptp_stop(adapter);
 err_eeprom:
 	if (!igc_check_reset_block(hw))
 		igc_reset_phy(hw);
-- 
2.39.5



