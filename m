Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065471;
	b=MtEQuE25KmW00mUwLymcO3V2NG5Ho08q8dKj4j7MbKKGy81X4p3mBF+qx+kr1Ci/3hAq
	 ETDQLiYjNffYUkUs+hJO36IyOafXaLdSn4GacMtgEjsq1XJzUXtsLUj2pWlScDuWoV4j1
	 vc/B8q3gL4d4HK08nzH/ifZhP/R/hRLVqHbAt65A62FWU9dk/EkP3xUqzo9kqwfemRVYZ
	 FTlq+GnYtUSE9Q0AreRWA69zpnV/95N7PNZeXtkwBFpTP06oh5r6lISIn+cuinUi5lQnw
	 5d1K+hC/L7JsB3l7/xRSGglEj8BanYkbnk5Jw6278itXpQb/cGexoMmCrfyvsiS97ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a8FM9OrHxGyPW50BoxIFsA5IEdEjOYTrgRsSaoheop4=;
	b=m6H/HKnzBU8ARpoNmlIIdjCzgw+DuYLXBGlMCS2Q2dVQ0K2YOGCishPfye/sILTovc8c
	 broUywk41EK5wAjNf5slhGPHDeK6i0NehnvbjpOLCHcSXMjNpEH1nHg6DTjKu+4IODF+w
	 ndmwwk3BCdHP0XgEGSPwPNRFU7R0ubO33EQLC0VuxPNu3Gy24NmUncmMbzk4ch3GgrW8V
	 r+1RYD/IhnbtGjTMVtz23DVxeh+Vkb/yyO//KSsl4Dte9aTrqSjnJUrH3C7RYm7g/mE6t
	 s6WHM+IDw4LkxYosXLhQPxKpnARzfXcVDln1mrZzuVlXeshkQVG5Mf1PRNsGTXUxi7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eiSRyNvb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D360E606A330;
	Sat,  7 Nov 2026 15:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eiSRyNvb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886791F0089F;
	Sat,  7 Nov 2026 15:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065470;
	bh=a8FM9OrHxGyPW50BoxIFsA5IEdEjOYTrgRsSaoheop4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eiSRyNvb/c9kVT33H5/zO+F40xiqTxoWxJSLGbM2ySARj8SNeNMKUxhqaLmO32kHw
	 xGekIps3Qu56VUlOPROc45PYaSc3HT4mq5CeV96d+/SiS3gnQaOIY6qqY+B2qGBDFd
	 nDKLm9icuVCQ+co2Cp1ohA6wdXJstnt//Oc/Bjc8=
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
Subject: [PATCH 7.3 1129/1257] libceph: initialize CRUSH choose argument weights
Date: Sat,  7 Nov 2026 08:57:05 -0500
Message-ID: <20261107135010.416183488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osdmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 7d65a81148166..e69a2249ddfbf 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -319,7 +319,7 @@ static int decode_choose_arg(void **p, void *end, struct crush_choose_arg *arg)
 	if (arg->weight_set_size) {
 		u32 i;
 
-		arg->weight_set = kmalloc_objs(*arg->weight_set,
+		arg->weight_set = kzalloc_objs(*arg->weight_set,
 					       arg->weight_set_size, GFP_NOIO);
 		if (!arg->weight_set)
 			return -ENOMEM;
-- 
2.53.0



