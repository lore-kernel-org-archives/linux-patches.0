Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168121B96D;
	Thu, 18 Jan 2024 10:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575416; cv=none; b=nB45BMVQfMjppna0lBGF7/6zcZpx4u/K7hFMZuvd3zFHae+JAC1pmPm7tz2L4dbeDbQVemruwSFbCF4npUW2AAiaEXbYkf5Lh7gSawKA3ggCPKLo+VCCf0Ve0BLl1ObmrLwO529zytsXEMpesTDT9u2YEh85/5ThRxXJwZ2drjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575416; c=relaxed/simple;
	bh=0QG+085uCdCq0Or4VNx9Z29UKQ5b88x9/Dj05pSHX1c=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=By1J433ZmC64YwF6FCYk4dxSYy+6JKtP4fzCmbPXXLEfczuciIqzyRGXENCM+0Rp46EV4BZ8hoKxy9EyTnLHzqpWD5gVOCwV6+XnZiYqlLmnnzvRN3Tk5F8GtII/cG6Xr3zI1B+R5BnpkcMJbVtVb5us9WiRAzngQ9qVEcoMooc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjL0+crX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjL0+crX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3F0C433F1;
	Thu, 18 Jan 2024 10:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575415;
	bh=0QG+085uCdCq0Or4VNx9Z29UKQ5b88x9/Dj05pSHX1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vjL0+crXc8dsxRkGQvZB7l3StEOw0vm/OLV/2hV5nvVclYhhBpXES9y21aA97iyrp
	 oTDLfBoH0BlTNXFbvKYPjFZjhkfM9Dbbl2/wDcCmI4Z0P4t/gw5ZZim9+aXYN8W9OC
	 Rk+kGy3KTDareDCPySGVpMhUNfMryTQagJ3lbveE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/150] ARC: fix smatch warning
Date: Thu, 18 Jan 2024 11:48:37 +0100
Message-ID: <20240118104324.343684899@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vineet Gupta <vgupta@kernel.org>

[ Upstream commit 4eb69d00fe967699b9d93f7e74a990fe813e8d2b ]

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202311280906.VAIwEAfT-lkp@intel.com/
Signed-off-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/kernel/setup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 4dcf8589b708..d08a5092c2b4 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -153,7 +153,7 @@ static int arcv2_mumbojumbo(int c, struct cpuinfo_arc *info, char *buf, int len)
 {
 	int n = 0;
 #ifdef CONFIG_ISA_ARCV2
-	const char *release, *cpu_nm, *isa_nm = "ARCv2";
+	const char *release = "", *cpu_nm = "HS38", *isa_nm = "ARCv2";
 	int dual_issue = 0, dual_enb = 0, mpy_opt, present;
 	int bpu_full, bpu_cache, bpu_pred, bpu_ret_stk;
 	char mpy_nm[16], lpb_nm[32];
@@ -172,8 +172,6 @@ static int arcv2_mumbojumbo(int c, struct cpuinfo_arc *info, char *buf, int len)
 	 * releases only update it.
 	 */
 
-	cpu_nm = "HS38";
-
 	if (info->arcver > 0x50 && info->arcver <= 0x53) {
 		release = arc_hs_rel[info->arcver - 0x51].str;
 	} else {
-- 
2.43.0



