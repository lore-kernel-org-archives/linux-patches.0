Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035037;
	b=mUVGceRuqc0n5N8tgT3MDBS/susq2kdrQwF6MFchEOcWXWmadpsZHzm455o5K6fE4Xru
	 ikAz6VbRxHGp2xZk/LHQ2fY8RCjaluCRwxjiiygMSAte0Cy+h/QA5rqmQhDXiVeu3El/W
	 wf0UZDr8sQ6PCkOoX/rTcj6k2JtNjR3JR0WWUS1COrLWDnfX1bR0/KsbWlLVXUfYyN5ZR
	 vo32m3N2bo/6cU+ik6FOp+hfSv0TQW+OSImQeCX5ukeQKCyWbxhVbtI2IZfZVHP21m+1C
	 WzqZwhgGz3PwArLWYfZndZzJrElLJWPaklFiF58i9r9Jyy28Z3bLlO5EvUz6vxN0g7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qKP8e5zK/4Ct5FHlwtmlsZYQRt4GBgUlB9hX1xYnb5o=;
	b=Y/jLw6tlPE1j05tKX2kUFmTzqPziVcs57fSoErZ9KBiTaRpx+enlk1FjGUAGTL+Nq/zx
	 mdPwiwJ0N8AKOiho42pbKCASoPnOmKN3+gsI1Hp6vsFuuZpOziJpJnSWA4WbPjQf6pcA5
	 z/OCLQx7CwQzRZgAkOJ8Y39Zw1IYXAMlC8xxH+PwOFLoIhhySDPXDb+8qjzi85gbrD5z7
	 1yIFgtJ4SZrJBf6D6fmcwXioDtiQXJz2kb1dqG6F/m65pYHh1BzCdsEjc8lu6c1tF/A4n
	 5tSeyG4S4R3m7Xxz7xmMMfKJ3AJsbipNZuNFQNM1fN3w0F0HqSiThH6iKfMvy83EHaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xOmscCiY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB405606A31C;
	Wed, 18 Nov 2026 20:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xOmscCiY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7D51F000C4;
	Wed, 18 Nov 2026 20:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035037;
	bh=qKP8e5zK/4Ct5FHlwtmlsZYQRt4GBgUlB9hX1xYnb5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xOmscCiYH7c6BT0JHU66gtDx39eKKBSyX09SRgXoBhkEOr+X/fZ4eW5NJcwN47M0/
	 HN1ohhJX/0fecoCcdRIWwMfwWBRJKuFIBlqid2u13KoXFeLIjau9LnWcl2ReJ29p1e
	 qs/j9CdgDxoT/4ZZggyIBmzPlBbYN8ivH6o0KLvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0581/3318] x86/ioperm: Prevent NULL dereference on theoretical missing IO bitmap
Date: Wed, 18 Nov 2026 15:20:03 +0100
Message-ID: <20261118150334.948101461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 2d36d3b451a94899db9c965adde15492ffe6027a ]

Outside the IOPL emulation path, the IO bitmap is always expected
to be allocated when TIF_IO_BITMAP is set. The paranoid WARN_ON_ONCE()
handles the case where the flag and the pointer got out of sync.
In this theoretical scenario, which presumes some other bug in the
code that triggers the WARN_ON_ONCe(), return early, instead of
continuing and dereferencing a NULL pointer.

[ mingo: Clarified the changelog. ]

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Link: https://patch.msgid.link/20260615070115.4720-1-lirongqing@baidu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/process.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e3c26cc45f700..4e18baa67e99f 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -472,6 +472,7 @@ void native_tss_update_io_bitmap(void)
 		if (WARN_ON_ONCE(!iobm)) {
 			clear_thread_flag(TIF_IO_BITMAP);
 			native_tss_invalidate_io_bitmap();
+			return;
 		}
 
 		/*
-- 
2.53.0



