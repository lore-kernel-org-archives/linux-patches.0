Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210167;
	b=UxUgdEHAu0tAOaTBLpAkCWoQRru1W5K17FnG6ONb9GYSAhAnPEY14WFdLPH9MUHIj12i
	 /OhcwuPOZKaOJcbiyYNukVOtvKs2+jox+/czBnsx4TulpwUma6xzo0hSCMbDKqeDpkC/6
	 so3FUHvTwLOjLS9NjJ11b6JMRW2VVfe+Qj1XQ4L+/zva/hyqQ/ppYuq0MA6YXN0ePijcQ
	 pCE7K7OiHWZIhl4hyHaTMfy6NSOw0mnfhKx+Z2VcQrMyLFUHh95M7EeGgclCNR4bw/gTS
	 glKmu6TWm8JAHj6L47zNoQSnSnnaVbkvgvwOMXjUSYLXiBf+4ze7kpt7pm/4JwKGzwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=371N67Ten1H435RkI9FIOlmIVzj032DSpRfvaRUS69Q=;
	b=OWTQo9OykpmmBlqoRX3y2O93Gngg0BrDPmdoeKoBBkbzZJ/53hdxhsDUhi3TxKirA5sR
	 R8cI/IC2HN8Z5s6fULuI/dgQlaGASElWcJAZck0bfKW4dGsTrt+b1xDBW082D3UZN+a42
	 odgRJVzKHlSe7w9aGkLggZSr7VMCsADaFNV0s66VP8b32wX3uSxpArlAt8UQUbkKBmYk2
	 FQPfoiyE3heQlCS/710b37FzW83xeUWMw5eWkHzwNZ+0+diJTgZjYSlX2Dfz/xErwTUKM
	 vUpSIGAy5YVEsGLvRxPewNiMpaNWsQyG51Ezv3XUQx6DMg5KVSI0RgDZCPa4GhMW9EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aIzGOpRY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC6060A381B;
	Wed, 28 Oct 2026 17:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aIzGOpRY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFF51F031E5;
	Wed, 28 Oct 2026 17:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210167;
	bh=371N67Ten1H435RkI9FIOlmIVzj032DSpRfvaRUS69Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aIzGOpRYU6gtlnnSwSG0VBeiXgUl+Z02LuIHxqWgTUsBaohGtVw6m2f67XCQY72yK
	 ePhlOAw70M2BLxN8Mt0DOV/ENobufsSSVPRC1MEVw8pqkQq5wxKhrKgyOlJ5tQhSe8
	 925gXq3gUk8Js8fROUpxuD4xAspwbZpmuJBBiMfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Juergen Gross <jgross@suse.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.6 054/168] scsi: xen/scsifront: Check for a NULL shadow entry on a backend response
Date: Wed, 28 Oct 2026 17:59:50 +0100
Message-ID: <20261028165944.367746311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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


