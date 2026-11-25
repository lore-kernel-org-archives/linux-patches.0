Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617878;
	b=Qa9/H0aqEYPOnZ5R52WZarytm8YqjMt7bulWFNp9aQPZ6fk2R2SXTsx4QQb7WFC7fzZa
	 BnJ0CE8iEePOohtKJK/g9kbvr0SgNFY9cCO85zF2hYn3/LazsVDHCZrCwTQGYadK7LGD6
	 me6HhiK0M05QtTu0Tt/IqYZHWiHJQ22+aoHbYN163D3MEt+K9iic8WQL9FU8il7/bJSpQ
	 GSjSGQoyIXLAENtmL44Gmjsmsrxi3L40wdqfMW94BEKvu4DFT+xO2OkupqmB5bbLI0T87
	 LFfiHBNunJgjZ0BzdSKjFongrj8tla5AV8GLwhxmkxHKuwLdrfgs18FFEBx03h5Tz7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=86uJXMsrBhjmDaZsEbY5a2W0FWe6TT4lquNdYq0k62A=;
	b=XfFl1SdJCAXsCog054xfT/HHadv7OJosfIV5qKZH+KXm1mkPlu4MOyjE583Sl4jL0/Pz
	 VfA3VbQaHc+DBev04XxLztn/06ItVPEcRgVjPpv9cRYHl+hSvpxbjPvaFpZZMIgee7DDE
	 e3qifZnLH6P1wFWFAi8s7dQ7R/4XGLM+8b3+HYKuT9eeOGBpOQRwvKcRVsQTJa4rXxvzL
	 1VIYwtbUl/h8/yeYOisbYCJGZ4nwMKZ2ee+ld9uGtxkx+dw3Y8F3EcDgTS7p+W9wAo8IA
	 q5uAV4Hl7Fd7sLN1RoIHr9EsQYdX/57RF7tk/UMldRcShjNoCQncSYR9Z25Hdik0d6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AaZ4BOuE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08C3606A335;
	Wed, 25 Nov 2026 14:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AaZ4BOuE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265E01F00ACF;
	Wed, 25 Nov 2026 14:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617878;
	bh=86uJXMsrBhjmDaZsEbY5a2W0FWe6TT4lquNdYq0k62A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AaZ4BOuEiwYwzXwQkEK6MvRzU+Rz46pP6YfkObYfMdqvzUztjKZZ7QJUuxgzASsf6
	 8QmvANmlhJjCMt8gPP/QLRLB7EXFygOYCYIHJkiuljkUASMzacNuo98y76SNNuB7rN
	 h0H3vCcR46qZ7auilpk1WdTf4SDH9G5wJW27aFtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0103/1005] bpf: Remove the WARN from arena_get_unmapped_area()
Date: Wed, 25 Nov 2026 15:24:01 +0100
Message-ID: <20261125143824.157809640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 15dedd4b259289bffb8a5485b81722fdaebac71a ]

The user range of an arena must not cross a 4 GiB boundary. Thus
arena_get_unmapped_area() asks the mm for 2 * len bytes and rounds the
result up if necessary. If user_vm_start is not 0, addr must be equal to
it. A WARN_ON_ONCE() assumes that the mm returns addr. But addr is only a
hint without MAP_FIXED, and the mm can return a different range that
crosses a boundary. This is not a kernel bug.

Remove the WARN_ON_ONCE() and its -EFAULT. arena_map_mmap() already
compares vm_start with user_vm_start under arena->lock. If the rounded
result is user_vm_start, mmap() succeeds. If not, it returns -EBUSY.

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-7-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 8b0892e19b198..8e1f7bfd2b4f7 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -655,9 +655,6 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
 		return -EINVAL;
 	if ((ret >> 32) == ((ret + len - 1) >> 32))
 		return ret;
-	if (WARN_ON_ONCE(arena->user_vm_start))
-		/* checks at map creation time should prevent this */
-		return -EFAULT;
 	return round_up(ret, SZ_4G);
 }
 
-- 
2.53.0



