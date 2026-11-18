Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043403;
	b=bcDL9o5hT22+f8E1j6SDdGMbtGz0Sth71DIBQo1RHS1QJ2q15L9Tdw8f08bRJpw1DAdV
	 TkIzoXdK/c1F2FotA1tDDHaQ3lGJ2Et45eqNcpZZ33Hud6288nXFoxKKB3M+441stRKKg
	 +jvzwAPzYo0qFtc7cBuU63NYHix2I+oI/zLGrprtU1r0vSOpNbyUgDPO3/dWy2F4XR14S
	 lm8hxa/MZShPs+zXdvxMKoE19Q3xNEoEFbMNQShLavClyoYJK4/1mllrsoCpgOPFOyyhI
	 vi4mdVDZh3juEcYc9drPw8EugmEGkyFWsDJM/SwF4SblYZdsfR1Y8dK2YyB/JfOz0dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tlhtRwHLK6pS4LyvXdSWh9PGS0cNKPF/obt8t2+m3Eg=;
	b=TlgFPpvxBmGilD75svSe/NNNqL+iuxPNeySA6SsJFDfXWtK6z38rMkMS8lgsKOB69G7N
	 O6EuTACGl1WoiZNp+gAtbqkPhrhkhOElLvktDqI/+yBxkREFI8XVqVJExCKtlMTTZAEls
	 oatUzyOqN+zlKJf+KTtMrN2jA62YTOOR7/nIEe77U1rl25fDhgvj2YsBJmgVs9hqobIh0
	 0ZoAKD/Ai/aCbgWtM7PAUhRWXbNHMEGcvHxnaZB4kXfAjNkLsMntUsFoSyvyHYYzGqhSq
	 tD1NP12qAIuelIKCIuZRMM92doy0jDG9hMH9jnBT1Xmb4vuFkE6j8ag8o3l56UKIiiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X9ATPF8u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6917F606A31C;
	Wed, 18 Nov 2026 23:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X9ATPF8u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A4F1F000C4;
	Wed, 18 Nov 2026 23:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043403;
	bh=tlhtRwHLK6pS4LyvXdSWh9PGS0cNKPF/obt8t2+m3Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9ATPF8uS2EJY/kFFOa83gmOBr8Wgt917WGv3OrgZ9OabfOcYm4zvv+C9X3mSMILm
	 c3GyMSo4HvUI/D93gQCQnSzN1I1KsY8Z5US7CPQS6AUhCY+r7ZaMUMr7rItdzhqrLb
	 VMBrLgSZRgOy3ThTuHpXNUXPfOwxqK32eORqsNnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0156/2857] scsi: ibmvfc: check for NULL evt in implicit LOGO and target delete path
Date: Wed, 18 Nov 2026 15:19:50 +0100
Message-ID: <20261118150206.966359765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 214b633148311..16f8272003e5f 100644
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



