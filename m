Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217071;
	b=RPGybEcgmfGdUsEyWUveBQJD1UgWvx2Lb0RsFSDmggYdZiX1z6TEYeNUei7vSgY21eiF
	 HhEqvJr/6h8CqZhxyzZj4JUtoufF4MDF/FmQlgegT1zWFgiKGC8KPzZ8OMTxV0eV/rxU2
	 2FbOOe96RC4PauSWAI+l4lNiiM6YPe7wmQyBt0l6b/BQAc+b/csOf/Pi5Kz/oSljWrwzj
	 sSPlU9Ro6bYCFsG8L39hM44IE5jRZu0OhqWQdxMiCjpoqIEsOw0IgNHprEjgblLeoK1uM
	 NsktH7aXP5OKmRVc13tU1oYTIz+TBkDjY9V3uig6SwlKRrBhU/iDccD7bdV/ltPNe4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wd1ZuqNvCltAWAc5kf8BJRwOTFrrtAyk177yhUklRvM=;
	b=EarRk/S108MiHZVbAl6z4TqnTz0LHWXH4VBmMPCn0bQNIdwwdNI7A4tsZ899sIv1W8CE
	 EEL+hhE+mJE9Pg6psN9BYiT9HJ7pn/aY2XzpbyrlV0Qr7zJFYrTvfDKlpWac9z5+vuzAM
	 6ZLwLHUUvNYCMM90kqlduKQbwR0B42tntDSzguG8QbIql6+RxZmopZ/9uzEVtkJMsd/uD
	 gabNeai2dz9JmWFJiKY9oGGM6Xir+5vppr950Yb7HnsfU6gRiKb1Ne+OUXt3BpTZHPwYe
	 HTFuYJ5pHGdtnH/ON8UBJ8vLaPIMyqaNqMwQkElpLYZ4JRJN8bCaRwcnXaPo5mBlWTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YBdtJ3rf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A19A606A31A;
	Wed, 28 Oct 2026 19:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YBdtJ3rf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37E61F01825;
	Wed, 28 Oct 2026 19:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217071;
	bh=Wd1ZuqNvCltAWAc5kf8BJRwOTFrrtAyk177yhUklRvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBdtJ3rfPEsHUYnkqzA5MUKCYYBfuMkd2rMs55lnTktbYFOgh1LCBEJawMvn5U3uR
	 AjysS+kI93RZKR+GB+7evXtYkeWH+2VUXJRjfF30pD347EtGSzIcXAzz1LP+se/QJn
	 09UCOAo+qKnhpXGc6Bf597JwN/LgW6dC6Visf7B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Juergen Gross <jgross@suse.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 1741/1887] scsi: xen/scsifront: Check for a NULL shadow entry on a backend response
Date: Wed, 28 Oct 2026 18:03:57 +0100
Message-ID: <20261028170539.073183921@linuxfoundation.org>
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


