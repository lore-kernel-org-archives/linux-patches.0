Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022844;
	b=5P3nRHC7UDKkWg4DBvCYMwBBOGYNS69m1GpYmgzRNk+yY1dVrtVMyelqA3A3nqUhMD2m
	 1l6dowRae3aC2rm3bsE53E5LgiHXTsop41nRoDZxqCxSxM5i5ST/2yDauRSho79NZNXPE
	 Wx4THr9DZ5SrPFNjf9aHaf7y69KH5aHAlZ12KUTwLu5155e+FmOOpl4AiZ6+6gJ2RvRGj
	 V/ACD/Kj+ElwjU5nxXOevAYsp066WmPe0/rmHy64bH5oLLOOJ4D3l1+y71SiFHjowAtI+
	 M8CByWZz1YJSbXIcyS9P0rrkV5GhKX/iURYcvq5KCG6LDImvUYT9LOy2im1gtWF4WqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uVmrGy/RELRlsgHVD5T+UjQJy0Z68UY+rPbVUjA+uko=;
	b=j0TK5JwFGxEKi+gzaVBSFfg0O35r9jaLglgDAUb4IwrfUbxF2vi5t3m6AEjTBWuDPdpz
	 XWlt+y5kW4hleppIm5+l0htRjHGv5aI18XdFyuSnqDqooNxj/SPnR9cJE1Mx9jF+LrpEQ
	 vCzbNW9+5sA+bPlEOzpyjpuyBZEJyTaglvy2q3gMhwFsE+JfmIAPOHHcpcFZgYeuD9z8J
	 oxG1R8HpVPBALSVpfEZlfG3KwsM6A5skrFm9pCIas/WI8386XJZkjcrAVZK/HuN+5Z5JU
	 NyuIu7sPWzYY8vN+gG2zNdd+ab/qyl4at0hfWNFeSHg4pls6v4exMQ+1Datswn8P5ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p4ml7F30;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EFA606A325;
	Wed, 18 Nov 2026 17:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p4ml7F30
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC08E1F000C6;
	Wed, 18 Nov 2026 17:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022844;
	bh=uVmrGy/RELRlsgHVD5T+UjQJy0Z68UY+rPbVUjA+uko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p4ml7F30LTPyRO6C7RMs8ajdiIuFhKWzfroiRaskVHHlOXgJZ946zOlXCIXlxtuNW
	 IArGdLtP3TdDGAXDprQQ4j7QW1SKfO9DRykHR8XCAwmFYITwO2wd70ahWFi+8Ztjg5
	 yV5SaAQ/cxXNpe7LMSxkfdSVgz3ZWiUTxm9PPRi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Bradley Morgan <include@grrlz.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0158/2151] kexec_file: stop the top-down search before it underflows
Date: Wed, 18 Nov 2026 15:31:33 +0100
Message-ID: <20261118150127.508841321@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit c711461303af9f796b293b5ac06f49a885e46e71 ]

locate_mem_hole_top_down() walks candidates downwards by subtracting
PAGE_SIZE whenever the window conflicts with an existing segment or with
an architecture exclude range.

Nothing stops that subtraction at zero, so a search that reaches the
bottom of the address space wraps temp_start around and continues.

The walk starts inside the range being scanned and only moves down, so
bail out once a candidate ends up above end. That covers every step in
the loop rather than the subtractions alone, and it matches
locate_mem_hole_bottom_up(), which already bounds its candidate on both
sides.

This is a better check than subtracting with check_sub_overflow(), given
that we would have 3 subtractions in this block, and this single fix
would take care of them all (instead of three check_sub_overflow()).

Fixes: cb1052581e2b ("kexec: implementation of new syscall kexec_file_load")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Link: https://patch.msgid.link/20260812-kexec_posioned-v6-1-e477887086f0@debian.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 2bfbb2d144e69..dd48efe2d6408 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -483,7 +483,9 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 		/* align down start */
 		temp_start = ALIGN_DOWN(temp_start, kbuf->buf_align);
 
-		if (temp_start < start || temp_start < kbuf->buf_min)
+		/* A candidate above the range means the walk wrapped around */
+		if (temp_start < start || temp_start < kbuf->buf_min ||
+		    temp_start > end)
 			return 0;
 
 		temp_end = temp_start + kbuf->memsz - 1;
-- 
2.53.0



