Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91706350D7B;
	Tue, 26 Aug 2025 14:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218684; cv=none; b=esS+Grz8V3EgJNyvB9R942ufseQMHginDfqCFPgQ+jO5CGldTbT5wlgkwOTXd2BjOoIGBPn8f5Uru/okPa1m6e4dhwWp4pRfMteix9Q2b5++jWPzO2wcmP+fjy2QX1M2UCdKGOyJebhH3DoZWtOg5smuR7eavVOSJSGFHX6Lx5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218684; c=relaxed/simple;
	bh=Z06c/Aff+Vh4tPT1xS2ZBVJIw5DvzQ5ggTDd9BFks1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3L3sF64i6nkrQ1pwEeBYiDkNMGAh+WQGnQcfP3Y4TpBU0vcAPDiBw4MbSQtFF49CRAVaWwkCu44nDENIIzTm37Agcd+e/hmWQXwEA/IM3XkemU2hsC9inRtmpcl58GEQ9azSQSowS2hrYEeHdTCF6yEMbxMcQaIPeQBzAyeyCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIxqs5hg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIxqs5hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1C0C4CEF1;
	Tue, 26 Aug 2025 14:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218684;
	bh=Z06c/Aff+Vh4tPT1xS2ZBVJIw5DvzQ5ggTDd9BFks1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIxqs5hg7rfyWUkiUBPu1ifptTXBXH2RnYUCVlvoFphCou97kwkBXZQ7O71jHnF9M
	 7njaMHXjlbGHbSz24ccWid7NvmeyAMx/5cfeIsuSTqA+RUe8tn/iZ3w7pKSMTgnoVn
	 cVxrsscJYk+YnrmUtm6vMx1DPybhpotckIcLpQzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Korsnes <johan.korsnes@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/403] arch: powerpc: defconfig: Drop obsolete CONFIG_NET_CLS_TCINDEX
Date: Tue, 26 Aug 2025 13:07:00 +0200
Message-ID: <20250826110909.269037763@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Korsnes <johan.korsnes@gmail.com>

[ Upstream commit 75cd37c5f28b85979fd5a65174013010f6b78f27 ]

This option was removed from the Kconfig in commit
8c710f75256b ("net/sched: Retire tcindex classifier") but it was not
removed from the defconfigs.

Fixes: 8c710f75256b ("net/sched: Retire tcindex classifier")
Signed-off-by: Johan Korsnes <johan.korsnes@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250323191116.113482-1-johan.korsnes@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/configs/ppc6xx_defconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index b75b62b094b5..319fe81a4a39 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -274,7 +274,6 @@ CONFIG_NET_SCH_DSMARK=m
 CONFIG_NET_SCH_NETEM=m
 CONFIG_NET_SCH_INGRESS=m
 CONFIG_NET_CLS_BASIC=m
-CONFIG_NET_CLS_TCINDEX=m
 CONFIG_NET_CLS_ROUTE4=m
 CONFIG_NET_CLS_FW=m
 CONFIG_NET_CLS_U32=m
-- 
2.39.5



