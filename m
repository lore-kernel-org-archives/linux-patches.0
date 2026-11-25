Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619640;
	b=UOy0LiTe3Jvb6bhA0eEVEKH6jUSBpl2y9h60qEWaqxEUWcXX6AQmAmyPGq+kIjXc3n50
	 EI0dAZBsnB3i8DeU4QrQTtMbr4I8qPBdGXSojz+f04AxX5iFEarb4ePvMC7sKibwDFSxa
	 b7WpHEpeQyLFpsAmDb88RU6+uIPLtJJZXh+3hxyQurChgllk1U8X+T8Pxdsp0F5aMd0/I
	 9K+NQmMGlEXorIj8SEg9yGWbqSzRxI/G6EA+4eSNLG53dvzjt0a6J0sq8dWf3hftD5ZIt
	 byCUfqS2ppYP4byPZnj0xEjBmgOHsGCFhMuYs2yRGgwdhGGiesu1YiZZiCFOIAwCuCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ORSFNvAdWpeKqYk176FErm+98/Z/1/nwZVo5NpWl6eU=;
	b=e47wrJNl8SR06Mko/aMKYFzpRjJGVMcKtG6TGexa2CiHQQFdVQwMGg8Uzj1RCvxpn7eY
	 UFbTCr16xqt/WPdTqlSJ/69B+vjMyUyvDr0i885v2fJQncMRZAmtXIMwts3IZFt1UtHcg
	 sgB6lHVkneAI7MrSs5jy/d7zNCUZRxHPF8+/euqk+zs51ja7hqZYdABd4jBpuT057ylGD
	 1edP4wW/jnkBqcCsfc3XHnAO/2sWqkeNbqovTUM9x8RdfV6J/mb6YVYTJ75aUw8HjBP+K
	 KNIN3Pd7oEktWaCeXvZ7amNdWy5ppI8jCo7E6hY4twRIVlwOpVPkj3eIrG7eYQVbdxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TkH3rWog;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC3A606A31E;
	Wed, 25 Nov 2026 15:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TkH3rWog
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245141F000C6;
	Wed, 25 Nov 2026 15:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619639;
	bh=ORSFNvAdWpeKqYk176FErm+98/Z/1/nwZVo5NpWl6eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TkH3rWogupR/nUVeYaOKa+Jof0EwD6k/D0q0cqMclMgZm+6jtNN8hQbura8FhGsTa
	 KGVzNzms1KTrJ9IMoHH3pPdcYnyPT+ekobxwVL8VJ4WhKrIMaJyZ2YwZoHWwxTqGaF
	 wZhypEs2+fcV5GprUXv8lvXMq/Fj0VYJjVlvKamU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0663/1005] netfs: keep the prepare_read errno when abandoning read retries
Date: Wed, 25 Nov 2026 15:33:21 +0100
Message-ID: <20261125143837.279951067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

commit d88a0c3a96fd6d7228d04532cecb23f23676aa2d upstream.

When ->prepare_read() fails while retrying a read,
netfs_retry_read_subrequests() marks the subrequest failed and abandons
the rest, which overwrites the error of every failed subrequest with
-ENOMEM.  The reader then gets -ENOMEM for e.g. a handle that couldn't be
reopened (-EHOSTDOWN, -ENOENT), a credit wait interrupted by a signal
(-ERESTARTSYS) or umount -f (-EIO).  The first pass doesn't have this
problem, as netfs_cancel_read() keeps the errno.

Record the errno of ->prepare_read() in the subrequest and keep the error
of subrequests that already failed, using -ENOMEM only for those
abandoned while still waiting for a retry.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/read_retry.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -28,6 +28,7 @@ static void netfs_retry_read_subrequests
 	struct netfs_io_subrequest *subreq;
 	struct netfs_io_stream *stream = &rreq->io_streams[0];
 	struct list_head *next;
+	int ret;
 
 	_enter("R=%x", rreq->debug_id);
 
@@ -140,8 +141,11 @@ static void netfs_retry_read_subrequests
 
 			/* Renegotiate max_len (rsize) */
 			stream->sreq_max_len = subreq->len;
-			if (rreq->netfs_ops->prepare_read &&
-			    rreq->netfs_ops->prepare_read(subreq) < 0) {
+			ret = 0;
+			if (rreq->netfs_ops->prepare_read)
+				ret = rreq->netfs_ops->prepare_read(subreq);
+			if (ret < 0) {
+				subreq->error = ret;
 				trace_netfs_sreq(subreq, netfs_sreq_trace_reprep_failed);
 				__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 				goto abandon;
@@ -222,7 +226,9 @@ static void netfs_retry_read_subrequests
 				part = netfs_limit_iter(&source, 0, part, stream->sreq_max_segs);
 
 			netfs_stat(&netfs_n_rh_download);
-			if (rreq->netfs_ops->prepare_read(subreq) < 0) {
+			ret = rreq->netfs_ops->prepare_read(subreq);
+			if (ret < 0) {
+				subreq->error = ret;
 				trace_netfs_sreq(subreq, netfs_sreq_trace_reprep_failed);
 				__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 				goto abandon;
@@ -258,7 +264,9 @@ abandon:
 		if (!test_bit(NETFS_SREQ_FAILED, &subreq->flags) &&
 		    !test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags))
 			continue;
-		subreq->error = -ENOMEM;
+		if (!subreq->error ||
+		    !test_bit(NETFS_SREQ_FAILED, &subreq->flags))
+			subreq->error = -ENOMEM;
 		__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 		__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
 	}


