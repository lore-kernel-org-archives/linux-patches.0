Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34A8243964;
	Tue, 29 Apr 2025 17:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948868; cv=none; b=CphvvoJE1GgLkyxCdVm0KJbFkQFSqytYEtosGKPLPxU268E0rRrp8rNK7axUKzO7DwJBdIEN4mSVrmONiqhUOdwbIMT/AKFDI2L9ho/zj7TfDf+jvOXnmQh5b+CwYDV2UE5OnRw3nbH2ILzgyh+v97HNyKhi9YBTN2BSXMxPCek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948868; c=relaxed/simple;
	bh=/C5Vl3ZiYoDntQuSnMvoYCuTKrbTujkHUod7MXHHFJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMn+6r88JYw7aXqNFLOuGVIgFsbnQCdOzAPdhzb9U0V73PheHOqMXhgSBTzANfvRVdFigvFQ0kQYwcIxWZkd7AlQnIpu94POeK87B0vj2wlva6xlE826HN/Pb1tt+XXyDVJjvAWWY+qlqAt54BjLJ8WjEHyt3o80uROKMbgRngY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4CGc0XM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4CGc0XM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FE1C4CEE3;
	Tue, 29 Apr 2025 17:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948867;
	bh=/C5Vl3ZiYoDntQuSnMvoYCuTKrbTujkHUod7MXHHFJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4CGc0XMVmOqyIVFThr4/QgMZ5E9OtK6FEsvDS9ATpPfq7EbDdAGcqt14dvTISBqQ
	 fJC1rpqeSwudTATDgl+XAj2Fm7p7hJZpC8FS2fZh7wBePTDIu1f+/QU8uORd6JbXsK
	 HTVXXcE+ikGNzV7+cNgXmUKkZrqbQ/5S3ABYxe20=
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
Subject: [PATCH 5.15 143/373] igc: cleanup PTP module if probe fails
Date: Tue, 29 Apr 2025 18:40:20 +0200
Message-ID: <20250429161129.050362540@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 27c24bfc2dbeb..4186e5732f972 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6722,6 +6722,7 @@ static int igc_probe(struct pci_dev *pdev,
 
 err_register:
 	igc_release_hw_control(adapter);
+	igc_ptp_stop(adapter);
 err_eeprom:
 	if (!igc_check_reset_block(hw))
 		igc_reset_phy(hw);
-- 
2.39.5



