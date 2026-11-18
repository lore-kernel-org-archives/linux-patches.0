Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059525;
	b=rcI1xJ2Bd3AtWZcAgMX4Z+1ot5B7xEexkrdufNmdkxx/j98hBpgUgLMSHbVLJQFueDRN
	 MvFZJR1c6pt98dya++mul77WLDJf4eO6WYRNwIJmPKqbfgxKARtyhv1/CUOLHiSVSZFnJ
	 wQMA1cw4wKT9Wa3R+Kjj5ZO3z89TVCqcK9mynt4tFdey+b4eR0kPOOV7Ku8CYLKzhdR2g
	 xPAly6xZH2WAYMio4hmAi86od3RhnvPNnW2ZlVBa5AIYVxGnCDYKAeahivQ9CWd77G/sC
	 M5r5BDssd1kgcXNGpfYFR4ue2jLTznWANmTRW1+sChbsPcATPA6x5ad9FM4v31XwKcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T9MU4Wo2za1djcjLKfRmF32UOpnG13FXgE806E+r1CU=;
	b=Akc0aeXdf19l4DoEjDzfX+6QBz8zwq3R2Vwx8yWdmuZvIe7WTBxfjX+MahJ4Xfzis9ob
	 4bIKUW9wMEY/lj97Xdgb/1V26XG11xVwZPBy/CHwFJo3F8dVLijnamjbLI106jXbNG+ok
	 KUCkaR/RZBV99kSPYao1YK/X41CaCeL5Iek5W0cbk3tTnaINHv+H0ILIctW3Ltc+VdxYb
	 +bG489Npx+shyeB+2kM836PbIJBTxhxeqPtvHTVtGkLe/zcUXkvSQDAqX/IuFM4SzlZAk
	 YBJzCJbBA/GOibWdHIZ71tfvOgsu/BYkqgUu3eJ0eFKm2PDvYvE46rD8Pu4xo80ACEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C5byeB1j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A4D606A330;
	Thu, 19 Nov 2026 03:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C5byeB1j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC971F000C5;
	Thu, 19 Nov 2026 03:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059525;
	bh=T9MU4Wo2za1djcjLKfRmF32UOpnG13FXgE806E+r1CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C5byeB1jhD+BdtY9kGRqYX0o6x5MLbEWvihDaHt4EnxLcaI+1EVAJywpYeMfdCIZw
	 NwRAEDU8m70PQEY7fe/VriuMpYk/bzFi/R92NDOcjGS1nl9ii5wrAF3mw4shOcrPNv
	 luQV9v8C0jA++y1baVk1Fkpdxt0bieHTjAdR01sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0872/1848] dm-writecache: report I/O error if flush failed
Date: Wed, 18 Nov 2026 15:48:30 +0100
Message-ID: <20261118145952.942626991@linuxfoundation.org>
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

[ Upstream commit 78a6afc2999d26e5a30a56db77db34c22b88f5d5 ]

There was a bug that if writecache_flush fails due to I/O error, the
error is not reported in the FUA bio. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: opencode:big-pickle
Cc: stable@vger.kernel.org
Fixes: 48debafe4f2f ("dm: add writecache target")
[ sashal: adapted the change to writecache_map() because writecache_map_write() has not been split out ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 1b7d89794c6a3..f8b671299c854 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1454,10 +1454,13 @@ static int writecache_map(struct dm_target *ti, struct bio *bio)
 		} while (bio->bi_iter.bi_size);
 
 		if (unlikely(bio->bi_opf & REQ_FUA ||
-			     wc->uncommitted_blocks >= wc->autocommit_blocks))
+			     wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 			writecache_flush(wc);
-		else
+			if (writecache_has_error(wc))
+				bio->bi_status = BLK_STS_IOERR;
+		} else {
 			writecache_schedule_autocommit(wc);
+		}
 		goto unlock_submit;
 	}
 
-- 
2.53.0



