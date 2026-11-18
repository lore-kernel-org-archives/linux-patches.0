Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033906;
	b=HKVFefEbPRICYtJtLbEV2yeD/MNsegRgXvjD1Ro/YvjsbHAhjes17Zp9J4ukLd2SlpYM
	 DVfTe3+dXSG7YMb49txqeRXTYy2Uzjtmm2KuQhb1Qzx6AUfmmUW5PLyPnPCAobkxrOCcr
	 vfh2fiPuEVAlaCBUv18uEP53+jtJW2hesNZ8yixYFdHrZ5pioN/QzOBFEiSipq1mDTUEA
	 SMZpOBQYhDaFfb4CDBTOwwJLLdX1Q4OcL0fwbIaft8vw5vJKQTeHOGBD9gIe1Mk6axjff
	 4/8gQpa7WzBL9Iqe/Ty/roaY5PAnTtR9ez95aAV5umJH85uCSTuAggpmkkWwEjQEzXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zB+OR+AhEowrzc2zAgtGl9+8p+pIdiPCgdVnUso7uOA=;
	b=hBrGaulenvspH+T0/bi1IrKrGhAGKdU/aS5dDyuJlJcFjw8g7+5E0IcgoFSG3jEGzp6J
	 3u78+BW8Xe2okSIbHxQPpNgX+aN02Q+tuDNwndlsDcY07erYDnxkGFjZZGKoLOxLCYPba
	 khxBsNtXT4451Rd5XLiZUHE0FEjHXtYstRvW/I3oDK9GTqTyXC7T60CiMJtVSb3G9Z4Fj
	 8a2c5OrktA0HAb0A6gLL5N6BUI4SaMfJqjqLlyP7TvUV+OsyUAYodbANiJwpfL65DNllX
	 D8XLpK8HgAdpqCM0SLKSLjvUUswrMvAebEKfQw68EJ0T8gleS0ApmX/mGTvkiDWLctA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EIeh0pWS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DB1606A33B;
	Wed, 18 Nov 2026 20:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EIeh0pWS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131591F000C5;
	Wed, 18 Nov 2026 20:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033906;
	bh=zB+OR+AhEowrzc2zAgtGl9+8p+pIdiPCgdVnUso7uOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EIeh0pWSi+yIuZ0Ib2PD2xZ/qugayM5RGlFX4v6lT94JMVlEINVEp73VKWLf0Wjba
	 FjsLLNpU/Un0LhwP1/awJTIeIr8w4OudxFKoaw2oJf/dvMqEQhrhS3Ct0vQ4tKw0Pp
	 1p+Ju3Bx8AiDBPnj0ARu9PuGa7e9fcZLSPoFdM1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0181/3318] scsi: ibmvfc: check for NULL evt in implicit LOGO and target delete path
Date: Wed, 18 Nov 2026 15:13:23 +0100
Message-ID: <20261118150320.152670835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 0122eab60b151d7815f420a91c7315944a037714 ]

Unlike ibmvfc_tgt_implicit_logout the ibmvfc_tgt_implicit_logout_and_del
path fails to check for a NULL evt returned from
ibmvfc_get_reserved_event and passes that directly to ibmvfc_send_event
which will unconditionally derefence the evt.

Check for a NULL evt and perform same escalation as
ibmvfc_implicit_logout.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Link: https://patch.msgid.link/20260723000149.969416-4-tyreld@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index f2780cc9c60ad..4c263b93a39a7 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4366,6 +4366,14 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *tgt)
 	evt = __ibmvfc_tgt_get_implicit_logout_evt(tgt,
 						   ibmvfc_tgt_implicit_logout_and_del_done);
 
+	if (!evt) {
+		vhost->discovery_threads--;
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		__ibmvfc_reset_host(vhost);
+		return;
+	}
+
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT);
 	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
 		vhost->discovery_threads--;
-- 
2.53.0



