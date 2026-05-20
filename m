Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CC031F9BE;
	Wed, 20 May 2026 16:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295938; cv=none; b=Ntbz6s58mWP5oXInhOJbLR4dHqv82aR8ROH4WBCLR8HLcC7KF17wzKDlYXxYWk8ezcS7ppxzV4Cl+ZRNaZRzNNNcQRjMsgiCWMWgZgP0r8w0D9KpLAohkhxSxSUS2DscheHMYU2HbUvvbVstD9NuiPvYwnN32pshtHB46RH0HJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295938; c=relaxed/simple;
	bh=onKFGNISb1vy2QMlBIXk22cPsOUUvqbCjq4l7fTsn18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dxe8drM/yOU0l3uoeP6qMZLZ2YImyRrZBMiN1rTwZPQlbzKFXuDK3XaRXo9JRIkMP1wdWWQeb3A0koCKHX0cB43hU/Ya1QCAgh3zH6Mm5o75DmuYIHH/cDcEZYTwEjF50wV9CySA9PwW2m+Is7qyY4iUFavqexwvrg2+S4z8Lcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7tnzsnG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7tnzsnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C44F1F000E9;
	Wed, 20 May 2026 16:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295936;
	bh=pytLVnX54q2YidkE6szHaqLGjd5TY8+CX8cPZsBRO2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7tnzsnGChqKhrzxnA+/wbTsa0COJt7MFFCn3Nc4El5dlLS4jrKzAAMZaaXqThmx0
	 Ey2dDZrVEX+dZxy+lvz6iW1xpOQHWX39RR9qVgLZIvBW+p/HRGppxYrq6/ciD68qiU
	 +bvjuhG2zzoRmpv7PAqe785E/AqpnvUkf8PdN9H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0559/1146] soc: qcom: llcc: fix v1 SB syndrome register offset
Date: Wed, 20 May 2026 18:13:29 +0200
Message-ID: <20260520162200.831588194@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 24e7625df5ce065393249b78930781be593bc381 ]

The llcc_v1_edac_reg_offset table uses 0x2304c for trp_ecc_sb_err_syn0,
which is inconsistent with the surrounding TRP ECC registers (0x2034x)
and with llcc_v2_1_edac_reg_offset, where trp_ecc_sb_err_syn0 is 0x2034c
adjacent to trp_ecc_error_status0/1 at 0x20344/0x20348.

Use 0x2034c for llcc v1 so the SB syndrome register follows the expected
+0x4 progression from trp_ecc_error_status1. This fixes EDAC reading the
wrong register for SB syndrome reporting.

Fixes: c13d7d261e36 ("soc: qcom: llcc: Pass LLCC version based register offsets to EDAC driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260330095118.2657362-1-alok.a.tiwari@oracle.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/llcc-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index ad5899d083f3f..b80d3f9cff641 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -3943,7 +3943,7 @@ static const struct llcc_slice_config x1e80100_data[] = {
 static const struct llcc_edac_reg_offset llcc_v1_edac_reg_offset = {
 	.trp_ecc_error_status0 = 0x20344,
 	.trp_ecc_error_status1 = 0x20348,
-	.trp_ecc_sb_err_syn0 = 0x2304c,
+	.trp_ecc_sb_err_syn0 = 0x2034c,
 	.trp_ecc_db_err_syn0 = 0x20370,
 	.trp_ecc_error_cntr_clear = 0x20440,
 	.trp_interrupt_0_status = 0x20480,
-- 
2.53.0



