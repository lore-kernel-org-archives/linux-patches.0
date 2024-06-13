Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58950146008;
	Thu, 13 Jun 2024 12:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281270; cv=none; b=EvRZFKaT9xkFJQnMThm5EKS1TYbWR7Jva8xza1E61ASgxxFEljGyI6/Ew20ReTTQhf7LjBK7gsEw9xpVzrA+Dwc+O34nOTS6hYfTnzrRVtWuuiiw89RrFI8NF8HLH42K8WTkUGSOldmI5uwDZ+nUS4GZCD1DzgEe/wFYUKeUjkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281270; c=relaxed/simple;
	bh=oh6LNjRHwrfqcSOF5/vY/qsw6O1xayaS32xZuf5ZBPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpZ/gXqIIL4RGI6wo66TrxJbiMenwHfGLbTxnLzGjRR24ckhWBRHbLBYci7j9Df0YJ66nVavHeqZi62GWxT8RIRukBl7G0mt0PYigjHUIz2nt4T68fJd3OP5hi01dskBhamKD2O/NLFkVuv6A8oiel7gVijUQGfFRHSi4Fl61oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpSxhDzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpSxhDzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EC5C2BBFC;
	Thu, 13 Jun 2024 12:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281269;
	bh=oh6LNjRHwrfqcSOF5/vY/qsw6O1xayaS32xZuf5ZBPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpSxhDzX+dpPlp4AecGTVpquQw9F5+oUZPbhwmpTtxTEMLUhAKHluCuqH1x/0kOQR
	 C5sCGqXpBlntMRTwM2hmWDTyHz+UsvtUjbpYaK1faXETsrMkYDfFVmgOBSPAl+5q+H
	 5IKsmDmxfaoeclgX/Ccc29sbVEC14v3YGEUB6Nzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/317] microblaze: Remove gcc flag for non existing early_printk.c file
Date: Thu, 13 Jun 2024 13:33:06 +0200
Message-ID: <20240613113254.061821507@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



