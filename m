Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6C322FE18;
	Mon, 10 Mar 2025 17:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627694; cv=none; b=X+3+Vopot9CCpOpHLZM6lSUWkN55veb6rRxGynpPhmryGUSGnj//KwkfzWetmukyM1PWozCZhwxXHw/hWPh0RJV1kb9KAS42fcLV4D47EtHbVe+1uLX/OI2MfxzgB+EHySt5iGZhb4XZcpozI60OXGzXB4mCVd80fzxlvpeZ/6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627694; c=relaxed/simple;
	bh=qkBq99Ue2+DwG+JUiLkTnakek6KX6QD27xH2i3XuCE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGhmlSrweVeykQt6w0CfmR2hlFfqq89XvQ1evji16Ivj7HJ3z79MUyYDKyZrNeSB2QjQtPdqR+QLhCfuMvZgOJa5bNBzjjD6rXIHKFN0on8SHX4mQPCmpF+rKCWfMGyK9/V2OqPXavxZwKCto3RKikLhJmbrggLLRXwtv8VVmi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzUzBHhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzUzBHhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B160C4CEE5;
	Mon, 10 Mar 2025 17:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627694;
	bh=qkBq99Ue2+DwG+JUiLkTnakek6KX6QD27xH2i3XuCE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzUzBHhSGFs5izlWlXjDrUia7+XOHIyUb5nSPfK2y8VAIJt3MQukA0D9+ngRgHkJm
	 OLBVaebZFW65O7lC9Whi998z9UcCBM4ClVzgG6Al8d51WKFQy7KGQ5TQDFMcV7iPGQ
	 xQfhIPu3nh1rvDqDDlOXaeK6G7MrR9w1z+oLYd6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/269] net: ipa: Fix QSB data for v4.7
Date: Mon, 10 Mar 2025 18:05:39 +0100
Message-ID: <20250310170505.120874504@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 6a2843aaf551d87beb92d774f7d5b8ae007fe774 ]

As per downstream reference, max_writes should be 12 and max_reads
should be 13.

Fixes: b310de784bac ("net: ipa: add IPA v4.7 support")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Link: https://patch.msgid.link/20250227-ipa-v4-7-fixes-v1-2-a88dd8249d8a@fairphone.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/data/ipa_data-v4.7.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/data/ipa_data-v4.7.c b/drivers/net/ipa/data/ipa_data-v4.7.c
index 7e315779e6648..e63dcf8d45567 100644
--- a/drivers/net/ipa/data/ipa_data-v4.7.c
+++ b/drivers/net/ipa/data/ipa_data-v4.7.c
@@ -38,8 +38,8 @@ enum ipa_rsrc_group_id {
 /* QSB configuration data for an SoC having IPA v4.7 */
 static const struct ipa_qsb_data ipa_qsb_data[] = {
 	[IPA_QSB_MASTER_DDR] = {
-		.max_writes		= 8,
-		.max_reads		= 0,	/* no limit (hardware max) */
+		.max_writes		= 12,
+		.max_reads		= 13,
 		.max_reads_beats	= 120,
 	},
 };
-- 
2.39.5



