Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023732;
	b=uq8ek+dQYww4AfZcTalfFlfOsgmxeD6AFqZTyRpMM8ofmNYyWawN5ujIGN7jVc5V2BxC
	 eu3dQVlqLIaA13q9KVTCW8w+fpW7DCW4h9D8rJMT7yxochaU7Qb5N2R89Lii+lpEP/hm2
	 Ijanx5P5e2uPL5BMf03fpoFr1rz6/DB8/K1M/qMdq+IMJJkXTf0yjClcxs+NPVsPkq9nF
	 F5Bpwtoq2JgWbs0/oGUVMeacW0imk2ZvKjOvufnX1wTlIMZxk/iKhdqbQbbbBUHTx6OpQ
	 huKUAMCmfwxW2bXuyIH0kaphNzMCGyfyekxGkBHSQ73U9yMdbM4L6XEiq6yY1nBu7fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H6VsC3d6uZ0FSbTlD5LYt9MSunCZqRt5uU0YaXHNbX8=;
	b=3mGnMmiE5RBoae0aYfqaMRXJeeryDkkE4Q2BPd2YvMOOOIc8zeNFy0xE0wz8GMNjTIdf
	 +8lK0bXRTm+e310CQCDbgFLEtp91annLJiHRWisdRUSzn+9kKvSPLhDaNWVYNAib6Smn/
	 M2LP09Ogd5riPP/j92Hv43nLxJcxvKrrCmlDoh6TCVFFEZFNqlSgoFTz9yU2N1GKryCG/
	 uastbw/KmnmUg8KS6U/WuDWJgOK5c2ugyi4Im/XBCdr8DVFci3vaTf2U7eFA6d3H7Ei/5
	 KENTa/8m2Ln70oBEcECa0N6BYwJlk+KUnas1OVSxLBYef35RLDAPkG465I4Gv3cLIIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nqA7uhp6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B152606A320;
	Wed, 18 Nov 2026 17:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nqA7uhp6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934451F000C4;
	Wed, 18 Nov 2026 17:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023732;
	bh=H6VsC3d6uZ0FSbTlD5LYt9MSunCZqRt5uU0YaXHNbX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqA7uhp6xl8/2+h0LN5GljEWTubnOqoItoJuXogP46gFKfjUy7muXu7In9IyS0zmo
	 20NAU8TaOZoXQUicA+A+KzFnpP5XR2sO0b6dMfaIuNF8TxngZ4V4yklzB2lJMp1fyB
	 EqclmXuYoMnwEyIhKl16fdq+/3xgskihBqQf4+C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0433/2151] fs/ntfs3: update ctime only on successful setxattr
Date: Wed, 18 Nov 2026 15:36:08 +0100
Message-ID: <20261118150137.816990447@linuxfoundation.org>
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

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit bfa6296bb6a0e2333796a9507beb4605b92a9fdf ]

ntfs_setxattr() updates ctime and marks the inode dirty even when the
xattr operation fails.

Do that only on success.

Fixes: 2d44667c306e ("fs/ntfs3: Update i_ctime when xattr is added")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 03006ff6a296c..d25de94b878ea 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -974,8 +974,10 @@ static noinline int ntfs_setxattr(const struct xattr_handler *handler,
 			  NULL);
 
 out:
-	inode_set_ctime_current(inode);
-	mark_inode_dirty(inode);
+	if (!err) {
+		inode_set_ctime_current(inode);
+		mark_inode_dirty(inode);
+	}
 
 	return err;
 }
-- 
2.53.0



