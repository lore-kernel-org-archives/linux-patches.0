Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022669;
	b=GNrIavBL2iaZieqo4RBRF+293SRYjk5NGTomcErIDH/ApXtgOM3DFUJXzTxlWY1tcY27
	 jvA7oY2c6RJv8wTe0k5bI3cAyJ+AnJ8qDovSkDpSnt2uTGDqcGweReOdQIjsdzafADqhS
	 PwCslnqCM4IOKOSpvcs6Vt0pLrtgfieZaTaoNvfbdt80HKPukBeX5fqnSVXEs+8Y/ATFJ
	 dWXdpUW7uX6YbHKA6wkCg5IcSiiHmtenaXwigVZyGVKrTqEoAFKwuCFvfH+lkJPnWd6ig
	 kDGtKV45T+3UuLAMQxZo6jIXPL3GdHKQH06IQO4Tk69KI48wbFvICR2NQccuVvk67PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tt3JJ8+GLTWBvpX3GXyN8QhJcH/h3VTMF/wJ7nzhqBI=;
	b=c1viR/9GY64e6+vK5hhBIpYCoJOvDh47iDKngwhX31POa9NHX+HwUCUWCXiqpCxgAgkO
	 APTS4OwjjBQB/Pqi2xFIf8am8snby+C6Wd4eRuFwjFqe9TX/w4dB5UCjML/sdgpjT10PB
	 kWjwzWVOuGLyjjefxLO6eEa1G3G5aBbwi+WrhGwRWYbkxNelivQjvl09XVDnhAYCYAhD4
	 C7oZLKsOhMf9I7kcHw6wHoBbYRSDbmkjE4Q7y0qtA2aJ1Ky3HBxbBG4I3D3r+N8IR/6UD
	 lLkj8kYCzHdIxSBp+oo6XxNVXU/+kkQ36GwtWZoeTAuAW6fEVG2z6LkYGbfRTQLiaHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NYsz+0eg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855EC606A32F;
	Wed, 18 Nov 2026 17:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NYsz+0eg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA6E1F000C4;
	Wed, 18 Nov 2026 17:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022669;
	bh=tt3JJ8+GLTWBvpX3GXyN8QhJcH/h3VTMF/wJ7nzhqBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NYsz+0egLiDuonSDdIv9aIdo4+n4baRIaqIck5MFv4mKMeFyjpoRC/lSc+Z08QnIQ
	 OkT1JzRo26FocMAMLRgyAefnOsXXXkAGYOMpSkx5qOkTX83Fb8ZhgPFEIen7tQxFZC
	 CqzKRw0DBWbH502OgTFrooqo/R34WuT1bPoNhNh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	David Matlack <dmatlack@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0054/2151] tools: linux/types.h: Add 128-bit integer types for arm64 UAPI structures
Date: Wed, 18 Nov 2026 15:29:49 +0100
Message-ID: <20261118150123.708293312@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

[ Upstream commit 10a47fb67340bca274276faf855d7d460afd9a7a ]

The arm64 UAPI exposes some 128-bit integer types to represent things
such as fpsimd registers in the sigcontext. In preparation for defining
these using the '__u128' typedef implemented by uapi/linux/types.h, copy
that typedef over to the private linux/types.h header used by the tools
directory.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/linux/types.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/include/linux/types.h b/tools/include/linux/types.h
index 4928e33d44ac4..bf3e47bd5448f 100644
--- a/tools/include/linux/types.h
+++ b/tools/include/linux/types.h
@@ -23,6 +23,11 @@ typedef enum {
 	__GFP_HIGH
 } gfp_t;
 
+#ifdef __SIZEOF_INT128__
+typedef __signed__ __int128 __s128 __attribute__((aligned(16)));
+typedef unsigned __int128 __u128 __attribute__((aligned(16)));
+#endif
+
 /*
  * We define u64 as uint64_t for every architecture
  * so that we can print it with "%"PRIx64 without getting warnings.
-- 
2.53.0



