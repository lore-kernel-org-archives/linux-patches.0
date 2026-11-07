Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060581;
	b=xr/I0q/kiUDM5LkcVG2D+8WqEFR1sJLojw7YmDtMle0aw7Puzj4u840F7khtD/2+nd7/
	 BsDo0Jxmxwa7mOi9gqIrH9xKc4O7A45ayqcXPgyv5p/Aq6NcPRQgTwckJlqC7gdNN7U3d
	 wqd43knAuZk07KJ6hJHVyJgOONdYtKxl6XGZrPzSJPWKmwAhxZGpYCrCTf9A2tMHxsFBk
	 EpfiLL9MHZ0AkHxoy8/4QtGiOUot+YlQInx9eqbFum4Sv2O+T9eHNn84QMcUki0b4t/iq
	 uI9kT+6aBEXcok9UH/txydSskaL5XzLst87F6VzE+3WhM0aT6aeWQ0bwWNoIBOIxvJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TvzPCfhOEbFtOSBxpPtluf/t/VAZMleIiAiej+Omtfc=;
	b=kurCycyHls58GG9IQwsOpF8WUiL/uCl7GA7++HwGWcS1gg0WDr6jPhR17ustCyPB+BPt
	 R4yxYnxoPMqDuX5wibnuAndOZaBsH0/D90+IvTYRUcAemsuuHGJOqY9FZ5/xtrzCyG2uQ
	 TdGj8QIUR9vIqvoVVEGesu0rM6TaoxNJwGm9cmNfIV8Aq2ZfdwLKQ0X5R3xD19IKb67QJ
	 tirPN9n+0/+jD6Re6/zHJc8HjrF8OinF7/IQMx63PstUbjVfgre7HKsJceITmQtwB7acr
	 iKqakoWFdPZ2eqGxedRVgXSbuV2+4ln7Fqx3tJB6TMzNQU/pH/56UIUIYFN91doddWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y7nzILhU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31071606A32C;
	Sat,  7 Nov 2026 14:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y7nzILhU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31E91F0089F;
	Sat,  7 Nov 2026 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060581;
	bh=TvzPCfhOEbFtOSBxpPtluf/t/VAZMleIiAiej+Omtfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y7nzILhU8vcfTxu0CSdviHzYqfNm6oWSCxR97RsrAY84FEiSlJSymQtcxO+YsLk9H
	 EEfdekR+/2Fg7hH5/csKioFKIeKWWgvsJHmbQvMgUilhhPt4HMr0+AmtHB1QjF1F08
	 TZddZwSk//FRDgQdfwNFxPtYSgiQHIiI/Hi6rJmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0012/1536] mm/damon/sysfs: put target pids for damon_start() failure
Date: Sat,  7 Nov 2026 08:33:48 -0500
Message-ID: <20261107134958.021173130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

damon_sysfs_turn_damon_on() allocates and sets up damon_ctx to start.
If it is for virtual address space monitoring, the setup increases the
reference counts of the target pids.  After the setup, the function
invokes damon_start().  If damon_start() fails, it deallocates the
damon_ctx object without decreasing the reference counts of target pids.
As a result, pids can be leaked.

Fix the leak by putting pids using damon_sysfs_destroy_targets() before
deallocating the damon_ctx object.

Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index ad9fa8a86c9ef..b3ce45d66ac65 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1538,6 +1538,7 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	}
 	err = damon_start(&ctx, 1, false);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return err;
 	}
-- 
2.53.0



