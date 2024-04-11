Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B297145FF0;
	Thu, 11 Apr 2024 10:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830540; cv=none; b=T2nmvdBtff6ezFz2v6poBs1OXo7abCoGAc0n41oQTfgf6okUQ7m5R8wcs70RXulwt57E/Cg7wT++JbY4vHYtDmKFgxJXoel+Ux3SRvYFeQJOUIInd+92bkQvlwvCcpnjWEgOaVYtdFhAChrVfaWrxuM57H4KxsTP/GqZFtOSBGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830540; c=relaxed/simple;
	bh=lzXy1O7N/JUlfj00r1jDwuapNf/O1AXmjxPPj/aYfZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHbIgHNlA8YUJuGqY1If5QQI5fakAmeiTNz+1SfZx77XRRP2eriofL+2u5l0/CL7/B9Ri3gdbocEep5v0oXdvsNb9ZCVvlCkibtuVWRlCl7668RLecppkfpzza2wjX8H4RojkET0JCG2I4siWDhKPeBRbpw65dpTZY/WLRSswUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ss+l6IwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ss+l6IwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F3CC433C7;
	Thu, 11 Apr 2024 10:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830540;
	bh=lzXy1O7N/JUlfj00r1jDwuapNf/O1AXmjxPPj/aYfZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ss+l6IwWtdg3DmOZM7Boq5BYeIhDrguv9GUAcYd3lKyT7O4X6BSF39rZdkTBgAEzh
	 SQf826zW2GYoMWCu5jap54sZv0KZrawjvpsu8oGFajK9cewa8iTh1gv4mUrodtwDpq
	 qHanjs+bZLgJr1aoy6czBIrnPzXJjUw2+mFwzqTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/215] clk: qcom: mmcc-apq8084: fix terminating of frequency table arrays
Date: Thu, 11 Apr 2024 11:54:04 +0200
Message-ID: <20240411095425.953441049@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



