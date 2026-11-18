Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044561;
	b=uOwTQjvkp0VSURXyWELe3YDNsJspq6NWfJl9ozh7D6eu1iHPWo1zQdfE4kTi48BoLlBP
	 oJJsFJ5sEW3G+a1uSnNVLiKhRa1INXbvqZ0wEV2sR3RtVRHm/qWakvLrATttdsaJ16wgO
	 ao3JcuU63D8LWIqq086eZiKP21KplVPVYC8t0xzUA72LPnY9+PaE2xOM5i0ileZVTfWxp
	 2mya8n/Bnjh8xA9JfSlSje+OIj7eQZg97PQpKUMQ+j4gutN8RmMlTYGiFOtulRIANAQhv
	 dnq3k9z3huMSltGSHmRweRobGt8Ak4cIk/mKADMQYLgnG/m5i51uc91KwDXWmoRZ8YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=837315ff1xFB3VbMK7DzpONsWLKbibNgMmRXMv5p/cw=;
	b=FI2j59Gf5l2sOUD2+8vd7tvldLLxjZdn/WyGXZFuF5Ps2Q6Aw1GGHDvsQCSXP7hpDzD9
	 n/yyo8LmMljV4n7s/CrXyf36Clx6N/tcJDj8uPg2rZ1zWfhmj5Ee/0BvaddMihVY+6cow
	 dTFKJebHhVxJepXhOT9NQrA1uE8YziWTEJ8CohhcJPuC9a98Qam0Z+N03+cQJNWbJZRrU
	 zCKJr/wHu/ZIh0JddDi1hZrPueTPb63lcQXlrMv80vQHKY2c2McvDc9uo9m1Rn2m+0Wt1
	 XprbXRgvmeLu0LGO/0EvD62CxH40WTBRC07GojVPvM1CAh0WXC40yMpC6MFhsHRwn8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YCbt0dze;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0360606A320;
	Wed, 18 Nov 2026 23:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YCbt0dze
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046D71F000C4;
	Wed, 18 Nov 2026 23:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044561;
	bh=837315ff1xFB3VbMK7DzpONsWLKbibNgMmRXMv5p/cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YCbt0dzetwt+FkOVjy19iVtvRLtUb6yesNCV6AQ0nIgOkVw9eOrhJA54Nf+cmrLZZ
	 spSBckxAvSnkIoUSAdHjMXd7fDYDHAqhb0SmniuPJcVtuCF3k5ezhJ2NNn95al0/rO
	 M8EFCLhYk3/BJBI2TpU5eNHJ9Bu+TY7gn4Flyb+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0609/2857] nfsd: Fix id-to-name cache entry leak in idtoname_parse()
Date: Wed, 18 Nov 2026 15:27:23 +0100
Message-ID: <20261118150223.418713057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 8ca3b74c0c447af17d0e27e76658a3d4cae3c5ba upstream.

idtoname_lookup() returns the id-to-name cache entry with a new
reference. The name is parsed between the lookup and the update call,
and when the parsed name is malformed (negative length or longer than
IDMAP_NAMESZ), idtoname_parse() jumps to the error label without
dropping the reference returned by idtoname_lookup(), leaking the cache
entry.

Release the reference with cache_put() before taking the error exit.

Fixes: f9ecc921b5b5 ("[PATCH] knfsd: Use new cache code for name/id lookup caches")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260917163154.2162438-1-vulab@iscas.ac.cn
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4idmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -252,8 +252,10 @@ idtoname_parse(struct cache_detail *cd,
 	/* Name */
 	error = -EINVAL;
 	len = qword_get(&buf, buf1, PAGE_SIZE);
-	if (len < 0 || len >= IDMAP_NAMESZ)
+	if (len < 0 || len >= IDMAP_NAMESZ) {
+		cache_put(&res->h, cd);
 		goto out;
+	}
 	if (len == 0)
 		set_bit(CACHE_NEGATIVE, &ent.h.flags);
 	else


