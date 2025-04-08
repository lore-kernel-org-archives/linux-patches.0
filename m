Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D44F267B7F;
	Tue,  8 Apr 2025 11:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111269; cv=none; b=X4GpVaqqOfhtQcic0MZw2Ql3fTWJyIzVJvP9X9pR+Jb4tUhJqc/kG8lnQQAHpjmh2N2B9wbGuk7rmAM340YE7Ad7a9pEVbB9O+scTdAJzYcMHKII98T5BMLftEr3pUoRTCIygb1TCMzKK7WMM79K3ClYZg89mIehbdSpVGNA6iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111269; c=relaxed/simple;
	bh=YrJiwNGKO+EkZNOS8FLzzf4kt0OFINc/pfr82G/fNx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAnHBIl6BmSDuyaXnsuC/8uFk5z68Hz8jsOE7XnH+JkRN5+mNVaLTdonMjyhWDucJ52SOxUwcTv+nVM9IS1igVSzSuJNSTcy+GNOKPo446n//8suwehZczfcqMtt4gr7oB6lzhR8M5+2oaDZyJqJysFBj6QmnKy8DAD/n2ReEHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCinji5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCinji5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53E4C4CEE5;
	Tue,  8 Apr 2025 11:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111269;
	bh=YrJiwNGKO+EkZNOS8FLzzf4kt0OFINc/pfr82G/fNx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCinji5u5XeaY7HQfFf8Rc8UTjgN+lxua7i8WWOR9yvGcCjjHdx4H6op5B2wqgpfy
	 aNi5kzLgAEo51MhtZlnz9eCrjdz9c/NOowxdlg4M0Em1ZSIWBkG71XBHcQ08wPff2X
	 +vXoRL0WUpilI9NPqwEhwU7JVTmG06WVxGdcfyug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Mylavarapu <quic_mmanikan@quicinc.com>,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 369/731] drivers: clk: qcom: ipq5424: fix the freq table of sdcc1_apps clock
Date: Tue,  8 Apr 2025 12:44:26 +0200
Message-ID: <20250408104922.861044641@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>

[ Upstream commit e9ed0ac3ccba65c17ed0d59c77a340a75abc317b ]

The divider values in the sdcc1_apps frequency table were incorrectly
updated, assuming the frequency of gpll2_out_main to be 1152MHz.
However, the frequency of the gpll2_out_main clock is actually 576MHz
(gpll2/2).

Due to these incorrect divider values, the sdcc1_apps clock is running
at half of the expected frequency.

Fixing the frequency table of sdcc1_apps allows the sdcc1_apps clock to
run according to the frequency plan.

Fixes: 21b5d5a4a311 ("clk: qcom: add Global Clock controller (GCC) driver for IPQ5424 SoC")
Signed-off-by: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
Reviewed-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250306112900.3319330-1-quic_mmanikan@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5424.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/qcom/gcc-ipq5424.c b/drivers/clk/qcom/gcc-ipq5424.c
index d5b218b76e291..107424395ef17 100644
--- a/drivers/clk/qcom/gcc-ipq5424.c
+++ b/drivers/clk/qcom/gcc-ipq5424.c
@@ -634,11 +634,11 @@ static struct clk_rcg2 gcc_qupv3_uart1_clk_src = {
 static const struct freq_tbl ftbl_gcc_sdcc1_apps_clk_src[] = {
 	F(144000, P_XO, 16, 12, 125),
 	F(400000, P_XO, 12, 1, 5),
-	F(24000000, P_XO, 1, 0, 0),
-	F(48000000, P_GPLL2_OUT_MAIN, 12, 1, 2),
-	F(96000000, P_GPLL2_OUT_MAIN, 6, 1, 2),
+	F(24000000, P_GPLL2_OUT_MAIN, 12, 1, 2),
+	F(48000000, P_GPLL2_OUT_MAIN, 12, 0, 0),
+	F(96000000, P_GPLL2_OUT_MAIN, 6, 0, 0),
 	F(177777778, P_GPLL0_OUT_MAIN, 4.5, 0, 0),
-	F(192000000, P_GPLL2_OUT_MAIN, 6, 0, 0),
+	F(192000000, P_GPLL2_OUT_MAIN, 3, 0, 0),
 	F(200000000, P_GPLL0_OUT_MAIN, 4, 0, 0),
 	{ }
 };
-- 
2.39.5



