Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705198;
	b=YOCYAFpkA5qiklo/Ura3p4NBYIp/v4zBC3Nbk97Lbh4w2U4Qf0W6zmE2Q2hbZ2bjv0Ox
	 6J/r46rUtXb7auigQXOQ6bJu1i/Guz82/7HTDZi+n9yX584aSi4mCcjTM4udlZz/V7TWf
	 Fngi2cj2/k85Tjju/GQ7Pmn/TMv9Tk5aN15WgnJ/nSNP5Zo0hbjBiwfgRZ9KITj/lrnvI
	 A2AjzTUUXz0BsO0R44cTG8hV2M81MlyomxTsFogTCJQ0jPS0CpyuKSN/tn6YoXIF6nrry
	 CYE4FMT+LhbVp/phdxzHpbvZLAal2ydT48VhprczwcgCzM8OX3K1pM6tHo1NJrP4FtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PknWQClJY+JfcrafTw9tRGZyEpMcX2s6+s0P//lKUm4=;
	b=Ww9Z25uWbpVvm26zLsuXNn7cI4aqWCOoTZevBAZET+46lx5Vosffa1b2vkdCOzzG/wbC
	 3FGfdiDNBXHQFuzInEj49CcR1ksqtFcDtJU5Hq/jIV2KjCRcV7+0+onbU8shOi83nOfpd
	 C79EcDFi4BtAPmPZFmk1yYoECE9SqW5jmj7J9ms+l14aNIqEjini4W2rtuFACwzu1ZmCh
	 c/t1/9b7Xsn4mVQNzH7jUdNnEzh0ctetBWww5Xe+OEvEL0jwbQhNaqvuCQygOTGkrpZom
	 bzuTk0w6FVkIzAKfQ2LOYQ//hbG500Xz52aDTiEiL9JyDg0iIij1P1u0mBPaKMWWHnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iZGepqy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F72606A31C;
	Thu, 26 Nov 2026 14:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iZGepqy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119A41F000C0;
	Thu, 26 Nov 2026 14:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705197;
	bh=PknWQClJY+JfcrafTw9tRGZyEpMcX2s6+s0P//lKUm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0iZGepqytE8zmi/Nq/rmZdBRwfFUnNRQCyNESlZ4QH7w2Z1I9LVK8D4kubEzrzdHD
	 AmEE9Zge1MF/ie5uBQCCh/o0C0Od6U4deCnfcj89ZSI9UkF6jYRdO8qEGknsqfNcF7
	 qqXNIXLRWyIhu4VGtSbFl+xkz2MmYsD88/uIjlL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/319] include/linux/fs.h: add inode_lock_killable()
Date: Thu, 26 Nov 2026 15:38:03 +0100
Message-ID: <20261126144009.341296666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit d8c5507cd140d9471472ece673e70250b957c595 ]

Prepare for making inode operations killable while they're waiting for
the lock.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Link: https://lore.kernel.org/20250513150327.1373061-1-max.kellermann@ionos.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 7a5783cfac71 ("fs: reject negative offsets for SEEK_DATA and SEEK_HOLE in default_llseek()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fs.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index a6845fdc73cf9..fe4bcaefff094 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -795,6 +795,11 @@ static inline void inode_lock(struct inode *inode)
 	down_write(&inode->i_rwsem);
 }
 
+static inline __must_check int inode_lock_killable(struct inode *inode)
+{
+	return down_write_killable(&inode->i_rwsem);
+}
+
 static inline void inode_unlock(struct inode *inode)
 {
 	up_write(&inode->i_rwsem);
@@ -805,6 +810,11 @@ static inline void inode_lock_shared(struct inode *inode)
 	down_read(&inode->i_rwsem);
 }
 
+static inline __must_check int inode_lock_shared_killable(struct inode *inode)
+{
+	return down_read_killable(&inode->i_rwsem);
+}
+
 static inline void inode_unlock_shared(struct inode *inode)
 {
 	up_read(&inode->i_rwsem);
-- 
2.53.0



