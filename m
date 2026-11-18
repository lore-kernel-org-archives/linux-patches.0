Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022489;
	b=4qaElbjg5UTjEfXCveMblFE01PfSSEqrLJRIftLuW6ENArbAnV/9N8KwGtwTEl7ek34J
	 C1YtXNcXdgWAMu7v3SnZ4wcHyNQZOmN4fsQTf+1UwEyvR8vr4WHZIt1KR3i6oh0QDnPnv
	 Vxnq/+gcONMDG9Ts1ruhId0Z6fIZWVtrgd6VPRvXjA+qkUf0ozXLEvo8TzzYSfVBGOn3C
	 97zB+iaK2r4d5xVXl+T632IQqOm0qYu90qc8d/2WTUdeG5gwfF7Ud62UPI4ikYJUAidCj
	 5NG2UW36k0UxmCjNDgYWmNZfRiGYOp6/8PzxDKmRZExIcyG8ZC99pwEWPrxa9hYepzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yI3nCMsa5ETZYsVfcfvTZrnjZImnMGWhRCXvQ/13byA=;
	b=Gtmxl42czlIVyI/g7uCDZk0l51d5ziSK8zLLpLG0nYH46nRYiyG9R10Jzuh5CgyqbA2l
	 RqfgPfhDtE5J95grg8pfomGzwcU1MsWM7eYmvK4toDAlY2HXGjwGbfPMKoQAGeWZUR2ZC
	 AtCnJgDI5FhtonwbIy5Y3BxSL0T7cFvurRo5lidd2MfrRh/SzmcJbq2Skk2413O3J00t+
	 tfUPWUk+4PG6W5JSYNsHjhKKmkkeIaM01/fJVKSqHTxOFiLiaa7IsfZm4zzCeKV8eR54Y
	 aKShkcEMgLLN+fVR1QRgxwD78IuBsD4T59nclBDmjth45NpgySGwQ5ZcFiPWBbhsjKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bc6pvDu5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782A8606A32A;
	Wed, 18 Nov 2026 17:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bc6pvDu5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24591F000C8;
	Wed, 18 Nov 2026 17:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022489;
	bh=yI3nCMsa5ETZYsVfcfvTZrnjZImnMGWhRCXvQ/13byA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bc6pvDu5X6V1n0uA06Y7Mm1T4qSFeqV7Q9qfY0vG4yxoTTJWg4H6r1jEgipa0ATUw
	 UDDnaBbuToEx9G/fa0/EsV7xUTNw7nqYyVO5XlGJ0Troo4XAxHvY4GaUtGNNXN58kK
	 ZDSEU5viE7s86f3NslyNVs+PGjZwwQDt3vqHEl7w=
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
Subject: [PATCH 6.18 0031/2151] libceph: initialize CRUSH choose argument weights
Date: Wed, 18 Nov 2026 15:29:26 +0100
Message-ID: <20261118150122.790231665@linuxfoundation.org>
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
[ sashal: Used kcalloc() instead of kzalloc_objs() to match the existing kmalloc_array() call. ]
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



