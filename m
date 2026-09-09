Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CCC57267D;
	Wed,  9 Sep 2026 14:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963251; cv=none; b=GKCqGwvtfGfPrAJ8F11OOUmLLB4JPNQ6Df6eHBP92LV9Ht/AYdclO3sH+c4ZLSym7nLdsJxZXHkTYSZhvu94qmZUwFpdpm8PuEpv24of4pcDqPqpi+dMLebQjmdI1O+JmG9XCXtVSto92K/Wa9upWU+bTP+2SIA/K8YMUQTEOic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963251; c=relaxed/simple;
	bh=qgRycAy+/tNfo+EMg0/8PKBp8Pd7U/Aqb0JqkNCyIjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgOaBhUfxcbY3TpC/H7DPGluz816nS4+dqR64fai/RTNZmOZCaFGVwzQIoxgD4ibtt0qAtGxaFK5Tg4uSJ37nkG1JOBMVVUjlk978YjCnjiYqZGgqoKE1gVLbQX/koh7KZlGPfnMQtqH+j7QatgKrmUhSHOHXHlV/dSnO/gZ/VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0ONFTCh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0ONFTCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B691F00A3A;
	Wed,  9 Sep 2026 14:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963250;
	bh=/Y+7kiTK2Kn7QC5hgSb9tL4wWEJHmFfEEv5qCjquiqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0ONFTChpyeRFDxavnLK6Jenarox0ktOybhREERJ0dGCow0BNRxBq50k8RgQ6XI4l
	 nW+qSAJp6iHyHYmrdjSOW7kzm8qyxefUoUia7jiXlCRwswjvdADshVlRIdAivudTX+
	 FVmVGK5iYId7K07Kig+5+i5aDxCCj+oTVaOBtVMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 015/583] clk: qcom: gcc-mdm9607: Increase delay for USB PHY reset
Date: Wed,  9 Sep 2026 15:35:00 +0200
Message-ID: <20260909134238.337128594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


