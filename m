Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040925;
	b=D9a3wHMp4LVWSajh6qq0rjrV32E1NQN+sU7douUf9f1PR+CNoT0E0Yufzi5NMEXWGiKZ
	 CoFd3F/AY7Dg2Cl/GWBNMSoCJsE7nmfSKAw1A+7JA7Li9aOQgAmj3H1fZifFRUwu5dcv3
	 fPb1y7aDBmuCVGpAvIHCE2V9W60KT35BohB31PPK6UA3ut5xhfehvfzGzTlnnFnUV4DkZ
	 fewrkImLiWjvp4dmf4EoY6zu//mjoKmvgwQERn/VwK9/oDE/OvKjWQhXA2uNxBacCYgJL
	 QVsgYJCYhJFtvH3CAMgJ7wl6hTvoVUAFeFhXQC1G+KvGaUHSu5w6aPZ1wEbG0p7iBqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8yerpsi+UBhHKMzR5GABNwlzTIzs8DWh0ZqYxkhIEqo=;
	b=PM5lutHSdNeGMs01QKAT3fegdiRkxWuUXQ1KYBMrAnkGzf+KthFaZJM8aAb0sa2veYbF
	 +xlImbgNSgxCztkzGMGlO5+hgPBut7rbbua+GSDxfjJ3FiLzeM9MPFMX1TMX0RNNZ0yLd
	 bub5QjnQeyUTZFM764eSBHldG3rjBfhds8oE88XAeeRhq5UBK9bKhsoPMH5rHS2+nh/np
	 FeTjjfWoMASAcX+kdT8FnceLUHzx0r3tXWmmvLGlS6EgVOmDMLJAbByVR0AUy0oBXkgQ/
	 /wqDKJHNauTM7Rkp3R4FgW5Nkj3K7NCejnW1t29YDdq6rLBlywKgeFNjCbpKV23RDQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N3AKJCwZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CEF606A325;
	Wed, 18 Nov 2026 22:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N3AKJCwZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F281F000C4;
	Wed, 18 Nov 2026 22:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040925;
	bh=8yerpsi+UBhHKMzR5GABNwlzTIzs8DWh0ZqYxkhIEqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3AKJCwZMHA7oI6DCxk1boqw/yt6YfgnqRImzw403XqFWxV14zqehIigIiUNyJb3D
	 u8hPMozn4zNZbff3kQEvrpO4sdIuikmx8Ft1V+AEgRg6v6Wbl11NgGM4EnOi3vaQVY
	 6nPAq0qjUIX3gU5M6jQdqucWVZrI4q7ZgNCce0OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2588/3318] wifi: b43legacy: debugfs: NUL terminate string in debugfs
Date: Wed, 18 Nov 2026 15:53:30 +0100
Message-ID: <20261118150438.823120731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6b0e8d1170611..86f0c4b717c66 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -263,7 +263,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 
 	if (!count)
 		return 0;
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 	dev = file->private_data;
 	if (!dev)
-- 
2.53.0



