Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25D16A352;
	Mon,  8 Apr 2024 13:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581390; cv=none; b=Ofc3pWGy70i7qiGJB4uYu/3NxmxGfUgVDXxe6KQUkVw9RBnBAQul1iqmkpOeujiJW3/V5OrTjbmJhG2BW6c7hA/06nVNnhiriSY0XhFsyy5BXff7+QU4XIR75Dedl51Ihky2IFSPIeb2eEp+JTUdMM/haZQICy4Mv51/mUErMSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581390; c=relaxed/simple;
	bh=n1tzjMIKJw8GhjDTOCYb6QUPKx8K4WNLSW/HpRtjApw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkTmDyKpHGeB8toqrjV/3OZB3D/NaSX/xYaOMJIE2mhhfiARyV3eLHZQz9frlb9ufhdI+p8YrtoyNADSnnO098Ty+SY9bbfGn29gQBhU2mKHVKfbXkoOLfHY3/AHl4SA1Xj8BktPtkAK/hIRQBmvIh7lHrqVLK6H7D83VgLIdl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddWcZRQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddWcZRQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C9BC433F1;
	Mon,  8 Apr 2024 13:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581390;
	bh=n1tzjMIKJw8GhjDTOCYb6QUPKx8K4WNLSW/HpRtjApw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddWcZRQflBtS55cXRAf1tUDIZoOLs3J2jB+fRCTp8tgeol0MI1x1qww/XlECyaQHm
	 WIlRjTj/ysGOGJSyO+fW/+Md1BViZCyukloSeVz1TWthC+4pn5GYzP2uccslMd0p2M
	 fHnAIjWz7Lbr9iflVer+fL+eNySqPWxQoU4JDXo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/690] clk: qcom: mmcc-apq8084: fix terminating of frequency table arrays
Date: Mon,  8 Apr 2024 14:48:29 +0200
Message-ID: <20240408125401.091609006@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit a903cfd38d8dee7e754fb89fd1bebed99e28003d ]

The frequency table arrays are supposed to be terminated with an
empty element. Add such entry to the end of the arrays where it
is missing in order to avoid possible out-of-bound access when
the table is traversed by functions like qcom_find_freq() or
qcom_find_freq_floor().

Only compile tested.

Fixes: 2b46cd23a5a2 ("clk: qcom: Add APQ8084 Multimedia Clock Controller (MMCC) support")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240229-freq-table-terminator-v1-6-074334f0905c@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-apq8084.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/qcom/mmcc-apq8084.c b/drivers/clk/qcom/mmcc-apq8084.c
index fbfcf00067394..c2fd0e8f4bc09 100644
--- a/drivers/clk/qcom/mmcc-apq8084.c
+++ b/drivers/clk/qcom/mmcc-apq8084.c
@@ -333,6 +333,7 @@ static struct freq_tbl ftbl_mmss_axi_clk[] = {
 	F(333430000, P_MMPLL1, 3.5, 0, 0),
 	F(400000000, P_MMPLL0, 2, 0, 0),
 	F(466800000, P_MMPLL1, 2.5, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 mmss_axi_clk_src = {
@@ -357,6 +358,7 @@ static struct freq_tbl ftbl_ocmemnoc_clk[] = {
 	F(150000000, P_GPLL0, 4, 0, 0),
 	F(228570000, P_MMPLL0, 3.5, 0, 0),
 	F(320000000, P_MMPLL0, 2.5, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 ocmemnoc_clk_src = {
-- 
2.43.0



