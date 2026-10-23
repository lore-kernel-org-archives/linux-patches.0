Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774748;
	b=t+q0cDTxReaZ/daKySV003JRtd1JD9KyqlG/7k8dXP6ejrnak0qryNOaanb8sB5b42hG
	 n2Sr14JTUsJfDhyq/N7r4tNheQmEfK0m6U4vneBFgn98+YKJuLix4y/m9XWyoJdOIN0j4
	 7NGTfnYdW3zCELwyQgeYEEdtH6WpQoqsuxblvifzm2DwXwL4u+WWBJi9//YgbI9fj4jWv
	 8ms5mABr57dvnUpaW0YZcssTt/FNA/ikiQpNrNj0XbplJSKQTRLMXp5h35+RCP28MLezd
	 FDtF1k+1S0RcLAiubp3tDErR6JOJTKp0Rl95Y+vTU+zZ/fA0YloUGJCpiRBz5otMEJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tA+oDqZQe/bbuDqugxZCL429UWBLPVtEur42FfPY73w=;
	b=k+6U5Qcraz7ZRbp6Y2UL4p266JlTHBGvLnEULvB4ml0LucTa0BAzITKwH6Wke6WXpmLU
	 6HJKkw8e+vfEKZ9/C3YCI5Ii7S6zL+UuosthC7pZB7Jy60N9cIN1PeFL9UfwmPeSyUcvk
	 BbP6+HHbhv8cQBsSBE0D2h9Tgmk25EAuIb9Ny9XWqlTmith/uV23P8QzNjIup+mK3AYG9
	 iw6OZh5AMkZ1OzL+d5ocsYiT2kcOCreRlfTC1tYRXYTOhVjLiZFAhOpnO3VLpwGb2comy
	 v5+nUSWkbh1ouGayAkqVEqLqZVUVR1/EGSpwoU2pIgjNhYPF2sm+9YKhlLwwUPAqFDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1lBZxUqh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E3C606A31A;
	Fri, 23 Oct 2026 16:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1lBZxUqh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BB51F01825;
	Fri, 23 Oct 2026 16:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774748;
	bh=tA+oDqZQe/bbuDqugxZCL429UWBLPVtEur42FfPY73w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1lBZxUqhsRJB6w1jXYScFrmJarckO/XTWnV+1eP9sI/X8fgF3eWc0QGDyfVJnH/Fp
	 HOkW9WG3F1fSOUzBBeR3nZ1CQaTztl1pxABsJWgfrO3hFy9LS0rZ6vswi0vY6x0RXm
	 IgSJ6SkaTSrcpjjYZt5iA8AvnhKSJY12UN43UhZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Juergen Gross <jgross@suse.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 146/242] scsi: xen/scsifront: Check for a NULL shadow entry on a backend response
Date: Fri, 23 Oct 2026 18:39:48 +0200
Message-ID: <20261023163717.236264404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


