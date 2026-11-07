Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064746;
	b=vcR9o5m3TOib9I1YKxeKrWyjSvNt0Kia7vRZjUFthcrU97b7wLAN5XYjucgcuuluDvTL
	 n1IKHTQMGPH5VAbdYdLrnFHfKWPCpRY0ImmKL5d9cR9xWtHWh77NuMa/q9xnJIZ9F6tCa
	 uVAE7uClPElOq7bv+apK5EqtsxNVAcU7740oD8Dsp9YG09fXNwiuQLQapAMNE5PIIg2Yv
	 AOrnk3U28TulzUugzY0a9M7o59Px4geViA8pL35FmqGGO6cNpcj4B73QxfSNNMdkTVj0c
	 gcf+49BuReFedeLhM/YSEnWlI5x0EMyTFynkLgAxMill5E/dG6hJdYN8BkFLnh7QS4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rgjMCUenD9aPf7LrAbxKD9uRerL4wOpmOPFiMZ6oz04=;
	b=Q7cdYPon0xX0wW1l1OR3k/yDkQRphXNnGUpaCe9H+DrTW1lGR/KN0PxGLIYBFl6s6BWX
	 96z8Tb0ihdsFDZ6vVgiRcbuvkxSwJ7hvQbe5G5KABKzAB3LSYW3+TfDITJw9A3r/NhkCy
	 H/jLC/h3xJV22/qd0FI3OgbGNPIVaZxlIooTIiTr91jX5dIcXxB1LuSNUo66Ut/VZ63Ke
	 VaSVwBDKnR9zj9KWQOLtYmyjzShcgkLXDZBsXSlz+cCgccVY33fEYjlbCzZzSeUluqYBi
	 LbFrQ1UOG2j4gwFkZPuDSkOnFsNtQo6ByLiTSQyMI6G7G+UIS+1sfzSBhTDWut1OOEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKVYmRdQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DFF606D81C;
	Sat,  7 Nov 2026 15:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKVYmRdQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071A31F0089F;
	Sat,  7 Nov 2026 15:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064746;
	bh=rgjMCUenD9aPf7LrAbxKD9uRerL4wOpmOPFiMZ6oz04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKVYmRdQX0WlNUotTJQbD623euyrKi+Fr/XhWD8pZl39eGjdr9wsmPEiDj78cFimD
	 6V9OJ1LUOwR91nwmdA+1U+sNJ8YIszXWsuFbJKRGSgZwi5ihul2fdVdNN5au86hrW4
	 tru7zgAz4QPimpAs6dlTyRxfjbgvf/9dcHmeZWHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Joanne Chang <joannechien@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0721/1257] f2fs: allow pinning empty compressed files
Date: Sat,  7 Nov 2026 08:50:17 -0500
Message-ID: <20261107134959.175331475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c9a1bb07a5b32..d8965229e3e7a 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2913,7 +2913,7 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 	 * If IO comes from compressed write path and fallback to raw write,
 	 * force out‑place to prevent metadata‑data inconsistency.
 	 */
-	if (f2fs_compressed_file(inode))
+	if (fio && f2fs_compressed_file(inode))
 		return true;
 
 	/* swap file is migrating in aligned write mode */
-- 
2.53.0



