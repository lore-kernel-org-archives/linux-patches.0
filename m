Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032839;
	b=HKspMrWAAUp0ZBVr1BAXCkI9uAMsRX5R1+ZqVO4Fj+tIxTXNxCmmBX+HBFdQVys2aeLq
	 YwQdplDFyT9WSTnIGpoFp8erb3Wtiuz/+pikkisS9G8+fNWZJh6bXtS/DTFUUjW/EzOFg
	 VVvxvqcuimW6BO7uNgqoEiVx98/jRObxo1Lccrg6pslWxR+4Zv/HvZ/aJiTTtMwGQXYLY
	 cdzDONOP3Qvbr/QKZBy4XSCMn7oQDBEguyfmCZ/YGKPQBX0GbhQEi5WfmdhX3kT7/3jjA
	 Q62Ja9UQpvOrMnIYQubyordBKcmUruKChKQbe1QS0Di0dNqEeu2O8RPtGTMI5wGZeIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+W+zsdcjBqW8VQ5Q5Q6ILTdiYbzQG0laVpgCbotMbdY=;
	b=vcG5rXg6e1o9Tp3dSHNjX3AkuRIGKyH+DRDI/j4lnokG226HqncufJu+inHl0/qSWDz3
	 R8WsUKhZRjG/v7UdpygTNfAJ36x+a9Jx7zLEzr9oI/6A2wE83nSX+5LraYqkdJNwUYn4Q
	 uqIcTTviw9uEHcVIaMVxKlaRrW1iXQXsO1vWB22f/pJa89K9u4yIaoe477fAGhI2X+J35
	 iTv1VexEkF0KNBoC+bmXO6HrgWRHMuJrC1RYXRSIZkXX7W6busnmwMW+BMD+O9ge5laGG
	 kLOPOB+SfcaQqAKRmlsK6Z8LhsDBQHmLDcwZAeXrvCDrZOtGlrqjWJpqAw524yfC4PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s0tsaoZI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5066060A380B;
	Wed, 18 Nov 2026 20:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s0tsaoZI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B136C1F000C7;
	Wed, 18 Nov 2026 20:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032839;
	bh=+W+zsdcjBqW8VQ5Q5Q6ILTdiYbzQG0laVpgCbotMbdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0tsaoZIWBr4YylTmfMVZg9D5n3vBkkDXPwATGFsXB6SCCmO5SSonRxeM+zpQCRgO
	 cxIQChj0EQa7yH/BMA7C1v2m+Wym7+4UhlI6PHh8LYvygKS2GCz9WvGx/CYTTcwf5O
	 L3zU8vSgJtMKvX9wSaMWw40Nj/sNKYGIeO5VkKzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Kuan-Ying Lee <kuan-ying.lee@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1552/1756] scripts/gdb: fix stack depot out-of-bounds diagnostic
Date: Wed, 18 Nov 2026 16:01:19 +0100
Message-ID: <20261118150110.870825400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Ting-Han Hou <ue081723@gmail.com>

[ Upstream commit b6232ca8d194c60ee603586e42b5ea584d4b7be9 ]

The pool_index field was renamed to pool_index_plus_1, but the
out-of-bounds diagnostic in stack_depot_fetch() still accesses the old
field.  Looking up a handle whose pool index is outside stack_pools
therefore raises "There is no member named pool_index" instead of printing
the diagnostic and returning an empty result.

Use the already decoded pool_index variable in the diagnostic.

Link: https://lore.kernel.org/20261011023044.1722-3-ue081723@gmail.com
Fixes: 9d938f40b228 ("scripts/gdb: rename pool_index to pool_index_plus_1")
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/stackdepot.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/stackdepot.py b/scripts/gdb/linux/stackdepot.py
index 37313a5a51a0d..aaa18af25cd12 100644
--- a/scripts/gdb/linux/stackdepot.py
+++ b/scripts/gdb/linux/stackdepot.py
@@ -39,7 +39,7 @@ def stack_depot_fetch(handle):
 
     pool_index = parts['pool_index_plus_1'] - 1
     if pool_index >= pools_num:
-        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (parts['pool_index'], pools_num, handle))
+        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (pool_index, pools_num, handle))
         return gdb.Value(0), 0
 
     stack_pools = gdb.parse_and_eval('stack_pools')
-- 
2.53.0



