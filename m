Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035410;
	b=J3R8O024Ogj5K1FTj8JjBOUnodNqvP2D/filNtSgdjMq4FpKhVLKXsv7SIg9oGu261w9
	 sqSyTrgMW9qVg/W7lzeCDOXD4DgfkRBoI5Z4c9nEyvK7w6nqeF/DSh2ByW/TSX4XJ0bkj
	 ID4DRHO2IXDIa0WMras+9JKjKCqCtkGBSMsnFCLLMTNoCb7KrmbQL/GolcULKhleUtt5c
	 6+RgIZKl+960ut40WieZQhskTX6xxjSVNbq+1zmwGj1V8FDeJ/TUlGd0dc/VJMcCi4Gdb
	 WHARTQ9J/2iRj0lRoG18pWC5Bez8YUc/gImdOIyHQf3MdkUmFgNPhAnwBaeqMo/eBdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=itMzT1U8WfpR4IBANscACbRu4bQEWUyHa6xGJ9hXJVo=;
	b=U9iCCp+iR+BwvsNYWxsCMLVg/VscEyR9S/qwtiG6yLpI6a9Usia3FZuB0tHX/yJGdRcZ
	 aZs+pgwItLMOV+qh76V+7ELyOANZ4eoz+D0wpALMu1Nrn6DefetEVEC7BGrSOXzMPNa6D
	 QOjV9hBWPw0G+FBJz84C79Ry0Jpy5xCGPkxF55mn8oFmeOWGHEn5fiYYYljArRdetjrYZ
	 tVFwNf792zOwecuQ0gbHC+SfGObkdQBxqMMrUyM4acekloBJ/wFvOoIm199vS8cGlxBaj
	 QKtaMOc4uRmSpZ5qP49Abi8fQZK/HPrzBIan6VSLOQAoV7DSHy7OTWS7XpQKcFvUK1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eRFtHDEn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B570606A31C;
	Wed, 18 Nov 2026 20:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eRFtHDEn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBDB1F000C4;
	Wed, 18 Nov 2026 20:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035410;
	bh=itMzT1U8WfpR4IBANscACbRu4bQEWUyHa6xGJ9hXJVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eRFtHDEn15YzCEaf9toeowz+BB3Y6Fqq2XiWdHpGzDDqJ0DoPhH1BSLO9mvxOHasu
	 dKB00n53+6RClvlTv/WcXQgNqgduaIeqpKWMN0XKmUztuqowpSgvP17R4RPvFtJSbR
	 mOYZEVcrcab6AHI8Mwesqicke8NXDt2yZD1+9mT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+24c7c12d69e63c6d@bugs.sh,
	Weiming Shi <bestswngs@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0647/3318] smb: client: stop processing a read response after a receive error
Date: Wed, 18 Nov 2026 15:21:09 +0100
Message-ID: <20261118150337.402899563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1862,6 +1862,8 @@ cifs_readv_receive(struct TCP_Server_Inf
 #endif
 		length = cifs_read_iter_from_socket(server, &rdata->iter,
 						    data_len);
+	if (length < 0)
+		return length;
 	if (length > 0)
 		rdata->got_bytes += length;
 	server->total_read += length;


