Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207705;
	b=smfd8INL0MkHR50o7u3KIjWNdofN3R/5cSACETWEAbkA3S4aVYVpE21PlpcIoRmKJ8e9
	 O7ImEhnG+/9I9aANFGu/oqTn6A7sEumZF/oSp+iP1PLNWk4TEUd57BayFkde6KlMjNz15
	 mZxnR1BGlXW+7+VKWShS2HVym8qZCvyp3iD2ZXRkYYe4Ra+8s9LXkfxTbMHDEiIOgnQe7
	 PYQNi3tmh3ocw3IWwVgDaCSjg2R1cmQklEYEvZ/VMjuCAzKXy1AP3eXdaEBO2mxv6cLyq
	 P2GzAUzsvf7xde5Sl1qUAnqr5olEmjkO6TmKuTnvzpyryOJwLpOVQ7fbpHtW6ImV7ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xyk5f3X6Mnt5ZVhyk+sH0M8DHBpzPB88Ck0g3lDqGXg=;
	b=4gOgX+jB/YFvtOclDTkN1jzFxXXoYCDJneaPqufWRKqB1sYFu0nw/52BQ25Vl5LrrRmr
	 WuUpTox3VPdhxs6/8hLW7lsZjEf4IaF7y4gzxngKfSqUVyJGIVhuIRFmMuzj0nEnNRyJq
	 UEtfgE2z/ldMyJjYk8bvmvpyWUauot6z3/aJ9PD2x9JsDGYBjQVa2wutrd0RPSnMtArxZ
	 fYPmhPNAraocfLcidaIXbyLOQo5kajyhFSr0s71cpPBKRi6zU4i4pUsMTqkqHAVPmG74Y
	 tk8S/eUGLI2I/dYxUdjPdB3Oa4B4AqBflJUtMPaRpl4QeuTdOuc+0JU5iPpgWApjn3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2yGQ1+d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B612F606A329;
	Wed, 28 Oct 2026 17:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2yGQ1+d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F4F1F01825;
	Wed, 28 Oct 2026 17:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207704;
	bh=xyk5f3X6Mnt5ZVhyk+sH0M8DHBpzPB88Ck0g3lDqGXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2yGQ1+d1RgAXD/81dLQIG5X1thN6TeWQqfKBQDldl+RUArNX4LfE3BSexQEzxXAR
	 2v1Mfxh1Y+JHaniBtk77/tzm3I+tOecEuayb49yn0BhZtxhxDz8MLz9PliWzxYD+Hp
	 7HJzEw3M6leQ+LK/nMonLhF96oQjQCVC63fdn4jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Juergen Gross <jgross@suse.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.12 083/247] scsi: xen/scsifront: Check for a NULL shadow entry on a backend response
Date: Wed, 28 Oct 2026 17:58:06 +0100
Message-ID: <20261028165949.359752434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit 8c8222c255772713eb36cde695777a1fce224917 upstream.

scsifront_do_response() validates the rqid in a backend response against
VSCSIIF_MAX_REQS before using it to index info->shadow[], but then
dereferences the entry to test ->inflight without checking that the slot
is populated.  Shadow slots are NULL before a command is submitted (the
host private area is zeroed at allocation) and are reset to NULL in
_scsifront_put_rqid() once a request completes, so an in-range rqid that
does not correspond to an outstanding request makes the frontend
dereference a NULL pointer.

A malicious or buggy backend can thus crash the guest by returning a
response whose rqid is in range but not in flight -- for example a
spurious response before any command has been issued, or a duplicate of
one already completed.  The ring has only VSCSIIF_MAX_REQS (16) slots,
so before the first command every in-range rqid selects a NULL slot.

Reject a response whose shadow slot is not populated.

Fixes: 6d1c2f48f3fc ("xen/scsifront: harden driver against malicious backend")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20261005123555.253995-1-yhlee@isslab.korea.ac.kr
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/xen-scsifront.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -367,6 +367,7 @@ static void scsifront_do_response(struct
 	struct vscsifrnt_shadow *shadow;
 
 	if (ring_rsp->rqid >= VSCSIIF_MAX_REQS ||
+	    !info->shadow[ring_rsp->rqid] ||
 	    !info->shadow[ring_rsp->rqid]->inflight) {
 		scsifront_set_error(info, "illegal rqid returned by backend!");
 		return;


