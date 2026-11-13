Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590856;
	b=J7ICR9nLk59DHaBjMtbajZwD1rjtLMYaOHuZxB2w/rFjwhOVsltm+w4880Gh6I/h9be5
	 PeaPQAqkJqToDtnreX35FggLTaTuSa3bFjT1vzmVOEbiTkNrfkkoApl3gXRRiC7i1smoY
	 bQXLgC9ACQSZTcKGJ4niw+M6EV1BDIF2Vq3X+4rVzuqur26/D0KyWQWwJFJ7i2vxa0ZWk
	 vLB9sfmVlymKICYtGws5vpuh/Za99Vxj+Abdbu3qqAvkI6+mgifaudPt8K6xS4ZtRD+01
	 ru3st1xt8ZbS/jOA86sgCwt/x9ABzXccW5CHaGwC+5/IpeBFmcvx3Whj0WCWc0U7w/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fKIC7MGBIlT6bUEIaK2m0eOaIh0Ct+b6htHMpxkCkx0=;
	b=nP21N0eJpnqppxaY+EZ1v+cTCZLuxrKcbFUm6WH9giI12XeCZnIf4F00JuFoB5RXE89W
	 G1nf/auflwZ+ykU6UMfqj2bAV9PMSVopSUN9FcV+PjgH5DGT4hQg6C47NdCwGAHvAtCfJ
	 tRDm8CL5Fhih/vGZHA3U+DHCIb/bGju9zXAHXtSDkTVbU8pCpCsdH7QIvXwBuZ4YihWbk
	 GtJOuXbCVHb7YnDvf17XIdVi8AoJNHGcTQoJRqYjznEGOcr4pixgrM14IaSN68JBahoFa
	 48ktBJtr31V5DH+VzA9mvJxtr5gZ5u7tmiMjDobRIuJm6Y5S97da4qeSWhaj5rYWN4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJeAcA1F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D871F606D49C;
	Fri, 13 Nov 2026 17:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJeAcA1F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA6A1F000C4;
	Fri, 13 Nov 2026 17:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590856;
	bh=fKIC7MGBIlT6bUEIaK2m0eOaIh0Ct+b6htHMpxkCkx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJeAcA1FzZuQWaDqPX8l3WijAbdIiKr//W5dC5oEEW1uRGeuba4vIkeCsPSjPasDG
	 1gPOf5Ek3CN9mIpZr97ZW6+GDR8Iy4l9fHd6TQneFzDMcDHaE0vKANkMY9CWCOmaj6
	 /9e0pfLITt6Wb17czpj8aHCq6sZN6lms/GoW/PRw=
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
Subject: [PATCH 6.12 015/670] smb: client: require stable pages for SMB compression
Date: Fri, 13 Nov 2026 10:42:59 -0500
Message-ID: <20261113153811.701361935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: replaced tcon references with cifs_sb_master_tcon(cifs_sb) calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 9307a2ad9e444..5db59b429fc3b 100644
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



