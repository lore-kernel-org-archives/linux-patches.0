Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADC651014;
	Tue, 23 Jan 2024 00:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970085; cv=none; b=V6Ne/TFHM8QCAOR0G2V546sFS2kbcbM/AFabtYdKPkV4nHzUvnalKTdr43jzgHG4BhRoEuK3aeg1zsJLZyr2qMk5yVukkcmf8UPQazGoj9qck8vtV0OcDTQz1Rtw4Pn2P2ojbxi4DRj/IfqSt/f+wWsebnhZbTNiy2vWtWuReu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970085; c=relaxed/simple;
	bh=u5VCg+latCj5iCXQkPePiaig1A2wccYi78PoiGMEsbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUQfq713gu8t1tLOz/rQloOWL4YPa+szvmUZXfIKIOqaPDbwdf+MgP4tCv0KgvICiyjUrfVuNqTmceM4oJ6Dxe947f8qX0HbriU1q9OWhad9BxsW8RgAdX/nD69GRmZ4C1ZXNQsRbVHCHZjkLezkc7Gd2qVydgZmkoQ6IikXoJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcLnft1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcLnft1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7056DC433F1;
	Tue, 23 Jan 2024 00:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970084;
	bh=u5VCg+latCj5iCXQkPePiaig1A2wccYi78PoiGMEsbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcLnft1JZPK86IMToAO4azdYHWBtQ9qNG5n2S5vOtaR4cdX1x9PDHayIxgFsS68oJ
	 1y5am7a+yuSiru+Ye5tx5SPUUmG3yAoFsaqIAH+q6NLkmABewDi12zGejWtSPSo5nV
	 DVrFAqUGR1Tr8RMF3rfQ5yiuWHyMYPDlIO7HmC0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Harris <jim.harris@samsung.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fan Ni <fan.ni@samsung.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 559/641] cxl/region: fix x9 interleave typo
Date: Mon, 22 Jan 2024 15:57:43 -0800
Message-ID: <20240122235835.637334376@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Harris <jim.harris@samsung.com>

[ Upstream commit c7ad3dc3649730af483ee1e78be5d0362da25bfe ]

CXL supports x3, x6 and x12 - not x9.

Fixes: 80d10a6cee050 ("cxl/region: Add interleave geometry attributes")
Signed-off-by: Jim Harris <jim.harris@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Link: https://lore.kernel.org/r/169904271254.204936.8580772404462743630.stgit@ubuntu
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 3e817a6f94c6..76fec47a13a4 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -397,7 +397,7 @@ static ssize_t interleave_ways_store(struct device *dev,
 		return rc;
 
 	/*
-	 * Even for x3, x9, and x12 interleaves the region interleave must be a
+	 * Even for x3, x6, and x12 interleaves the region interleave must be a
 	 * power of 2 multiple of the host bridge interleave.
 	 */
 	if (!is_power_of_2(val / cxld->interleave_ways) ||
-- 
2.43.0



