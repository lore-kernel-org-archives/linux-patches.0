Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062057;
	b=nF3IkdSoiYwi8jCU1hBBqWqH3XhwzWPBbToohKMOvLfSTLn5FRGSogyECyhXsWjAXDVQ
	 Z5r5OwkDXYeDgb+hnA5Za/Rpk/9YUL/zcRvzfWUZPLd5kuNPV1txCRdDFGUnB0wH4Ici/
	 2d70SHe/y50NfqCGzzg5EJgAB/fTvrcHWpS1CmcAcKVb7HcCMUrwaFe10zeVYszYJn2Hz
	 hBBv3a269HymvoAy+lJqWQPmNhwDnAtjpLPTo2hpw8o3UxDDbSSPTxFyPnwiLsPcX6iyU
	 DQQ1/+Z+GdL/4WTw8C1bEMY1p5/+OEkm1prL8u1l1irhcIZdF7e0V0QReQZSTTtXMJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LAMfzURfCzuNX6SPNCBgCyMSi7rKKvRby6nRgYIXhWg=;
	b=yRD6D2MrO1jIhv44S0a99oRWBdstPwJ3SRz8lVpUNfoKgoA9IIMQkqlSIHCtuFcDJy9d
	 7GrDTUuoGvMwB8sss3Hb+2G1iDe2kAEv+MCuSSclpmQHCoE0VvKnC6PpW7y5E3fIJwk/8
	 eMgPucf5cd1bWSDk3C4mkOMftNdNxUZOAKi8kztG/huSOzRCySJqY3vqZVTtro7ikjBDP
	 JZB8CVH4L2A2/W3oLDJ0z74KuXh7bpuSMYTgox67dDc9yvmklWkMmmuwwJlwCAWaVukFk
	 Npi4XwG8gEh9NXU3lQolkkkTQ6S0Q/o5Pz6VgMhYMDw7A1pkPCN8mJa4hpZF6gWmg2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qea2Sft7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98F5606A320;
	Thu, 19 Nov 2026 04:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qea2Sft7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BB51F000C5;
	Thu, 19 Nov 2026 04:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062057;
	bh=LAMfzURfCzuNX6SPNCBgCyMSi7rKKvRby6nRgYIXhWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qea2Sft7gZ+6KDoHaLrY7mLAIaLNyRwPGUiVap4wqnJxTCuNYYtas7xI/zr4dvKQ/
	 iCRoQGILZqwAoSCMerAotnoLA0GGZpYl50IJHfJvusa+nUbVn6BqUAsLVRnc+OKDgS
	 hNVL5jkfbEjaFNqTMTHTs8HofRNhNtZubOyS8Sac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bradley Morgan <brads@mainlining.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1772/1848] profiling: fix sampling step on 64-bit big-endian systems
Date: Wed, 18 Nov 2026 16:03:30 +0100
Message-ID: <20261118150033.573062039@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0db1122855c0d..c2ab50a88da51 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -476,7 +476,7 @@ read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	unsigned long p = *ppos;
 	ssize_t read;
 	char *pnt;
-	unsigned long sample_step = 1UL << prof_shift;
+	unsigned int sample_step = (unsigned int)(1UL << prof_shift);
 
 	profile_flip_buffers();
 	if (p >= (prof_len+1)*sizeof(unsigned int))
-- 
2.53.0



