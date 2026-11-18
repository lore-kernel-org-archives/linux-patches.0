Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047411;
	b=X1jkNCxfCMphXsX/a5/ny0ctssDdwe+k412LvJJCGzTzUTf8YHQqUh/IIEQLGmqvcgOC
	 2CZ/Bje2mn3/7nJIUMNFRff1F9tEHFLQMZbi+tvae8vObhbD1+I1qF7I2Zhg8bt0itS2E
	 t0A5YRgvDZNJLtI/SHMotfM5eQ7ylXxhqRtPt/H+aJVOZ7yYGoEbMzeCx31Fp/pfmKI+S
	 /pTnZr+H+la5tGesDe0OFHoBvWjg+1y/veh9ldpJSH8KeHSJxcNOHkSi/TTu/2Bx0j0o0
	 ZPtkpAVonOtnDUVK++JKTlkq6H22bvCDjRIy2U7BAWkOIv31MmADaaYM2E0HopTeGMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iBxVFSPiYLZOI+v4bc9fu/emohioYW9kNjq8iTq8KKU=;
	b=KVDFHNgixaV/1zJkaA6yuG/nucJ7t5toDJ+AVG31H/SQi0Okf9gHUoF5SMtFrspxc/UE
	 /L/T2FUoaa8bh56GKd8rZc3JgxU3VLn4GLhbE+765MXlfcEGpD+/LpdVZ2RfZSUdAqCHy
	 svArtYAcy59wzlAfY3jGvqkgbiptXVcvll1MIi/yg8mD8TIHlOIZngarVsRvAIa3cuQQR
	 hhVr5l46VjUPNpBSTrB1iUNi19IKIqaxpJe+FKl00JfWWyyVPwNoAHr1P1ZSFK0lJCPqs
	 LXn89YLQIgAhcsNU5g59ccAwGuwwQPThqYlNj0i/sdPwNBwk5REbrlPYPlnBAho0sFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=agVegkvi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220A4606A31C;
	Thu, 19 Nov 2026 00:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=agVegkvi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBD91F000C4;
	Thu, 19 Nov 2026 00:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047411;
	bh=iBxVFSPiYLZOI+v4bc9fu/emohioYW9kNjq8iTq8KKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=agVegkviZ7ZX1ZwSXyfsnqwMzhsRlLvJdQr5eHOiwoXaTY5xt6zCKIaeV6TIMbTad
	 VDF1VscLIOJ1lYzEYjMhTTOdqHRqg+Ru+mjcTqg4s80PX/d2XyV2oITYBfqY6m2w6z
	 E6zPk5KSYdKwuho1lLvE5/+E7LXI2b0pMBpq2mG0=
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
Subject: [PATCH 6.1 1628/2857] libceph: initialize CRUSH choose argument weights
Date: Wed, 18 Nov 2026 15:44:22 +0100
Message-ID: <20261118150259.961894531@linuxfoundation.org>
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
index 803514a1bc7ce..fdb8c398f5ecd 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -320,7 +320,7 @@ static int decode_choose_arg(void **p, void *end, struct crush_choose_arg *arg)
 	if (arg->weight_set_size) {
 		u32 i;
 
-		arg->weight_set = kmalloc_array(arg->weight_set_size,
+		arg->weight_set = kcalloc(arg->weight_set_size,
 						sizeof(*arg->weight_set),
 						GFP_NOIO);
 		if (!arg->weight_set)
-- 
2.53.0



