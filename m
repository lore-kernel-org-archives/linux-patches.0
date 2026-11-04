Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831012;
	b=M4Tr5RWn7vzJnTK+3qKJrjWtWvkSU1qoK6XZoMHmf1YUnUXYCLQ6yWjTDEzF0THgtKj7
	 q9ECL1VwCadOF9Pt1/dee7ABO2IXSeNa+gMTiSdJxHzNM3i35XoV8yEWmtBoG5fASDdYW
	 9sLWLqeKgE2m5c0MYXPfT/txDuQfGsbNIh0WloOvb2nG4aSxr10RA1T+o6eZeoXoHuyD1
	 CDr+ic9N/ZS+5PRmWSkSG2T9qf3IaTooK6+gwFlu6YUdrMeCOjS4+2Z4nbiq2ln1Fk0mh
	 DJqyaQgj5p+iAWHHdMotHwNz0i57ldm5qzP2bBVKn7bsJBkv+75xUJGKAemowOZyozg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LJSJ8lXpgIZ6WRJCyJX1hD8dcC73bsuzUcI3r10PrQg=;
	b=EUIqQsZ9axQy51MwvG4PsIfC6r6z6EOyYHqx6vcrVMxwoIg50f74AgvVyj4u/LhxEQ5a
	 c7XbjCVMemHs3d8uEFdF/UT+QXuhATBZI9O2EmusibUpj7z5/+3kSFf8wsHSN9ejJ7TfN
	 nFRjZQBkhVcb9rBw8bsDJUDnN1xZ3kz5iGw3ZzM2G6quwFiR3W2jgFQY+XBd/TrQ2m0XP
	 skjcd+AC9UtP0UIoNxk72aObB6GTTO0Vc2/TXZcEGqLrHa1alSL8QFcAcEkudvkGD2Bxr
	 WykQa4AsYjCFx/k0P/pNfViXf2nt9x3OBURD4E1bEOusf+9IBHU9iKyv1lKpsScs4KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tuZlGQFA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40F26070327;
	Wed,  4 Nov 2026 22:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tuZlGQFA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5AE1F000C1;
	Wed,  4 Nov 2026 22:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831011;
	bh=LJSJ8lXpgIZ6WRJCyJX1hD8dcC73bsuzUcI3r10PrQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tuZlGQFAce4fOTc9FYjJbK3TMp/Cz6wHk8FkFDiUANiAG+JbRpSBtrhPE0gkO2EBq
	 EG20m3ekdcjfRogo7dIFAyJVNkodHF89fdZYKDcY9RxROHS7I0zvPouAqezgKwHmdD
	 Rtl65BL4eyr5SKhXdTaaqGqcklUQWdrjXlSv3PeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jenson Johnathon Reggentin <mail@jregg.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0455/1005] docs: block: fix dead http link in blk-mq.rst
Date: Wed,  4 Nov 2026 16:03:08 -0500
Message-ID: <20261104211056.789381288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Jenson Johnathon Reggentin <mail@jregg.de>

[ Upstream commit b40a680ea4efe4ef2addada63e304a94d19500d1 ]

The current link http://kernel.dk/blk-mq.pdf leads to a 404 error page.
https://www.kernel.dk/blk-mq.pdf leads to the correct document.

v2 to add the missing www. prefix in the actual file change.

Signed-off-by: Jenson Johnathon Reggentin <mail@jregg.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20260819192422.42189-1-mail@jregg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/block/blk-mq.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/block/blk-mq.rst b/Documentation/block/blk-mq.rst
index fc06761b6ea90..2798761efe0d6 100644
--- a/Documentation/block/blk-mq.rst
+++ b/Documentation/block/blk-mq.rst
@@ -139,7 +139,7 @@ completed.
 Further reading
 ---------------
 
-- `Linux Block IO: Introducing Multi-queue SSD Access on Multi-core Systems <http://kernel.dk/blk-mq.pdf>`_
+- `Linux Block IO: Introducing Multi-queue SSD Access on Multi-core Systems <https://www.kernel.dk/blk-mq.pdf>`_
 
 - `NOOP scheduler <https://en.wikipedia.org/wiki/Noop_scheduler>`_
 
-- 
2.53.0



