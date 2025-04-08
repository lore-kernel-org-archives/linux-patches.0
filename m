Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044FE26AAA3;
	Tue,  8 Apr 2025 12:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116432; cv=none; b=BzxXhY6jYkWKc92vVPKAB5CArC8KxLIl0N4RFFwT5+Az7MH7HZohEGy1No/LhKNTTT1uubJ6Oxx8Hs82luGgkHjIeyNEHxFELdBH7cV+Q3lNO97XEkG/VVwSGHU2WtIONbA6KEs4GMNKXBXO7S6GjqTa98AmZ2r2Mp0eSdU1hNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116432; c=relaxed/simple;
	bh=oFERqbAc0ThQVFTz4ssVYn9UyMkj9P7E2IV4MAwwu6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A/MJqSxccYz8NJPaTdm10xdiHfK2SrQ7DLeBecZF097WW88sfC1g9VU2ieyU4nc5Yc8sW0uR5WgXs0FWg4+CG44Vy7uvsqQIyO8eqRQMi2kOG44qC2RtznmAyGR4Nm5NcDGR+wljoVqKH/iS5knQB6SEtKWlIAt2+rfUzz4t4Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjncFbJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjncFbJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBAAC4CEE5;
	Tue,  8 Apr 2025 12:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116431;
	bh=oFERqbAc0ThQVFTz4ssVYn9UyMkj9P7E2IV4MAwwu6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjncFbJAhMzGErkOfbVJA116qRx5AJVWObKLqhnEbPleMABg+wYm3jQYGANigPG15
	 T2GZ8X0OfIMt3Dy5Licy5/PolJXTKdlSpTAwLdshL/lbovIEz3Rd9CZzWVoqWxONv9
	 i6VU/gU4ma0GKbE+PkjdRF2J4vRcbcOClQKLyJQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/423] PCI: dwc: ep: Return -ENOMEM for allocation failures
Date: Tue,  8 Apr 2025 12:46:55 +0200
Message-ID: <20250408104847.813112285@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 8189aa56dbed0bfb46b7b30d4d231f57ab17b3f4 ]

If the bitmap or memory allocations fail, then dw_pcie_ep_init_registers()
will incorrectly return a success.

Return -ENOMEM instead.

Fixes: 869bc5253406 ("PCI: dwc: ep: Fix DBI access failure for drivers requiring refclk from host")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/36dcb6fc-f292-4dd5-bd45-a8c6f9dc3df7@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index b58e89ea566b8..dea19250598a6 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -755,6 +755,7 @@ int dw_pcie_ep_init_registers(struct dw_pcie_ep *ep)
 	if (ret)
 		return ret;
 
+	ret = -ENOMEM;
 	if (!ep->ib_window_map) {
 		ep->ib_window_map = devm_bitmap_zalloc(dev, pci->num_ib_windows,
 						       GFP_KERNEL);
-- 
2.39.5



