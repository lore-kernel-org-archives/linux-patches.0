Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059222;
	b=2LgQzqdH/dy0CFN7jCypAIZd44XUK1E9su7MyhEyZxdHrZSO4lOGiu/+t/TmgvdJ5Mo2
	 FaA8URz7iduQuslu6TLulBPzLVN+Ybdh8ugwGSX4ShlUMUJktBSj5hNEtl/UHTfsLfEdW
	 pcHRVTfVm08PAsuqElwyGMZIjBMkI0cNORshgbsFRC+lzc7Ijx/x8JY5A800d3/lAGPEX
	 rLFbBZSH59kkTgJAvmm86y8bWkVRr+/SHTfFpCRQOFlB+nxKiFMyoM4m0/qUSzSrccD55
	 uQdJwn/aebRwvH3iC3bTgu6HGQUjWEXLOQBkTeUKeZcUbtINA5k5rjRYw5FipbDnH3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r2ZQQ3hdE1Mq9nFKQEFx6m4570I+/0pEKV7IIkZu9xk=;
	b=cbVtHv/jofgJ80TtINh7TyDYrqIcdWadsBOEUWX6JP31dQsTpIwrEnNQ5R5rCu83VRJ3
	 ng2ns2HU6piuqB/79r2/d+li8xdShoU3S8jl22q1aKBAwfmdwZTq+9lkL4f48fmPqnAUF
	 1/0senXKmjlTXFHq5DO8EzqiITxLi5l0jRnA2krQpQxqwFWECgknEY9szvZvJBq9SYAeX
	 sNoAFsNJhGdorIG5qQpWV5L8H/ZZfMit//ZvFypSlAckJGsnYUB7jrxDrclSDChZWqTLk
	 vUBib9sA+7oJsaLOUl3x9f7YpLOZcji8Z/AOLhBd9ZV8HQkii9Tz4m6HsBv3C2TAHsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HlzH30a8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B27606A320;
	Thu, 19 Nov 2026 03:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HlzH30a8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489411F000C4;
	Thu, 19 Nov 2026 03:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059222;
	bh=r2ZQQ3hdE1Mq9nFKQEFx6m4570I+/0pEKV7IIkZu9xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HlzH30a8RSHOgP5F2Pw0tlpirdPRuR4NS12pYUNavuk0P1TJX6YuVwTG2A21bkxQ+
	 612rS3RQaaLCbfsEUhT6HolFKBQRCUp+8cug3zbqBkxQl2MhH1TGBAKzea8UmXvLbx
	 ePV/gOk28KwSlkxFFHBP/c7Kn7Lm02i2NAVSLiD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@xilinx.com>,
	Mahesh Bodapati <mbodapat@xilinx.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0766/1848] microblaze: Do loop unrolling for optimized memset implementation
Date: Wed, 18 Nov 2026 15:46:44 +0100
Message-ID: <20261118145948.484917928@linuxfoundation.org>
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

From: Michal Simek <michal.simek@xilinx.com>

[ Upstream commit 95fee37be45f443a8a322ee7f6f78167b73f2abc ]

Align implementation with memcpy and memmove where also remaining bytes are
copied via final switch case instead of using simple implementations which
loop. But this alignment has much stronger reason and definitely aligning
implementation is not the key point here. It is just good to have in mind
that the same technique is used already there.

In GCC 10, now -ftree-loop-distribute-patterns optimization is on at O2.
This optimization causes GCC to convert the while loop in memset.c into a
call to memset.
So this optimization is transforming a loop in a memset/memcpy into a call
to the function itself. This makes the memset implementation as recursive.
"-freestanding" option will disable the built-in library function but it
has been added in generic library implementation.

In default microblaze kernel defconfig we have CONFIG_OPT_LIB_FUNCTION
enabled so it will always pick optimized version of memset which is target
specific so we are replacing the while() loop with switch case to avoid
recursive memset call.

Issue with freestanding was already discussed in connection to commit
33d0f96ffd73 ("lib/string.c: Use freestanding environment") and also this
is topic in glibc and gcc.
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56888
http://patchwork.ozlabs.org/project/glibc/patch/20191121021040.14554-1-sandra@codesourcery.com/

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Mahesh Bodapati <mbodapat@xilinx.com>
Link: https://lore.kernel.org/r/10a432e269a6d3349cf458e4f5792522779cba0d.1645797329.git.michal.simek@xilinx.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/lib/memset.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/microblaze/lib/memset.c b/arch/microblaze/lib/memset.c
index 8810a89de851f..9a62a1f0fc1d9 100644
--- a/arch/microblaze/lib/memset.c
+++ b/arch/microblaze/lib/memset.c
@@ -72,8 +72,19 @@ void *memset(void *v_src, int c, __kernel_size_t n)
 	}
 
 	/* Simple, byte oriented memset or the rest of count. */
-	while (n--)
+	switch (n) {
+	case 3:
 		*src++ = c;
+		fallthrough;
+	case 2:
+		*src++ = c;
+		fallthrough;
+	case 1:
+		*src++ = c;
+		break;
+	default:
+		break;
+	}
 
 	return v_src;
 }
-- 
2.53.0



