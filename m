Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13D22FE579;
	Tue, 12 Aug 2025 18:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023985; cv=none; b=ZlNINW3lSI9CeMziTb25y9p5vUy/QUdmOZ4dGXALvhTAQsnmNHXWbWi/9Q9eVaIrJLJC7HHoH2Eap3rdrA5z2jmV8RNQlwe3dvlbT7DeAJsQuEHKT3ipkZXTAkYXI4Y+f/Xww9JLP4QM+pbJBy1A/MYVBsoP+ymPDcuLtU4SeBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023985; c=relaxed/simple;
	bh=/m10iM81LQvaU6efVs4NbsQkDmaTSU3Qq9nisbKc7zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwGTtJ38RRQhvf3cKFkbF4k/HxpC3bUaFQ/3p8uXEScJGcqrHMEroOmfyi/oHoZU2A1axI8M46VjAjIhIxiSxeelGapqJhwBmd68o+N+vnKszFPmn6k+xvMppf6K5FMLCMo5orcmhk0j9+94CCJZcaH30pyxr/faa4+lLsVLeWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f836mJMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f836mJMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4435C4CEF0;
	Tue, 12 Aug 2025 18:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023985;
	bh=/m10iM81LQvaU6efVs4NbsQkDmaTSU3Qq9nisbKc7zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f836mJMxq1Jd7YciTwda+Kh8Nn3n9MMEVrYZdG9tRG8jaKBs1B0oatNW5jc/QA5b4
	 YQPa/kr3BtC9a4If35IeGa+VFicf3gH9N0JSpFEiPOf/bj0KjaF9WZLSRkKKlPrRRV
	 CHcWCAHDFUYKTfwG0gIbSCqbSpTfqv7H+qQxuWHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Korsnes <johan.korsnes@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 206/627] arch: powerpc: defconfig: Drop obsolete CONFIG_NET_CLS_TCINDEX
Date: Tue, 12 Aug 2025 19:28:21 +0200
Message-ID: <20250812173427.121055719@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index f96f8ed9856c..bb359643ddc1 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -252,7 +252,6 @@ CONFIG_NET_SCH_DSMARK=m
 CONFIG_NET_SCH_NETEM=m
 CONFIG_NET_SCH_INGRESS=m
 CONFIG_NET_CLS_BASIC=m
-CONFIG_NET_CLS_TCINDEX=m
 CONFIG_NET_CLS_ROUTE4=m
 CONFIG_NET_CLS_FW=m
 CONFIG_NET_CLS_U32=m
-- 
2.39.5



