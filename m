Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062347;
	b=awufGVD7Xem4uqro5LrLGMinq93U2iL2lm9sSD+xKtlDjs8Qw1nzyDT+n4K4RhFuzwiQ
	 IfPIlPfTkOx00ydNOaaR140b2HVsGDqZrVLE8B+5MmZRoN6Kb06EBQ56Gw6tLbxPk9Fok
	 8VJDnmQBg+ADozHKc7cktkkQFNffT65Y1WTSHImOj3m1hnvl1d7DrNFPU9Fg56Hc909Qh
	 YrRsvQds51jLYcxSzIUib0RLt0Uknk+5OJwatbElVSR2i7/RC2Hk8NLWDLGvRvmk5WDYG
	 zlJSD6x6XR7mYNP63XfhgwMwySYdQIqwwcEOJkU6y04ebLuEmyZIXHszyTg1Mslj3WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1F0mFfHzZrX0OYat0sRc1b+VeUjVqga7r34IwtCsTBo=;
	b=FBdMbKf9wwPKCRq2gZ0FW1RBAQDI+oI1XU1lCcoYjq9zgepwBH2onWjloXIzq/eoXd4i
	 3qnkaiDqKQItvalrDOZJCnM9gtKFtxWRqM0zFWUXhDd02+Gqjr6NCC8iwgm6+8bdkOKKH
	 AgM04+Zq2SxEHsw7dF8ujZsRsfADkbGOPk7zULtDB7GYpw20nt7SpIbeV8qpUAvZwAuEN
	 VSZ0unxnVRl1/TpDBm4MU4Yc3H/gMLZk2O53y5PAEubVVL1DGb5abxL7DPWm7f50k/+kO
	 GnGBDHbV5dYGdUYxPH5iQe0TrQdMsWuFOEnOt9MvVLNkGju8LSJpdEWHUbgmqk4Oe8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tK8LvAFY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B84606D826;
	Sat,  7 Nov 2026 14:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tK8LvAFY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB421F0089F;
	Sat,  7 Nov 2026 14:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062347;
	bh=1F0mFfHzZrX0OYat0sRc1b+VeUjVqga7r34IwtCsTBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tK8LvAFYgySeRMvmp1Q3Wi2gt8TzGzFuq/2hIEBhMHjjDf3+rLdtZg6cO/hwr+CNT
	 mboktmBo8ct43bapkadKRExNcZl3ffVyElm6zSGlVL6UlvlboCFC6gyZz8yeq6J4/+
	 JumeBrBTR1QU5KYW21PlpLfRLUnTGOK3kQpQf2rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Joanne Chang <joannechien@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1274/1536] f2fs: allow pinning empty compressed files
Date: Sat,  7 Nov 2026 08:54:50 -0500
Message-ID: <20261107135033.559625971@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 539b0324ccc49..47743a0bdede5 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2673,7 +2673,7 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 	 * If IO comes from compressed write path and fallback to raw write,
 	 * force out‑place to prevent metadata‑data inconsistency.
 	 */
-	if (f2fs_compressed_file(inode))
+	if (fio && f2fs_compressed_file(inode))
 		return true;
 
 	/* swap file is migrating in aligned write mode */
-- 
2.53.0



