Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027858;
	b=kvg4VF+95RN1MJDIHPMEAHvuzzY3ijw4tdX+vIGSGucb8POzBD05byhGRxfjDn/CpsAP
	 rrArXhW1Too55FXEsKR7lq0WnoLa99UZvvRwQDP4zIT8V+fB9srV9tBV1z6MrqpIGYROy
	 rwqIYcr959v6RAam1uTXb5JUQIQTRpFsMNOF7VuGtowQFpAb9c3pRXVcEF/xT7dPD4hmR
	 JYFqcEyrBEA3qoTSCNqt8qzv2X+j6GkWIa72GfTeRYBnU3mdAZvj1jbyISru6UsAyVrwN
	 Y+xyh4xoP6BVISej+bfvY4Dgr/ap5DUMPDrVaPuuKbSxxzQBKNuNWCiJrFgGbsfuIqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6PaPS+jjP4AxR9mSmq9GQMJ5jPmkklBHwVeAyKiCLF0=;
	b=QAU54Sc3RBXTypcpMtuLCKZEtA0jQBtGBrjfFA1Y9++N+iYSvBQI0MifgEZrw3Vj9B6m
	 pTgIMvJcPGn++BVGxKnKmK1sWl+s4UPUAyQGkeLuIOJX5I8xztk8bwf1zj8Dnqcukoj8r
	 TjlDIE8AIUKbxPOhn9SomuagU2Wh632xokNCPcYhzSaDbp4euY7rl7ZOE30c9Wy06gPrm
	 s3wThfhM9uJWScM1o7Gpmbb+L1JauVEjynkm+kgIyDdAmOLcfzgn3etRXuEfszOPT1Knc
	 CL8uiFEMEAl2fcSCyzgwKPnAQABjPeQboIQhHnUFbpiJFqWi5TurEd/pTcLYv0G6HRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ql7MHogY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1214606A31C;
	Wed, 18 Nov 2026 18:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ql7MHogY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B5D1F000C4;
	Wed, 18 Nov 2026 18:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027858;
	bh=6PaPS+jjP4AxR9mSmq9GQMJ5jPmkklBHwVeAyKiCLF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ql7MHogYdp3PFYq8YomVtnlMAhp+0qWKe8lmLVbp4eK2JGwiU4s655MCl+tDhfp4r
	 c8GOxxaulBTZp3CUGReMRHU+Gx2xit91ya0k0gtCM1KvT+a6rLvjd/KafsIv8DvSiu
	 Hs2arRUqmedufsu/zeutkiNNqtxgyBWS6f6Idb2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bradley Morgan <brads@mainlining.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1938/2151] profiling: fix sampling step on 64-bit big-endian systems
Date: Wed, 18 Nov 2026 16:01:13 +0100
Message-ID: <20261118150232.370042244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit b1d68946a08313895f352af5336623d29739c299 ]

read_profile() stores the sampling step in an unsigned long but copies
only four bytes to userspace.  On 64-bit big-endian systems (not common
obviously), this copies the upper 32 bits and discards the rest, causing
/proc/profile to report zero for normal shift values.

Cast to unsigned int so we get the correct 4 bytes, while keeping the
shift calculation in unsigned long.

A small C reproducer under qemu-s390x reproduced this and proved the fix
works for prof_shift=2.

Link: https://lore.kernel.org/20261020101225.917959-1-thnkslprpt@gmail.com
Fixes: 2d186afd04d6 ("profiling: fix shift-out-of-bounds bugs")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/profile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 1fcf1adcf4eb0..e7defa90a34c9 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -156,7 +156,7 @@ read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	unsigned long p = *ppos;
 	ssize_t read;
 	char *pnt;
-	unsigned long sample_step = 1UL << prof_shift;
+	unsigned int sample_step = (unsigned int)(1UL << prof_shift);
 
 	if (p >= (prof_len+1)*sizeof(unsigned int))
 		return 0;
-- 
2.53.0



