Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38C225EF93;
	Thu, 17 Apr 2025 17:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912569; cv=none; b=EM7P8dWFReJo6+9MMXSK1DSZThJh9osMSzHB604Qer77K3EPuxmuhCX90ZZFpAvdSfXnLxbhQncAlhkVLiOpIKpUzl5um1WdbereIGIESEzQ/l8qgueurU4vA+fClALA5CU2VEF92Orr62IhhDKkZKw+L7OGcM7e5jdOe1E5RT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912569; c=relaxed/simple;
	bh=2a0mnXXBMeD5mB9h+FrEn1PrkpJU810zyQafx2lGxQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcOxpBWy4i434CTzEkOSLQpwtf6Y2hGwgUZws/iCknQ81BgZb7mSMmy4pmmVbFMA9LPiGEaCJh+XPuY8sDTigBrfR2XmN0O0pebjahJLpLsWwisS9Rhz9PaQoBTmTjKaULwecYmEpF5akQTo84oV8ZBu/uDcjrGR5fIeW0rWUsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UeSj+8Na; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeSj+8Na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F1CC4CEE4;
	Thu, 17 Apr 2025 17:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912569;
	bh=2a0mnXXBMeD5mB9h+FrEn1PrkpJU810zyQafx2lGxQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeSj+8NayPh1eZvM5Ny16BegQsTzCKjH7lc7VkoxYPK9sNGteAyE3UP9XKYjx2uB0
	 tSGyx4WRWW00T8ASPqM1cmKzjalEWkXGZ97mmYQANKoTDTJo+vrUopChyNlWKsch+1
	 Nt2cVYuCfnlEN3biRdhoG2LhyDKzKuDbRc3HZaVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 036/449] x86/cpu: Avoid running off the end of an AMD erratum table
Date: Thu, 17 Apr 2025 19:45:24 +0200
Message-ID: <20250417175119.447311944@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave.hansen@linux.intel.com>

[ Upstream commit f0df00ebc57f803603f2a2e0df197e51f06fbe90 ]

The NULL array terminator at the end of erratum_1386_microcode was
removed during the switch from x86_cpu_desc to x86_cpu_id. This
causes readers to run off the end of the array.

Replace the NULL.

Fixes: f3f325152673 ("x86/cpu: Move AMD erratum 1386 table over to 'x86_cpu_id'")
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 54194f5995de3..ce71f49654ee3 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -803,6 +803,7 @@ static void init_amd_bd(struct cpuinfo_x86 *c)
 static const struct x86_cpu_id erratum_1386_microcode[] = {
 	X86_MATCH_VFM_STEPS(VFM_MAKE(X86_VENDOR_AMD, 0x17, 0x01), 0x2, 0x2, 0x0800126e),
 	X86_MATCH_VFM_STEPS(VFM_MAKE(X86_VENDOR_AMD, 0x17, 0x31), 0x0, 0x0, 0x08301052),
+	{}
 };
 
 static void fix_erratum_1386(struct cpuinfo_x86 *c)
-- 
2.39.5



