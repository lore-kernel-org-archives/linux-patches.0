Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051FA34AB1F;
	Tue, 16 Dec 2025 11:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885219; cv=none; b=cdVAKniXmGahepisKryWKlPJeyb2pOqmoj+2w7gw5WGLmwX+o804reTQnqDsrRLJ/XQ7LsZxvxfzOIGoN5jonaGgHCrE4oTjPwabbZVUJ2/iXT1lM50LW4NyAAjqUriN1XKyzW7erHdrQg7rZ6cSMBYkKnnfOLHOJYE8DSL6alc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885219; c=relaxed/simple;
	bh=zYREsMsqpUuvuA6bPw+BZlHHBzZA0lOj5GgjYBGk18I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8M6TXNAOIKgpoudmPY/hwiqdEw6bKHaGgri9UQkFUkMUrXlS0ZglHK6bfpD8gZRP7wA3G1cJ1UJMEwV2uhhDj68gu7Sf/AmpQH+LyZpyJWBynF6yNhzs/6GgCfG/hB9XNuv+miWBTluUMbMDBX8nbYghEWCp6xmaBUhhYd2Lt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qubmaVL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qubmaVL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D76C4CEF1;
	Tue, 16 Dec 2025 11:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885218;
	bh=zYREsMsqpUuvuA6bPw+BZlHHBzZA0lOj5GgjYBGk18I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qubmaVL8igWuWNw0ePZS7rlwLIh9/IB81lfDdmOVVX7i8E1N5++QwXFjX+pjZPHQv
	 GQheGZCKKPdJn0nkm9x4MxLOUE+5k1Jg3Z2XPkWOG9gyHKpcf++AlQKdZT8PZBFIQ8
	 w6I2Kd7yjlEkSqMQzRksZBLhQ/G4M4TyNt91g5Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 074/507] clk: qcom: gcc-sm8750: Add a new frequency for sdcc2 clock
Date: Tue, 16 Dec 2025 12:08:35 +0100
Message-ID: <20251216111348.223437640@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit 393f7834cd2b1eaf4a9eff2701e706e73e660dd7 ]

The SD card support requires a 37.5MHz clock; add it to the frequency
list for the storage SW driver to be able to request for the frequency.

Fixes: 3267c774f3ff ("clk: qcom: Add support for GCC on SM8750")
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250924-sm8750_gcc_sdcc2_frequency-v1-1-541fd321125f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8750.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-sm8750.c b/drivers/clk/qcom/gcc-sm8750.c
index 8092dd6b37b56..def86b71a3da5 100644
--- a/drivers/clk/qcom/gcc-sm8750.c
+++ b/drivers/clk/qcom/gcc-sm8750.c
@@ -1012,6 +1012,7 @@ static struct clk_rcg2 gcc_qupv3_wrap2_s7_clk_src = {
 static const struct freq_tbl ftbl_gcc_sdcc2_apps_clk_src[] = {
 	F(400000, P_BI_TCXO, 12, 1, 4),
 	F(25000000, P_GCC_GPLL0_OUT_EVEN, 12, 0, 0),
+	F(37500000, P_GCC_GPLL0_OUT_EVEN, 8, 0, 0),
 	F(50000000, P_GCC_GPLL0_OUT_EVEN, 6, 0, 0),
 	F(100000000, P_GCC_GPLL0_OUT_EVEN, 3, 0, 0),
 	F(202000000, P_GCC_GPLL9_OUT_MAIN, 4, 0, 0),
-- 
2.51.0



