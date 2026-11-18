Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059991;
	b=rqK9CT5YR2q7ZlXCOejUlKi/feHy6a6H2ATA/m+i+7TX0Deig/pDqI2XA3IK8w4mTQFz
	 A2/G9MTwSu2RgE8K0pfGrKtAlcyOyvnBxdoLXvBiVtaq2EQUTKJ3JwRxXuvbXKL1HwHP3
	 OHwamthe/MKra5Safh+R1h2n2GRBuIodLGo6XgAn3XNuQV8fhsynpEMz1ciiTiFVYkyoO
	 w7fvAUmvSTnXd7tK6deSHec8bf+7S1RxBI8VozL6z9p/wtpLRKI5pu3riunt8EiYNKdTn
	 unGOIZLIJ4MeqPoH0k1AhmJY1fxJp2q5A3Ru2X9MPrncewFXcdXwuqTrXV5QD16YDug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NSXbIOkxt2EpYqrYVaH4gZRu3BrCMtos5TEdo86l1QU=;
	b=pX6kW6O1hWMHIAw4sC9OlXk6nrSSONnMr9hAMUH+dkv57str8DCw8Jf5LnxiqrLLwML7
	 Y2N/Judd6RFpXchM4ZsLPGj32ewAyA6HsorcFB5eS8v2+dP0pWSuGE892NUq7Tuh1toE1
	 SA+Q42YoFAQ96b6lqyNUO6U/QmerT1ecLccm8l4ciI7g3wmal27DyAZSuo//j2yQNfpx5
	 6ZJBPSLE5kQZ5DTesXZI99Z6xjjb62sRGho/8bEPuE3qbFlApXF9i68tcSEFf+gqZydGt
	 xGjAH7TMqfA7mR5acV0leyX9cS9pzEKJxpsJWr/1d518rlYs0KcmKm7k1nYAJAXHUJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKiWhcaj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5547D606A325;
	Thu, 19 Nov 2026 03:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKiWhcaj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C2F1F000C4;
	Thu, 19 Nov 2026 03:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059991;
	bh=NSXbIOkxt2EpYqrYVaH4gZRu3BrCMtos5TEdo86l1QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKiWhcajwM6JFYeZh41nsLRU0aW6o7Q0ttMZe6L+99o+R4360he6jyZEhrDMMHgNI
	 QqllIuueyH7fo3SXpJ+D+VL4mflKyIL7lOEyPf7FTIwuMauFBPRbPdulRi5G/E4VTD
	 nJctjBkr5utMWegecnUYPA5qNG4QcGqSgXTtnUow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Darong Lu <zzyy19904204639@163.com>,
	Ren Wei <weir@nebusec.ai>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1039/1848] libceph: initialize CRUSH choose argument weights
Date: Wed, 18 Nov 2026 15:51:17 +0100
Message-ID: <20261118150000.845597159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darong Lu <zzyy19904204639@163.com>

[ Upstream commit c3a995ff0782587789333c621e1f6bd5e574371e ]

Initialize the CRUSH choose argument weight-set array before decoding so
entries start in a defined state while the decoder fills them.

Cc: stable@vger.kernel.org
Fixes: 5cf9c4a9959b ("libceph, crush: per-pool crush_choose_arg_map for crush_do_rule()")
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Darong Lu <zzyy19904204639@163.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[ sashal: used kcalloc() with an explicit element size instead of kzalloc_objs() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osdmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 2a3ab4ef39c28..d180863865166 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -304,7 +304,7 @@ static int decode_choose_arg(void **p, void *end, struct crush_choose_arg *arg)
 	if (arg->weight_set_size) {
 		u32 i;
 
-		arg->weight_set = kmalloc_array(arg->weight_set_size,
+		arg->weight_set = kcalloc(arg->weight_set_size,
 						sizeof(*arg->weight_set),
 						GFP_NOIO);
 		if (!arg->weight_set)
-- 
2.53.0



