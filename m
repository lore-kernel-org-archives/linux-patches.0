Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213198;
	b=CiM5uAoibVwNdMM32a1I2g1H+xB2KsK3fGMEYXelhzTu799TtT+L5vN3J+JAQxZHIdlF
	 Hl1plne3ur39bgRePBWpsJ9oBiD9UaeqFHqmrmsMV8fBphgRzuOYpX1Gz7uzv87P+D2hA
	 tJMKsVuRm6lhNapj7KhCx3eYxZlweixIXmbXlXknIFcdsy/PXY6r31d4SgtCM5ejWxLz2
	 qsXD/+IT1gUvOLdM/W7CiHi40I2Tgw0gG1KbsEE5Cske9Y02AH06NX7k+ICQ4nSwlQGk1
	 hXeyoXrXihmKerjWo8YtMQkTTAtJL7uGRRtSMqFlCQxooZr419pGi3jvMxVkTiZkuOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yAjn5rsmtjZhk7xyNQKMFLksQd4KCQOvp0/+hsirvhw=;
	b=sg0Bvz5FHqlRhhEYXBdbDCsWKQ0STrSM4yhKSWzRfIfH8E9DPhNsPesVjuxnzQTnLHsK
	 9ir0k6M7nWyepjgQddTk4hBOq5DX6oKNfGJqF1FxLPUX2XP+mV4X5Ja2UQHduqZmioGUo
	 N1ntw9j6v6jzGOH3B7P70w9a5pgp0UlBnNfoGKaInIpyCEm8XU4XiPFB/I/9mnskEKZaT
	 TYfwF3ODnqStoD72XnS1nZPxxqXsPjN5Zoy+39XuWWB5YpNYHSLxv5XBMmMJtrBYWMram
	 lMs6sXEJmS5WR3rtzIPIDG8SRPbq53csyxmQVL+vpAB5Cj1t+DEY0IShuzjACM17lGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B6nMaezt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB829606A31A;
	Wed, 28 Oct 2026 18:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B6nMaezt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4FD1F01828;
	Wed, 28 Oct 2026 18:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213197;
	bh=yAjn5rsmtjZhk7xyNQKMFLksQd4KCQOvp0/+hsirvhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B6nMaeztODfs1dh2GvSkLH8eUkXP4NxBYblM6+EJ3UZwzkKmk/mcFxONO8QyaOIT/
	 vpHGEZHclSWDVVp6wEiM/WZ3aVxok7Hldcyii7vEDHP9eQHWxw8ZG9lQufTuJXZEOP
	 0zCB1PqSyMm8p1tbRCmz6WphcqaltFCPgD7rWRxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+83c9dd5c0dcf6184fdbf@syzkaller.appspotmail.com,
	Nirbhay Sharma <nirbhay.lkd@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Nikita Nagornyi <nagornyi@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0420/1887] fs/ntfs3: fix KMSAN uninit-value in ni_create_attr_list
Date: Wed, 28 Oct 2026 17:41:56 +0100
Message-ID: <20261028170508.792821167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Nirbhay Sharma <nirbhay.lkd@gmail.com>

[ Upstream commit 5f33da04e6ceee849e76e6592cc283c72fef7af9 ]

The call to kmalloc() to allocate the attribute list buffer is given a
size of al_aligned(rs). This size can be larger than the data
subsequently copied into the buffer, leaving trailing bytes uninitialized.

This can trigger a KMSAN "uninit-value" warning if that memory is
later accessed.

Fix this by using kzalloc() instead, which ensures the entire
allocated buffer is zero-initialized, preventing the warning.

Reported-by: syzbot+83c9dd5c0dcf6184fdbf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=83c9dd5c0dcf6184fdbf
Signed-off-by: Nirbhay Sharma <nirbhay.lkd@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Backport to 6.1.y: only kmalloc -> kzalloc applied; 6.1.y lacks
  14f527d44de6 ("fs/ntfs3: Correct checking while generating attr_list")
  error-path rework. ]

Signed-off-by: Nikita Nagornyi <nagornyi@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 17559fca5984c..c9d0947651c4e 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -819,7 +819,7 @@ int ni_create_attr_list(struct ntfs_inode *ni)
 	 * Skip estimating exact memory requirement.
 	 * Looks like one record_size is always enough.
 	 */
-	le = kmalloc(al_aligned(rs), GFP_NOFS);
+	le = kzalloc(al_aligned(rs), GFP_NOFS);
 	if (!le) {
 		err = -ENOMEM;
 		goto out;
-- 
2.53.0



