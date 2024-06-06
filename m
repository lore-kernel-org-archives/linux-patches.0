Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5E4198A36;
	Thu,  6 Jun 2024 14:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683436; cv=none; b=hnK8CXUu5d33GBCZd4/2LJ6KCSg9nqnDM+Zl7LfU2lU7OWGAkIk4VullJBdNTWTkOHMEt3WrW7LRJROUvbjNDMkY2lGOYzSR7nkdz5TjjX8dihNn4u2edeptvGhEzRiDXhhvPSGjwzXz1iyZeZYOdfCKGRRoXlnL0+03LQpNVOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683436; c=relaxed/simple;
	bh=S86VOsFthoqRkpbtzmlS8h+jFeTAHGR2FRAgdyEn/AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBQfcbGKbwM/nKem1JC4QYu7f+RDwhdjyjmMvDWEdAl1EqyoQcUpK3/ldHBtX/84lZGZ9m5C/7izaTZ1U5luGPKY1yfiNNemqf7FtxEpKgIA7gVv8tyEnDfiPj8XlELwyISNV6qHS4JXjNyLBhvGRrFnI1TbvPY6IN3slylVcSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTXDOG9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTXDOG9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021F6C2BD10;
	Thu,  6 Jun 2024 14:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683436;
	bh=S86VOsFthoqRkpbtzmlS8h+jFeTAHGR2FRAgdyEn/AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTXDOG9+KO2panlIO1t+eTv39KYNSbBM2WognTjID36DzZj272ck/M1RHqvfAiYQE
	 4M9686TtNv9mCbUcanFaThTPWcPtwid6JOspp5UOpZeOmWL0+DM1xhcER7+TRX8Svx
	 38iQv/qb68DBl5QRrTCjt78HXGllf1IYoaHNcO6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 321/473] microblaze: Remove gcc flag for non existing early_printk.c file
Date: Thu,  6 Jun 2024 16:04:10 +0200
Message-ID: <20240606131710.544481811@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4393bee64eaf8..85c4d29ef43e9 100644
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



