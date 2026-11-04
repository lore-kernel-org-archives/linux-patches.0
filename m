Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831279;
	b=MY+FL4gOz9X14zDf2l6JrIM1ASPCDReauH1xdf10TOXbys9fcvWPgaae+j9wE7p845mi
	 Jb+eTXN9j/SA20LZaCbNSpkwPgQeN3u0OXbXQCW+SpjlHD/xi8SY8vai3e4d4/JWsjcdH
	 ss+ilzcCubk09h36bEUUMp7+nina17B/ciEhSdsgSpYvmNRXp+JHpVcIcU7DNzuNjMAu/
	 WEWn7HfE170CWzba0jMQs9JyNQ8bKSbvZ+kNuGkv4Z2cfLcbnUukkBiwyV0aqnWSQAaSr
	 I7KxB021C2aaEx/alR2cy227rLHHyMG68vr2NsQVOqNI98PCJ8pc1K2LbBd5l9/I5yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nVPznJKyp64HFwo87GfzQHIuNJD1Otx9zz/SIXctIHw=;
	b=vb5Z47seSzU3vwKepaDgV/W6A72WEBKjw68j6qLV8uMS+u4+IP4P0EHgp2pmKZMlWYVE
	 bpOtIfwc82ulkNOzYFlbASuycTzOo3YPP+DB9btFs5Ljb+iDyPXTUsFcC8NIOA9E6R5w0
	 mNS00Y1xV/YQJOlerN1qy//hDlUO4612P0PDYncfh2jTsQfFCisHN1Ou5G91kt/BH5M7B
	 8ge++cEPmRrxMvO0tfnwbwItua1b4I4keW54T7Q6THpilmc0m/7pUksz2TK0XQt/BoGg1
	 S+D3PG38I3WMOiXTtf5vxdXc/yq2R7q2l30h+NEEhkLJD6rkIuAYdW6tWDahvMdlzng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iagrm4BH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A1A606AC16;
	Wed,  4 Nov 2026 22:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iagrm4BH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213F81F000C1;
	Wed,  4 Nov 2026 22:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831278;
	bh=nVPznJKyp64HFwo87GfzQHIuNJD1Otx9zz/SIXctIHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iagrm4BHbB9NwAzbsFhpYn+stDwJBNPzLM2m8yOP4o8ZUHUeziSVvrW02JKUcZBv6
	 fkvBbJrzKAOjllielO4/89tPwS75p9Bahm6Ppwqd8OFNlhgC+iLS4k6k/br+WKVGnM
	 9Bgaeuw3mhFcoM4rBBi2C6pGmrksDC2NdMBtF2Cg=
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
Subject: [PATCH 6.18 0608/1005] smb: client: require stable pages for signed connections
Date: Wed,  4 Nov 2026 16:05:41 -0500
Message-ID: <20261104211100.878751459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
[ sashal: Replaced upstream's tcon->ses->server->sign with cifs_sb_master_tcon(cifs_sb)->ses->server->sign, because cifs_set_ops() has no tcon local variable in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 382e83735da28..7c638b8d5490f 100644
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



