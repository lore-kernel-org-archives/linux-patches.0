Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6F33644DD;
	Tue,  6 Jan 2026 17:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722004; cv=none; b=Er+yilM4rqjaP/4C+oUDloZ4qu5wX6pO5h6UuIF6hSByqDXNF5Bsw8iTVVQ2D2C1kKCxErwcuO6nCWWMKrtEIrZdgkhuHATCjFf38Qe6WpQKtyGwLkpCMm5OpiKUULng/659eRRDSExNPrE/wj2DFz0SkBxNBfKovJOwo8Ho584=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722004; c=relaxed/simple;
	bh=Jwpt7SZz+BoR824jollab26Bm5epo12vgGUmsaKA9xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flIP2zrf8mV0QLeyAiz4K48V/fvx1gebUh7LwTKeD6ZboCF5+tRX6rXPTVMM/Uj+iDkGkXxC52Lfm3xaLdKHX5+PFDXyko4BFJP1/wmzh58e6qCpc2FSPyQwNFH+CvaORe5yDbK7MvD/nqb0mCBgkCkccXZJkiLd8Nj8+Yl/vfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtlKAC40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtlKAC40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37759C116C6;
	Tue,  6 Jan 2026 17:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722004;
	bh=Jwpt7SZz+BoR824jollab26Bm5epo12vgGUmsaKA9xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtlKAC40+VEYJHMqTCf9Wupbr/Pk83mTdF3jqcc+ROn53uCkT5HuVrHxIaZfXjY/B
	 80E2bFT4vuTudUYgDlorKOA8mOTcj3eHb/lJgFL5Mh6b2TlmiSiZn3GSVm4RaSWlsG
	 IDgFEPwp7Lcney1P0ZTZB6KFd/Mw8lBf4YSTbkHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 137/312] clk: qcom: mmcc-sdm660: Add missing MDSS reset
Date: Tue,  6 Jan 2026 18:03:31 +0100
Message-ID: <20260106170552.797380372@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Alexey Minnekhanov <alexeymin@postmarketos.org>

commit 0a0ea5541d30c0fbb3dac975bd1983f299cd6948 upstream.

Add offset for display subsystem reset in multimedia clock controller
block, which is necessary to reset display when there is some
configuration in display controller left by previous stock (Android)
bootloader to provide continuous splash functionaluty.

Before 6.17 power domains were turned off for long enough to clear
registers, now this is not the case and a proper reset is needed to
have functioning display.

Fixes: 0e789b491ba0 ("pmdomain: core: Leave powered-on genpds on until sync_state")
Cc: stable@vger.kernel.org # 6.17
Signed-off-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251116-sdm660-mdss-reset-v2-2-6219bec0a97f@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/mmcc-sdm660.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/mmcc-sdm660.c b/drivers/clk/qcom/mmcc-sdm660.c
index b723c536dfb6..dbd3f561dc6d 100644
--- a/drivers/clk/qcom/mmcc-sdm660.c
+++ b/drivers/clk/qcom/mmcc-sdm660.c
@@ -2781,6 +2781,7 @@ static struct gdsc *mmcc_sdm660_gdscs[] = {
 };
 
 static const struct qcom_reset_map mmcc_660_resets[] = {
+	[MDSS_BCR] = { 0x2300 },
 	[CAMSS_MICRO_BCR] = { 0x3490 },
 };
 
-- 
2.52.0



