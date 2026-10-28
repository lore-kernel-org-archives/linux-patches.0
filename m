Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212342;
	b=jlP2adDTly3StigggRJ/IP//EkwXQh1wBBvILS55ApJ1X8BcQyEYBVtR3/YIVa0bRp73
	 gnYfY3HZBTEIhKa+B8e6u+8Y3ZfGf3C2BBUnGGd79eCM23sluOVXffKmXIOyztE95P/wV
	 17zDNyFlKROHaoq69IrRrGceaIUvl0nUO5SX3ZaZBAb8GxIQuDnFKn6XvBAwZTqesF5eZ
	 gP5F2gvOEZkQr7qTGcYKqHUdLMbZ0h5Pd5lqguR5M+hZoXy8WkSYa3LFgnWFJQVSxg7KD
	 86c/AsoEpPT4LqHET0W9hEKSDu5YopVyGUjowCfcvRY8wmCf/+uzEr/bUd8n0MpzjHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ClNAdFa5FGspOuxz4XBr9o3kcwf9GLCke6jJavHPj3s=;
	b=QPn9Gr82EYp/h9F5izj/T2fuJiH0mXCDWiNea4nihbQp7i8y+kE18inwVC93zVsFYNul
	 /u0KhhXaIadqL5vr1j1Tz5KMivrQfn13AedzBkmreVpRsmp1Tz0z9QtDVdDgpSNAU92nZ
	 ThFE8UmISYv29hauQVbZorCx2+DbHsztgTERKrx+M3+wF7KI+xmbb3yjzrfhQEjVNvI0H
	 JOzHEUW27F/0YF8MseR1HEKtpAI37UEJl45eigH/vi/fqt+dMyGj4mvKqVnzmA8fxB1nH
	 IncTG/qB6G8UOJVr3r/6H+7vwkMtfWXDeQF91qXint01UXv24jL+7DvVPFYE0hLo+zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tY8dIiNU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B78606A31C;
	Wed, 28 Oct 2026 18:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tY8dIiNU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF9C1F01825;
	Wed, 28 Oct 2026 18:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212342;
	bh=ClNAdFa5FGspOuxz4XBr9o3kcwf9GLCke6jJavHPj3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tY8dIiNUgaFVD1MqbTgbNjybnsaFqo9uSMNFhJcNsUu4bQ92sUAcfsArALJMH9VnW
	 2nribLX6jOzBO5XoDMoA+ixNseCswdmd4AcTC2cpxDLE5hRryd/N/0xKGAbqXNBUGE
	 v/DqqIgyqH71ZdSAFIK4Sccnx8vJyV0fvtZJ0jjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gurudasani <nikhilgurudasani314@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0121/1887] erofs: preserve LZMA decoders on resize failure
Date: Wed, 28 Oct 2026 17:36:57 +0100
Message-ID: <20261028170501.992817841@linuxfoundation.org>
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

From: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>

[ Upstream commit 617d0d8d199ba1790c94310fd75a22d01c97a8d6 ]

The pool-resize path frees each stream's old decoder before allocating
its replacement. If an allocation fails after some streams have already
been replaced, the failed stream is put back on the list with state ==
NULL. z_erofs_lzma_max_dictsize is still advanced as if the whole
pool had been resized.

An existing LZMA mount can select the broken stream and pass
NULL to xz_dec_microlzma_reset(). A retry at the same size also
skip another resize attempt. Since the global maximum was advanced,
thus, the invalid state is left unrepaired.

Allocate each replacement before freeing the old decoder, temporarily
retaining one old decoder during allocation. Stop at the first failure
and advance z_erofs_lzma_max_dictsize only after all streams satisfy
the request.

Record each stream's dictionary capacity so retries can skip streams
already enlarged before a partial failure.

Fixes: 622ceaddb764 ("erofs: lzma compression support")
Cc: stable@vger.kernel.org
Signed-off-by: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
[ Retained the existing `struct xz_buf buf` member alongside the new `dict_size` field. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor_lzma.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
index b1ac88a820f2d..c6e6ceae48a3b 100644
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -6,6 +6,7 @@
 struct z_erofs_lzma {
 	struct z_erofs_lzma *next;
 	struct xz_dec_microlzma *state;
+	unsigned int dict_size;
 	struct xz_buf buf;
 	u8 bounce[PAGE_SIZE];
 };
@@ -132,11 +133,19 @@ int z_erofs_load_lzma_config(struct super_block *sb,
 	err = 0;
 	/* 2. walk each isolated stream and grow max dict_size if needed */
 	for (strm = head; strm; strm = strm->next) {
+		struct xz_dec_microlzma *state;
+
+		if (strm->dict_size >= dict_size)
+			continue;
+		state = xz_dec_microlzma_alloc(XZ_PREALLOC, dict_size);
+		if (!state) {
+			err = -ENOMEM;
+			break;
+		}
 		if (strm->state)
 			xz_dec_microlzma_end(strm->state);
-		strm->state = xz_dec_microlzma_alloc(XZ_PREALLOC, dict_size);
-		if (!strm->state)
-			err = -ENOMEM;
+		strm->state = state;
+		strm->dict_size = dict_size;
 	}
 
 	/* 3. push back all to the global list and update max dict_size */
@@ -146,7 +155,8 @@ int z_erofs_load_lzma_config(struct super_block *sb,
 	spin_unlock(&z_erofs_lzma_lock);
 	wake_up_all(&z_erofs_lzma_wq);
 
-	z_erofs_lzma_max_dictsize = dict_size;
+	if (!err)
+		z_erofs_lzma_max_dictsize = dict_size;
 	mutex_unlock(&lzma_resize_mutex);
 	return err;
 }
-- 
2.53.0



