Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460551DF734;
	Tue,  8 Oct 2024 13:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394011; cv=none; b=KWnT2hJd5L365dldHu1K5mSXcptzF+I7gZVPfhMHWA+ZGO8V/ATNVpbX+MlHUzOJ5JXYN9c46IDchZ1iLt8tjDYogFTGKwRlP0/JgP9JPvOWhHNx6T19sX9OIU+5KXZxKZtQAY8wiOH3XyfZd2uCiOCv+S+vg6xG6NAz+vTk1YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394011; c=relaxed/simple;
	bh=xZK7JB9MBrEXPEO8dVo/FUM6e8uqXQ6Cd1s2rItFTx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yag57+vvApLnqur5UDQRPPWnuIfSfiEVnqjJBhdoMFWUTz1FkIUIEnfa1Py7iXtex6Q3A+rAe7IlJGkZwvDFEbaoFlGM8dZUXSsRZCcrE/7tB+lwy2L1F+tP/n2QyobB8trpsfOR5eWt8iUc7IQMACUFxb2rDWJOLVCtWu0kzew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5Lcmopx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5Lcmopx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C41C4CEC7;
	Tue,  8 Oct 2024 13:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394011;
	bh=xZK7JB9MBrEXPEO8dVo/FUM6e8uqXQ6Cd1s2rItFTx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5Lcmopxqc5yBAnqaNR1PhEewpXEAlDN1BuwSYzOs59RyilAlXvQbxk0vjcHYmTnM
	 FAjzjIvUIKtu94ehOrotP/7YWM3n+HDkDP29fY5eZR81ivxTocRTvuSzOvFmB9Oywh
	 aVXYnxHS8nm3R8wY0QuFTi7bgbucu/p1zlKNhhl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 293/386] clk: qcom: gcc-sc8180x: Fix the sdcc2 and sdcc4 clocks freq table
Date: Tue,  8 Oct 2024 14:08:58 +0200
Message-ID: <20241008115640.917121207@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -894,7 +894,7 @@ static const struct freq_tbl ftbl_gcc_sd
 	F(25000000, P_GPLL0_OUT_MAIN, 12, 1, 2),
 	F(50000000, P_GPLL0_OUT_MAIN, 12, 0, 0),
 	F(100000000, P_GPLL0_OUT_MAIN, 6, 0, 0),
-	F(200000000, P_GPLL0_OUT_MAIN, 3, 0, 0),
+	F(202000000, P_GPLL9_OUT_MAIN, 4, 0, 0),
 	{ }
 };
 
@@ -917,9 +917,8 @@ static const struct freq_tbl ftbl_gcc_sd
 	F(400000, P_BI_TCXO, 12, 1, 4),
 	F(9600000, P_BI_TCXO, 2, 0, 0),
 	F(19200000, P_BI_TCXO, 1, 0, 0),
-	F(37500000, P_GPLL0_OUT_MAIN, 16, 0, 0),
 	F(50000000, P_GPLL0_OUT_MAIN, 12, 0, 0),
-	F(75000000, P_GPLL0_OUT_MAIN, 8, 0, 0),
+	F(100000000, P_GPLL0_OUT_MAIN, 6, 0, 0),
 	{ }
 };
 


