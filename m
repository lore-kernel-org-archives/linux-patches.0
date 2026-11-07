Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061488;
	b=ZP/EynFCd9TLZTMjX9DfViG8ocWsf4adqE51i7fBgUYmWnRzPOJH2ee7iNotFGzX+Wy5
	 GuoDRCg5yACQ2EJ2wl/veVfpTd5fNQxmdG49iPkvQ/73QEIeQ0QcS8TLO72KS7fqgQ/Na
	 AksnaYJ6RKXcSYht2iWdkHKmUxK/C+hiU8OxUkLbp+rii0+5rhHvHiQZ5ky6BQyxRf7aW
	 qEDa3KDS79BJvxdLpi6sl6yRmeN19y64msW6x6iGKfXOnxE0yCJtPe7V7Ggq95jiKo+Fn
	 +d6Mtmh7yIGupejhmkdeZSrssSiVFocHG6pSP1ntaEx6t8j3XJuwbIrJ5WTVl9ufj4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n/P3nDQMGIJNu7KYLLNHxJOnXiYa5KQ8ZIi3VLRgD/k=;
	b=0cTGVsQJPOx+O3mgCF2qIGUiSkT75hJWpUg9+s1CV+AMqbub/Tz3kGLqJ/c0nRX190lS
	 g+kH5mweC7twkQd6tCV57PvDvnZniLhlYTUNuSNJ0wmbFVK0loWva9vIv3uDsWABtME9j
	 kSh4MhdaOv7mO+j5ddK3UwXh/oosaSwHMTyw2MXZBjN+ykeZeWP3Tcqkx+eAaNuA0+cUT
	 je1Leeco4JTF33xf9qp3hon+BgSUuix0Rf8PDkaPlr4BUxbD3YvOCaYsKafM3fxK9irnj
	 36kLUg3EUBTjxK3iK0aBaDHjjRxI0K9niM1zRnTPVsKQ+r9dlHOY4B41HU35J621YCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bRyaMDPH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD22606A326;
	Sat,  7 Nov 2026 14:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bRyaMDPH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712451F0089F;
	Sat,  7 Nov 2026 14:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061487;
	bh=n/P3nDQMGIJNu7KYLLNHxJOnXiYa5KQ8ZIi3VLRgD/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRyaMDPHVNw/5iIUoRRWZ9Z7jPUT3wRykFfj0FPDVss6CjBO6eDpdQEInrXAHJXWM
	 iF3P5K87pfqRxMaoaENo5PWHxjj2h5+olK314Nm1qSeCJcOjW4A7dsn721Ak9Ye7c9
	 CsNi6DHJ2A0l4MsZYprEjbo+Ew7A7wLN8BHzZVhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0545/1536] smb: client: require stable pages for signed connections
Date: Sat,  7 Nov 2026 08:42:41 -0500
Message-ID: <20261107135012.924407655@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 53c5c2c1095eb21e214811fec16cd75f89d72ee2 ]

When signing, cifs computes the SMB signature over the pagecache folios
in place and then hands those same folios to the socket.  If a buffered
write mutates a folio while a write subrequest is still in flight, the
signature no longer matches the data that follows it, the server rejects
the write with STATUS_ACCESS_DENIED (-EACCES), and the error is latched
in the mapping, so the next fsync()/fallocate() returns -EIO.

Mark the mapping for stable writes so netfs_perform_write() waits for
writeback to complete before modifying an in-flight folio.  This is
only needed when the connection is signed.

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ sashal: Replaced the missing local tcon in cifs_set_ops() with cifs_sb_master_tcon(cifs_sb) when checking ses->server->sign. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index a7142ce90ecd8..9307a2ad9e444 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -87,6 +87,8 @@ static void cifs_set_ops(struct inode *inode)
 		else
 			inode->i_data.a_ops = &cifs_addr_ops;
 		mapping_set_large_folios(inode->i_mapping);
+		if (cifs_sb_master_tcon(cifs_sb)->ses->server->sign)
+			mapping_set_stable_writes(inode->i_mapping);
 		break;
 	case S_IFDIR:
 		if (IS_AUTOMOUNT(inode)) {
-- 
2.53.0



