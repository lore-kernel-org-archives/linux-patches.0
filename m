Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE15B26B0B4;
	Thu, 13 Feb 2025 15:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460435; cv=none; b=skVMe5jwfFV4Hw1VspgC/ioOmGU4jopgwP8/E6MPXhmKbwzHL0mWkI2pT9C7o7KuLJd1w971IZioI6trnyEKHnKMgEFiBqoEGjnQ4buGWSjjpzfF7xRI4LmGIpwUIlm3WTF2fsolox53b8URIio7SfM4HXePrMDsfHAkxdOgerk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460435; c=relaxed/simple;
	bh=LFktnINcZBdtcTQtWwRE9HvL3nMNsy87MbdDlBXL+7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nf9Bl6lLK1zZYaR27F5LuTkzgTpxz6lnhFWLjEUJsyyA8aUKgBreePWf2Xq770hI+egpipCge+zQa3N5GDMpxewDFtScrkysHCSHKoyCRLDmGmWM7W5oEZFf5ahqRhDxDRTiMg+lye2Qqgj8AgUQ6MgF4+hJH6iHwjtyJRYag18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlOzQ3d7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlOzQ3d7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A2EC4CEE5;
	Thu, 13 Feb 2025 15:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460434;
	bh=LFktnINcZBdtcTQtWwRE9HvL3nMNsy87MbdDlBXL+7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlOzQ3d7FEQSiX2E19zDKpxv7d0S/TsvvrkEto21juJTeFqZvjCLeyy7Uz4cZVTyR
	 9LCbXKLnEfMfxRf6XqA6tNpPSDA3eSlYQ/xRGLXpAjChCTSW/WOxvwQvHFKeRT7PEv
	 A5DxLMbrUwUtAC2if9Vc9A+kNuHtu2kz0CLR31kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 112/273] clk: qcom: gcc-mdm9607: Fix cmd_rcgr offset for blsp1_uart6 rcg
Date: Thu, 13 Feb 2025 15:28:04 +0100
Message-ID: <20250213142411.770630213@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

commit 88d9dca36aac9659446be1e569d8fbe3462b5741 upstream.

Fix cmd_rcgr offset for blsp1_uart6_apps_clk_src on mdm9607 platform.

Fixes: 48b7253264ea ("clk: qcom: Add MDM9607 GCC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241220095048.248425-1-quic_skakitap@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-mdm9607.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/gcc-mdm9607.c
+++ b/drivers/clk/qcom/gcc-mdm9607.c
@@ -535,7 +535,7 @@ static struct clk_rcg2 blsp1_uart5_apps_
 };
 
 static struct clk_rcg2 blsp1_uart6_apps_clk_src = {
-	.cmd_rcgr = 0x6044,
+	.cmd_rcgr = 0x7044,
 	.mnd_width = 16,
 	.hid_width = 5,
 	.parent_map = gcc_xo_gpll0_map,


