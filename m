Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618416;
	b=hr9cLUDSFdR+2su527geHJOynOzlwUOVoldN/GlnjwxLBeEtpeZJslufczgGf4gVCPFn
	 qZqnMSflymlji5Q4hTbDxzfEYaLx2UcYZ7jL+pOK/Sy2PBQAtFGtep+kDREfL3qAZHQto
	 HNaqx6Ajy3SRK6jnT6vh8QCHCfwaPQCoYUgRTAGTX+m7uCgWEeR7lE0oU4jHN0pFfMjdy
	 Q/TtYPkdcJo+e0hQlFehyAiqvNMzJ0Cd/o0+eytI6wSx22ewkBEPxhKTOiMUE99idJvls
	 8OBw+/h0TCHuM+uOTF5hXd1YLEzGaq5gh1l6icKrtOkvegu3FJvTXzDfImMx8+eiwEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YqkMXvSd59TseasM3YA9C/TnYlXUD7oppqIWg7v13ug=;
	b=jnVzQSsn3WnF3pzm1Uef2RnSKoWXsVQc9qJhzcWVefTFjVY8y9B792DhkWPVLjFKGvVB
	 n4Q/ieA2UKJTkXnYmO7dY54neuTLrS2+DrLnExuEUeVC04cjznO+mmBO50zFWcLV5nPk5
	 Tzyw1Me/KtLqRm7/bAXem/yvA21NbU3hHnOV+N4TX678bqnK73g/6uI98KZJM4Aao+fVN
	 UpQyvnluLMCu9FMl5oe4u5z8PgtFgLyuB1tXXuxQpOV/jfIygDwZlGDTyhE+fJdh7EQge
	 kRCnk4rRJduQHMXDzWqhfuJCzH/SrKGWN7J50TxdNPxADFXsLDzAvHfFhP73Iwx2FlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="e9/Xpca2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6563D606A323;
	Wed, 25 Nov 2026 14:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e9/Xpca2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC6D1F000D1;
	Wed, 25 Nov 2026 14:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618416;
	bh=YqkMXvSd59TseasM3YA9C/TnYlXUD7oppqIWg7v13ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9/Xpca24p/7cnZXmAOz/Izrb/QjMCFie06K4a8EmnKSI0DWdI9PwOKv2kPl1/tcj
	 BqB+8pUMEc2QBAqMNsKGUMFt4H9ORZasnT3UrPxDOAefSf9LH7Uz2QEqGYgCRKl6OH
	 cf49QmSjVx4nmx9uYT2rLOO+GouKze8kZqCZIJec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0274/1005] net: skbuff: reject zero MPLS TTL before decrementing
Date: Wed, 25 Nov 2026 15:26:52 +0100
Message-ID: <20261125143828.157407895@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 24614e72df484ad50ecba98aaa88c7df2448c122 ]

skb_mpls_dec_ttl() decrements the u8 TTL before checking whether it
expired. An incoming TTL of zero wraps to 255, causing the TC MPLS
dec_ttl action to pass an expired packet instead of dropping it.

Reject a zero TTL before the decrement while preserving the existing
behavior for TTL one and valid TTL values.

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Reviewed-by: Xia Yan <yanxia@cmss.chinamobile.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261031114135.3784868-2-thnkslprpt@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 54a76d6723fb7..0cd5f30ff9bbf 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6779,7 +6779,7 @@ int skb_mpls_dec_ttl(struct sk_buff *skb)
 
 	lse = be32_to_cpu(mpls_hdr(skb)->label_stack_entry);
 	ttl = (lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
-	if (!--ttl)
+	if (!ttl || !--ttl)
 		return -EINVAL;
 
 	lse &= ~MPLS_LS_TTL_MASK;
-- 
2.53.0



