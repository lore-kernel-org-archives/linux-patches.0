Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063346;
	b=tM9vyAzJgJOkz1t2OQKQDkXGb41I7bavQxiTnEFqQK+6cnFrqWq+PHssCTttpamH1Tq5
	 wUCgVk1JrKo+Jdnef2MvzDO6D1Wb4HKCnA9bCrxTFY14qC2bH8RUzVDiUVnIiGAA+gcX2
	 B4Mmfvk4DLFoWLXOtLF5+FGvi+4wcBqN35G6V+HFjlsHVLjnJ/KEPV/5gTJYIftf3liV2
	 UpDodNs9CdjK1Z9a1Ydr0sHoQ2CNvnFziFhQGLeN/co0dcS0olLBKTyP7Rk1C0UY4FAom
	 r32uJLUgX7wf8uoqcTGuTbDt/Cpk3bM7qNFesDGXQOTyvepiMK7w7SHf2u2kodngY6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FQGG67nVSCEmRLMpvuwQujzf2FEzjjJ3tu/mnXQB1DI=;
	b=x8LyRTPhDijhbLVn1dR/RagguahEB2QLlwjJ/Usqo/XpPeNaNA8tyzPs0fgnDUtzhQHs
	 t1qxqiPpubTTLGY74Ld4yDTKDzLFgQ12XN9DCmMZf+odAqfE+rDKl6+xF4iiHz2QCZIB1
	 3b4P0BY2hr4Yh69Fnet0GWneruXqwOoB+aP3AafvKPjk7dz+3htbcB6tVibXLcX2hmSFD
	 7+fnGaduSuRfReS5cTPI4YvHOiGKLixEsdayeMQZjVmTPamPsJc3wg+hlsksFAsuEk/Lq
	 pWuST1ToRDDs8n3UyC9Qn132jK3ZhOkPNxPbF6YHcE+UNZG41FzSIs39cfr4BbPgJkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vu1hV8zc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40878606EE9E;
	Sat,  7 Nov 2026 14:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vu1hV8zc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E181D1F0089F;
	Sat,  7 Nov 2026 14:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063346;
	bh=FQGG67nVSCEmRLMpvuwQujzf2FEzjjJ3tu/mnXQB1DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vu1hV8zcQ7att2ja3Oo+39ZNyvpvhjeWo3C8/HqCXghwvgH48E8pmdOirw2TBNkEi
	 9L+YS42Um5jL/iKTuK/Omm0QowM7egcBpLdQBvWfLwUTZEeL18iI/wBYjG5LfnoJff
	 PfR6ujHt9HmH3wUKsQsg22Lkrii4nI0SHGsdTieo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Joanne Chang <joannechien@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 528/869] f2fs: allow pinning empty compressed files
Date: Sat,  7 Nov 2026 08:53:30 -0500
Message-ID: <20261107134911.385070524@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Chang <joannechien@google.com>

[ Upstream commit 2eebc31ae5f53e1066bb6238c8087c23b688ad17 ]

Commit a64a3fec11e7 ("f2fs: force out-place update for all writes on
compressed file") updated f2fs_should_update_outplace() to always
return true for compressed files. However, this function is also
called during f2fs_ioc_set_pin_file() validation, so pinning an
empty file with compression enabled now fails with -EINVAL before the
compression flag can be stripped.

Fix this by guarding the f2fs_compressed_file(inode) check with fio in
f2fs_should_update_outplace(). This preserves forced OPU for actual
compressed writes (fio != NULL), while allowing f2fs_ioc_set_pin_file()
(fio == NULL) to proceed to f2fs_disable_compressed_file(inode).

Cc: stable@kernel.org
Fixes: a64a3fec11e7 ("f2fs: force out-place update for all writes on compressed file")
Assisted-by: LLM
Signed-off-by: Joanne Chang <joannechien@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 52bdfb2785f06..eba1e025b9d6e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2679,7 +2679,7 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 	 * If IO comes from compressed write path and fallback to raw write,
 	 * force out‑place to prevent metadata‑data inconsistency.
 	 */
-	if (f2fs_compressed_file(inode))
+	if (fio && f2fs_compressed_file(inode))
 		return true;
 
 	/* swap file is migrating in aligned write mode */
-- 
2.53.0



