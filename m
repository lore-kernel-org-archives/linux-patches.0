Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021209;
	b=WoUQnqSzyA4AE8h7ouPgTw8Yh0YfqBPrGY2ljH91RLdlcIv0yqfJ+nTAGUbuLdc73ter
	 QzF2hiTWs0D42Cmp7AQeNIJzR5AvctIUhueFhUC1Z1mss28YRNnVLv4K1o79fKGPuN9W5
	 zP7Qfrk9vHegc0uou0mpxfggbCKdzuo4kQcuTVZvzTrzcXSpKYWWhCfapXm1VUn6OIxSN
	 W3VNdtzALNYa/d3itj3j7GqJ+u6CYkfSehPehq9sodGiMHGwKgHCGzKoU+DPgoartZGvZ
	 EryjIdKxnKIekmY2QZs7eAC3GgAHWebM1k5arXEgOLyOUWF1R9Iy5jW33AZMkNGQzvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LY7Kh6S5U4tPmUXnVorpseL+ClUtuaNaKuADyZ5Vvkw=;
	b=Mx0Uh9VrQ0bzV4L3I7XRMYlMPgy/B9T4ugGtv4N1/q4BLkpBldPqqL0QUveVah5O1bDs
	 jEvsl/Lm+rpFGcsF6PWPygAnVU8ZmZizkw0xDKZ7yBRgmLJfh6R+yTb1sbsC4dtF8KPIK
	 wgw+FYaqpMdBWTcxY0vA42++a/BGz+rdvLe3JZz8TwRvw+Lx6+tCME9AgfFuMQSAYtI7q
	 hfHT7bYVUEC0TDB5v0J0RRrDr4SzWFmGrbBSFrAMxahRGIR7qlFqN5dryQkJWhkkzUaY0
	 pPWsDaXjJ+2gDgVcDUNka6+89xbSDoXJCiZz8svlnJIIIf+Tcb+7Yh3+yvtjI9W0D7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNBR5rFK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C62660A2608;
	Wed, 18 Nov 2026 17:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNBR5rFK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252911F000CA;
	Wed, 18 Nov 2026 17:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021208;
	bh=LY7Kh6S5U4tPmUXnVorpseL+ClUtuaNaKuADyZ5Vvkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNBR5rFKn1o/9q5WegZy7jyBKW0+0C0szJT25o5CoKYMR6YqCeVkLSHReaTfcqfvg
	 gm85RyMA3/gSuCrYcqPWO6wFM/3wMGoQrwH0eVDbgTehISD1t805H1rWX6/7iIi8cG
	 c7HUEgQgqrLrSTCc9Q/a6uTfBwA//rrxDQ8LA3mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2223/2651] ntfs: propagate EA truncate errors
Date: Wed, 18 Nov 2026 15:57:43 +0100
Message-ID: <20261118150405.602449376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 27110888543c046fecdb947fc34bcc3b64313488 ]

Propagate errors from truncating an EA stream so callers do not
report a successful xattr update after a failed resize.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/ea.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index 9e00588ff9b5c..082db077a4ede 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -37,7 +37,7 @@ static int ntfs_write_ea(struct ntfs_inode *ni, __le32 type, char *value, s64 ea
 		struct ntfs_inode *ea_ni = NTFS_I(ea_vi);
 
 		if (need_truncate && ea_ni->data_size > ea_off + ea_size)
-			ntfs_attr_truncate(ea_ni, ea_off + ea_size);
+			err = ntfs_attr_truncate(ea_ni, ea_off + ea_size);
 		mark_mft_record_dirty(ni);
 	}
 
-- 
2.53.0



