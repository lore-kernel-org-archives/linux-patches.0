Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042346;
	b=Ccqdzi//DhuGa4s6sXmsXVYW8tTzxHuzbRdu/059G9BKieAlm3yTyvWc7ao15DVCN6G9
	 teFgGs1s2ZOKsyZonFWv4+wmhNvbyfpTERU381wOCBLTdPhMP7HcUnKZFXTnC8qPix5iS
	 Gbl/STuSxOrRaGM8SHy6MteUiXbOAzMNIe9FiffELzO41nB1svFgALH2a4by+FXxgmYK0
	 S0e7D7hmYVwsUpxFSXgKz8crfdhn/L1uDpNmO5GKJnV1FVc+AGXHi/X5cBZ7peaJFh+S5
	 djgw+S5uo7/iSmqqeNisRp3/Fgl7n8QjX4ayiD0ULA3QpXEEmJEEF1O/uiKtsvOm5qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=04gSD82NcD+YPT87Ci/frUQm4NN6PBtSNEAVybA4Y68=;
	b=3I1LRysgrlFmwc5EZgpyYPuRdFl5g0v6Ldg6nE+ix8FS9q/Gu9Ntiz/oPAUh57awPy3/
	 U/a6mKwpdfluJPYEFtKLGx6RQvGJYRFCTETjoZXo+BR53V3NyJg6iDrrEyP6tw7H4P+y+
	 hJCrc7HDkxAupznNkR3uW1VM7zA6toPXwr8++7GdmBHMcrirsL8FpfUnbOqYulvx3oSb2
	 pFLRYjUHoGrI5Eer+wakVjdhQj6qFaeAZtXHZZi8IhNkLjnRo6igMaXhe82aJh8db5hgA
	 Xv4yFaQw82tUtXTgjI9DqWHis4KesVCNabKIcuDmgOOUzQzCAvMhle6tcGIZvHUZJUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0PpIOPfh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2408606A320;
	Wed, 18 Nov 2026 22:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0PpIOPfh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395341F000C4;
	Wed, 18 Nov 2026 22:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042346;
	bh=04gSD82NcD+YPT87Ci/frUQm4NN6PBtSNEAVybA4Y68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0PpIOPfh7lmYJ2VheDiGkMa8qfhStlW6JEGt6FoATIeyuMFz2yE31yI9Jl+9Iiaem
	 Oioa6N+P1vZ4v4ruK0bFN7Mw6sq6Ivbrsc3WC3YWKfqD6u/ckk+ovcseR/3iJotjWR
	 espxsj/U5eufEYThO8LHl+19HTFbq3FEZV4NFKmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3138/3318] ksmbd: select CRYPTO_AES
Date: Wed, 18 Nov 2026 16:02:40 +0100
Message-ID: <20261118150454.023498939@linuxfoundation.org>
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

From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>

[ Upstream commit 2c36c4a86104d763ee798d4a89e2d3384b4cd626 ]

ksmbd allocates "gcm(aes)" and "ccm(aes)" AEAD transforms for SMB3
encryption, but SMB_SERVER only selects CRYPTO_GCM and CRYPTO_CCM, not
an AES cipher. With a configuration in which nothing else enables
CRYPTO_AES, ksmbd builds but cannot allocate the transforms, and every
session that uses encryption fails:

  ksmbd: Failed to alloc encrypt aead : -2
  ksmbd: crypto alloc failed

Select CRYPTO_AES, as the SMB client already does.

Fixes: a848c4f15ab6 ("cifsd: add Kconfig and Makefile")
Assisted-by: LLM
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index da0187e76cf1c..57aab102675e2 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -18,6 +18,7 @@ config SMB_SERVER
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
+	select CRYPTO_AES
 	select ASN1
 	select OID_REGISTRY
 	select CRC32
-- 
2.53.0



