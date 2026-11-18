Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026002;
	b=MfH9UVmMNlomPEKGymrprkmcZ0v+weRm3sqSGJXyDKqL7+QQ+GcAqLzCTc0PAlbwgk5/
	 769XLRGycEAoiMlAV7RbFETda9eqmkgpVnrRGRYoRxuPZ9YAxBAszjYS1YBgjk6eZJ92I
	 6e7k1NS0PhWq2cd6tkvpCNioo/sXTCk93GlR8iOhlVQM5dHXM1zV0VkXrTYM5yzbYTxJT
	 zB3q5FWw3nZC59XZUj2rKkLxeVzR96K9fz/27vD5aqbjjx9W8Wcthzmgr7cJKgFnTXDOc
	 yXQVUWYd+4bccof2r1YP5r/5EZIdQFPSOEeCP1feUKT7VBp6nERjwHTTcb6UHc3HzFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f/Q+vcih9E+280g/7SoXOPBGkDcReUn9lsJGY/4zf8g=;
	b=U4LfFxz9vBZAYeJJZ5IH5ItDXqiotBjYYUmTyaC6NeLnXMo9FE4QlecGrSmdQhoYy6hv
	 cpV9wod/D313wRHXV79gBARInebXFJLCALXSLxl+Obw+yvr5qMvzZk2YxhV9mNViyhTCh
	 xwz3u6xie0qFJWiyTfx2MWfnDS/IyBxtREm+S+VSNrD4AanElnSVOXaYUJvZnU7GfL96q
	 sBPpnrbqdAL1k6yXBJaMWjB1KGMX48cmglJgI4EfVFi0TGCEQg0F6RC22U94S0YPkP7+l
	 BLPMkWrUrTpN4KdtSyomChQNFn7KFUmgSqdqJBvZ7V8YxaotBkpJzUoaXVLrUPxB3uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjz2zLtr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD654606A320;
	Wed, 18 Nov 2026 18:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjz2zLtr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBEF1F000C4;
	Wed, 18 Nov 2026 18:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026002;
	bh=f/Q+vcih9E+280g/7SoXOPBGkDcReUn9lsJGY/4zf8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjz2zLtrlR6E8t5MkDMKP5rw4YEVJNwmdHmSuFD6uy+Iza/XVeBDVBr6NlKX6xIDX
	 0gMXUQbOkcXVL7mVYB9RiUBVDuchzLA2+595d+EZisSYlUOVA/HY9NGso1wo8Ye8RW
	 mndi1e7ZmfXXmcLIbDESn89aHAw5iMHXlcoi5dAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1279/2151] x86/PVH: dont truncate initrd address/size
Date: Wed, 18 Nov 2026 15:50:14 +0100
Message-ID: <20261118150208.714859668@linuxfoundation.org>
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

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit fcc43d1d6bf5fbd41e1e308b17187f9b759df56a ]

Consuming merely the lower halves of the provided values isn't very
useful. (While generally loaders try to place it below 4G, especially
when it's huge it may not fit there.)

Fixes: 7243b93345f7 ("xen/pvh: Bootstrap PVH guest")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Jason Andryuk <jason.andryuk@amd.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>

Message-ID: <9698d810-6664-4a9d-a847-18ad124261e0@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/pvh/enlighten.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/platform/pvh/enlighten.c b/arch/x86/platform/pvh/enlighten.c
index b7dcc9c992f32..0ee804f88eed7 100644
--- a/arch/x86/platform/pvh/enlighten.c
+++ b/arch/x86/platform/pvh/enlighten.c
@@ -84,7 +84,9 @@ static void __init init_pvh_bootparams(bool xen_guest)
 		struct hvm_modlist_entry *modaddr =
 			__va(pvh_start_info.modlist_paddr);
 		pvh_bootparams.hdr.ramdisk_image = modaddr->paddr;
+		pvh_bootparams.ext_ramdisk_image = modaddr->paddr >> 32;
 		pvh_bootparams.hdr.ramdisk_size = modaddr->size;
+		pvh_bootparams.ext_ramdisk_size = modaddr->size >> 32;
 	}
 
 	/*
-- 
2.53.0



