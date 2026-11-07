Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062141;
	b=PPrtsvQEhjf/LsuY5ThhwYrcNpj4qmnfpwnPzVt/m4OXs9Pmjtw2a1QK8i4zLQNmp6xK
	 xTOsts1EjUAoPgkuO60/fZalkPGqPdKVKOiBA/+f3OBiN+w8N+s4X896ZTdEym+awQcpw
	 PhE38JraCNDXisX1T5ox0RinRr1eEuVmpwwHTHMzxC8kXw1eIjmFrkpzckYXGmTaHBc6S
	 21ZqqOucGjvUIV1RYMzxdE/Jc9ibm7CSA+jvH7Ehcevg2gYKQjR68EKH5Anu3fmE45A3t
	 4Z2rz++yjS0rJCyte7gGkEfXzCNsowqNfI9Pd6Pv5QlhJMqrWwwnZ5E6wq2JS494ZFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pL5bD6XvUWIq6ZcOdVQJRiJwJZgJu9f00kxVdDDevlE=;
	b=gnZGQeS7HNrN1JPrANTxkAYJa7ztZDiycT+TU3Ky8Ds9Iz+L/38n5SzT3lwp6Cpudsg3
	 mxhrGqd96aa/w4K6GgPblvrH7aSZxc33RHMRguv9ioYYKDgsmZOutJeZu4zDpMePfxXT7
	 uOmY8GF9qEXXnOBrOGcxQivWrXWxoC/RDfTrnBl2xKMhSq36QJHKbtmTFImL9aPkJ1XKi
	 4rhU7Oq1P+Q4Qpm/H6vo8xQutbi/Z/MXogO7hoMCtq7YsX8O/lE5s1CGwN1wJ7WyPuCz8
	 eqP/exsCj35ypKlYl2oE34j2nRAkiNWqhcuXdRHQ+yT+g4+oIiBNeege4eCi+eKMgcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pvT/6eYU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193ED606A653;
	Sat,  7 Nov 2026 14:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvT/6eYU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5C81F008A2;
	Sat,  7 Nov 2026 14:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062141;
	bh=pL5bD6XvUWIq6ZcOdVQJRiJwJZgJu9f00kxVdDDevlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvT/6eYUHaHWmiTFUwz4AZTIPKrLhWCJLss2SUlAEdwZar+/buSCJHqBcuEt+8RMh
	 7TaBepUJmD/uqKVyS32YgJJRTyoRW6pf9PVfEUGfakgzCFt4nAo+leYHoH3ZmrkvYe
	 Ucyh1guk4RgGFiH4lG8jtwja+3XpeYxOjJZkb+Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1106/1536] pseries/plpks: validate input to plpks_signed_update_var()
Date: Sat,  7 Nov 2026 08:52:02 -0500
Message-ID: <20261107135028.765038194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Srish Srinivasan <ssrish@linux.ibm.com>

[ Upstream commit b59ff2d50b817eeec1259f357aae821c7834007f ]

plpks_signed_update_var() dereferences the supplied PLPKS variable pointer
without validating it. A NULL argument could therefore result in a NULL
pointer dereference.

Reject a NULL pointer argument with -EINVAL.

Fixes: 899d9b8fee66 ("powerpc/pseries: Implement signed update for PLPKS objects")
Cc: stable@vger.kernel.org # 6.3
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-4-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 1ea3ef0a36254..3686d66277262 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -434,6 +434,9 @@ int plpks_signed_update_var(struct plpks_var *var, u64 flags)
 	u64 continuetoken = 0;
 	u64 timeout = 0;
 
+	if (!var)
+		return -EINVAL;
+
 	if (!var->data || var->datalen <= 0 || var->namelen > PLPKS_MAX_NAME_SIZE)
 		return -EINVAL;
 
-- 
2.53.0



