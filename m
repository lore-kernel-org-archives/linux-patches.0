Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2CB47ACCA;
	Sat, 12 Sep 2026 18:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237328; cv=none; b=MolRgWjYJGu/ZXgyDWP4mep2lNy27Wk2RSdaBs1J/7eBRdEvIdMFx51ATfoC7MoRPjK26lIpwKYyVeJBNqjB/hiAX9cjuJKyc8V+LfntE/W6ZzY9VW9+6SO4yuZAri+RvDPCfKZEq2GwRwatUjo1n57Hbb7cNQkdrW33SfrtDl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237328; c=relaxed/simple;
	bh=cdoC21KtXealnfO4HFtpg6+iBclAHpLPPCtON4BrXbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxuT+BhLj1YiWeCWCExbT9x3uPxVzVsaeHcX4kQhFjYN8YR4evqWyuFaUcBg4z+hSDbzsFy0K2jEQv/ene9P8k39tyipPDuYLX7/UMvTiGPffzVsE+Jg9t3npdGtaDasM5+y+UslYWB4hXUM+ISm9RvOEljYT5dVUCFc8qFQjso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WI+ImtRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WI+ImtRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C4F1F000FF;
	Sat, 12 Sep 2026 18:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237327;
	bh=LfIM9CTBGFdnuuqQ2FfcM4swPaWbkXfzgL06CE1CC7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WI+ImtRZmHVnru4F2np2k2sOevVKqU7ubRdpQ0OePvw2J3KCnGwT0ht+YSKS2Q8CM
	 YV4bMuTCdTvNIL5Jg+kE7bs020KEH6YYIlVEm5AZsWK14tx4zo9LNjtBmabgE7rrVS
	 ieQD7MNEZSICZXY5i+v3KFPD9908y/T4NTadUdKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 236/935] clk: qcom: gcc-mdm9607: Increase delay for USB PHY reset
Date: Sat, 12 Sep 2026 08:54:26 +0200
Message-ID: <20260912065532.240630235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan@gerhold.net>

commit c99bc8e83848358bd4a0436e4bdae5b7919babb2 upstream.

To conform to the specifications of the USB PHY, the reset signal should be
asserted for at least 10us. Guarantee that by increasing the delay for the
USB2_HS_PHY_ONLY_BCR reset control similar to commit dcc6c9fb7128 ("clk:
qcom: gcc-msm8909: Increase delay for USB PHY reset").

Cc: stable@vger.kernel.org
Fixes: 48b7253264ea ("clk: qcom: Add MDM9607 GCC driver")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20260706-qcom-clk-mdm9607-fixes-v2-5-745565101869@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-mdm9607.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/gcc-mdm9607.c
+++ b/drivers/clk/qcom/gcc-mdm9607.c
@@ -1568,7 +1568,7 @@ static const struct qcom_reset_map gcc_m
 	[USB_HS_HSIC_BCR] = { 0x3d05c },
 	[GCC_MSS_RESTART] = { 0x3e000 },
 	[USB_HS_BCR] = { 0x41000 },
-	[USB2_HS_PHY_ONLY_BCR] = { 0x41034 },
+	[USB2_HS_PHY_ONLY_BCR] = { .reg = 0x41034, .udelay = 15 },
 	[QUSB2_PHY_BCR] = { 0x4103c },
 };
 


