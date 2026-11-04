Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829472;
	b=0hIR7ugVke4hLAZBB1WN+oyrZsAdyc+NiP/iMJo5dAhs9CjxFnUPpwdy43agK5a3nl49
	 pPYSkrtzvyOfT8OzAMpdeXBcE/64lsRE+GJzoeYh++xCthEZbs3ulUhUKdSsFI2SqjqL+
	 GnILOWTXyPK5PEu5KqXJ1v3hPmEt0lfDuJhIMcW6zrPtcLb83OXq2cjX9wKU2E+dvyf1G
	 6oRiEh+XSjyCOoSLKzi6F8yz5+neWscpiH9OeTHJiVvJ0hN0N+nZBOXdS+jxB78fNuuSs
	 roW4f88xMA8PVoB5XaX7mBu3Hb2YDpEUJNCwwwhgYspUvXmQLsr0W7inKNKM+71weKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x5eRHDNhrYOF/67GU1JkkiAJVZU1d2rxAQ6F9QOewGc=;
	b=aKGvxQwK5VH5orCgIT35mAkdtNuzcsdk1wy5bHhwMzawbOsHFJqh/f1duatC9ncePQjL
	 IBx6Um06qr2XbmAagH1OwfhlQ9XG3r6MfDXTZGJmTRFsC6vcvzmiG5vXaCtatfIcTw7ia
	 rYSrO+zQnAKDFicRnS+Z6/NU9okCj4TweDEOvS/HMwEy0J6oja6e/JAj3n/1rPDuo9g0D
	 JKIAriMtdCp5kKhZ/XdvNd2cEzvaTiybvcrsB8Kd2UcOwVvDr737BLXLm84c5tll9eycF
	 m5m0va6/E4hST9ZGHDS0lbFu1Uey5FvdVjWZLsq65szMHJQoGWrNVHKksHGbLI+X2/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RhXPWLib;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE298606AB20;
	Wed,  4 Nov 2026 21:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RhXPWLib
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694901F000C1;
	Wed,  4 Nov 2026 21:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829471;
	bh=x5eRHDNhrYOF/67GU1JkkiAJVZU1d2rxAQ6F9QOewGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RhXPWLibcsZLOA0PQXFoidSSwBIu/W09mX03eMkZC9OUhn3I6RqHckZCeXMDiqlBw
	 OmOEfk8QDd13YWrjEhqDRzzha8U8rHP6i8ucB5Iw509nNBw8KrXVQCWeYY9FnVl8Fh
	 F++nD6QuySWt/QKE9UEuiVQVOLrfxmPJ+4yTiiDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hari Mishal <harimishal1@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0147/1005] nvme: clamp FDP nruhsd to allocated RUH status descriptor count
Date: Wed,  4 Nov 2026 15:58:00 -0500
Message-ID: <20261104211047.827689859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit 29261f8bb41662f2a660c479e5cf592942b53f78 ]

nvme_query_fdp_info() allocates the RUH status buffer for at most S8_MAX
- 1 descriptors, and then copies ruhs->ruhsd[] into head->plids[] using
the controller reported ruhs->nruhsd directly as the loop bound.
However, that count wasn't taken into account for the actual buffer's
size, so there was a chance for a controller reporting a larger nruhsd
to cause the copy to overflow the buffer.  Clamp nr_plids to the same
bound used for the allocation.

Assisted-by: gkh_clanker_t1000
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 5ed62e070f715..ad725e346c94e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2313,7 +2313,7 @@ static int nvme_query_fdp_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 		goto free;
 	}
 
-	head->nr_plids = le16_to_cpu(ruhs->nruhsd);
+	head->nr_plids = min(le16_to_cpu(ruhs->nruhsd), S8_MAX - 1);
 	if (!head->nr_plids)
 		goto free;
 
-- 
2.53.0



