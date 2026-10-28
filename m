Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215740;
	b=f9RdOt6p3vtCYwqb14lk4xN/1hJdj9zZ0xhe7D1q0uYpEXZFimYyZkDsjDd3U39OOq9Y
	 Bt6JXLeBFGC3vq2s8g0NAeHj6G4DLLkNc1DGXO+VBZOWYVdFbipJRiF9SkOGPNLQIhGJt
	 LF70/xeVZkEtepmdVTTJRZ5PSfaI+RBCWgWNv8egVsclOwiamH5QZy5GBK/Lp2H5UJ9FB
	 NanCNvP+Wj/4QeUn+TvSwxART6Pwck/VO2EsJL7YY+1QiHzcRXxc9eQB80Ye3eyvdo71Y
	 TrKFnL1up9j1GKb2kEVgxsM5HeDMHkbOZ2zvmjO/TMXk0DWkxkaywcwJt8lnFN5RiVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HSngYjOQ8qemhrFnUEhk+BgGij8LNEukyL7si0Yqgvw=;
	b=PVNyitHlmIFtjic4w5MmPSsoW5MMdLZh6VInalNfsDMJ+ymdI3K2P+6eXDVczmRZ9EMb
	 KUF1Yz/6YWZMbkNMGTXOLa1rFOxJclwQa9abdR+J3Ys8cfWfmOn4SjSqvdlMYQTOVuAxN
	 87RzIL2jltIZrLDg4bmIwh7hklc9hlCYc97Zb1jQNzg5LsNLBfdbEbUhgAft4mQ6SSuoE
	 D8oc744DfaYp4Hcl2ojnFeXo/iVDCt0ZBrdvBAqblWjjbi0X4YRO4Sz+Uc/AtF3k3C2ok
	 2vjHCNfC5WlJBfjpFkHIMaa2P6vmgZehuehT08PbUIokwXNQHchlRv99nGMyW71H11w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="B/hbkPVd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0AD606A31A;
	Wed, 28 Oct 2026 19:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B/hbkPVd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772E01F01825;
	Wed, 28 Oct 2026 19:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215740;
	bh=HSngYjOQ8qemhrFnUEhk+BgGij8LNEukyL7si0Yqgvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/hbkPVdo1RC9fxoU8x4GUwdZ6cioc1LWwQAcMaaLN3ixJy8rkxBKsMLtPUk9rxy3
	 XZoj3eIku7Quoz+rqt1WOx1NsCBKueMfuO4m040r6L9Ao0tlof22irZChgCKeTfovZ
	 9r5H3TzZVZiYHnzr54W27o/YUNweyy6oCi1I/kzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1314/1887] s390/vfio_ccw: Limit the number of channel program segments
Date: Wed, 28 Oct 2026 17:56:50 +0100
Message-ID: <20261028170529.330265037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 5405c90d6a47b3014e74ee0618a162449abbbc93 ]

The processing of channel programs, and the CCWs within them, is done
recursively. As such, there is an arbitrary (but not architectural)
limit to the number of CCWs that can exist in a single channel program.

The vfio-ccw logic breaks these channel programs into segments whenever
it encounters a Transfer-In-Channel (TIC) CCW, and the combined number
of segments count towards the global limit. Impose an equivalent limit
to the number of segments until such logic can be made non-recursive.

Fixes: 0a19e61e6d4c ("vfio: ccw: introduce channel program interfaces")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_cp.c | 6 ++++++
 drivers/s390/cio/vfio_ccw_cp.h | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index e64ac6e9b2911..3a234cd20cfb0 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -376,6 +376,7 @@ static struct ccwchain *ccwchain_alloc(struct channel_program *cp, int len)
 	chain->ch_len = len;
 
 	list_add_tail(&chain->next, &cp->ccwchain_list);
+	cp->ccwchain_count++;
 
 	return chain;
 }
@@ -478,6 +479,10 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 	if (len < 0)
 		return len;
 
+	/* Limit number of chains in a single channel program */
+	if (cp->ccwchain_count >= CCWCHAIN_COUNT_MAX)
+		return -EINVAL;
+
 	/* Need alloc a new chain for this one. */
 	chain = ccwchain_alloc(cp, len);
 	if (!chain)
@@ -709,6 +714,7 @@ int cp_init(struct channel_program *cp, union orb *orb)
 			vdev->dev,
 			"Prefetching channel program even though prefetch not specified in ORB");
 
+	cp->ccwchain_count = 0;
 	INIT_LIST_HEAD(&cp->ccwchain_list);
 	memcpy(&cp->orb, orb, sizeof(*orb));
 
diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
index 54d26e2425334..5c51d1197ba98 100644
--- a/drivers/s390/cio/vfio_ccw_cp.h
+++ b/drivers/s390/cio/vfio_ccw_cp.h
@@ -23,12 +23,19 @@
  */
 #define CCWCHAIN_LEN_MAX	256
 
+/*
+ * Maximum number of chains
+ */
+#define CCWCHAIN_COUNT_MAX	16
+
 /**
  * struct channel_program - manage information for channel program
  * @ccwchain_list: list head of ccwchains
  * @orb: orb for the currently processed ssch request
  * @mdev: the mediated device to perform page pinning/unpinning
  * @initialized: whether this instance is actually initialized
+ * @guest_cp: copy of guest channel program
+ * @ccwchain_count: number of channel program segments (linked by TIC)
  *
  * @ccwchain_list is the head of a ccwchain list, that contents the
  * translated result of the guest channel program that pointed out by
@@ -39,6 +46,7 @@ struct channel_program {
 	union orb orb;
 	bool initialized;
 	struct ccw1 *guest_cp;
+	unsigned int ccwchain_count;
 };
 
 int cp_init(struct channel_program *cp, union orb *orb);
-- 
2.53.0



