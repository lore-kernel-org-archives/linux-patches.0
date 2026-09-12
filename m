Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34AF47A0C7;
	Sat, 12 Sep 2026 11:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212933; cv=none; b=WWfXChRr509B/ScH5TA/gJivApab3NRIVNs+kC+txQiS9rEWqivmI0db1lHXS8hlxW5UjAynxK1u5TteQpv0UH7+HUQn/vba4FjNRj8m1ERfpDlsPqamiDhEk2stLTKPX4ouKdPSa3Gy45VlZbwO7UOZbovBIkWbJzNITBLm6OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212933; c=relaxed/simple;
	bh=+iPRmSkKxI9ShrloX4kkdNWvlREanad9uZwu4eYuAI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIls08k5sVanPEqFbKy7ExrmwelCfkrKQsw8ZCUWE7GbRwP98/yTWUJrIp6930tzab6wY/1EIeiB0vRFJ7uemjuFLGUVQIRYaCerhzp9sRG89ZLNi8lq22X/ssznMwrBWenRKrTbFmLLSzAbdsZ3cRxx17rj7p67+JVagunV6Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XeK+J9nr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XeK+J9nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A561F000FF;
	Sat, 12 Sep 2026 11:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212930;
	bh=fWKZWQE8XEr/lIBxrRh0LdR0HFhCQk1dzee98pw9DHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XeK+J9nr5e0T9+aXXkTVkaf/1Xx8UhkOAJfhM3fZPfZVJdRRcLCg7/Uvo/j9L/JUS
	 LO9EagkliR1dvvhpnswiFaKd3dd6miZzhe9zDUddNfajqNpX2OlZ6+ZlKOvMugpRP/
	 89ZJOsTKTGDUSk8RqF08V0x7wL+1IfC40NDmj8sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 0019/1376] clk: qcom: gcc-mdm9607: Increase delay for USB PHY reset
Date: Sat, 12 Sep 2026 08:40:45 +0200
Message-ID: <20260912065607.976821757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


