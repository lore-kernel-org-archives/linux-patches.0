Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210427;
	b=EkxOXao1lHyLOgPN2ERCI9WvSm1BdGSLJee5STlmiKK/tYGbZKYGJh+pUaWTCZizeocP
	 +0lkAMMVnsoFXtNCnYDmFqTnbRYX1bfwfYSr0EtBfEMGyDOTF5kencBy1t3U/N1MmYE17
	 P9E0R6klS3YF/ZjUc3FzjgyARa0sCoLU0zx3Ez9LNRCRkXM02xoY2JmamMglv7oizEGfA
	 5fJj4T47zVcaS3d5fzP4L7Axg77/5Vp+rNwQXh2/J5Ojl0/2teS9e9T8vWDIyww7wM+GZ
	 cav0xCfzmth1hZN83PdX+17MFqcS1Iph38CdN5r6Y7LzbwTtYKK8G1P38M0ueHPlavQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wPExqIymxGuKnyTstr9a2ph7UELsMtYDBcRSRMB/bOk=;
	b=p9hAHNeBAZ0vydBCNyDWI71Adp2+dtA14HvA2X+9V9ANcd2MMbkDCcfR3PK2ckRRQCZx
	 77/Na6PN7iqXbGRxrYxReEa0uEDN40iHLhjuTyDOf9+780Jq+emJBdB7xWZCVf2kYOCYf
	 a7NZAGNov06CCj0jZwu+699iBQmHiRCka/HV+S5vLssb9KfplMt7s8f2XZmuZ+O0sl9Zi
	 C4i5IKupPIVevsTQDXcLVR0oB69igI39b/MHT/pmJ6Yem2ljTFk+Ldhifg50Ql22y+i2q
	 AQMhnGqozIGsxAVjiDZ4PXe6KO9Nk/HQ36AbeuqAGrGSYYfrONjEgkcBOpD1s0VSpIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgakat8t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3F8606A31C;
	Wed, 28 Oct 2026 18:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgakat8t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB861F01825;
	Wed, 28 Oct 2026 18:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210426;
	bh=wPExqIymxGuKnyTstr9a2ph7UELsMtYDBcRSRMB/bOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qgakat8tNPsK1SirT+Ai5kpCb77ZAlPDlHPdJXUKiQANy2W/iPSsAX/l+T5sDf30q
	 lFERLJxLJsb7K/W0KNiJu/jtm+oR8k4+ziRaMM1MNe60bv2f0ngLfGxviW1Xk1y0Hb
	 ILmAE0ElfzlQyapF8TUtslPX8MVwlWDYP7aEPbmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/571] scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak
Date: Wed, 28 Oct 2026 17:52:49 +0100
Message-ID: <20261028170008.549097354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f4b56708dfcab..27a97d254e33a 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2412,7 +2412,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
 	    !IS_QLA28XX(vha->hw))
 		return -EPERM;
 
-	dd = kmalloc(sizeof(*dd), GFP_KERNEL);
+	dd = kzalloc(sizeof(*dd), GFP_KERNEL);
 	if (!dd) {
 		ql_log(ql_log_warn, vha, 0x70db,
 		    "Failed to allocate memory for dport.\n");
-- 
2.53.0



