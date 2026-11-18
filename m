Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037034;
	b=Z2EWDnTy5xKqiiG/OfJjCgFEIbCa8dtb0Quvx6156TZSL7+J7fdVdfuMnf09j8oU5Sff
	 AHJToQA3Y5UhbR1SNOlxeSOA+oLdTVJUk4n0KSjw0kUedR1iZ2wEwI9d+MUFW629kM0jE
	 H6rI4OgeSLHtrzrqYkT5FmUHGNR+JkIk3T5CFC4BhvDgis22p0nKE5mEVwSL99+/QMm+0
	 BAVFq+o/j8WwejAs7utPq7qaz2kKWi6PRDLgKmIF5ffmsRrIavIUXR3a3OONYNQgPHaOa
	 LP+vND1CzboYjG7KcJh0g7MqhWT1fUqhlmt+1yPHn1cfuyH4pRdcOnUiV7JJFvYS9Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3C0jumbtHo4SIvwSnROM2y+g1CgICa2I0L+s9eR+zas=;
	b=ZjhbtQP/3Bk6YpikRMLMb2c/N4lrWoNrJXZyCKI4+O5bDGUNla1cpVDWpfHV6oaAHnay
	 ThawszktcrzlAR7P7OYkUu+oIL3f4a83z0P8OmhahIlZQ+jn07u21vDqUNp9e08OzhajS
	 /zGof+O4wB7AJoGdN91hWPKxsk5aJ6RXiALg+uRi5SSwraCY7XvcildfNzdY4mN2ucUj3
	 lTDtHqRCNTX5YxPCayxJbuTm9L2SG1yPT/u/yH8bVY28MoD24SE2u4mWUIcLKBSHbzXwQ
	 TOwQXeTZAhKEtnNRQB3GMGHFmD9CgizHeWKJTC9jHGAuXjLy7Kc1YnDseHGplckwgvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ql7XVdtI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4383B606A330;
	Wed, 18 Nov 2026 21:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ql7XVdtI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959001F000C4;
	Wed, 18 Nov 2026 21:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037034;
	bh=3C0jumbtHo4SIvwSnROM2y+g1CgICa2I0L+s9eR+zas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ql7XVdtIrv5wJ+rQy/XDFZnnXm3obsNr0MZRGr/GO4gEN7Ohcgr+2shyfc6eWz+hG
	 dNBEZaDyQBcasfOeyg0ordZ9i2mnsXeAqD5XKw9zVjoF5iJYzDuNiTJ58x/F6bzcFh
	 8gIzpFJ2Rdum1s2eMmbHL1EQ2Uyfhsj5i/bKdYcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1270/3318] ntfs3: fix mapping pairs bounds check for alignment
Date: Wed, 18 Nov 2026 15:31:32 +0100
Message-ID: <20261118150358.323041584@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit f517cae6333121783043d9ba5142b50f5d1cf75b ]

In the UpdateMappingPairs action, the expansion check compares the
unaligned new attribute size with the available record space. The new
size is aligned to an 8-byte boundary before the mapping pairs are
updated, so the check can underestimate the required space by up to
seven bytes.

Use the aligned size in the expansion check to ensure that the
subsequent update cannot exceed the available record space.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index fe6cc4f123ca3..4d790d523f7c9 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3438,7 +3438,8 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 
 		if (!check_if_attr(rec, lrh) || !attr->non_res ||
 		    aoff < le16_to_cpu(attr->nres.run_off) || aoff > asize ||
-		    (nsize > asize && nsize - asize > record_size - used)) {
+		    (nsize > asize &&
+		     ALIGN(nsize, 8) - asize > record_size - used)) {
 			goto dirty_vol;
 		}
 
-- 
2.53.0



