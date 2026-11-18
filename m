Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029553;
	b=gCq7o3tGzpeEBV7+LWFiFEafXI1caBVA1ARMlLYWsczb6OTzTK+HojK0HgCwnbZkrMXF
	 TkIU+DJYr3B6Vj2lqTQ+F8HijItap2CbX3/rWOI6pAqjRQAqJjL71uAxoHbyWHALrGD2H
	 wf36SB1UlW43+i2Q7DpVCzZFl928PNWrgNKXpEHGUszIodTjZ/HoCu1luyF/K7h/IxK6T
	 vOND1+YAuKFY4hwSAPKy+110UZj6R7kIvbqaYOUbAXIoDSMIEBjf42wfcmmFHRJo6ERVP
	 rJ7jgwhgPL0r6AZhAzbX2fOmj2WKu8dcF4upgk+oE/XTEyDMos1ckZhnuNF86U6Qpjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oCob0vAs7b6DbRuIP4em7a5SgVj3ZmywNa6aNeS8T2U=;
	b=RK0ph6M/srGjxUZDvaBJFCDyWNgh6KbRohT4ZxI/AjGGulN5fslMRDjMwCac19o+tG18
	 QPV5h3P0q3hsIS+IBesj2ywLlJYGyfqmIyYnibtTdJtX8nmX/PrvOkX4TLJMTHxfkASj2
	 TbMCRaOQs6HNk/diQaaHM5XmSvNHElY9dRcFtNX7ZndX8lO0c8s0UpGS1GZWZyC3YkkU9
	 ahLSK5biW4H/CEs2JK3I5TzIHZhy8rjqwEuZzPEnljjApFCMZdWGd7G4W0cMgpMLvLyCM
	 bmvgl8XVZ49tMqMzF31e6Lc7trnMwbaHSazrHUmsbiZ7J35UFZQ2uTxpY557giqFK+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ku17Go/f";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1628606A32C;
	Wed, 18 Nov 2026 19:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ku17Go/f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6F11F000C4;
	Wed, 18 Nov 2026 19:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029553;
	bh=oCob0vAs7b6DbRuIP4em7a5SgVj3ZmywNa6aNeS8T2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ku17Go/fJznpRhKqgqKyN8YBm44CWcDKn6qphDmZDvrritnLc1mHVaNU2cI/f9MZi
	 yaCpgDlypPStxKjJfnp5h6bcGnf7G4kH412bo4n95f8g1ca/lj4XLC8iMP3cO3zGvA
	 QOhJygBZS2BMqFPaieT1LMgiWtgd20s8OUcv49E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0392/1756] fs/ntfs3: take run_lock when freeing offs_folio in ni_decompress_file
Date: Wed, 18 Nov 2026 15:41:59 +0100
Message-ID: <20261118150024.322163865@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit ad39d8d90fa0fd99b2714d4c84c6f4e1c399f1f4 ]

attr_wof_frame_info() allocates, caches and dereferences
ni->file.offs_folio under down_write(&ni->file.run_lock).
ni_decompress_file() frees the same folio with folio_put() without
taking run_lock. When a WOF externally-compressed file is opened for
write, ni_decompress_file() can drop the last reference while a
concurrent O_RDONLY reader is dereferencing the folio in
attr_wof_frame_info(), leading to a use-after-free:

 BUG: KASAN: use-after-free in attr_wof_frame_info (fs/ntfs3/attrib.c:1619)
 Read of size 4 at addr ffff8880120c9000 by task exploit
 Call Trace:
  attr_wof_frame_info (fs/ntfs3/attrib.c:1619)
  ni_read_frame (fs/ntfs3/frecord.c:2421)
  ni_read_folio_cmpr (fs/ntfs3/frecord.c:1916)
  ntfs_read_folio (fs/ntfs3/inode.c:648)
  read_pages (mm/readahead.c:181)
  page_cache_ra_unbounded (mm/readahead.c:292)
  force_page_cache_ra (mm/readahead.c:364)
  page_cache_sync_ra (mm/readahead.c:573)
  filemap_get_pages (mm/filemap.c:2688)
  filemap_read (mm/filemap.c:2806)
  generic_file_read_iter (mm/filemap.c:2994)
  ntfs_file_read_iter (fs/ntfs3/file.c:842)
  vfs_read (fs/read_write.c:574)
  __x64_sys_pread64 (fs/read_write.c:773)

Take run_lock around the folio_put(), as is done for every other
access to ni->file.offs_folio.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index ab8615abb981b..f3d8483c9f543 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2395,10 +2395,13 @@ int ni_decompress_file(struct ntfs_inode *ni)
 
 	/* Clear cached flag. */
 	ni->ni_flags &= ~NI_FLAG_COMPRESSED_MASK;
+	/* offs_folio is accessed under run_lock in attr_wof_frame_info(). */
+	down_write(&ni->file.run_lock);
 	if (ni->file.offs_folio) {
 		folio_put(ni->file.offs_folio);
 		ni->file.offs_folio = NULL;
 	}
+	up_write(&ni->file.run_lock);
 	mapping->a_ops = &ntfs_aops;
 
 out:
-- 
2.53.0



