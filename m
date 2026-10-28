Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212206;
	b=Yli5j4PfAOqtSp2nR3EKG3Bugav3CHsLg1Zb1hYhpAv1fC5dVImtBQwz9rzXh7I1gGnG
	 EiflZ2+v2okyf/fNX57BQ+wl1L8g7I9Peh4dvBYZ+h/YrdN1ptc/pzYoLp7o4xNNaYe18
	 4cLiim53nWCZxGlIKm6Kgcy1/gLXZ6qiUeEZIyRKSDjvgiAh4B51YZbE/ikBdktvWgqbT
	 AZZJ20wBs6oaL98gWChUJ9dfhbd4+uVMAZD0Via10Bp4Rn518646YBoQL0tHGQzNG6Jl+
	 pbDUjbHvIas7PVBj2hookf0IAR+ua8dDwnJiOvsEpG8+M69jMXKG9iCzcAXw6LJt0Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Caz8Y9R8N3qGuIW74WNNFWSVpuwass7UQ3sTPIh4eoc=;
	b=L8gbw8pmkBiF+aFmP+ixadRdYrcz2RyPeH/iOWwIDOwG7SBmr8gUqdH64bWIiIokeEPl
	 /GjWHW02eWtNzRID6IMg8VcKMDgaSI+UXnU4XSdJgf+xauEbkSQzdz949wpye9yXgVrx5
	 +DA6L4KJGOM6OsdRpflHg3qzk9D5Hz4ihMxRpDGWs8yb32Dg0KkoDBn6QmzjNy7ayaNWV
	 5WzKLDPSJ7UwI2ImrUk2RFZwmObN+DHWiOtd/6twxtVjFtqYJmFpovglcRgLjuA5nQh58
	 GVi+SsLJw6QO0/pM2nahEw3Rz1Fx2jR0EbRZFqzS4r5hkXlmEZkzGOPyAEwXiixBEMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JUOvuxXJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA0F606A31D;
	Wed, 28 Oct 2026 18:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JUOvuxXJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6131F01825;
	Wed, 28 Oct 2026 18:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212206;
	bh=Caz8Y9R8N3qGuIW74WNNFWSVpuwass7UQ3sTPIh4eoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JUOvuxXJuR5uwACdywEI8JrSk11Zot2lqdLXKQ7SRYDvlZUK3gBYF1CdAN8vW2sdG
	 /6b7QAUSJ4//exEUuQ9OWgqU/Nm3Q9onwwF2Qnkj7PDFaShjIz3aVudzlMZ3Psu6Zh
	 SdAGwcuh8gwtKQMMagt5EcEMJbdXGA/DBF6CSh5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Miroslav Benes <mbenes@suse.cz>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0076/1887] kernel/params.c: Use kstrtobool() instead of strtobool()
Date: Wed, 28 Oct 2026 17:36:12 +0100
Message-ID: <20261028170500.964308925@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit def7b92efd868a6c78da86770704c1a03506016e ]

strtobool() is the same as kstrtobool().
However, the latter is more used within the kernel.

In order to remove strtobool() and slightly simplify kstrtox.h, switch to
the other function name.

While at it, include the corresponding header file (<linux/kstrtox.h>)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Stable-dep-of: 3dfaae04243c ("params: fix charp corruption on allocation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/params.c b/kernel/params.c
index 82109c0cf9918..e6df4c2ef097c 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -4,6 +4,7 @@
 
 */
 #include <linux/kernel.h>
+#include <linux/kstrtox.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/module.h>
@@ -310,7 +311,7 @@ int param_set_bool(const char *val, const struct kernel_param *kp)
 	if (!val) val = "1";
 
 	/* One of =[yYnN01] */
-	return strtobool(val, kp->arg);
+	return kstrtobool(val, kp->arg);
 }
 EXPORT_SYMBOL(param_set_bool);
 
-- 
2.53.0



