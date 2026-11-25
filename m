Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617596;
	b=altQ6kfEM0PFOiC7/vndpgf7mKXbsl3eqMElcVm7122kpcABoNRX5EJwmI8yIOTh8HNx
	 eR85UGWbaHxrg2xaXcd/06V8poWjr5i0YXdDllbi/ToBeC/9MxWdNaL7z7kT3G/nF13KC
	 VqqXabhKoLRiwEFS8aOCpc32Bwt9dL+MqXGc8J5DP6lnbriNmL3Erg+ftXK1Nu9iCRNqS
	 w4XLmwHx8bK1s74/c5BvNN7RKT2xdrDwwEI2YO2PuII6czA4N2XwK9drn3ba/lHj+lXpR
	 ipcdpBHsgEcJrj6X9X+Tp5Ck2Mh1pabaF6U9CshsQxTjK7PfNEHlU+KRWbRZmGybroQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=khwp+rgZdLnr0PbalgjpWBidOfDlSU5uuuMRone0wjw=;
	b=BIrGW7BM6cRNB+rKlmdH/bMbXSaCPrQC4bLHv+NXk1Jfg3mjDrGmJjwzDrE+MkxTJaU+
	 NvLpDBiS7Z/nUyxRfd5VOrbXBdXGH+aqnAnK8N9K9jXxzYwrOwyUfAwYkg7DtkLhKwyKw
	 /G/UABk9itiqJd2kPf3a2D8AthPgERrOEBI3FsXHBnhUR0QIFDGDDvFNPnwRoS2q/jd2G
	 PKL4gmqj69GHJOIBXrN+OownIDKoLnfUU4ruKXovU9tSyEUsJzR5ekFyN3IANZoN6133c
	 zbSXpAklA9vp0ApQX5dBerw0YKgWl3H4fFk0Nit4xIjN+SyNRFV4Z5RyH6fsK04xuvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CD4FOnri;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C4D606A321;
	Wed, 25 Nov 2026 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CD4FOnri
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83401F000C6;
	Wed, 25 Nov 2026 14:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617595;
	bh=khwp+rgZdLnr0PbalgjpWBidOfDlSU5uuuMRone0wjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CD4FOnri8yFQZh2ZAXhPiNr04NMBFEQC0sQn+VEHOQY1Tu3uPbdor/BLCscPcHIqU
	 C64r8WIco9q4XODN7ywJC4sntOzBMQzNtZg6ckkgqTTdc+YreI/zTHqgfojYBoVfqo
	 itWKQLHwW608fm+yZ+v4ge9rIVeGPSQvAZMeohbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0016/1005] io_uring/futex: fail soft links when cancelling a wait
Date: Wed, 25 Nov 2026 15:22:34 +0100
Message-ID: <20261125143822.117359747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

Commit 9a7cbe50dd95594d6fb3c57b8454ace58d8d8d0a upstream.

__io_futex_cancel() completes the request with -ECANCELED but does
not call req_set_fail(). IOSQE_IO_LINK dependents then still run.

Fixes: 194bb58c6090 ("io_uring: add support for futex wake and wait")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20261114072246.741950-2-yangxiuwei@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/futex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 9203998654ffb..8a85ae20964b3 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -107,6 +107,7 @@ static bool __io_futex_cancel(struct io_kiocb *req)
 	}
 
 	hlist_del_init(&req->hash_node);
+	req_set_fail(req);
 	io_req_set_res(req, -ECANCELED, 0);
 	io_req_task_work_add(req);
 	return true;
-- 
2.53.0



