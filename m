Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058487;
	b=OByD6HQB+wSXxrjuOabKhht4905L5FSyrZGBd3mZglfTxS8B3dBi+yGSrJkUvY569nR1
	 r0+2gGW2Iea00iuSNoNui1BJ1k+JEsWPO/PFDQYPg3/GgsTIUgFrclKEZjwjcmTz7e816
	 axqjTEoH6Cztgs6ks+ZLZaS1wiqn2Zm/Q1yIlKkURb+jhaTkm6XHIpvF2i5UbQaP72N5U
	 NdsAZ/+Kj0mxifCDF5S5eMu23I8fR0DDBLj0e8dT0zWYXXfthc6DRnef4sdYrEL3MwJ0M
	 OL8ghDs9xxBGMW5q72jHNHqLr8MghS7siJ1BGhOYH5gG11OElwxvQj8OP2BTPBJ15wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lvkh+Lp4ETMtBY2wvmslUq8G2x5Px3cvhFt4wqHmktY=;
	b=3FDL06wBbLcOt+gZfEgcebzduN30CA0xUpTX+7SsAt27eh4TRKTRKTq6/M8/QtI682oF
	 CInx5NQ9gf94Q1fyvQWEXwunLbZAJBEkvZJjki+yroifOEUKkqoiwGHv/D3SmiAxKavYt
	 UcMv14TGiFgz/wGkC221zLvJH9DrasxiQCZDQ2h+wFvGRNi7/MZLvHMTr/RKQIUiuqbFY
	 A8k6TP4ry0cG/SfnYKT24XksR7FqwK0SugvcdXdF5kuoDg2+mmZwJVmb4JSAz4oetDZ4D
	 E53dhYUrjOlkpxWHBkkPKmj/bTMzmxP0Y+7rXbPC2KY/TYwMYbrNgWF1jRSUsPUf+yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RG9TJKSp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC869606A32F;
	Thu, 19 Nov 2026 03:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RG9TJKSp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D64F1F000C4;
	Thu, 19 Nov 2026 03:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058487;
	bh=Lvkh+Lp4ETMtBY2wvmslUq8G2x5Px3cvhFt4wqHmktY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RG9TJKSpnP0ZPZ1FEhj41Lm+Pk6fA593DhuuRZO0moyVbXhAY37o8M2aQhevAF5S9
	 cx3cC1tm5qKXi0by4YcYenjrktbu369RZtGQmBxJnuf7GUXbRLYdLHpIPev8VZZl97
	 eq+F8zrjKraJRpjHFg4gZDe/CQPtfAsg58Gqp4rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0504/1848] dm-snapshot: fix crash if dm_io_client_create fails
Date: Wed, 18 Nov 2026 15:42:22 +0100
Message-ID: <20261118145935.902530945@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 829c4d21148a205eca864429e06530319e1f92d5 ]

If dm_io_client_create() fails, it stores error into the ps->io_client
variable. The code would try to free it later with
dm_io_client_destroy(ps->io_client), causing an invalid pointer
dereference. Fix this by setting ps->io_client = NULL.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap-persistent.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 8e329c3f3a78e..5b693bf71a379 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -322,8 +322,11 @@ static int read_header(struct pstore *ps, int *new_snapshot)
 	}
 
 	ps->io_client = dm_io_client_create();
-	if (IS_ERR(ps->io_client))
-		return PTR_ERR(ps->io_client);
+	if (IS_ERR(ps->io_client)) {
+		r = PTR_ERR(ps->io_client);
+		ps->io_client = NULL;
+		return r;
+	}
 
 	r = alloc_area(ps);
 	if (r)
-- 
2.53.0



