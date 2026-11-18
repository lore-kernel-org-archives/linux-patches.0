Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022275;
	b=txu6Yd2mJeycwpta1CMBKbsOunztdQ6dYCzJCJ8u3Q1VzWGxdj4LUgygZMwRXVddRTV9
	 d1q1F+otcDazKWMfV9YMlozItIKBW2k2gsUX/FF/MHWVWjjRrOwfEN6LWjBcJzCkL5zmj
	 DlExsByjbLWW0ehOmiBSG/D5QuuRzOPnohBRSwW1vNRBgC70zetx3aRv4UsgF9x9JvUGE
	 dsD60PUgYSc7tqOWWmUgUIR29hR8MqtIbVZOYthtFI1xqJ5cHnPMi8qwSnw9Z3u6l1oSc
	 LkXxgQJBvpVfnKOSWOqumJVuFGe1kc7dqyLatJB5l1Ozh3QKKSFu9WolwNTDCpQ5QHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=i0TELLpwpoJdi3xcPnlmX0Ts2lAgIyhtxpkTkED+CaM=;
	b=Rp9SUrECq7tLWf86ysYhdBxzwDjv3PSj0x0ZwIHp0mxIa2y/Axp4RkmETQ9cliFPzYhi
	 Yfaxk/52EDJ+wanbK+KsVrYxpMR3y8dsM4Jav8B947nrG5yhLhrX2MSxKCKj3T0prjWZY
	 4kkWutI9I1Fwydm9IAIeSRhviFHUC2WSR1ZVwqeBMwmpwIJYACo4m4MdgK12e4aiwzc+6
	 lIxJTBUuwO7bMU+ZPHHJPNzsqtQ9IDk7ZhkbAYG68iNfhkCgxyidSkthaKSL7bDKPv0hh
	 caDco738m0OSATSjhrwVMEP6fFh9EVE1wNTPJJ7j4lk+TAprIlGZTmHU3LidvkkNOYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zqCTSKxT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6983D606A320;
	Wed, 18 Nov 2026 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zqCTSKxT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6E71F000C4;
	Wed, 18 Nov 2026 17:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022275;
	bh=i0TELLpwpoJdi3xcPnlmX0Ts2lAgIyhtxpkTkED+CaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zqCTSKxT2rJ3JbAF+Yk14udMkrrghpRHg8QNY67+7BzMe0ruo+qaoB8O6Od9DYI0S
	 auFKTxwtnlTwLMyFKDmHmG59rii9y3pyx7Jxx0Y72mvJGHMRIpYEg1Fqo0aZV0QOaU
	 60/z61poKiYlmky8345MLBN16pI+0PXtBW0M2Z2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2604/2651] apparmor: report a label allocation failure as -ENOMEM
Date: Wed, 18 Nov 2026 16:04:04 +0100
Message-ID: <20261118150418.009880946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit 07aee062c6ecaa7199be583c83a1c74ae9885f03 ]

aa_label_strn_parse() returns -ENOENT for every failure, so a caller
cannot tell "no such profile" from "could not allocate a label".

Report an allocation failure as -ENOMEM.

Fixes: f1bd904175e8 ("apparmor: add the base fns() for domain labels")
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 42ed476fe89d9..fd67262330f90 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1954,12 +1954,18 @@ struct aa_label *aa_label_strn_parse(struct aa_label *base, const char *str,
 		goto out;
 	}
 
-	if (create)
+	if (create) {
 		label = aa_vec_find_or_create_label(vec, len, gfp);
-	else
+		if (!label) {
+			/* not absence: creating only fails on allocation */
+			label = ERR_PTR(-ENOMEM);
+			goto out;
+		}
+	} else {
 		label = vec_find(vec, len);
-	if (!label)
-		goto fail;
+		if (!label)
+			goto fail;
+	}
 
 out:
 	/* use adjusted len from after vec_unique, not original */
-- 
2.53.0



