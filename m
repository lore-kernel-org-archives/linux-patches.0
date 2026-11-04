Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831525;
	b=IDS6JqZ7mQV0GMLjBL1hJqvE4XCmcmOrcekXPsKCtRV/6na7NEMRUCojGpGXCUWEXshz
	 QVHU0mVDaGB983V+UctFeyG/dOF1j2N7X69PlLgrk9ecp91mp+8SEKgfgE6Ut1fVom6l3
	 JzZ3w/KmAj+L04aL1szEmPWBUzvk5hYCyaNC15rTtyTNG1Z0u4cagYbDCsvLTQbSu67E3
	 Uwjk4QN/uBQ8iEZfn+BycavCLmL/lSH4deWaZhnKF1drqeefpNDnwsL4W/XJh9PdJolDl
	 lewJFdLlf8UUlzFL939HWhsyVpebsq9TrQVtueBa3xey8dbkRvzFCgiR8D5hK64c85A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GJA6m1Nalr7jf5uJRsYcf1fwQLy/WeqaMCQlYo5RzFI=;
	b=jvs66VJ6ix9MPtLKKMSCP2CVphiuBi057aIaCaUu0dx1RPjX7z0N45bA+Cwlm+ie29+w
	 meHa+WzNIJKYlhF45hqcTO534TBm0LfxtCZbjhLaHv+n1fB4Iuj8Cxr/EMOb1CeTq9226
	 GR9BbdQ/Ud0hIBJ8JLoHtDQxZq3JPIdW9Ou8Wnw8LzLQkZfUWcxIYgaHnVMA57WBUBXUi
	 BxgYkW8woSyrKiDkW8aFXKirqMZLTjzKtemWjvNYFdscPF/nH8noLv8VEV/WKFhdezneM
	 c825bEW+zGq20u/o1qKYbXwst9UHYYwrPPWgR1cNl8ePitIv6+ELxinvYUxq/Mzd0Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PposN4aG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699B6606A33D;
	Wed,  4 Nov 2026 22:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PposN4aG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054811F0093A;
	Wed,  4 Nov 2026 22:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831525;
	bh=GJA6m1Nalr7jf5uJRsYcf1fwQLy/WeqaMCQlYo5RzFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PposN4aGRZnc9SdplgQ/nn00jxrHDXW/FMyQgRBd7KJtsEiPUJwiD9JiumY6+zgK7
	 LbI0Q7kQYbB4hxDUXaVHJ2B6VC/NJKUtahrDCK8ciEVdEAiSQr/eempVCQoD9s2xwH
	 k1ivfK3f4aOeleknGamh64HIyzWdcBy+MEx00mcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 0718/1005] iomap: dont resubmit an ioend after ->writeback_submit() failed
Date: Wed,  4 Nov 2026 16:07:31 -0500
Message-ID: <20261104211103.644309592@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

commit 3f517370076f1fedaa38cd8c78ceb73616b79336 upstream.

iomap_add_to_ioend() submits the pending ioend through
->writeback_submit() before allocating a new one for the current range.
When the submission fails the helper completes the ioend with an error,
but iomap_add_to_ioend() returns the error without clearing
wpc->wb_ctx.  iomap_writepages() then submits whatever wpc->wb_ctx
points to, so the already completed ioend is submitted a second time.

For XFS the second bio_endio() lands in xfs_end_bio(), which
list_add_tail()s the already linked ioend into ip->i_ioend_list.  This
corrupts the list and leaves a use-after-free/double-free window against
the ioend completion worker.  Reproduced with a fault-injected
->writeback_submit() failure on a reflinked XFS file with several
CoW writeback ranges in flight: the unfixed kernel hits repeated
"list_add double add" warnings from __list_add_valid_or_report(),
the fixed kernel fails writeback cleanly.

Clear wpc->wb_ctx when ->writeback_submit() fails.  The old
iomap_submit_ioend() cleared the context unconditionally; that clear was
lost when submission moved to iomap_ioend_writeback_submit().  The final
->writeback_submit() call in iomap_writepages() needs no equivalent fix:
it is the last thing the function does before returning, and every
caller allocates its iomap_writepage_ctx on the stack for a single call,
so wpc->wb_ctx is never read again afterwards.

Fixes: f4fa7981fa26 ("iomap: hide ioends from the generic writeback code")
Cc: stable@vger.kernel.org # v6.17
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/90fbd42df4f51306e57a95830d2d53873f630eb9.1790342457.git.parri.andrea@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/ioend.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -187,8 +187,16 @@ ssize_t iomap_add_to_ioend(struct iomap_
 new_ioend:
 		if (ioend) {
 			error = wpc->ops->writeback_submit(wpc, 0);
-			if (error)
+			if (error) {
+				/*
+				 * ->writeback_submit() completed the ioend
+				 * with an error, so drop the stale context;
+				 * iomap_writepages() would otherwise submit
+				 * it a second time.
+				 */
+				wpc->wb_ctx = NULL;
 				return error;
+			}
 		}
 		wpc->wb_ctx = ioend = iomap_alloc_ioend(wpc, pos, ioend_flags);
 	}


