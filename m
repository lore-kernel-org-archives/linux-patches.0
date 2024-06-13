Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8650143C46;
	Thu, 13 Jun 2024 12:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282250; cv=none; b=fdFiRTWXCExhMVN54Uo/wwBxCtLUiRI90DmQo+GRm99KBl8xJJcRwem3qNIN05sushqnFNZUznKoDnqobMjLuiGXmSH/KI2e4D580n05Xgn1pGAbaOYv03OVr0zKM9+lgjmadsHANvqLPNlvYhlld0oqRw3wTac0C2MfvoUbjvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282250; c=relaxed/simple;
	bh=8WffJuHFXbRxWPXe0G40deMv9yCJD1FroBBUy1haSqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8Degydmn/R1Rv1GbYNc4ciIPljVpVii5/5adaDhUsGlMjNEDTbesAENO6w28p0N2ydjdzFVqxYrigUkC8pNeUi1w8NsZZ3LSfzjVVmpDaIGJId09uV58jF4YpSamGK69+Dj9GfSIovxj7D2stoZ4OvOVtNfX36d9W8zdHefT5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNGmAUmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNGmAUmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F133C4AF1A;
	Thu, 13 Jun 2024 12:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282249;
	bh=8WffJuHFXbRxWPXe0G40deMv9yCJD1FroBBUy1haSqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNGmAUmyQY0cuLGow1fQOsROFRRdpFtmBArlPvDcy1vZOGZjWD5HSz3/tVg/JMOXD
	 tuLyraabmlIVi1HMMBoseeEKTvrDIgwNLTg7I5R8L3Ba1UItVRzu+S10WguLz0eYx9
	 GNENvuQ0El4FjpLS9x7I1ApX+RHxqbfQD6BvflyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 212/402] microblaze: Remove gcc flag for non existing early_printk.c file
Date: Thu, 13 Jun 2024 13:32:49 +0200
Message-ID: <20240613113310.419151017@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Simek <michal.simek@amd.com>

[ Upstream commit edc66cf0c4164aa3daf6cc55e970bb94383a6a57 ]

early_printk support for removed long time ago but compilation flag for
ftrace still points to already removed file that's why remove that line
too.

Fixes: 96f0e6fcc9ad ("microblaze: remove redundant early_printk support")
Signed-off-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/5493467419cd2510a32854e2807bcd263de981a0.1712823702.git.michal.simek@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/microblaze/kernel/Makefile b/arch/microblaze/kernel/Makefile
index 15a20eb814cef..46dcc3b6a00f7 100644
--- a/arch/microblaze/kernel/Makefile
+++ b/arch/microblaze/kernel/Makefile
@@ -7,7 +7,6 @@ ifdef CONFIG_FUNCTION_TRACER
 # Do not trace early boot code and low level code
 CFLAGS_REMOVE_timer.o = -pg
 CFLAGS_REMOVE_intc.o = -pg
-CFLAGS_REMOVE_early_printk.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_process.o = -pg
 endif
-- 
2.43.0



