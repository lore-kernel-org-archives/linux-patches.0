Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD70F3264F9;
	Sat, 12 Sep 2026 13:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221150; cv=none; b=SjPIzZkSMQXwpomf/LTxMeN5O5tPqCrqZ9cKqIiQLR0ro9tO/22Jfr34XeAdRoiLhMBH4kwgTuaydyQl6KVpNBgt4Iq1zsDU0+DdwrbX3IM8PwWbNjg7pIaRhn33he6hRSYFD6F3+ArgK7UryaF5P36jv3+Vpa77BfvzTIUzetc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221150; c=relaxed/simple;
	bh=B/Z7u8BgREufXsqzMjO5ppz/dfP8w7tARTTyWLx+seI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbpsSb73i7cE1GspGxHwXKsMWbcMmsUvxLe9qKHYgnq2/q8RfOd0yY+ndjPYgAb7ljoeZhaDUbWFcoN5mvNqxtmABrWBgrpHnnw82oJBHBtjFLVZARe/B+nNGQEOrObH9rxlLJmO43qhizghF0XpGUembpbChLBz/OvkWQI0nT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHNTftKM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHNTftKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF801F000FF;
	Sat, 12 Sep 2026 13:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221148;
	bh=WDyt4cPc8LA3Q00VbIjCY5jcumf4PEcScOjGG2WhT6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHNTftKMjTlnnXJtm5P7zekYuT654CsAxbBsdAGjzvPeU1JgpCVBvF+37sz6+4ki/
	 nK1PMSKzMVmahj9QnUoiaL5xKO2OgzBJs/ahDwRLjO6w6z+rQc4b8BcWwOAFxO6J7q
	 GEBKwKZs3bx5IN4OSTUSIi3IUBKn6QProvon34sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 0324/1424] clk: qcom: gcc-mdm9607: Increase delay for USB PHY reset
Date: Sat, 12 Sep 2026 08:45:56 +0200
Message-ID: <20260912065614.542105271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1567,7 +1567,7 @@ static const struct qcom_reset_map gcc_m
 	[USB_HS_HSIC_BCR] = { 0x3d05c },
 	[GCC_MSS_RESTART] = { 0x3e000 },
 	[USB_HS_BCR] = { 0x41000 },
-	[USB2_HS_PHY_ONLY_BCR] = { 0x41034 },
+	[USB2_HS_PHY_ONLY_BCR] = { .reg = 0x41034, .udelay = 15 },
 	[QUSB2_PHY_BCR] = { 0x4103c },
 };
 


