Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624140;
	b=UrE164WIbILyx7j5ZftzrtspJynsoVINQRDl+YYzTclsA4lpxL3Lv985fKqMpvTkPIZv
	 Zi1k1tUmiLg7U92Ol//CGDxK436PiiJ1rMjwesEUEnmZHL7VlT/VgFs/6dQLhvpsdN6pE
	 OQQV0U+K4y003slOT+MqAkJAE23BB34N3CfUgAmXqJlj1VJFX5ULDTnHT8P4oG+TUKz/u
	 Ww6e0hwMa7dKJ4UvW5yyjd5JSkbIcFpcSBACKOWoSlaLHFhRquOQkT/d3H3icatX9/XwW
	 EjpPdNiIsX6pGt1L4M7RNqE2Fy+FEgj/EnSw7ejw6zQMm5w/QBY/paBoe7a5PXZkRCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xaxI8pnpEqW+y4/el4/2QawfbLYrRypOBJXAAE+4k74=;
	b=wCPa7W9//ri0U3QxdDcZWI1dLrmwf7r4Z53F0/cLsEfA5pTnYlYKKNRNtJgtp3sRWAmE
	 F4AN7NFhOpzOapowIgzqkrmkDZvqSzpFu9D6uvEeLxYo95ZdALCQxf5Urp1vWbsHAskdk
	 Iu3WCE/hrlarzz7tMX8jUzfKMIprQOzqP3z5244i0NE/ekPL9YuMAFuUxqf0aYm5T9Jf9
	 Ze+bVIDCT/scDfZWRNvkRSMCBDq0125dhlCpoRnByK0JTpfxAyhDH9uMEeJkWNne2+mv+
	 8+INM/4VDTaTAAVg3x9XsqTd7cHpf9sd+mUilO1qMmvSziLIoP96DzPASdPRfLBtecw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2OpYPlB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A1A606A337;
	Wed, 25 Nov 2026 16:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2OpYPlB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF411F01812;
	Wed, 25 Nov 2026 16:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624139;
	bh=xaxI8pnpEqW+y4/el4/2QawfbLYrRypOBJXAAE+4k74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2OpYPlBfqKWBsXGE2wSmpq4iuTU2ynqQqC8vffjaXaUbus/dM+C/sMCkQ3IICPqy
	 eIUItWe+yW2nbwIoJxNDyxFEnwkwyYW4/UVs3q0A2jBO3gi9sEIKWn0qTY2KEVDU1O
	 ihVkSiueyQUDHz99sfpLsDVdJdhtG0Yd5eVbgUDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/816] bpf: Remove the WARN from arena_get_unmapped_area()
Date: Wed, 25 Nov 2026 15:27:26 +0100
Message-ID: <20261125143851.486907008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 345c77f7cd2b5..5daffb7167925 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -346,9 +346,6 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
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



