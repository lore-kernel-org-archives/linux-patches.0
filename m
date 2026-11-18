Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030470;
	b=PleetAnqIs9aSBO7KuCfq/w56p7Z0tziQZhn+su0Uk/N/F273MG/cuz/YYUg+RNt8+0Q
	 xQqZXjOkt6cAxZ0Hp48cfx4KzRvdmnGrGXN+7A3Reo0AurpfkH+41clrPhXOUCCs4sj9s
	 DSOK743KZqR9xvNnuC2rG6xCIiYNQNeDA161/iuCTxXNfK7ifRrjOe5Nd8mzSsZ+3ghBC
	 4YiZRKZPGa+FS41vktV0jmP9dbA/a42L8/+Qdn5HC6WJE5SEo21gml1NYjnh8gODYI59o
	 2fHfP5eSLpr8tmiZNfMRpMwSreJG/kqrsXADt1KVsS8pzLqIcZbJh/JpOrnB7vdaZMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7BLM8H0s1Jt3ioMO6Rg/WW+s787JNHp0eI3X3luTeCE=;
	b=XaREdWn1mMSi+nsjuK2XTbyafMiBsGGlekxNRLLhTtM2cTyaSCkSnKurbxwjtx406psR
	 TaAcjysU4AHbZd4ddqJN7TjxqZ8TN1pGJ5ZCTgREyQmDFYD3J4tv6djTTY48KzNK5LcyD
	 Fq8RU1ZDmvhMdMaQZD2t80nBLH9BYNodbEs6GkLgVzA3iR6ZGIbx5mJPUQwjdVzfe6LmX
	 wBT5XUTT3I5bP86S4gFyDfRmdF+A5Bdz0Z+3pPHKPCricEMbzA/8yjUpGCUYndL1Zsggq
	 UDFeT78i+b2HawXjb3YqbOIUT3ZOsJn7iGeRoSl4li5ED/7sObjV2n5IZ3GygDOu5Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eTZKMKfM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87331606A33D;
	Wed, 18 Nov 2026 19:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eTZKMKfM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E7B1F000C4;
	Wed, 18 Nov 2026 19:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030470;
	bh=7BLM8H0s1Jt3ioMO6Rg/WW+s787JNHp0eI3X3luTeCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTZKMKfMavU9A5P16lf25MIp/QCRJE0notJ0/K1K6ofpKoJ2ZFrdof+Nufoim6saF
	 ds9It3m1Jas8A+jptxnYGdceT8WahtYNHsvvrXmi/kY85mTrNmBz+NpWeM0eRx9VxI
	 vzd0S8ro9qNbUox4C7b9DkQlQybNP6Qy/4uaNxds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0716/1756] tools/nolibc: stop rounding malloc() sizes up to 4096 bytes
Date: Wed, 18 Nov 2026 15:47:23 +0100
Message-ID: <20261118150038.043538970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit b7db3ba9434cbad3d15f62500104525bfa28a304 ]

malloc() rounds the size of each mapping up to a multiple of 4096,
presumably to align it to a page boundary. But the page size is not 4096
on all architectures, and mmap() and munmap() round the length up to the
page size themselves.

Drop the rounding. As heap->len is no longer rounded up, growing a block
with realloc() now always creates a new mapping.

Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Reviewed-by: Willy Tarreau <w@1wt.eu>
Link: https://patch.msgid.link/20260926152414.251214-2-danishkhateeb03@gmail.com
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Stable-dep-of: 2111eb4273e7 ("tools/nolibc: check for overflow in malloc()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/stdlib.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/include/nolibc/stdlib.h b/tools/include/nolibc/stdlib.h
index 75aa273c23a61..4c2da9731b1e7 100644
--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -132,9 +132,7 @@ void *malloc(size_t len)
 {
 	struct nolibc_heap *heap;
 
-	/* Always allocate memory with size multiple of 4096. */
 	len  = sizeof(*heap) + len;
-	len  = (len + 4095UL) & -4096UL;
 	heap = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE,
 		    -1, 0);
 	if (__builtin_expect(heap == MAP_FAILED, 0))
-- 
2.53.0



