Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063727;
	b=Wd8Reimsk3wO9EGQnQc+FUCH3/xv/S3pllj+B6c3JgVlbGqLfoSIfkIAFY2lMaM9FgHH
	 5ufPJaL/XExYrRA7Z/N3ztmQt8W34wlEES8X1ESmEy/yzeoaP9YEPuSZWxoURR6FzXoUQ
	 RDWwKBcd1oNhSukUkrwK+JLx6SCgokELyzXS0vMUWLOIO5S8QfihEapD4QJAE9GF/mGJN
	 teQL72LX2fABDmDrNYQ03dLawJ0BSxgejeB5+zoxKoARd/a2tlLJNI8BrDV5IjCMnZSlz
	 f2+dOVmZ54EKcLhJIf+01WCzR6y1hd2t3w4RfPfdR63wMFHa+siKRjViATM2mU7EyuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BD2dN9TRHBjKCiWBzdNK17G2qyuituZBf/ldJGHhI/0=;
	b=r6sG/dTHJMqhwrJ+gcKUwR4s2ZjZVgOWBpiJbIplO5HpEuR6QJLZ/sIomu8FktYhf8KN
	 lfZ/6PTAhb7Ohk5fJ8DEuV7T1lE9C27ls6m06OsYGmd0j5FfPEDIvp99MvmwJeI9/QCZr
	 e9lCRFB5AMriyIfw63Aid5+0TTFX5j9KvuizV2pXgFRY1X+aDGP6Vz2eAjZ8uF4VQJpmK
	 U9tzvx4YgdxunktcBtpoJhtO95/5b2aV2pLmdRbMASoW6Oy/3EUXq/xX8883aiW7McJsX
	 Gcn+VfHYRKTtSrA7Z3ZjbPDLjO7RgOp0DLxYvsDjBUhmnOfX9NWpRPmvEVKQSrryduA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVzf18On;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52935606EEBD;
	Sat,  7 Nov 2026 15:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVzf18On
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A241F0089F;
	Sat,  7 Nov 2026 15:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063727;
	bh=BD2dN9TRHBjKCiWBzdNK17G2qyuituZBf/ldJGHhI/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVzf18OnGK86ZXhfTQYhVLggVCpYmq3/tjf/jQmHbj+n0WSg63pHU1wU7KpN6o+ox
	 DUwpmabFWAxRl4jKFGSYffzDQQ4yJF+MWjltKxTdDdlNHxjFrIku8EYfo75XjsftXa
	 2dLSlz2Hd6iaeeL+ZJQaLmUMzd1a2G32eTmtEw/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 825/869] ntfs3: fix mapping pairs bounds check for alignment
Date: Sat,  7 Nov 2026 08:58:27 -0500
Message-ID: <20261107134920.933281614@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index e2668c57066b4..4753fcab4d81c 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3436,7 +3436,8 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 
 		if (!check_if_attr(rec, lrh) || !attr->non_res ||
 		    aoff < le16_to_cpu(attr->nres.run_off) || aoff > asize ||
-		    (nsize > asize && nsize - asize > record_size - used)) {
+		    (nsize > asize &&
+		     ALIGN(nsize, 8) - asize > record_size - used)) {
 			goto dirty_vol;
 		}
 
-- 
2.53.0



