Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053607;
	b=aWzMpUBZkC/z31AKC9Xoy6EL72vqVzKTosQkWYjLdY1cjFx91scAhVsqaIeJ8LB/x/83
	 bVaXzTriVFeWQJt6qQjVmq7YxVbK8gh07CfBK+G0ug1eScu/8FFTTOavW2Cyj2ebvzmbn
	 ynyDtq3FramRyYaNfVZKdEN1cUSEgQYnyWM9Y+oQa55STyv8odRqQALRHl/SdKqOXWCeJ
	 wmLMP45pEArHJ3ZYTidVbgVYnZXNsjj7e88fhedTXwOIipJ3zHk2THHV4Ll3PgyosUbeH
	 IXaNfUVaLTyTFqyarR2bwcXrLSv7jtW6dgvRoWWibYcXhkEmFjIY+9h3RWw+tDUVEPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AFk01gjLrAb6U8lM1Br+VoaZ4gHQ90ZZwXuGH1cxJ10=;
	b=4x4VTzehJDMZaCw1J55kGSjE6908FZfrO1Edm/8e/B+hsCXCsSB6q1d/nUJ/+TZnFS7U
	 YhO9gj0EjtQLd18PPJPYWXU+oPixYzkix+5D2aNtkdisCKF8XtqpbQl2mgXy2FW6j6KwQ
	 f21gHN9vItw2fljnFM4iTEuDWrTmDYCXvqEPwnhCmR0V5wnaNV9zRWaTj9Zjms5YbU+gL
	 2gUTuyGaFzzfG2EZcwGf7Dvepv9qTVrE+FMboPwK+wrKLnWWAylO8DVp5nfq1c1mcmDDk
	 3dMW0extbi0b/koKkcjV5h2aEzoRXgikojaDDBV7ejstg4bQvQOmlQ16lQeD7CKUCsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EE9jXXvS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1417B606A32A;
	Thu, 19 Nov 2026 02:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EE9jXXvS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648C51F000C4;
	Thu, 19 Nov 2026 02:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053606;
	bh=AFk01gjLrAb6U8lM1Br+VoaZ4gHQ90ZZwXuGH1cxJ10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EE9jXXvSXqkXECT8PGLUNnRcMITQczCoSju0t0FCbIDe9rrF5Z7cRM9BKiiHhv4bR
	 k6dmLqLnnNEm29PyX9T0PxjxMzZQXGa/ftUUI50wmF4Te1NKXkIXXR1Vv92iOJ1jMN
	 SsIUonXcuAAbb5r7kyhgDjADfUH4sag2yvFS6DFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@xilinx.com>,
	Mahesh Bodapati <mbodapat@xilinx.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0938/2214] microblaze: Do loop unrolling for optimized memset implementation
Date: Wed, 18 Nov 2026 15:43:34 +0100
Message-ID: <20261118150049.890233670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 615a2f8f53cbe..7c2352d56bb0e 100644
--- a/arch/microblaze/lib/memset.c
+++ b/arch/microblaze/lib/memset.c
@@ -74,8 +74,19 @@ void *memset(void *v_src, int c, __kernel_size_t n)
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



