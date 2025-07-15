Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763AC2E6106;
	Tue, 15 Jul 2025 13:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587413; cv=none; b=aCnrSqVYGgTeX3TRmyUxMk6PHTu2xLSeVTOkj49HrPnfvGdbtda3acZ24HvsH8fBjAwYsnEKgzL7ztY6B7UhXFEiL2Fy/Qb0o06lXhd96WcWmqxt4628tRc8ETHLiG5m9ClDQIv0oXCVCRz/jPs9E+zMLx7z+9ONtvXT+mJZRLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587413; c=relaxed/simple;
	bh=5WgwFm+ZE1uQUr5bnpVpUQJP0wWJ6NlDt7zXGuh8eyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IX9ybh3PRIp7cn9ohWrfWg4cNCdQBEwwcPt9sK2pArSPZSPTm4BAi1v9ROfOp8T76jqB+EDNn02uKQzdeZ4BP05oSMPJuQlhS91HTtZJ33LTFxdZw2V5lR5Em3bMvyWqJCeByMfBXhv2rhrRC+sVU+H4gVBpHFjRyTkq0dCgscU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZv7LHyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZv7LHyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09510C4CEE3;
	Tue, 15 Jul 2025 13:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587413;
	bh=5WgwFm+ZE1uQUr5bnpVpUQJP0wWJ6NlDt7zXGuh8eyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZv7LHyRYV+DWtGJFO+7Jgxu/jRJd70snZdsQlw5Cs4gks4UVcql/ArTkdwHVSxUp
	 FpgdGA5ytEsrN5Jv47vNVDEDJ9yIPFBGPk/XsxBsp/2QOA3icM5AwVC7rvyT2IslkF
	 PI3o0fLCskz55lcxt7lWBvOiMvBLK4FcUztvzViM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuzuru <yuzuru_10@proton.me>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 75/88] ASoC: amd: yc: add quirk for Acer Nitro ANV15-41 internal mic
Date: Tue, 15 Jul 2025 15:14:51 +0200
Message-ID: <20250715130757.584391396@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuzuru10 <yuzuru_10@proton.me>

[ Upstream commit 7186b81807b4a08f8bf834b6bdc72d6ed8ba1587 ]

This patch adds DMI-based quirk for the Acer Nitro ANV15-41,
allowing the internal microphone to be detected correctly on
machines with "RB" as board vendor.

Signed-off-by: Yuzuru <yuzuru_10@proton.me>
Link: https://patch.msgid.link/20250622225754.20856-1-yuzuru_10@proton.me
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index ecf4f4c0e6967..1f4c43bf817e4 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -339,6 +339,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "RB"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Nitro ANV15-41"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



