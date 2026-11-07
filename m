Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060998;
	b=n/aCwJSaaFkykQtJMN2U2Yvp5Uiq1Vq9MyhSiKJRuYfYuVzMzEmOMoDjPy3GEJwRsE66
	 9HYbA4h5OplwSvbR3591XQSc787HP7CjshJwaqejYvJvxX107V1HysLD3LvMIJeLD2ezk
	 /Ij+Y2NT+Uhgxu03rh+87mp7ZwbtMwuLIHnWsHHTCKIzxzpDwyTnlPs0kaf0WPjE0nOJH
	 m1Max83soDvFcyQvdts16GJ1nW+60Sam1x3+IBujfoJ7ZVIN3MEoCM7zAcR11Ayj5Wrvv
	 PLEb1Ss75ge3xjXqn/rP7lhopcvwKqsAPJb4fBlMSaEUmQoHnuFUR5311uoTp2R9VsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ybxw+WDY2jzZQS/mzPGtPnfSWUQjrIiaInLGVepDX/Q=;
	b=c28C6ODuWttazOHxxRR3P83bND2GnLIhbUvOJRCV8Q/VIipB1EWgpbnXvjS1TU+XIV32
	 u20gas11Kt0FZlQ8L4scTrss0T16uDZvK742ty7x/S7PtUEn+AJRCW0W6OtUio0XbK8We
	 W42BG06dzeuUtmSBteNe1hl8KVIDupP+0IF1qaE6ijZGl+C2ccXeyAjSLJX7wh9VpWnkc
	 +GuCDbJtHozHP7QVKFsYUm3Q3eVOke6uqfr5ud0ATozj4myysMipDKkUFNcqVcsgbuqF5
	 fZ64nmSAhfnWu8JqHwrG5kISLM9o1JRIPJ581/YEVJfrVyFSCmi2J6vMNNfMr1vDoOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ClQ8oBKf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15C9606EE8C;
	Sat,  7 Nov 2026 14:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ClQ8oBKf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E291F008A6;
	Sat,  7 Nov 2026 14:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060994;
	bh=Ybxw+WDY2jzZQS/mzPGtPnfSWUQjrIiaInLGVepDX/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ClQ8oBKf5ZpSC1O40icf7eQlP7SiPKLJ/deGAnZMXe2f7jrMiPcMcn1xWg7Flxjyu
	 FSMxbhG5A0I+VEm7ZZVbnV+s/xMuOl4bf/xQKZ+wz6iKjO7FW7eJMNbsTOpkFO979S
	 xF7Y5hTvcKsvZmE5SlWRsIaa//mHhrkdhFK5RQws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0342/1536] ksmbd: fix off-by-one rejecting minimal COPYCHUNK query-limits request
Date: Sat,  7 Nov 2026 08:39:18 -0500
Message-ID: <20261107135007.290016994@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit d68d4b3293034f549d55f407a23b4c0a6c90e50a ]

The FSCTL_COPYCHUNK/FSCTL_COPYCHUNK_WRITE input length check uses
in_buf_len <= sizeof(struct copychunk_ioctl_req), which rejects a
buffer that is exactly sizeof(struct copychunk_ioctl_req) bytes -- the
minimal, valid request containing only the fixed header with
ChunkCount=0 and no chunk entries, used by clients to query the
server's copy limits before issuing a real copychunk.

Since copychunk_ioctl_req ends in a flexible array member, the correct
minimum is that the buffer covers the fixed header, so use
offsetof(..., Chunks) with '<' instead of '<=' against sizeof(): same
value, but the boundary case is now correctly accepted.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5ec635d840cad..678db1aaeba55 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8532,7 +8532,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
-		if (in_buf_len <= sizeof(struct copychunk_ioctl_req)) {
+		if (in_buf_len < offsetof(struct copychunk_ioctl_req, Chunks)) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.53.0



