Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025491;
	b=pJi6xPX94oJHJkpVQVnx+EpwFlGj7Jt4T+wvNLcNJ8BDXlDXaRSmgRDXekjK0EiM+n6v
	 DOryg4S6WuPM/j4UFp3C12Vmt3g4tRq0tUlAlP4IoOOyrotCd7cjc9t6fAl8r+Q4+UQkN
	 UN0av2NlaVhxyupPoN/mWlqliqxyv0/Z0h0WPNsbrYwc9RpnVB/GBkONX3gt3zvq/T0JY
	 hdqnSON/nI0/XZyRCs9lKRCtWpHNyMsz9D7H+M4xHzhGYvsn8egK0z9gtMpdZ/VEDqrDs
	 N2FZ5zBRkgibszLUrsZQlOMErT4BVXbKKoyBue52cQ7M+c3d/1h/4XlxmFTIrIX31ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Ak24NokYWCpy8OnT/gpHCNxj8z5NR7R8B5PrfFHsDw=;
	b=s7m46T1PVZ99uoe5AmVqBGjPxmVFVr/apV9zVOhdWn3qvSZVh92tm1dJcCGevuGcvNRQ
	 TsKfwQGtTdRy9necOR3jJ+eSk6qnvyFxi2Bpe7yNtIGIugdgJpj1u65sSpFdBbQwLyn1K
	 gWjvHDifDzEFzJhnDBbsqYiGybltvxn/56t4QsFtP0rYv13pEwJSEEULyO/ofd/t6x788
	 4ZA+L0462tRFVlVMlFUF+KeiZSRfz2mqDyHqipRElYB2PQJvF3IoUfBKJltrlk1r3UGuz
	 6FpoNEM60BfWQ032275YfI2+3thdcbdsXhTWqOhRHl9Gu1wfqRSbOxbpxgffyfAnxww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m0NLzCHZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DAC606A32A;
	Wed, 18 Nov 2026 18:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m0NLzCHZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3A81F000C4;
	Wed, 18 Nov 2026 18:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025491;
	bh=8Ak24NokYWCpy8OnT/gpHCNxj8z5NR7R8B5PrfFHsDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0NLzCHZJ+Rk6vuuZxWV3BgUmfXbdSi3HWD7IBabzCBbZBkrIMOFDGfyUNtpBHyXE
	 5MgsxoX+jnyB6bUS1h9DaLKT/BBrQXw6kOFbntXnztFYJrEB1ClibKZ4PNRKPBamWk
	 kNoKiTbrYQkdWEu+9gGahj0jVY3jiFqcZjmB3A4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1097/2151] wifi: b43legacy: debugfs: NUL terminate string in debugfs
Date: Wed, 18 Nov 2026 15:47:12 +0100
Message-ID: <20261118150202.229121763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit f94595252b318a9ae3c01d78b3bcd33b01b1c082 ]

The "buf" buffer is PAGE_SIZE and allocated with kzalloc().  We store a
string from the user in it and then pass it to sscanf() in the write
functions such as tsf_write_file().  The buffer is only used to store a
number so we never come close to filling up the whole PAGE_SIZE.  Reserve
the last character of the page for a NUL terminator.

This is debugfs so it's root only.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/909ea7a88658b5e7c183bf0fda31687a91d73818.1790839793.git.error27@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index 5d04bcc216e5c..c9f640d0340a8 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -261,7 +261,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 
 	if (!count)
 		return 0;
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 	dev = file->private_data;
 	if (!dev)
-- 
2.53.0



