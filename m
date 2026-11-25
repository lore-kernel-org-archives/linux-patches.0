Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620237;
	b=Yo/qVg/fLkTNQbESBQ/i4xQoaRVeSK8x30WJFOpBFypVr9aoEYn9ECgbpg3SOp2UYsjx
	 6dOptGge3zNmNTmpwziFf7r8MAQQ8RA+rrnmT8wR5ZlFxk4T5un5WXO1s7iiSArXZrhIX
	 JO+iEWNwMNJBSTCKpBL8WLmLpySaZw6/GQ+0dInrKXksUh0S8A6AvsTa24QYHkEH03X6X
	 pMzKTh8uPBZBeq3aj9nfxp1/Lj4r9Wlw15idIicjtyOLx7P7eifVuEVrTaxZIxQsGbe3d
	 cOrD2/Mlthcqzse3LusZipHbCgbjsCQEoLG5smZqcZac64Barl3+Yuj5krMxzz8Bbag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hjAVjMLal40lwlizJEcyLizNMbsuvWabUaG92NjIe+s=;
	b=ouF64SoIeE1S+tDXbZB8N7QXJF44l87RJMtpK6RyBnrKVxz8tNTSJabEktwCSEgA6VqD
	 KsPIFIdOwgy6i/vLGc+fBZzbM1rpWpm4N4N1jl6MzPxIbMZfTwEWEeuMbhLXVSdiZ7XaC
	 Jm6AI++VwkC1vvKpGaxqbV2gFi48CTukZiwWJROuLscqBHqE48aq/0u3zokRPLTSi3G9B
	 ZfS37w2r4jqOjXbxAoq8cRnYylY312y5TX9zsLOWz9M1ORHa3i1BkOGuITNDDbKE3ww0o
	 fPt5pR6+DmxEUQWgZbSCtQxkywyWVb72H8EcSM1JUb6FEJHAgTg55LMfGKv2IzKZfJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OScdOTCY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DB7606A681;
	Wed, 25 Nov 2026 15:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OScdOTCY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C47E1F00A36;
	Wed, 25 Nov 2026 15:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620237;
	bh=hjAVjMLal40lwlizJEcyLizNMbsuvWabUaG92NjIe+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OScdOTCYigX4RWtMrgCkkDnUSik2spdUr0lp2HJyn70lZdq30XOuWpQ3xZlFTcpYB
	 Y73IobBVAm4KWlNUbwCCTl8HfBxiscdLnazOOWNV9lhITJwz/Y16dqQySTffRLr/vM
	 mQaTL41KQflE1PqX8ptmpmab/4lsvziVbQNM3yzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Tejun Heo <tj@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0854/1005] dm: fail a REQ_PREFLUSH bio with data when its preflush fails
Date: Wed, 25 Nov 2026 15:36:32 +0100
Message-ID: <20261125143841.714201439@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

commit e92cd41e8e5ee5616c6c7cd4378661d942f0a7c0 upstream.

For a bio with REQ_PREFLUSH and data, dm core may send an empty flush
first. If the flush fails, __dm_io_complete() still reissues the bio
without REQ_PREFLUSH and drops the error. When that write succeeds,
the XFS log keeps running and fsync() can return 0.

End the bio with the flush error instead of writing the data, as
blk-mq does.

Fixes: 6a8736d10cb4 ("dm: relax ordering of bio-based flush implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -983,7 +983,7 @@ static void __dm_io_complete(struct dm_i
 	if (requeued)
 		return;
 
-	if (unlikely(requeue_flush_with_data)) {
+	if (unlikely(requeue_flush_with_data) && !io_error) {
 		/*
 		 * Preflush done for flush with data, reissue
 		 * without REQ_PREFLUSH.
@@ -991,7 +991,7 @@ static void __dm_io_complete(struct dm_i
 		bio->bi_opf &= ~REQ_PREFLUSH;
 		queue_io(md, bio);
 	} else {
-		/* done with normal IO or empty flush */
+		/* done with normal IO, empty flush or failed preflush */
 		if (io_error)
 			bio->bi_status = io_error;
 		bio_endio(bio);


