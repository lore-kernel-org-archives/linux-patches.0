Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA31C1779B1;
	Tue,  8 Oct 2024 12:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390908; cv=none; b=Hn/hhrBOhVu3YLuGKV2imi4dCv96CqQaTQ11ZkPf8IJCSS+v2TtQuHiqseNupYX2ROr7nCW+A+BoPJEEfWpF998YsLxcK83Zn5SvKOj91ZgKms/tppSASGwvgqkeoqis+6XQnkm7AmbI80J69+ggBzSSSoUCUjAj8EMOPb2WwzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390908; c=relaxed/simple;
	bh=a76k2vsF7Qu18zNuKK5eBQ7qwygnGKVMNl2uEYKSsvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHn802If86RFe07jXfoP3rvq3k0e+AmZz05oZmte0jpWTXVyHf6h06JU26IV03MthyVa2f9S9v+DIhapRM3mVLVg/EYUcZavcHcCNs85maqcF5k2Fdoa0tY+bPRwl6eSAlvuuOW92TVcSxlCxfRqaQ8csP1sGwlN9vKjo/E6VQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKhMRqbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKhMRqbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF67C4CEC7;
	Tue,  8 Oct 2024 12:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390908;
	bh=a76k2vsF7Qu18zNuKK5eBQ7qwygnGKVMNl2uEYKSsvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKhMRqbDrnIL5gwBirlX+XFEFnlpbt6BK3fsN2WITfYJTHdOhxLSpMQwVepj2V8re
	 /uZhSz/DvLl6lSddq9QWGjA5EM+owltt7bl5bE0subpiYkrLoMSIYJcMUlxIsXijiL
	 lx4DFpAkR9ErHr556zSf2uDYU9xeqTeB3JPabt+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 398/482] clk: qcom: gcc-sc8180x: Fix the sdcc2 and sdcc4 clocks freq table
Date: Tue,  8 Oct 2024 14:07:41 +0200
Message-ID: <20241008115704.071997818@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -911,7 +911,7 @@ static const struct freq_tbl ftbl_gcc_sd
 	F(25000000, P_GPLL0_OUT_MAIN, 12, 1, 2),
 	F(50000000, P_GPLL0_OUT_MAIN, 12, 0, 0),
 	F(100000000, P_GPLL0_OUT_MAIN, 6, 0, 0),
-	F(200000000, P_GPLL0_OUT_MAIN, 3, 0, 0),
+	F(202000000, P_GPLL9_OUT_MAIN, 4, 0, 0),
 	{ }
 };
 
@@ -934,9 +934,8 @@ static const struct freq_tbl ftbl_gcc_sd
 	F(400000, P_BI_TCXO, 12, 1, 4),
 	F(9600000, P_BI_TCXO, 2, 0, 0),
 	F(19200000, P_BI_TCXO, 1, 0, 0),
-	F(37500000, P_GPLL0_OUT_MAIN, 16, 0, 0),
 	F(50000000, P_GPLL0_OUT_MAIN, 12, 0, 0),
-	F(75000000, P_GPLL0_OUT_MAIN, 8, 0, 0),
+	F(100000000, P_GPLL0_OUT_MAIN, 6, 0, 0),
 	{ }
 };
 


