Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059283;
	b=Z1s2WRwxyL+odpDF8cYy+hfUNs7wTi+VB9GcfKc0+AtHml3tYS07GkQO53N8xRVWS6/e
	 ujW8f4UGTbGqPLOuYaHlRdPfsYwUwSXfZXFPNhQ8R5EdnxUCNSOmiF2NuPH5NgV/bO5cP
	 O4zuOw2N4rkdvbtGCZ0nKkcv9knHSy09rCdyz+Hu1lCq6o17ZJ6BgTbgK6t8qQgXQHvt4
	 veyXQGDexX9ZjKlJopAM2ycR1iKMJM55KDqpVTAL0fqGydp71BAKEY3zl0WuicZMDesfU
	 ttEpX2E9I/mHIU1ujUm+z8nFlPCIje4Qy0/VrIhhnF1deQpTtZpeG3sCdqoFpUas9BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2YkDp1E+O2fj36zqmRh1qkvzpDI3uuMu1xzHpkiZ5ME=;
	b=ZGK1htDnzcmqyOFXOn+qJ4SyDBGUpc8ls5N5R9xXxrEX76WXAiIiGkdhYqmBp/fLekyj
	 s3d/GKXwYFwJ5m9T82w0L8ejKTrB4oIF8EmTCrh8NnxFJCR2M7jeIyWMA7nh+San6slzb
	 vDQsgkXVVBJN0jSsiRwCnQfaipeRRBw4d7Ep/G77HN9PRzcAqqBvIbbiX4joJTtYso0uB
	 dEzsaUdiqf1VXIgOtcryECNs/0PCr2wu5y6TzhQkClX5kMsODJFApOFKdeUOAQa2i/CE+
	 dpEx7+O/h6xTZUHHzhCxTFEjQkvgL1JgRBQr6mXj11jjG7JVyaCigcK/fHczGK8PYTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zLBw+C3+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516E6606A320;
	Thu, 19 Nov 2026 03:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zLBw+C3+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49A61F000C4;
	Thu, 19 Nov 2026 03:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059283;
	bh=2YkDp1E+O2fj36zqmRh1qkvzpDI3uuMu1xzHpkiZ5ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zLBw+C3+AlHHg6FgN6ed+3Sqct4yOkVP1SWGRtjfN9GK2NWrvwyY95FAfARTuFpVJ
	 45OZo8rN3SSRlA7Rk7wGK5oF6ztMveZn7cFwfWSyVI2Gw975+o02ntdUK2XEsGYYNd
	 HGQBVMpnLw592Wf4LuovHwFawBrtf0hmSWZYoKXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0785/1848] f2fs: force out-place update for all writes on compressed file
Date: Wed, 18 Nov 2026 15:47:03 +0100
Message-ID: <20261118145949.321809071@linuxfoundation.org>
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

From: Jiucheng Xu <jiucheng.xu@amlogic.com>

commit a64a3fec11e77a3a0dc0009bdc58b925e45a1bb4 upstream.

For compressed file, compressed write may fail and fall back to raw
write.

-Thread A                                         - Thread B
  - f2fs_write_multi_pages                          - f2fs_down_write(&sbi->cp_rwsem);
   - f2fs_write_compressed_pages                    - ...
    - f2fs_trylock_op                               - ...
     - f2fs_down_read_trylock(&sbi->cp_rwsem);      - ...
   - f2fs_write_raw_pages                           - ...

Thread B acquires the lock first, which causes Thread A to fail lock
acquisition and fall back to raw-data write.
IPU_FORCE is enabled on small-capacity storage devices (< 16GB),
so f2fs_write_raw_pages() overwrites the original compressed data
in-place.

The in-memory node has been updated with raw-data addresses, while the
node metadata stored on eMMC still remains in compressed state.
If a power-cut occurs before the node is flushed to disk, on-disk
inconsistency arises: disk data is raw, yet metadata treats it as a
compressed cluster, leading to decompression failure.

To eliminate this risk completely, force out-place update for all
write operations on compressed file.

Cc: stable@kernel.org
Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Jiucheng Xu <jiucheng.xu@amlogic.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
(cherry picked from commit a64a3fec11e77a3a0dc0009bdc58b925e45a1bb4)
Signed-off-by: Jiucheng Xu <jiucheng.xu@amlogic.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 2933b32032e79..f3ff1865868c3 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2669,6 +2669,14 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 		return true;
 	if (f2fs_is_atomic_file(inode))
 		return true;
+	/*
+	 * rewrite low ratio compress data w/ OPU mode to avoid fragmentation.
+	 * If IO comes from compressed write path and fallback to raw write,
+	 * force out-place to prevent metadata-data inconsistency.
+	 */
+	if (f2fs_compressed_file(inode))
+		return true;
+
 	if (fio) {
 		if (is_cold_data(fio->page))
 			return true;
-- 
2.53.0



