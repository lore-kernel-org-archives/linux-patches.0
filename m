Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047147;
	b=DG7nX7fc0B+/jUOBpnrsRJ7zHMmvfKuNPKU+P/a3PBRTAj+7WaRRr0yT7pQR7qiXgncB
	 5tWaCQKiLPIH4/9bbLbwGMcLjlchRlKmXzFR/ZLwLiQkqRzMF24+Cw2ODrvNTzC/S6jYa
	 u5046KmpMM2oVzigKSofFe0YTvlqs6HqDnYZnoIf9ODVAsKIPAMAtyvPCNgods1IJRkMG
	 gWuElCMNG3MBAAWEyJRJDuCUHZkSknnzkswgHIbXwtcnbmEfyVFYUWGr5pUREwsja7j49
	 0N2nh0uK+9Cl4hTi9bIMkTcf3k0u4MUf1LUY+GQ+WsawDnQBKPCo1WIYIcRuuXU1LzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SdqjwxZN7ztoLMEq2SgqZGzJiHg0eb66WL5EvFdEMGM=;
	b=WvE6UN1DAenlrCgFrQ5qZ12lQDXpZCYihcfBr1vszhgbEpxtxiIpDBl4BmXN6Tc+GKEB
	 GL1mu/sLKhs74ffAF+wFe6ODUJNWauRO/Yzz3tP/MBBr1euX/hvpO1PPBoYmxh20SXwEg
	 vxllCglKNztYjjNKyc9bw6l4ULqfqGa6/H6bqxY/4bbCL7SgiFvjVW1LClvqYUsILxjSw
	 BbDpnuR9+jHQ6BDGaDxB2IW+s8NamEQrxY35eIXyR44lAK7p9ZW3ARc3h9w1YwSicz2hn
	 NKzo7A9YmoAMoc0a341icMNGxEh9xGULRvSgJKhK7CfCMMSngS2jksVGBMi7h06R/vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bDuQbOxg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BE0606A325;
	Thu, 19 Nov 2026 00:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bDuQbOxg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225971F000C4;
	Thu, 19 Nov 2026 00:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047147;
	bh=SdqjwxZN7ztoLMEq2SgqZGzJiHg0eb66WL5EvFdEMGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bDuQbOxgdeGa1izJ5MkT2YuML0N6nFucDx6X53fRUWEiVKHlTUZteM0VIJrNwP87e
	 OM00uexc1Z8iY0GN3OLgAhbvSZKf9Ozs5q2uhKOu1stoF9IL8u/MWZUYlQjAPKBwb0
	 W0f7fGAyaiDkrCeci3L9zoHyts/kHPNLVNaiOgBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1535/2857] ceph: fix 32-bit overflow in readdir reply count check
Date: Wed, 18 Nov 2026 15:42:49 +0100
Message-ID: <20261118150256.593306797@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 52913831ba56efceaafd80b501d68fa00f79bde6 ]

parse_reply_info_readdir() checks how many entries are in a readdir
reply by computing the end pointer of the decoded array. That pointer
addition can wrap on 32-bit kernels and let an oversized count pass the
check. For example, a count of 0x40000000 with 156-byte entries wraps
to a zero offset, so the decoder can write past the preallocated buffer.

Check the count against the number of entries that fit in the allocation
before publishing dir_nr. Reject oversized replies through the existing
error path.

Cc: stable@vger.kernel.org
Fixes: 54008399dc0c ("ceph: preallocate buffer for readdir reply")
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[ sashal: adjusted context to retain pr_err(...) instead of pr_err_client(cl, ...) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f8b469c900dee..099b68d6d66d4 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -363,10 +363,8 @@ static int parse_reply_info_readdir(void **p, void *end,
 		goto done;
 
 	BUG_ON(!info->dir_entries);
-	if ((unsigned long)(info->dir_entries + num) >
-	    (unsigned long)info->dir_entries + info->dir_buf_size) {
+	if (num > info->dir_buf_size / sizeof(*info->dir_entries)) {
 		pr_err("dir contents are larger than expected\n");
-		WARN_ON(1);
 		goto bad;
 	}
 
-- 
2.53.0



