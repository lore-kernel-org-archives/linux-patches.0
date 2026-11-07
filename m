Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064334;
	b=ZlxgjOkSLWeR9GFJH+VkOBDh1ezZJ0O1ujv838H44ko58LklFvU8fhKrDJ1QOIuv6Fqp
	 k6PTS6usGJh256Gh3EH1TE2V+pVrO4LGNunpgUe4TfmUY0DyRWH/IB6loQPSuV/trN6ia
	 HZbxp20dE5VaxZIxZxKLRcvdQm8SxrzyJraXKrr7f9yR6HHtyXmGdrdQfKqbl4A5BYaxm
	 6cz+sxknt76tlD6L+xWsZcL7SZsDRuDJp3vRbaESrwAp7SdCYvIuMgWts4FcGX2JEsTTD
	 rioD6yrGGBS5aFpxsTjT2zgYTzcohAgKwbcqJH0Yd7BOvkvSBX1pZ4zFhoQEtvl2Fqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6aAs1bCCN/1x0xo6T7rfOydgiue/eYXiu/cvIFUJ+YA=;
	b=KSj9sG1XjBy32jmLNE5Kjby1h8MZuPqh/waY8cbOt4HI/07LmRdJ9hktGbFrkfeQIoko
	 bl+p7lcj5f2mWgvL8rw3bnEsh3a/MkMS6orCi9Ri0FlMmeYk1mDInLFa1o/jzZ2041y/B
	 vVpO1tPGvj+shEaTOHB6xOnEwkx5xHEiaPKysNKvRkdOfXzSLzMrN97BHuKZ0q1M/lTPs
	 pdkVipNRou7QLYU+1bX8LQ1bfq/HJJZGHLVrlJNzbiW1lv/He3PeXNkq/NuxLpEQ6dOit
	 FnOF+QxJAFfMLb8s0oZFEkxv9LEwxXyWoS8IB1Gd8shl2U310JgqYKsNCnCme7g6hMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T6bEJ09c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FAC606A33A;
	Sat,  7 Nov 2026 15:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T6bEJ09c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817FC1F0089F;
	Sat,  7 Nov 2026 15:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064333;
	bh=6aAs1bCCN/1x0xo6T7rfOydgiue/eYXiu/cvIFUJ+YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6bEJ09c/p/8f3IelcrsaH3xNJC9+h5Gd6Ht98vuwZPq2p2tqwkqv72FfPxxdIqiT
	 GPy8bVTzzKYkLQ3rtFiUmWJw2Ewl6BWg9q04x+tdibg7Adcl+aE6AEgCTHPrKAn/zD
	 y/n0xv8W30DWT5yg4KZ6JQl9OvzeTnpKyH9MWYoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Nayna Jain <nayna@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0381/1257] pseries/plpks: clear signed update authentication buffer
Date: Sat,  7 Nov 2026 08:44:37 -0500
Message-ID: <20261107134950.073265068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Srish Srinivasan <ssrish@linux.ibm.com>

[ Upstream commit 63de55024e7c85975f4410380323edb05b186d7c ]

The PLPKS signed update operation uses an authentication buffer that
contains a password. Freeing this buffer with kfree(), without wiping
the contents, can leave sensitive data in memory.

Use kfree_sensitive() to wipe the buffer when freeing it.

Fixes: 899d9b8fee66 ("powerpc/pseries: Implement signed update for PLPKS objects")
Cc: stable@vger.kernel.org # 6.3
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Reviewed-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-7-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 17a73a04d45b4..b057e378a6b39 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -685,7 +685,7 @@ int plpks_signed_update_var(struct plpks_var *var, u64 flags)
 
 	kfree(label);
 out:
-	kfree(auth);
+	kfree_sensitive(auth);
 
 	return rc;
 }
-- 
2.53.0



