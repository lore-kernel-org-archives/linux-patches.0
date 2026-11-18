Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045984;
	b=Q3s/GhgPk6jPRT1kyyhZ3wpwf8NcgV4dxxwVPrmTCO3K/HZGcl3dx1IrJUeSaAduC0VU
	 Wf7BbZqOhull0jDJsTmL5++lOhkIsbfHh6V5sNjYjCTkMzdHtpdp1cUEfeMVjXh2jX2qs
	 cWJ4ecn/cmQmDQj4fGLAfqYe8dHvWtBc0ePn0t5shoS5w4xvavYX0TMHAATo9reEPCl9t
	 ZPVxRpzSD3cG4tb4NT5v1npP5qrZiO6SMqml+p0WQHtjKGB3x96TjKLKro4NRinnwsyJV
	 SyDEKGF5S9DYzVBDHCPXzQI2iczlpmFeGb78dX5lwQIyQ+ZxabkTFAnvAOGIFfuG6Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f3L2b4V0PQiZ5qZm1bviA8f/zql2qYxioSu9I/v0/YA=;
	b=feqhSh3vK8vhQp1VK4ErmGc6b3hVV2oB1PJ7lFtqwkElRmck9dzj/boEaj9ZzzEEvR9O
	 wPPwz/G8ROGtPlAbw5XmWaU/8W5Jo9EkGgpqdLDJlVBCaqnwpmpXrr9oPEINM7Gt8Nd9w
	 j02kAATz1BGNhZNcxrHaoyuXF/GZvuWiH6kSlGtW6nkpTAiYVp6foFFEtLJ2CMOZkuKED
	 muszz3nUunGdElmGaQ460wZO2PlbBXy4A6yRuFwdka+HndcEcDBcNDMiwbQ9R171G7vHv
	 QbjgjbQWDeSWuqjt7AWWj9xN8pEVTyuysI1ynY8DdpbvUGBKQu+atDZue15egU6fWlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C3bIqPIz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C376606A320;
	Wed, 18 Nov 2026 23:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C3bIqPIz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A203C1F000C7;
	Wed, 18 Nov 2026 23:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045984;
	bh=f3L2b4V0PQiZ5qZm1bviA8f/zql2qYxioSu9I/v0/YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C3bIqPIzy43XQ2UmEqxy9QG41azBS92PftdcD0HXYsJVOm5uEY9vqOxUifgZIa3mR
	 Q5HhD6Kh0hghxtrNqUZ2bkk9nqauOSdH2tscnbOSa/CJQo4JcUuObIa9KhJMtAb6d5
	 VuSlkz7mJegkWpuyXlRD++nII6Gzv9uaFeVfo+sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1078/2857] ntfs3: fix mapping pairs bounds check for alignment
Date: Wed, 18 Nov 2026 15:35:12 +0100
Message-ID: <20261118150240.423905293@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit f517cae6333121783043d9ba5142b50f5d1cf75b ]

In the UpdateMappingPairs action, the expansion check compares the
unaligned new attribute size with the available record space. The new
size is aligned to an 8-byte boundary before the mapping pairs are
updated, so the check can underestimate the required space by up to
seven bytes.

Use the aligned size in the expansion check to ensure that the
subsequent update cannot exceed the available record space.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 5ded4b1275a84..3575417b69999 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3441,7 +3441,8 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 
 		if (!check_if_attr(rec, lrh) || !attr->non_res ||
 		    aoff < le16_to_cpu(attr->nres.run_off) || aoff > asize ||
-		    (nsize > asize && nsize - asize > record_size - used)) {
+		    (nsize > asize &&
+		     ALIGN(nsize, 8) - asize > record_size - used)) {
 			goto dirty_vol;
 		}
 
-- 
2.53.0



