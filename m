Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21E234DCED;
	Tue, 26 Aug 2025 14:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217423; cv=none; b=P9dPYv16x4WPC7xYHDBYID/S27/qMCexd4d6bCcZ5d0Kw2+cOwu/i+N41PHsmZTXIbDN8R3kRGcBeo9/sjT6N8QIShHzsFCsnFqRTUczXsZhm8JiNSoSEKWf9D7X3VS93qjpiA79kzCvHCTVClGKXxTG9ARuFJZYk6fq9Z6xzWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217423; c=relaxed/simple;
	bh=YPv0qCtJ0gFtqLe6B7ksGJ8dk+KHf56ao35aWeqoiD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSERZErGQy2u+nnfpVhp2b5QgOaFunhvttmtIhe/L4Q/f0pA3ayOCgzbJ2Tq1ddU3f1E1dD1fGqARZbOyv5rYKgEltsLyzBCPxPX/0HV3fFix9JIT9gK4KklwonQapZppVmH//YQO6JJTIyU156VIB7P9GcSPwqFeLbJAgpd2fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjFzdUh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjFzdUh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DC5C4CEF1;
	Tue, 26 Aug 2025 14:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217422;
	bh=YPv0qCtJ0gFtqLe6B7ksGJ8dk+KHf56ao35aWeqoiD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjFzdUh8dsonsMrz/LqW6BsQc3385nyxWNWWcB7iGbV4wIzF2iSocTu24CmmAZWiw
	 pah1ByD1mCq7SZIefNqbumoHSzscIkSN268ri5v8DG5iccyZ2jGt8v8joNn2Rbb6JB
	 l9p6NhUCWFtoQeIwR7Xf0gya4aZtsqapqNdIxJjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Korsnes <johan.korsnes@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/523] arch: powerpc: defconfig: Drop obsolete CONFIG_NET_CLS_TCINDEX
Date: Tue, 26 Aug 2025 13:05:16 +0200
Message-ID: <20250826110927.150136481@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 021da6736570..7c14fecc7154 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -265,7 +265,6 @@ CONFIG_NET_SCH_DSMARK=m
 CONFIG_NET_SCH_NETEM=m
 CONFIG_NET_SCH_INGRESS=m
 CONFIG_NET_CLS_BASIC=m
-CONFIG_NET_CLS_TCINDEX=m
 CONFIG_NET_CLS_ROUTE4=m
 CONFIG_NET_CLS_FW=m
 CONFIG_NET_CLS_U32=m
-- 
2.39.5



