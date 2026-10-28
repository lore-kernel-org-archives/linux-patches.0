Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208164;
	b=FodK3ZrB/JfUBQqjAsMhls+9DnPPNvBubZi2gdUDMmXHLohzASykWHdm8ZwiyOKSm2YX
	 Q3bZvDkkIhDEAPwfruXB9PvUZPPnewKeZOCAY5LVh3mdwyZ9OQPDdk/WL4mr4bg/VCdkb
	 S6TEed8SdRYicnqk4A6jf9jViyqQ1bT70So81vaiQsvpX4QokVoJvsvkZJkNEjXIurJH/
	 J9ESwAHWyCGRk3dOBtnCtoM9BRs923fnOsgHwNCPRP5KnyTAP/FhpLPE6/pWzoNycndrL
	 +3Y2R32J5uLwcWqXIFYxU66KdvFz1D/C/IQJSANI2sv46rvady5ruMd2KkLLnghUQ9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JsITHAuAZ2tFHamcG7QvtfjxnM8RO9iXe0z4n6/IpPY=;
	b=GFuMQeAZI6praATyQw3O05aPgIE1RS+uL55hh61skba1J+jB969A5JjP8RGxP9JYEMte
	 66cbC3P8HkzKNfbYZcyMi8/PbV8cnOWmqjC5tzUjee2AbZYXty76nyrbfwyNfl/eqoC14
	 1ov2pUz+d0wQAcx5iOBQ6xTJbNhXfUmqcX5R13YKuXbbsHcOY4NI0f1lTFCxgLDIMdIox
	 Ps+9jztC9Az1LfWXqklGAe4pnXwyQHeXWVmcn6+l2vMNNRAzhcR1GJNm6+PokxwK6+LqD
	 IW5jfFdU2dyg/rch1/fUYjn/ZRf2Lz1kfuXIo8GQLMJ3+Zp08fTZl+/15qonw6jyjfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zoz3oCj+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E79606A31F;
	Wed, 28 Oct 2026 17:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zoz3oCj+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA77A1F01825;
	Wed, 28 Oct 2026 17:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208163;
	bh=JsITHAuAZ2tFHamcG7QvtfjxnM8RO9iXe0z4n6/IpPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zoz3oCj+I4TDut0HDRvb9+iGWXSt/OlSsr9zd3KWL0UixWxi93oeI2F8ofRTfuPKj
	 er3fWxBA8FJKXFaWqT/Pp4Fi/XGGSUwl0P3w2TwmP2ntnNbv6GZjoSTuN+2ShagJ+h
	 rHW/LRnwPnxxBxv6pO/JTRkTrFa054BrIh+ipgcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/516] scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak
Date: Wed, 28 Oct 2026 17:52:55 +0100
Message-ID: <20261028170004.076925501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit a152edab3854f01dd2daf3eaf8f32cbabdb3834e ]

qla2x00_do_dport_diagnostics() allocates the qla_dport_diag response
buffer with kmalloc_obj() (non-zeroing) and, on success, copies the full
sizeof(*dd) back to user space via sg_copy_from_buffer(). The inbound
sg_copy_to_buffer() only fills as many bytes as the user request payload
provides, and qla26xx_dport_diagnostics() zeroes only dd->buf. The
options and unused[] fields are therefore copied out uninitialized,
leaking kernel heap contents to user space.

Allocate with kzalloc_obj(), matching qla2x00_do_dport_diagnostics_v2().

Fixes: ec89146215d1 ("qla2xxx: Add bsg interface to support D_Port Diagnostics.")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-54-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ Adapted kzalloc_obj(*dd) to kzalloc(sizeof(*dd), GFP_KERNEL) to match the branch’s allocation syntax. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 387686d5d0676..19ed2d86ad2d2 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2389,7 +2389,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
 	    !IS_QLA28XX(vha->hw))
 		return -EPERM;
 
-	dd = kmalloc(sizeof(*dd), GFP_KERNEL);
+	dd = kzalloc(sizeof(*dd), GFP_KERNEL);
 	if (!dd) {
 		ql_log(ql_log_warn, vha, 0x70db,
 		    "Failed to allocate memory for dport.\n");
-- 
2.53.0



