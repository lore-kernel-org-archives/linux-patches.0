Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022772;
	b=uwotHDGMuap1lFoY5W6okL2McTC6zeFrBmAVybZ+11n1ULsUFFIfOSSG5T4SB4KLqY6h
	 l/Z7SU1rDkEDO2L2b1mcY20rIAW+KZnnuG9WPbZVZJL3CS1joeGqjxxHlOdTCIp7dnUfy
	 ELbZ7ETbg8yKyJSop6CkKn7Tjxw1vWBJpElQNb6phokR9mfhFfbTj9Q9m5qqcu1wsAXeD
	 Xi0mXN7+X+2fvxR9ETFsbBBGIXJwdUlCgpEyZt0V+hT3YKgt5WitUSGfKZrERoaPfrcHd
	 Y8IZQ125F1Lgm7+Ix6KLbVJVEORiB4UMhDX22H3gXwsPbpuXuwELf1XYGSlUyqSkxIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b1somyFd2vY53l9HTlMrhkC6Clrv5ndxAb4ywupwdAs=;
	b=PXIeWVvzHC9SgGkbP2P0G9bZftbv03LS7vSmPfaeN/Q2zYpOimE/R96194jUB876KBKC
	 YlBt+LDr5DADI8DErvFYyXNO1rH3L3uR7V/WJO/dEWXuaeKKbKWERq/qo8nPkGsCEkqPJ
	 huqQEyo0aLlry0VIz25mD8qUgj1WvnbQDnb53Sqzh5hmKp5+sgjYN3s5MnojRmytJEZ+m
	 sKTAnprrccfiIOK1mSZ68RxPYOsECabc5jBrIIwzHo3Cz2v+FZouL513xYLAEUlHkAeJU
	 OH+Ux/DnT2Bl+n308BGOBbbyhxe7nXDKtHebQN1zv3pQle+dfCsJ3IOhazH1e+rWGrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FepT93Q1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BC760A2617;
	Wed, 18 Nov 2026 17:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FepT93Q1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF521F000C5;
	Wed, 18 Nov 2026 17:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022771;
	bh=b1somyFd2vY53l9HTlMrhkC6Clrv5ndxAb4ywupwdAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FepT93Q1pssHRBfUiVuuhPBPR1zuIJ33dskETkLbl00sPmyARm78ukD4WAMMtWQx9
	 U1CGvYFr4xqBtTntVB/6fu/2kWX/HUu4JEngoyEdHJ8dgdd1j88L0J1M8kdPI+pfkg
	 awUUYf14u4RWQAos3e5/NBBsecJ8nVL9H5OH8TqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0095/2151] mm/userfaultfd: compare exact registration modes before skipping
Date: Wed, 18 Nov 2026 15:30:30 +0100
Message-ID: <20261118150125.263046480@linuxfoundation.org>
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

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 05f64f211a25f7d9771d4fde109aad97174a1cf3 ]

Changing registration from MISSING|WP to WP returns success but leaves
MISSING enabled. The no-op check sees that WP is already set and skips
the update, so later accesses to missing pages still wait for userspace.

Skip the update only when the current and requested UFFD modes match
exactly.

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: apply fixup from Lorenzo ]
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-26-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Replaced bitmap-based VMA flag helpers with a scalar vm_flags mask and equality comparison. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/userfaultfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d5467692e8c3b..afee33a97bc49 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2077,7 +2077,7 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    (vma->vm_flags & vm_flags) == vm_flags)
+		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)
 			goto skip;
 
 		if (vma->vm_start > start)
-- 
2.53.0



