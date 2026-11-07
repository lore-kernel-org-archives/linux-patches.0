Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061605;
	b=cO0Bj8v7yRdBiLHTr+bH13c70f/aCJgxNSN5p9byrYAwHAfiHUBu4NMBL4hFZNE7I/+0
	 YpyQ3OvPQtAgdGKMyMDgI+en+ASUvgrVS/8PLPkDTmG2akT1voN0xmxZQ1gICgdx4vi2R
	 +DmEJS8cv0LjNn30aw9ehpgx/AdqWbkdiWWJkW6IZhwxe/9W0Ig6Q0k+tuDurMpWuSnMi
	 d/1Dbywm7X8wbbzeI3Vw1FqUTZlUDbsdzZOOJJkgq7NK0nX4K5YC3+QjTHB+cdZWNisg/
	 vWvr9Lf0aVn6xtDy2nY/TC8G5kaivw27oJA3lZJJyB3CgvNFBmNBOxKB0fec5yB86Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iQGZp7LiVqkW32BJa9p/VU3pRmFkqJxapt7caYxiEGY=;
	b=nn/5PIAqCobNIyGVQhXJsPQ9g/LCB/Uk7/+PecPQIR5LCfApTODQxtLVKOCpgI0qy9Hu
	 SPhxg77B/jOxWDSAuXpLXXPof/OKJ9X7UeYcnlGJmNcnoBK3DCymPhpkttBJGPSfEhjeZ
	 FIEuFLZrwIC/UQ8T0b2cItC+s4QXUcnd9qdzPeCxKAQWGOWpCvKygZc66zYDmqOmMImqg
	 R2XkQYdk4buATLvU0iX8B4UC+BrAw4j/zE3QqXmtNGMYrDdytyamxfzhbHfrLDT5S2xpb
	 37ICb4gyYZAI/GJF+IJvqNGWq1T0pLbT9zvV9T9jdGKZi/7EhqUH5voyzOCW0V7G5qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=asXDuQqQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6B2606A32D;
	Sat,  7 Nov 2026 14:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=asXDuQqQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672CD1F008A1;
	Sat,  7 Nov 2026 14:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061604;
	bh=iQGZp7LiVqkW32BJa9p/VU3pRmFkqJxapt7caYxiEGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=asXDuQqQZrvz3zoNe6FPU/9wPHE+8WsJLW3Q4MYNN0/GkGXD8Xc2lxENoP4/Cz0YX
	 89JaQK5+AhElaXcvk38rEKww0foBxzJeUw0mFtpihUmFC4DNZpFzJg5jbpX+74W3bT
	 4ClTZXpfTwqPKhPPB3LpCIRPtsdX6SvYrPL4cccM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+24c7c12d69e63c6d@bugs.sh,
	Weiming Shi <bestswngs@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 0677/1536] smb: client: stop processing a read response after a receive error
Date: Sat,  7 Nov 2026 08:44:53 -0500
Message-ID: <20261107135016.497168354@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

commit 51efca72345acdbedc4af76782d464bd15ba50ff upstream.

cifs_read_iter_from_socket() may call cifs_reconnect() before returning an
error.  The reconnect path aborts pending mids and invokes their callbacks.
The callback can then release the cifs_io_subrequest containing rdata.

cifs_readv_receive() nevertheless continues after a negative return and may
dereference rdata in cifs_readv_discard().  KASAN reports the resulting
UAF:

  BUG: KASAN: slab-use-after-free in cifs_readv_receive
  Read of size 4 by task cifsd
  cifs_readv_receive (fs/smb/client/transport.c:1284)
  cifs_demultiplex_thread (fs/smb/client/connect.c:1355)
  kthread (kernel/kthread.c:436)
  ret_from_fork (arch/x86/kernel/process.c:158)

  Freed by task 148:
  netfs_put_subrequest (fs/netfs/objects.c:267)
  netfs_read_collection (fs/netfs/read_collect.c:460)
  netfs_wait_for_in_progress (fs/netfs/misc.c:462)

Return the socket error immediately, as this path did before the iterator
conversion.  This also avoids adding a negative length to total_read.

Cc: stable@vger.kernel.org
Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Reported-by: co+24c7c12d69e63c6d@bugs.sh
Assisted-by: LLM
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/transport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1852,6 +1852,8 @@ cifs_readv_receive(struct TCP_Server_Inf
 #endif
 		length = cifs_read_iter_from_socket(server, &rdata->subreq.io_iter,
 						    data_len);
+	if (length < 0)
+		return length;
 	if (length > 0)
 		rdata->got_bytes += length;
 	server->total_read += length;


