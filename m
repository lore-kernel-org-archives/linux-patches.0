Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC3B1AE01F;
	Mon, 14 Oct 2024 15:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919372; cv=none; b=Qw+u1FiQf6XIH2s1/HPE1t2enbbV30e5Jsi9bV9jEKIeHbPYDUyVCnP7ENG4rkOBHyDG/ykg3rf0CvCi6i9M2sZLjI/dVdmhpEgk8BlA23nWcV+/0sXg9hMsXu3Y92EVW7cDLhIfeZhuQ6Mx81ExenqtcBH/4d4SzJiWBGknr5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919372; c=relaxed/simple;
	bh=5l7HWN54Sg5ptCCW3jOB5TVemOxBrpmzbY223kQ1ARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXb0CTLT8N+5f76mRa9hj00WnEDc5/56ubtwIiOeLVPeDutUX1UwEyXCyGFt31uZOsmr1VlzFw1SxwtF2eoFyselgbTat4oqpH44rqTsIQZVf5M166tvsBNLIpoLJQVST1VGKdqkqK6nvVKGB6O5Cc8T+EFiETwHFP3C8HR1cN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7+EKx/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7+EKx/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DFCC4CEC3;
	Mon, 14 Oct 2024 15:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919372;
	bh=5l7HWN54Sg5ptCCW3jOB5TVemOxBrpmzbY223kQ1ARc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7+EKx/NRToiGz0mX3tpHmW/u1rCxu9jMpNn2OGuapYF61sjopcn6oXf1h2wABrg1
	 fCUeyK5j3rEBK8K2pX/iRRCmBZ7QPAH6ZeGDAmwPBb0VYWvhVpVHaHk8l/gHJMhtki
	 AY5gGnmn5DWvf6r5GzjBDJo/JICJrAoEFgl3/HFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 591/798] clk: qcom: gcc-sc8180x: Fix the sdcc2 and sdcc4 clocks freq table
Date: Mon, 14 Oct 2024 16:19:05 +0200
Message-ID: <20241014141241.223499476@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

commit b8acaf2de8081371761ab4cf1e7a8ee4e7acc139 upstream.

Update the frequency tables of gcc_sdcc2_apps_clk and gcc_sdcc4_apps_clk
as per the latest frequency plan.

Fixes: 4433594bbe5d ("clk: qcom: gcc: Add global clock controller driver for SC8180x")
Cc: stable@vger.kernel.org
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Link: https://lore.kernel.org/r/20240812-gcc-sc8180x-fixes-v2-4-8b3eaa5fb856@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-sc8180x.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/clk/qcom/gcc-sc8180x.c
+++ b/drivers/clk/qcom/gcc-sc8180x.c
@@ -895,7 +895,7 @@ static const struct freq_tbl ftbl_gcc_sd
 	F(25000000, P_GPLL0_OUT_MAIN, 12, 1, 2),
 	F(50000000, P_GPLL0_OUT_MAIN, 12, 0, 0),
 	F(100000000, P_GPLL0_OUT_MAIN, 6, 0, 0),
-	F(200000000, P_GPLL0_OUT_MAIN, 3, 0, 0),
+	F(202000000, P_GPLL9_OUT_MAIN, 4, 0, 0),
 	{ }
 };
 
@@ -918,9 +918,8 @@ static const struct freq_tbl ftbl_gcc_sd
 	F(400000, P_BI_TCXO, 12, 1, 4),
 	F(9600000, P_BI_TCXO, 2, 0, 0),
 	F(19200000, P_BI_TCXO, 1, 0, 0),
-	F(37500000, P_GPLL0_OUT_MAIN, 16, 0, 0),
 	F(50000000, P_GPLL0_OUT_MAIN, 12, 0, 0),
-	F(75000000, P_GPLL0_OUT_MAIN, 8, 0, 0),
+	F(100000000, P_GPLL0_OUT_MAIN, 6, 0, 0),
 	{ }
 };
 


