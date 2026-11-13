Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585751;
	b=nvELfruxOy5YRmF8Gmm9qnJGai1dK1R5O/oM066aOI65hnM37ynAkhfWYh41sLjSLr+w
	 F7aWeuvA++pNF5Iq7fXCAmmzgnuX5wzKOxu+eS3cKi7hxaBYrqSPE0yLG5LWa0xaR6IAv
	 2u1YIqIie52Hu9zwIK2AexGUPK2UmEK25+9pitx7R0zRK+uQnbXZa/NYonD+8A+oN+qUL
	 4p6e4mHx7MleBAsAys/bBRuRUH4yudIrlLSjsIfNbL0IU40r5649U+mhmmrNKtHzYC+xJ
	 XiPNY5So5lPEgpX/lhc+zpPz3xRLAY5uaD6YWutpt3QbGBHmkJXcD8Gqd0UnMfkFi/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/AOEDdw20jT+19OLOue/l41/7uUQ/KBjrjA0QSV7FEE=;
	b=dNOTJDbIsb522LjcyofztRo4EgLtysWBFDKM92Wxa03BA89om7EWItmt7mvSrfOPE0Sj
	 gnm/1cn32GL7xhyuoxuEx7yYk+nY7YI/jR4+RSIOlxsjMEt9VMm/xoW8QfftFCSYzFqPk
	 7fVvlLv0qZF5a3X0Dn8Kgs6hTHdsemvPhjKtpCFc1bQER7XPJTwK6FuxTeH0kTLlpQvS3
	 tndZ9bbX0pJ+r69JuGBUd6O/dVHm9uqxjGx9XHU1SKq1fdnWFOb6ga2nC2z7bsgyE0IT8
	 izN5BdUxhIGD/B0PQCEl9ABp7nPmAzoRstKexTE4nUNqch4yJsk1Su65zrWdJGCuSsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tEeYC3H4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEA2606AE18;
	Fri, 13 Nov 2026 16:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tEeYC3H4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426EB1F000C4;
	Fri, 13 Nov 2026 16:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585751;
	bh=/AOEDdw20jT+19OLOue/l41/7uUQ/KBjrjA0QSV7FEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEeYC3H4DbqWhwzTKXohSuKdGXsFKeCfLpzxp+1iDQXG6RErUjRznbWR5YIlqByrs
	 OZFXb57LsDD7A0WxbqPi+ujbHQUefIM5ek2L9z8FacK2Zm0n5XkeMu72RSR25VUgoz
	 xph+LMilmoOHBvNvqpngPtUK6r72WLNZxYQd3TJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 347/507] drm/amdgpu: Check cs flags.
Date: Fri, 13 Nov 2026 10:50:51 -0500
Message-ID: <20261113153807.191122500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

[ Upstream commit f5ea64f9fcd921bc4e2307a262e19450b8a58524 ]

Had no validation before. libdrm_amdgpu memsets this, even
for the raw/raw2 functions.

We have a lot of functions touching the ioctl struct, no
strong opinion on where this is placed, but I thought
early would be good.

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Faith Ekstrand <faith.ekstrand@collabora.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d01e15e76358f60ef6734462d2b6d9972b9dfbc)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 86a3dc3655b3c..40c71332d9746 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -188,6 +188,9 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 	int ret;
 	int i;
 
+	if (cs->in.flags)
+		return -EINVAL;
+
 	chunk_array = memdup_array_user(u64_to_user_ptr(cs->in.chunks),
 					cs->in.num_chunks,
 					sizeof(uint64_t));
-- 
2.53.0



