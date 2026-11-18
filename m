Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059286;
	b=BdvzuAtmY8ooF02IRpjwUubM2kRS327P535EpiYMkrbejJv3XgoW/ZyPW3sHsr9G3kog
	 AoMtnf6VDPlt6lMU2TfrMF5iu1BKC+W++RWs1ZLPvdW83smXwnjUYsFX5XY5235Z+0pCT
	 jQqKJqZeVsK8WLdOVl7N791OrWIiiJyDMuyq6DA/rFFmydPtFZNG5pseDoPogX7gfsmZu
	 36HKBQDP/6CRnI+IEy6vjwsZtMUtj+2btHR86KvXqXFPCWQiMaXHDRlBEcb5/5RWL4hZP
	 rK6oKl6h5d9MApSXPie87ooaIcr8jbI+B7FUxFdj97bqj7umJ6QrQs9vmLgwuizX8Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1iSd1V5O//96GQdXw++tVxYRSmDvyKAu9D7s+tc0ND4=;
	b=OfGEcXQMWRaLJBmOVlwbp/7UQBMMsVLx9YIBKhT8Fj9Jy798N+PySwxGfVG1gYXgqHnG
	 SeoLqMikFPfi0hf9GBTyufEnjbepdCcbszH12R/XKljSrLNX7FgSi8iqH9vO5c7+O1d+G
	 qw8tfePxeg4l9bvJhv78mk/5bMSs5VYFiLsDoWM9LntsEFRPCtt4oQrvHZWey7ZiT2RVJ
	 bcWvx1OFVWiUQcPwSZHPZvscDO0Hq8cmdNYTkJ5ztEDZ5tZghp+fpKDeV1M7//Zd9Wvjb
	 aqNS9almanzxLmx27v/P6CYKJNXQq+JiXf2tDSfw2wlt8gJ2MmCS1RZQwzk7PItqJYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SVhCwAxK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27280606A31C;
	Thu, 19 Nov 2026 03:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SVhCwAxK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB3C1F000C4;
	Thu, 19 Nov 2026 03:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059286;
	bh=1iSd1V5O//96GQdXw++tVxYRSmDvyKAu9D7s+tc0ND4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SVhCwAxKa5ueZgF1+2n9sZQB+PpVTO717DwHzAZvjwNoxcCExn4fYNCKeVL0X1JOr
	 FpaiDprLQPOY/dbI01mwkejG8DlgJlmrVZ53b9Qk/VJUpakpWyPeMvsqc8QfUQNXaV
	 UIiANzakqr/dAInsJHd1///XX4EudSaCj71xnxVg=
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
Subject: [PATCH 5.10 0786/1848] f2fs: allow pinning empty compressed files
Date: Wed, 18 Nov 2026 15:47:04 +0100
Message-ID: <20261118145949.355879316@linuxfoundation.org>
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
index f3ff1865868c3..512aeb6a0f989 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2674,7 +2674,7 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 	 * If IO comes from compressed write path and fallback to raw write,
 	 * force out-place to prevent metadata-data inconsistency.
 	 */
-	if (f2fs_compressed_file(inode))
+	if (fio && f2fs_compressed_file(inode))
 		return true;
 
 	if (fio) {
-- 
2.53.0



