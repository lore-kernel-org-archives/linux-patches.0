Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048244;
	b=osnXNvMTyzc5OYwNfkeos8em3FPSsMb5Ftk6OgXpZxSZwpUDbCxaB1f4ZvTzMBgTGuWw
	 ZZBzniYltm+guLhpYJmSWGKA/mjQFbso3y9Fy1OBeRcUTpTGeC9YoCP6ded/Sq6OeCdbg
	 wjouA0uj2ZnxBBPScrsbs+nWJL1JgxanKa4IyIY78s+n9e1CB0DR81CLqVIyRGJ9jYeBO
	 5ypGq+M9qWwefKwLwjlOMo+UVCWyY0IVGUXTd6lk3LXrPltCK3a+GQhHJH17AP0DEwLot
	 5Kx4884si0C5tFt6u+qbhHLaEGuvqJQx6hJaEawt/jDW7Qj3I81Nf/Snpn8BgXkywGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CIT6ho8xNJcKEd8T9p5AMD/4k9anf3A89ztPYKYpZm0=;
	b=IbQ8M9HInhV6hBTgFDZ0JOkOuJF2e8P/Wb4EICgxyig6zJhicpHYIbCW+Yx36eLIiurY
	 P9jGhOLdTVBA2BMRwkM/eE7oHa5yl/3U17TXSAAprqRYK6QfIKkAKkwQoz4NpXIhLNY4w
	 wrAr7uM34lU/3VHuI2lZQVF6PNGGVofS+iyOTF4fvpq0JrdEFh5ijZXMOCpssynU56wYS
	 kJ1oftwWGNUzuD7Np0y9sf9+hKQkBuPktxkcoJyCbTAhB2KaZpAsJxnPGO5P4LXC3BaQH
	 fEzMieRxvq6s3xfMBiiTdDoxLLFVF4qqvUtIOuNbcE7MKK/IqF/hzv5M73kMQ6KXK0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S3OsCbTl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2688560A2609;
	Thu, 19 Nov 2026 00:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S3OsCbTl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382331F000CB;
	Thu, 19 Nov 2026 00:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048243;
	bh=CIT6ho8xNJcKEd8T9p5AMD/4k9anf3A89ztPYKYpZm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S3OsCbTlLklHqPqsTOqpD5YsgKVuaoaLWkhkOK0Tdku79XvI5ujsQDMR5ifFgowKp
	 eFVwUF1CIzVOfzGxmmxvlEMOH4MvDj0qBw3cbUFvw/BEFCBNzl9Zbs6qA0Ql+WkVIA
	 Mns+Gdd5JKadoZJ5er9Ea792qRJ22MyTK7isN2CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1925/2857] fs/ntfs3: zero frame pages on read error
Date: Wed, 18 Nov 2026 15:49:19 +0100
Message-ID: <20261118150310.519947776@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit a32e893a077a4b0d3b04c86cb7f69e354a187995 ]

ni_read_frame() marks every frame page uptodate at the 'out:' label
regardless of the return value. The pages come from ntfs_lock_new_page()
and are not zeroed, and several error paths reach 'out:' before anything
is written to them (e.g. a failed decompress_lznt()/decompress_lzx_xpress()
on a corrupted chunk, or an allocation failure).

A page marked uptodate is served directly from the page cache, so a later
read() of the file returns the uninitialized page contents to userspace.
On a crafted compressed image this leaks kernel memory, including pointers.

Zero each page on the error path before marking it uptodate. The success
path is unchanged.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 9a7e1099d34b1..b8b5304be183e 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2832,6 +2832,8 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 out:
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
+		if (err)
+			clear_highpage(pg);
 		SetPageUptodate(pg);
 	}
 
-- 
2.53.0



