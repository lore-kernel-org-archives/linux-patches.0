Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015249;
	b=KrAO/tk1gNmlaekb3YbAj7jIX8lqKhE6vzPdfon4Q83nIHeBsdpdsa9Ns08taZ/DZH+o
	 7uy7Mx90TKzCep2MtqP1LkNTp0pS8yN8jrh5+3QWZVK5WAwdOLRTzQL2QfNU0RSkiSe/Z
	 SQvz3z6RdmsoaSk5nZWrP+MyMQYSl/AlCZAfGHmLH/GsH2Xa2w6ttH0zvnFJCTi3HWxjt
	 5cRxKAqZBoi8uinxck7+sTOLYdQlgovgXx/DCqFH0Afg1aaLbohmduVnRiYMp2/x2VvCa
	 vvh3D9LeLTvzp9uVpgXM3BPtFBpx+NiynWwEk1cP1QZDHwmj8p9CoZzVHN3RL708QHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+TlWqhnpgFJZo1FaRIk372bAyTZUu70iUumRzgnwJ04=;
	b=dRvshpEH7cLl2IGc/3it817lEotrTHXARaOMAEc6JnFWb5Fb2pWYSNoHnUknI7Zxs7dy
	 0micZJNVZG7NnQem5MJPDQizkIKAvs+RdhXq3jgyhBIbdqU2NbJNm/cJrrmJAq6MehOC0
	 52D+XWi+L75Svx97ba3ntzg4UdJR83k5OYf9RWVQ9kdWWaf9sTYvnt6ZX9jlwKw4hOztM
	 e4743PwU/BUCuHz/M8UnxzS+39IO7vDsL3lCYbnZtRhtdvCsEayr0P4tGWeZKEO12cGRB
	 ZSrd4OPnAHUb+yTth66pMMm1QvNBNi8PUDyJs+mzis+nPzREPYTlSX5T0LXK7N6B0+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWpwAtIs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D83606A31C;
	Wed, 18 Nov 2026 15:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWpwAtIs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502451F000C4;
	Wed, 18 Nov 2026 15:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015248;
	bh=+TlWqhnpgFJZo1FaRIk372bAyTZUu70iUumRzgnwJ04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWpwAtIsAAbIQ5nm/1681VIoBY1mPk0VWiNlymxzMAcAIaGYQDhCFpoW84ClRXc7B
	 qPk/jEmCblePu8FiFKzHykfbzdTaQIg1fRcio7UWCj2RtT0NOq9oscgkwjEXYdC2rB
	 FW2kKHQ4ylAzDz+D38hCLvlfHbMh/ww+pOByuJv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Bradley Morgan <include@grrlz.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0105/2651] kexec_file: stop the top-down search before it underflows
Date: Wed, 18 Nov 2026 15:22:25 +0100
Message-ID: <20261118150251.666281284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 59fb9d71e9d86..01a64d98fbcd7 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -484,7 +484,9 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
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



