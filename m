Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036201;
	b=WrTqZgcjM8pQgxcl4aJSeE1XifQhAgGRBV1Gxk8LsCxxNMTbaE8+MvxyuCKSkJIyZ83e
	 gmzzxncw420ByZ8+b3sX+axQVLeAWO0ryumIp61jleYuFgkzDUvgVnSbETCwctnDctjXP
	 q7+m+z9S59fI3sgDLRxGY6hS/qhiPyj+5xVyK2+88Q4Wnzi6Hwfc5w0pGENlU0qrqZFQO
	 NbaWRB/MsXHgv4Ds68qTVFZEtI8qfFvFwYA6eT0vIS54kupLNt+m2kKgd9Sf7R1uE3QiF
	 3WtQYWOGwXFT0ROl5NTGh6HSRmQSmJ12ijiJs0YtXLLRdeeL90XRpXF6xfjmoGyP87w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F82SG0V6e9fMnu4Ln1JwW2bZ+AVuhULhJeuGe1poqXE=;
	b=cEt+OaRcYUkHhw1aqP6hJFio06qDTBRHiEJS2cA/PCA/+5AtEYkUvv3hvEz3G3zzPMhd
	 L5ozcfU6hyonPGxAtb8TeUUhlfJAO7jlq6FdV7pT9rcyozHnFNmyRXBaIrCRlkqAHtkKa
	 dQ2jPcgRVdXXSEeYDELaqsvsZedPBF5Dn6ZmaK8MG8DukrodLC7lRAZhNQIfRiUHEl/oU
	 05uGi17cbdVKiz6S4I/KxvO6oYTZ4FAWhbaJmwyd+PqdZatbB6FvF+SF0buX5CgLfi8vQ
	 DBAhpQDNVBzMB8b9J7mVj/7Brzu+5eXxYJsRpYmbfye7X5w1n/whNZlhxeWl+XnNkDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GQ+soWbE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA1D606A330;
	Wed, 18 Nov 2026 21:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GQ+soWbE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4481F000C8;
	Wed, 18 Nov 2026 21:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036201;
	bh=F82SG0V6e9fMnu4Ln1JwW2bZ+AVuhULhJeuGe1poqXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQ+soWbEN449tvhvWbripEZRMlob/RK69B/A/a9dCr1N8nDamOsQw8FOZSSRtwKMv
	 XKLyYncVrUuBSxbOhUtnKLBzlCQ/Ca9njTVRThOeQnXOBQbwgPvImmV6NsxaYPwfkL
	 kyKCAkJjUFEhvcqfHDKeSefgnxT/asPB5PlIYHMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Nayna Jain <nayna@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0968/3318] pseries/plpks: clear signed update authentication buffer
Date: Wed, 18 Nov 2026 15:26:30 +0100
Message-ID: <20261118150348.719271505@linuxfoundation.org>
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
index d6a1e47c1677d..591923141a3a6 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -479,7 +479,7 @@ int plpks_signed_update_var(struct plpks_var *var, u64 flags)
 
 	kfree(label);
 out:
-	kfree(auth);
+	kfree_sensitive(auth);
 
 	return rc;
 }
-- 
2.53.0



