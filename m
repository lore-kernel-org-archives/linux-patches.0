Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023994;
	b=gOWhPo1n9Vqi0hnVkYlKtiysUDps2zz1ZtUY5yNg7N2tZJyVDpR8oMFvq68jumrDeZlt
	 eEQVJFSsh8Ny0A5/UX848m+Z1y4GTQ9FHprnv2vuMjVchH9qqQ7rpc8yKIONqpMHWakd+
	 J06o2hFLlOZBHjI7NeySipK76FngtBMDiLQZwXxByVgacirMIaKuuOnp2UE7EU1fBVGY9
	 fplGejBr4cY+nl78ti3PDICWLJX3uU7gZfXwCX3ueNu0LJwNTmFxQ4+NAdWRvNkrJlWES
	 IjXF932m2UTAwaN3OG4NqYxRaABMt3sNKew9SdiQXUWuH8lmUPXa5d8NZMyg/HpOURQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7g8X+FaeFZ9laYEzsdpw0oLT+F2/lJ5GGJq2T4Hi+d4=;
	b=X2OdRuHMmgAkaptiDdNDV4vUkRJ+9tX0ugbtSB7jP8CDA/DI7HKewda50QU/grZ+Ef+I
	 b5WxjC4c0VBSRPn+DKUZ9zw4e+Cm5mXUj1wHwNH2uv2H05RPe6ANI5utIxJ0FFLg4i4Od
	 iaCj3hmaev8OctP3xCoDUEEyhkBZehN35CBaVbCuDxWn1Q+cZWLVlZ1xA9iWvITFbe6/o
	 fWEpC0Jb32wlzMdIGfjDkV0SOA0VDstoSief9PrCq2/CI/51fZ2xi8BnA0+veVCDXvKLZ
	 aCQsWiJvLgIkI/Z5gaijetBzH8HJKqKw7lRWKZznv8Dub6TI0Mxvd06LVf0J5x+ovFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="y7gZBkI/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB0C606A31C;
	Wed, 18 Nov 2026 17:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y7gZBkI/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5631F000C4;
	Wed, 18 Nov 2026 17:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023993;
	bh=7g8X+FaeFZ9laYEzsdpw0oLT+F2/lJ5GGJq2T4Hi+d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y7gZBkI/sFXvESwoGNrHhomaAmjsNfzwpQfNNilMexYFrFW4szSS7pRUkp7TJIdsQ
	 qy4/q90pUlccHFlLaWqeIQEXpL50wFn1G/tghQgUvl6w7noSbHfqtncUCdhcG6QkYG
	 PuXn/KE28WjPyKK2+gkwitCECQB4p5sOfSJNENOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0568/2151] pstore: dont leave an ERR_PTR in the ramoops zone pointer
Date: Wed, 18 Nov 2026 15:38:23 +0100
Message-ID: <20261118150142.640428155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 70fec428c845216da98041b1ae9f16a8f54b3d68 ]

ramoops_init_prz() stores the result of persistent_ram_new() in *prz and
returns the error without clearing it when initialization fails.
ramoops_probe() then cleans up through ramoops_free_przs(), which hands
*prz to persistent_ram_free(); that treats the ERR_PTR as a valid zone
and dereferences it, crashing the kernel.

Clear *prz before returning so that cleanup sees a NULL zone.

Fixes: b5d38e9bf1b0c ("pstore/ram: Add console messages handling")
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/20260921202317.70595-2-parri.andrea@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index bc68b4de5287d..a11036272a4eb 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -605,6 +605,7 @@ static int ramoops_init_prz(const char *name,
 	if (IS_ERR(*prz)) {
 		int err = PTR_ERR(*prz);
 
+		*prz = NULL;
 		dev_err(dev, "failed to request %s mem region (0x%zx@0x%llx): %d\n",
 			name, sz, (unsigned long long)*paddr, err);
 		return err;
-- 
2.53.0



