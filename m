Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046725;
	b=3rTBM/c9ghxWa4+PNa7hwPpsFR3Y2861SvbTmRVbwoe7YTUbMPaXNC7pb7BAv8gBUzJA
	 dfKUfOXA4WpIjXHnquCgirCyRWyTXfzTDUvNZTkZ6yflb0Hv4yau3mhRX87FccPQdINGs
	 l/X0BiEria8KOGbpjfgQZQigeV3RBabYrooGCUiBbDAFrD/1uWO83X2g+rXKoJvhyGMnd
	 94AvtOM8JNi8DcBeFdSle8GKx5VcVH3kucNgDuo2PujPgG2pJYiJlS2XUaLj2HIE1XqKh
	 ABb+sgqQV2kuUgy4XXdLTgwKFw0ygPriH5muhRAi6+IibpMqPuNLsT+hZ3rgt3ZuDdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I0nxRW+Td7fJHJpYwCU+fwrDqTC3UOpYx9ko32JWd/I=;
	b=a+w9iytSMBEqXvtCoN/tMKryjIS/G/ZWzFeK4bz+4wNCnHrxwlMsd/K4u9f4opK4OBtW
	 jfWRu1pYIJIo6nJG3KcByw3yijUPVmE7SeoD3Fc0ri3LkRmDDJgLXqwyUgN8H9OvtbeyK
	 SDmjL0HzRx6D49c3GHembEgA37hFWWUoHFhaSzmTaZYyvvOHLEcfSGCHbvX0wnJb7dgyB
	 rLuSr4nrSGcaiq3HiHpBuShd4teTn1QbCfEPyNXIc29Dgllh9oOcqqDgBDPnUlcnNo8up
	 KP7J3CM12OGH2CoNb4WQdsgO7B7ip9+cyf1sodd1NOay9usy8RpEZqU3i+oJ5Sqn/tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="q8/Bo0j3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17582606A320;
	Thu, 19 Nov 2026 00:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q8/Bo0j3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7270D1F000C4;
	Thu, 19 Nov 2026 00:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046724;
	bh=I0nxRW+Td7fJHJpYwCU+fwrDqTC3UOpYx9ko32JWd/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q8/Bo0j3pxP1HMpB98rFBR+caAxPohnv5r2aHyX8w2Sw7olWD9v4IJ0f9o97GFVqX
	 cwWGzacIucLwkM3KP1l+ZufAugT2qO3hE0RAJSFOhzGCt+djck/dsUzV60H/6FYtkL
	 5AXz/mPOrDihzrkGO0kbqgWf1haSILsf7WXetTvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Joanne Chang <joannechien@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1333/2857] f2fs: allow pinning empty compressed files
Date: Wed, 18 Nov 2026 15:39:27 +0100
Message-ID: <20261118150249.431534717@linuxfoundation.org>
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

From: Joanne Chang <joannechien@google.com>

commit 2eebc31ae5f53e1066bb6238c8087c23b688ad17 upstream.

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
(cherry picked from commit 2eebc31ae5f53e1066bb6238c8087c23b688ad17)
Signed-off-by: Jiucheng Xu <jiucheng.xu@amlogic.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 4a0bf44b3a545..c07077f0b56d4 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2667,7 +2667,7 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 	 * If IO comes from compressed write path and fallback to raw write,
 	 * force out-place to prevent metadata-data inconsistency.
 	 */
-	if (f2fs_compressed_file(inode))
+	if (fio && f2fs_compressed_file(inode))
 		return true;
 
 	/* swap file is migrating in aligned write mode */
-- 
2.53.0



