Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829024;
	b=YPv/KXkR+RoaYxhAcRdBfwiB/OMqW4u7MpAbepl3Dp5zajWBr9FVb5s1DEOrsiMTXZrV
	 GGLQFpSXv7PD9hvfQw+w3q6J+XjXu3hNngqjt/Uqrb+ujhAboebRQ2haY0tero1LNvGFz
	 hdpo/4BA2ucrDeSng5wZJYkUtq3k2TfIz2zjXr0VrO/4UsQ5ohqti5LNJopBRZYEqKpCz
	 KyrAJe7PjE+/bZXEAUuRZ2APdaFkVViHTIM8yZaJesfHsDb2TvJLfQUd8DlQiXZMhaz1X
	 2O2Kwfg6UMnLX8csze+UwJpDXt6uE79/kdh7htWJ4TSTizyvIOsmZtLDae07u5miDSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8vbANA8fjv8NiH9w9A/KBxbr666JMsu8M/I8JA86ucY=;
	b=ImPgXwd/cKPHrD4A5+luRm4neekdK9fCBWdOICFI68K60GrPq38Q73pGjmOGz4W1ofnd
	 4+oXTLLyw79hSXN9idYEKAm+eXi8xzF883x5+ddfRDMODIWfnxLKWLZDCOtotfdXLgGnw
	 0L0HNUXgmMM4sDHijofLZaGwFxbZaRugzZyJLFXyNW2O7VJoKeGEVlM8VyTFJxWvLQOk1
	 yhUOKfnyjt/I6u/8LPRTOBCHYB9Wh1nnqUw9Xjwb0tQErexuFjbsR4fHI+gd93+WUMoUV
	 r5NH8ZUTdtqXUXPnJ/R5f55L/pIzr2BNhzXqp5jhcZ9zkd6JcpNlUNLDYck3CXWbPUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QVa4RHgl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FCC607074A;
	Wed,  4 Nov 2026 21:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QVa4RHgl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA6B1F000C1;
	Wed,  4 Nov 2026 21:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829024;
	bh=8vbANA8fjv8NiH9w9A/KBxbr666JMsu8M/I8JA86ucY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVa4RHglo/3ieTOu6OQeb+BwTtHqrrBAPJ3Xm2MJxyPwrV1o6Myt9igxNoUxCWrqz
	 eup31czkBOz8IvxYoHJ0Yzl+hKtIaamO2fN2h0gxRC+imfmbITQGQsZubnfKJVxAQp
	 bQEQyTuty71GbvoyywXCIDFnR/KIU3Te3IhPmFBg=
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
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.3 388/547] smb: client: require stable pages for SMB compression
Date: Wed,  4 Nov 2026 16:09:32 -0500
Message-ID: <20261104211049.322544738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

commit 8667061cf99394526dd9c0ea2662e6bbc7ae7848 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -88,7 +88,9 @@ static void cifs_set_ops(struct inode *i
 		else
 			inode->i_data.a_ops = &cifs_addr_ops;
 		mapping_set_large_folios(inode->i_mapping);
-		if (tcon->ses->server->sign)
+		if (tcon->ses->server->sign ||
+		    (tcon->ses->server->compression.enabled &&
+		     (tcon->share_flags & SMB2_SHAREFLAG_COMPRESS_DATA)))
 			mapping_set_stable_writes(inode->i_mapping);
 		break;
 	case S_IFDIR:


