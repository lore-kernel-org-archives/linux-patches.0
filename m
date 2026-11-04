Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831595;
	b=KlI8tM9C/GCBL81HW4OHKHp6qD/yjU9sRBUlEyk6lFTssv88atsfHQ3mshOTxFeSrH5i
	 +mvLAGF+Q2gfG/ZQ54XbW4BNwmF8M4WGUIsXRIKlRK2z+PewT+XbyMAJ8rn9dKZy3fzd2
	 7piu618pzQ70rsde57WVA2zqSeCRTj1C26f6iTLJ3c4AaC0xTWr4eha8J0rrQm/xDI2ST
	 BGAk3C4DcTzJjst7780b2eLEiYUid7LymXlhc5HXZCOYQxQ9/scJHFDEAgohGMtKnQdSj
	 5TMfQNI8VpksW9OH7JoPvod5tQwYVsc4ZKAIwx4CGsgPdLvEgC3DGZ9mL6Cf+m7gF2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lxp0ZPZWQ1Q+u33RKfRpYOklmBgwOvzvZspFYnP9Fg8=;
	b=vPPXqJdqT0E0g8+O4j+KbUKc05Jv/qerkpJybZgb1feMt5RaFE//Eqm/w9xCGl233N7a
	 /58tjZN0uAyUY1c44BlhLacG48WRNMDgRXbZFzDYHqa2KF/pZRkMrepl1i0h2pCyP038H
	 DiACm2U/MlflyBNPkCS3ZkKPnK5RKxRGuClQIajiUzcj9+5R24r1vT4QVGcCC20ID+DND
	 TonfN6CKITJ3nvpnrfZa9dvTaamTcYVOR1DXh7H03/ugvGI0aEvuUi1L3JbXho/3dH7Av
	 LQ1egAutwvqmg+ZKixJCBR5tcYAjLmbO+a0DGpbTChho20LS8XEAErrDJtAXvxfc0ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVWCSx1k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CD6606A844;
	Wed,  4 Nov 2026 22:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVWCSx1k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560AA1F000C1;
	Wed,  4 Nov 2026 22:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831594;
	bh=lxp0ZPZWQ1Q+u33RKfRpYOklmBgwOvzvZspFYnP9Fg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVWCSx1k4gVVR+tQh/791FsPGugO1fiek25O2/KsCFU4tf0ty6YiqvRAUlJQNoAf2
	 RqCJpb0W/UdJzIwDKAXo1fdPJTK107jmSdebQT49QMKTwZ22bxfUxChaDIspTg3eOi
	 /XO9IJbucoKoHo+cexE2/I6V6H+fSKTPUw44FQbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+24c7c12d69e63c6d@bugs.sh,
	Weiming Shi <bestswngs@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 0760/1005] smb: client: stop processing a read response after a receive error
Date: Wed,  4 Nov 2026 16:08:13 -0500
Message-ID: <20261104211104.716369336@linuxfoundation.org>
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
@@ -1312,6 +1312,8 @@ cifs_readv_receive(struct TCP_Server_Inf
 #endif
 		length = cifs_read_iter_from_socket(server, &rdata->subreq.io_iter,
 						    data_len);
+	if (length < 0)
+		return length;
 	if (length > 0)
 		rdata->got_bytes += length;
 	server->total_read += length;


