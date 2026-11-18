Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024000;
	b=PUU7/uTZsfOGaMdc/gfSAp0Jtbf0kEBzB9fEEqH5WiYDtKsHvBw+oY7d9iqZJwtr/j+W
	 f6EYI921kvYajEc2jmuFeMl4KlkXvOUZJma0lKtdFiv+xZMDI1wlWUmrzV6JKQ8Q3ie1D
	 +6WCX1kthKKfLLLNyfdD1cQH/EbQ9+ph3937WibnhDGFBxUojmQezI06QYqSqHedX2/+1
	 TBYYRQId9yQOoz1xFbMhow4GVwjUvXYWlj4wZaUPBtgpiiSmcFQSdBJs8cv/Wf4PCLkub
	 1QL2S8KlK06jd9MGWALnNBoT1RXqyjfKgFEbR6QYQ1vrdcla980t9vMovO8ak+RfO+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RKShoTj3KoTU47OIAgdbsO4vsOHCXmQQaSdc5QJ/u5I=;
	b=nu+NxdevK4TSkDcghJzL1O1eJ1wI9x31J4yFSXi6o85pwf/RjAeoai5pyrakmoWVV8en
	 8i7Dd6qkrqWOZo/7H/cxuRhwK6RWVrSKnGCzm4z7a7oKkpHmodaLhg38Pi+MqMLwdpS7e
	 vVSXkDzvitcxsrj3qIElpg0EqlXm0/BfVb4c/1p4UgW0FtzK95Y74LSKsBq2E79J8gA/t
	 6A9K8F3aLbUIvzCh9rk3etypKMiKbo9PKogd+torkn67Fl73AWHeQTrK1wFMcC0D1ghSA
	 GdRBky63o/SQd/F7WvSmhg7FCDMEb6OQlfU7hJ5uiRiK1e1uaNbw776tBPc1ac7dB2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBWU1Fjd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B0C606A31C;
	Wed, 18 Nov 2026 17:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBWU1Fjd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061891F000C4;
	Wed, 18 Nov 2026 17:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023999;
	bh=RKShoTj3KoTU47OIAgdbsO4vsOHCXmQQaSdc5QJ/u5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBWU1FjdspmvPiIC8mTpTr4phkFUrrlHErKBaHpvhRvLwj5t5l2FiM9fpz1iZL+vj
	 CE16yoc3EBouU8z5W0BT1d4ssIxdEkC6TOG07GjowY3BAUN6ylWALSgoPsMrlDHSYE
	 fwjfZwDqISeT8AhO2My2uYy6f1ghgu4OrcuP+V2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0570/2151] KMSAN: fix memset() when using fortify-source, again
Date: Wed, 18 Nov 2026 15:38:25 +0100
Message-ID: <20261118150142.710797304@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3555409e524a0279845f91273ba714998658c163 ]

Both kmsan and fortify-source replace the memset function. When both
are enabled at the same time, the kmsan version gets used, which triggers
a warning about fortify-source being nonfunctional:

warning: unsafe memset() usage lacked '__write_overflow' symbol in /home/arnd/arm-soc/lib/test_fortify/write_overflow-memset.c
warning: unsafe memset() usage lacked '__write_overflow_field' symbol in /home/arnd/arm-soc/lib/test_fortify/write_overflow_field-memset.c

Commit 78a498c3a227 already tried to address this, but this seems
to only have worked for memcpy() and memmove() but not memset(),
which is still lacking the macro definition when KMSAN is enabled.

Remove the incorrect #ifndef check around the memset() macro.

Fixes: ff901d80fff6 ("x86: kmsan: use __msan_ string functions where possible.")
Fixes: 78a498c3a227 ("x86: fortify: kmsan: fix KMSAN fortify builds")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260618142951.1739694-1-arnd@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fortify-string.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index b3b53f8c1b28e..93654e9973a6a 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -508,10 +508,8 @@ __FORTIFY_INLINE bool fortify_memset_chk(__kernel_size_t size,
  * __struct_size() vs __member_size() must be captured here to avoid
  * evaluating argument side-effects further into the macro layers.
  */
-#ifndef CONFIG_KMSAN
 #define memset(p, c, s) __fortify_memset_chk(p, c, s,			\
 		__struct_size(p), __member_size(p))
-#endif
 
 /*
  * To make sure the compiler can enforce protection against buffer overflows,
-- 
2.53.0



