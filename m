Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D0F3DD51A;
	Sat, 12 Sep 2026 19:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240441; cv=none; b=YR/crPt82NhmD3CAUp3Xb3TJ3PGsKi4ltoBOnnxPSMKyuYPfY+SWEsTDgyNVlyACellYA37AnYMGQqAWIJ2hdfdBQ/l/ciXWXJrlDJgCQ6mgYyEKMi3Kw1tJAs29GMD1bGhRQ0llsEO/UxWOaEKdzezyOz8OHxynVHsq5hsqu+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240441; c=relaxed/simple;
	bh=ew12EbQr2rTjq4v2PauIxWqqd8khDqkHj/4Vn85WwZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNrTEEPvm0bjQ1EmY0xSArMXhMY5X4o39wVfzOdVct4/JL8PHWI7kKwv0QjOo5yqRsNxHxSaHlZMm44+6cM3opXU/Msdnfu4V0wao+uZ0mD29pkO3u7JBucxvRME4CEsEgBd+wcOkpEDrwTH/KC2KTKYqgm35BKGlOf5ljc9MLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KsDrmtnw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsDrmtnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958F41F000FF;
	Sat, 12 Sep 2026 19:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240440;
	bh=Mid4WZZwDcD+VtXNsT4g1evyrXcxjAFrCGn+AdT8g7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KsDrmtnwFrX0uStdyt+89Sf+GszibJWVUKT3hb3i/JT2lKTo2rm4FAXa82pss8BTf
	 pbCza3g7pSVcTWVBCAdoRLzQKcwEf4fpbYuzp0VmP4N8vfip1Vo4CXSkOKGkN+YPsj
	 i6j9+hAUJvIlxyRX6tylmACl17CTxAklObGqixfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 870/935] net: ipa: report when the driver has been removed
Date: Sat, 12 Sep 2026 09:05:00 +0200
Message-ID: <20260912065546.771510504@linuxfoundation.org>
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

From: Alex Elder <elder@linaro.org>

[ Upstream commit 3c91c86d1bb61bd59d3b9a0b8003fe272fc9e774 ]

When the IPA driver has completed its initialization and setup
stages, it emits a brief message to the log.  Add a small message
that reports when it has been removed.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6b9eaa61ff2d ("net: ipa: balance runtime PM reference on remove error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index a448ec198bee1..272c1b449f7fb 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -836,6 +836,8 @@ static int ipa_remove(struct platform_device *pdev)
 	kfree(ipa);
 	ipa_power_exit(power);
 
+	dev_info(dev, "IPA driver removed");
+
 	return 0;
 }
 
-- 
2.53.0



