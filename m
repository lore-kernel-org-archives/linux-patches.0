Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041319;
	b=AShz3i3HzvZiWScmD5Wdi/ILwLnHN88X8sJu9drDgn3sspTlkAaA7HfOxcmQ6M70ekBw
	 9eF8BYBYAVk/1ph6k4ffNdy4G8YPs/r7zfFWBhN6uCBGMCeY1HdWeFqDQNujswKMfCIqk
	 h/kdm1HEj+Xs77ZXUdKnOGkieDw96xyjAOhXGSagoiLgPwkOaQ2FHuym9K7XhtvYtK9lL
	 GvPTE7mWDtXf0dv27UTfRtY/6+vEK6V35n47ITYgP30qMa6RNFK/+I1EyEbHUTCDCvnxl
	 wfFPtzi3p3mjXCE1KdeBI/Tv6+fadzViuHqOYhB4oAUQzJyY5BOQs5BAcYLiblLu5Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XaScuBPFv82hiq2CCV0ea4/J73AxANO5cscGx/SPP50=;
	b=pA1/7Zp+eJ+Qa5g+MtAVQ44z5fSbfnH6SlPOLgJRV27sVY+0y045MiWBp97p906CmE5R
	 DHK3AwN4gfMUBwZM6b7RpWMN4h19c36IjQ8wOVCzbM3fkRG70EU1lEyPvIERMO31ZmL+y
	 srwFA6ZZO5E1Ob7VUFyaeg+NTgyyymPtNAujD3iEL0lBMzeKPKvD17FLtNrlZ1fWzOpaf
	 uI4hF3UnSMsaQglhURlsfNluve0k+iR8HQ6jll37IdYy/9EnS3inf/YfsJVXXPIeP8FRk
	 ophT2wBH/Vs69b5++8c1qmwNGp5FwKAdZjqBVKROWTOp6nUuIkv7P3eXCFkf3Am3p0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6w+uzWN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0280606A32F;
	Wed, 18 Nov 2026 22:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6w+uzWN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4991F000C4;
	Wed, 18 Nov 2026 22:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041319;
	bh=XaScuBPFv82hiq2CCV0ea4/J73AxANO5cscGx/SPP50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6w+uzWNWSc/+5rIaVvO4EANawXtZu9tiJ6JiFKn9QdJfsSjrAkUtaP/73e4csdnA
	 1+cW/lYOL37FockJXUqgXZzBLCAjDKJNBG50jo3NvJLTC/hU11e7hZCJaswMoRQC1d
	 QOqRc6vK+c24CW9PFyG9Ho7Ufdqd0WsaQve4x8LY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2772/3318] calipso: hash the cache key, not the option start, in calipso_cache_add()
Date: Wed, 18 Nov 2026 15:56:34 +0100
Message-ID: <20261118150443.873164379@linuxfoundation.org>
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

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit d538cc3ec0bc4cb7b40981b3213a6c6671959ed5 ]

calipso_cache_add() stores calipso_ptr + 2 as the cache key, but
computes entry->hash over calipso_ptr, i.e. starting two bytes earlier
at the option type and length.  calipso_opt_getattr() looks entries up
with calipso_cache_check(calipso + 2, calipso[1], ...), which hashes the
key itself.

The two hashes only match on a jhash collision, so the CALIPSO label
cache never hits and every labelled packet takes the full DOI lookup and
category conversion path.  The memcmp() on the key keeps lookups
correct, so this is a performance bug only.

Hash the stored key, as cipso_v4_cache_add() does for CIPSO.

Fixes: 4fee5242bf41 ("calipso: Add a label cache.")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/179138670045.80227.16155454353416856947@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/calipso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index f23bccb0ee5a2..971b1c5301b2d 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -284,7 +284,7 @@ static int calipso_cache_add(const unsigned char *calipso_ptr,
 		goto cache_add_failure;
 	}
 	entry->key_len = calipso_ptr_len;
-	entry->hash = calipso_map_cache_hash(calipso_ptr, calipso_ptr_len);
+	entry->hash = calipso_map_cache_hash(entry->key, calipso_ptr_len);
 	refcount_inc(&secattr->cache->refcount);
 	entry->lsm_data = secattr->cache;
 
-- 
2.53.0



