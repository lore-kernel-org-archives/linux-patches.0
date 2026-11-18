Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048490;
	b=pwEoe2KXZyYDIWiRelmbsBtIBXpSZEzCzR3kXogoL36flDlt5zvOJRcwriHwvGQneNdT
	 4ACUjse9gq0ZpO8WnGY2hzZp3VlV5cvkUDuOsVtyE9jJRsan+HSrgr2h3j3jg5BsCpHFb
	 6KOyNQTWjWe6WzsayJW6ehM1WUj6aMdUOXq0DUaX3WmvmTgL7Ay/RPqNsZLPJPk4fGQfn
	 TXNlIfO4JVnkp30qVD6566wTPjWRMrIhqUXuMPzJO6j4EBvql6h0sJJYrYkWRMl6jTfQh
	 zgHaVnfFbhr+++grA8AqDvIsK/TsB0wguqs1Hw0dFNX1/2tA2Z/R7+sHM1ggx1S6GCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L8AODfEsCNCHOSkAKWuXu1BOZMXA9wDa0q1krUx4+5o=;
	b=JN0Ke2PyYe8mskntxicsolsUQmbqHVckQQUOWHC73qiCoRYJ6944enN1ypVazymaT2zx
	 mKUzq7E+RzXzq2Wpk4COovxUY9xBVKhSHRRyaFJX1Dm/LQE18WimLyAUs6ot3MYidKLHS
	 24jCD4ZSxiOl/KlACWAsTntkyPFbVxkwDj+WIEGrwOq8fYTdUFzg6qpccRpeXSrSx/dSe
	 5z0GtygNIjQq9FDdq6eF4z2DXhM41FzFrld4SeEiz89mYwmPxBwTS4lkzS79JN3EDbiTf
	 srasZJ8sXLD5840u9eQS9LPEU8MRyKkgqo/tylAQJHn4zchH0KIUC2R4x0KouFOp6sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SwJdDdqd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991D3606A31C;
	Thu, 19 Nov 2026 00:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SwJdDdqd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6F21F000C4;
	Thu, 19 Nov 2026 00:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048490;
	bh=L8AODfEsCNCHOSkAKWuXu1BOZMXA9wDa0q1krUx4+5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SwJdDdqdeih6vny0c2FIU4eSQlnZ9+6XzVN2xh4CjTaXQvwKCUnCSxm+hvR4R3yoT
	 4exoV6Hwk/dufusiKd5GTVNXB0oP/sdjqV/ZtkTZK/aFceYRN4vtW+CF0n7ravlUwb
	 wSwAVMX4KjbiP8OPcIw957F66jpMSp/k3J4XFWUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2013/2857] swim: Dont disable drive after every sector
Date: Wed, 18 Nov 2026 15:50:47 +0100
Message-ID: <20261118150313.880739656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 05a7c4b197279cfb3ec3df26146ce085a2438aec ]

This fixes multi-sector reads on a Sony drive. The Mitsubishi drive
doesn't seem to care either way.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/fc511e72753ae18b6f021701aa00d480335b0caf.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index f0aef4b963443..12d883c8a3ae1 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -473,8 +473,6 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	short i;
 
 	swim_track(fs, track);
-
-	swim_write(base, mode1, MOTON);
 	swim_head(base, side);
 	swim_write(base, mode0, side);
 
@@ -490,8 +488,6 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	}
 	local_irq_restore(flags);
 
-	swim_write(base, mode0, MOTON);
-
 	if ((header.side != side)  || (header.track != track) ||
 	     (header.sector != sector))
 		return 0;
-- 
2.53.0



