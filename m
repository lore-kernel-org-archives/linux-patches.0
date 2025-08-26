Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954BD27EFE7;
	Tue, 26 Aug 2025 13:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215744; cv=none; b=kTX06lMWlhMUFXaOdRZOTA4E854XlbAQ0Ce+9sk9BbGNn/3vX/SXBtdrzxPEd2/FW7mwkfGKTC4eGB6JkvcQTj89q04IZUoiYDvIX1BAK0LTT/7YnvUxKFLeTrXX2FioKAfJxpxFRhmLWB/xFjp0IFGV7k6RtlDPKKvmjweewOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215744; c=relaxed/simple;
	bh=jUgHxUKwtL/wDA+u9Rh+d9EUqBhVy5Zmdtlga3hdPtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLMksptaiPIJ1zRhUaMU5j4C7q3L+1j1SYGJjDfKRE2UEht2INpVHpmUXINpLlE2Olgt8+EK9eSnHCgKbj80amjGQbG2nys8c9QnkuBU4kORj/VCGBAwT1GbeHWPRZqPjMFHmdvRJR23jtNw+kBppRNWoshMa6N/DmEVdQCVVmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YW3lDOWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YW3lDOWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28783C4CEF1;
	Tue, 26 Aug 2025 13:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215744;
	bh=jUgHxUKwtL/wDA+u9Rh+d9EUqBhVy5Zmdtlga3hdPtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YW3lDOWOM8c+XVQ4yiRjIXQPrdcAWfrpNJbFdGwmeieTEwnvjNg9wYg6MWVIHB/1q
	 bZXlZKujTi776RqNKg0KL/wf6FgWqJ0uXJosqaoYRrD5CEldskMXsnjSXFRiAgGeMd
	 oGYAgnTAtKv02yGOJPso9zp0wgEZ3sm0EQUmO/f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Korsnes <johan.korsnes@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/644] arch: powerpc: defconfig: Drop obsolete CONFIG_NET_CLS_TCINDEX
Date: Tue, 26 Aug 2025 13:04:00 +0200
Message-ID: <20250826110950.176829160@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7f7e7add44e7..cdaf8469d484 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -263,7 +263,6 @@ CONFIG_NET_SCH_DSMARK=m
 CONFIG_NET_SCH_NETEM=m
 CONFIG_NET_SCH_INGRESS=m
 CONFIG_NET_CLS_BASIC=m
-CONFIG_NET_CLS_TCINDEX=m
 CONFIG_NET_CLS_ROUTE4=m
 CONFIG_NET_CLS_FW=m
 CONFIG_NET_CLS_U32=m
-- 
2.39.5



