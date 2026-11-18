Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042448;
	b=VPZEY3bI6NP8poL+EmLcvFEaJ5FuDScbA4HaKxByWKpEGqe14GH5dS6vVmUEw533a6J7
	 fqZlPs6XBXUlTGcoJjAbHq7k1e7yJvSj8JNpDIhOHYmRq3BSWirK9x6L8tviPFOW4/d1w
	 fMPgQp+tu2zg6MVEjvzIL/7Gw5frN06cDtzE8GMfdpcKJpTpjTZ8nAXn1vApTDMmajTGe
	 7ZvZn8Qae5xr4MrRezapVFOXsXYR5hKuxCuwigg+e7LNVufDcVfEyjp58N6h6o545H7DW
	 8Lq65Y8cCk+g0tvHU5qOGqL6hvuNgakQmkeKU8vYIHzR5PCn8kVRE6pKVvbGWA6B0+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2TlNdq6iVvbddtmP0hMfVPEF9aF6ZstkqP2Z+C5Lce8=;
	b=2RBbvucUR/cGtISA0ashIVGZ45Lt+5ATtPtqR1Oj6hU3e1F4/YOY0OUKPIRwoajV7XtZ
	 EHzsE0ac7l8Lag/kanEMIQ5UoY7g/IZ1eTxXs2jw6SfctdKtOZ9xMmR9ADsLHS8VAu3my
	 ygn5HRqmvbPq1i4+vOZx2UH1DwfcV3CCu0+v52ZueLkzilVFQt17XPgoxitLB9oMs/aUM
	 OVaQIS75aL/6+IIJH4Ap/CZw4ClEsNZetINNz/aGnOqLfR3gG6UYZOM6qXyWQ0k/XzlfK
	 Wh9652f5Vm0lWHp4QHBnOPrtWFpkfkr7t8LeohqsjpQzanZ72Aa02WWVK7rA+J5Njdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RyPvfJxe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C47A606A325;
	Wed, 18 Nov 2026 22:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RyPvfJxe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCB31F000C4;
	Wed, 18 Nov 2026 22:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042448;
	bh=2TlNdq6iVvbddtmP0hMfVPEF9aF6ZstkqP2Z+C5Lce8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RyPvfJxeZbgdFY+n02M556Iec2P2HXtNXtXTeXRAXVPu5p1jQoo7zuK1irroSIR+T
	 WXo4FPOHAN6rkJsm7Xi1bqYLgF7dGuFPNVFZt+3rcC8FK3hsXJoy5lj86fRdGDh2tA
	 mEjUe9fNZLVnQFj5jew6JJi96RmNQuCp/EoTYkCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bradley Morgan <brads@mainlining.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3157/3318] profiling: fix sampling step on 64-bit big-endian systems
Date: Wed, 18 Nov 2026 16:02:59 +0100
Message-ID: <20261118150454.569501462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 984f819b701c9..45fdd0cb6141a 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -390,7 +390,7 @@ read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	unsigned long p = *ppos;
 	ssize_t read;
 	char *pnt;
-	unsigned long sample_step = 1UL << prof_shift;
+	unsigned int sample_step = (unsigned int)(1UL << prof_shift);
 
 	profile_flip_buffers();
 	if (p >= (prof_len+1)*sizeof(unsigned int))
-- 
2.53.0



