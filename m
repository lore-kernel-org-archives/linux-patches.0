Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549E4391E4B;
	Sat, 12 Sep 2026 19:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243181; cv=none; b=aN2XP12/ydJag5Fp7pXVk1tpwfy+JEY9Tm8/BXb1SgzqrPBgnlG1wS+y7xCSiUT55PCwtJIdpMUqlT1L56zj+im4DmiYYtpRCHVypB0fB4f0zCRTfYq76IlSU4HIZsB0f0QwMbPSeGrEPJDtTgLWxoA3QZ94fbZcfdqFGfbWBBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243181; c=relaxed/simple;
	bh=T3llMYvCvqQkhnsvprTnFgR+4d8zrdVKbTqyO4i7D0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bt4sL0ZRlNDbp550pevxeICozmBcddhdCcJpMycKFV0YF3OM+S9d7QGL9cDZK/f98MeHKYbNP9GTS6jePO9RMan7FJNqyMVHTcqfldgBfNTF0il5Anzy+7l+tn6R7CKGkvdsi7hZ/sZYYszvrauHUSh0R55e698Y7SvhIIVIKio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIeFdaYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIeFdaYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708431F000FF;
	Sat, 12 Sep 2026 19:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243180;
	bh=8s4J94/xzUU2fU1+Lbz+03E36tK/jlgvnGdxoYDaNrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SIeFdaYOlKuraGd9epH4iWIiE1cMkNrzPg4M7Q824YbzQM1OqJgRUTXF6rFUAvUyt
	 O6D4lfRap/5/e9D+kcd6Fal50jr7ybPZs+oqhgpuMA/YM7Gguv0+FhytW9ZmvE6psZ
	 i4vST8mwexrXZL79sfRgRMJX6i43++H/z5acQ128=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 666/798] powerpc/configs: enable CONFIG_RAS to fix EDAC support
Date: Sat, 12 Sep 2026 09:04:54 +0200
Message-ID: <20260912065532.371402715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 3921cfc2e8155a767235801be88cbd0e4c73508d ]

Before commit e3c4ff6d8c94 ("EDAC: Remove EDAC_MM_EDAC") EDAC_MM_EDAC
selected RAS, after that commit, EDAC depends on RAS, but nobody enables
it. Enable it in the config again.

Fixes: e3c4ff6d8c94 ("EDAC: Remove EDAC_MM_EDAC")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260730105546.3658570-1-mwalle@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/configs/85xx-hw.config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/configs/85xx-hw.config b/arch/powerpc/configs/85xx-hw.config
index 8aff832173977..b655c36e56dad 100644
--- a/arch/powerpc/configs/85xx-hw.config
+++ b/arch/powerpc/configs/85xx-hw.config
@@ -90,6 +90,7 @@ CONFIG_PPC_EPAPR_HV_BYTECHAN=y
 CONFIG_QE_GPIO=y
 CONFIG_QUICC_ENGINE=y
 CONFIG_RAPIDIO=y
+CONFIG_RAS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_CMOS=y
 CONFIG_RTC_DRV_DS1307=y
-- 
2.53.0



