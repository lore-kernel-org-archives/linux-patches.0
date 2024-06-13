Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A212A143C59;
	Thu, 13 Jun 2024 11:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278867; cv=none; b=rb+G/DbNL0lt6N1AbR+DCSvs1R6ezIJIZ0RjWA1uHm252i1FkSpRoOXvrtOw98ydSH/sgyQwzz5/yyc3qMpPj5knBzqrdqjEz76UbItjQ5rHyCnBdqfrwPdJoUmiuy47w0HLAfj5KPSqtOeK3oRtr5GE/MpCI77nuI4EMsXCBtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278867; c=relaxed/simple;
	bh=d3K2DQHvqAnpJor6rBzVn2iLpmyd6EQbaciVO2YoXwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cADJbxI3IRZ8uWK3TKiWM/CtB0WFJtWtqOPH+d1fnqVc4jIHsF3lkbutmm2bibu3PEc0Z+TIDC5rW1FlQgYyJ9mg5H6H/Zb+MFVSJ4XOBYLeTpex2UmChRAwbWUbi7lrw3Wpt98R7mE4/V7QcIn1b+QwLRg8MNlSFCH8YBoitFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7sL4tro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7sL4tro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283BFC2BBFC;
	Thu, 13 Jun 2024 11:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278867;
	bh=d3K2DQHvqAnpJor6rBzVn2iLpmyd6EQbaciVO2YoXwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7sL4trowGV3+JQpeWuksezeYpK/b13t1m1ZYMEIGF+HE1xqsC+7Zo4QQfiqEmGrc
	 faO9a3uDwlUo5XuHOpHlTlIz9s29lrONmMB3nYxSYuB/z7lSm1T+vQATBl+JSbYBNg
	 J88N/eK4M8/jBzG7Hm6Qaxq6jRp3tgf4bhbBYU7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/213] microblaze: Remove gcc flag for non existing early_printk.c file
Date: Thu, 13 Jun 2024 13:32:25 +0200
Message-ID: <20240613113231.751050659@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index dd71637437f4f..8b9d52b194cb4 100644
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



