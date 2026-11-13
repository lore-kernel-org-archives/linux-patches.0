Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585975;
	b=SwwWBk+wMNX3e6vQqMSw/6g53zCxI2WmQwI2HPyzfQ2AgBluUKnJ3hyWr4BU3uHK/C6R
	 pS+taiJ3fW0644rrBNl5RPk6qWgAYniP++lYS1gWPy50ka2JV1OBgUaLiLSmD5Fx2qHkG
	 jQIvkAvgnYzMp3K5ImFhaqNHh1R3M9GzQ6rCJ065RSuvJD/DGaz21WAyFYmjGd7CVT/Dm
	 +zxBiQYhCA8iCIIDUcLaSx0U+Kq7RQIQ63sh1n8ExNi87uV0+dCYkLURdjAbgYG2edA7D
	 G/8xENVzEfu/W8dnnkTX+VA13JyGWX5MSC1Ei8X30Y7bUQu6GLOJoqhVpwhwNxMUCZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vh96L++9fXoJPH5BWsm/zVxkmlH0D6zqMdZWZ6HhBo0=;
	b=wS4XGkM6MV/SgwQYrJJkIQRHNfXAxXdArXitql+IZ1tfSrEEwfkoqd62oykOxIRWk7sb
	 +mzitDs+yHr/JbeQpv3qttWlpsX0K911jpZGMoLEvMCYmInq8sG6Y1x8rDqPqKukZ1SDS
	 nQac9jRYRcvTLs23CL2rN9tsHiSE991Buik5OzIIKmJD81+WzpnQ5MrgikLgxbDWP/2AW
	 xhvCe5mH8meF0TnDHmpMV5ISgkk0FsTgNeQIfHxaHG7+lriuf/Ps5ZHaN3wjCm3ewTcm3
	 AiCX87qkHxkNp4QJo3j6sQueLsboxWRnovPkUGQQAIlfDpXyl3VkVJ+mdROhXevNr5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e66D7Lg4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35D66072306;
	Fri, 13 Nov 2026 16:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e66D7Lg4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8685C1F000C4;
	Fri, 13 Nov 2026 16:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585975;
	bh=Vh96L++9fXoJPH5BWsm/zVxkmlH0D6zqMdZWZ6HhBo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e66D7Lg4gQpdE7dqFXSBfFdz/4tgH/nNnIwJwdj/o6mNgvM5hYJ+9PQ0FoT2H/bw9
	 krP4dkh9pI0z1m252W213mUzrbloxZhp2rQfwb9KSYreXRcjnaSYpy8LJIzIIQcqo1
	 2KnZU+/ub4q2M7ZY+EtSe5ZzNzh5yLWmGDYUoCco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 023/686] smb: client: require stable pages for SMB compression
Date: Fri, 13 Nov 2026 10:42:36 -0500
Message-ID: <20261113153821.699642076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 8667061cf99394526dd9c0ea2662e6bbc7ae7848 ]

Like signing, SMB compression builds the write payload from the pagecache
folios: should_compress() lets a write request through and smb_compress()
compresses those folios on the way to the socket.  If a buffered write
mutates a folio while a write subrequest is still in flight, the compressed
bytes no longer correspond to a consistent view of the data, and the server
silently stores corrupted contents - worse than the signed case, which at
least fails loudly with STATUS_ACCESS_DENIED.

Mark the mapping for stable writes when a write may be compressed, i.e. the
same condition should_compress() tests (compression negotiated and the share
allows compressed data), so netfs_perform_write() waits for writeback to
complete before modifying an in-flight folio.

Fixes: f046d71e84e1 ("smb: client: insert compression check/call on write requests")
Suggested-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ sashal: Replaced tcon references with direct cifs_sb_master_tcon(cifs_sb) lookups because the local variable is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index d9c502efe84bc..b8f9dd47a56e7 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -87,7 +87,9 @@ static void cifs_set_ops(struct inode *inode)
 		else
 			inode->i_data.a_ops = &cifs_addr_ops;
 		mapping_set_large_folios(inode->i_mapping);
-		if (cifs_sb_master_tcon(cifs_sb)->ses->server->sign)
+		if (cifs_sb_master_tcon(cifs_sb)->ses->server->sign ||
+		    (cifs_sb_master_tcon(cifs_sb)->ses->server->compression.enabled &&
+		     (cifs_sb_master_tcon(cifs_sb)->share_flags & SMB2_SHAREFLAG_COMPRESS_DATA)))
 			mapping_set_stable_writes(inode->i_mapping);
 		break;
 	case S_IFDIR:
-- 
2.53.0



