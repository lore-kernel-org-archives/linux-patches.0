Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051241;
	b=iwNgjQHkbt/P58dVp0dKnAIMaZeyKwGJ7yizqYSbTe3jUF2kmzS5Hb7CE7Gw40luL/zl
	 THu6bjFchmuHZQ3BQgN8Wr1Is4s+e9+YcD3svOfRy1Bzok1+jwTN3+KRwraFtLTaT6Jj3
	 IuC3gkJ3Yb5c2WbkjWQZK/0/McdrtRw8SaZYWqXWBB/zvZxLoCuGptPpelAG6Y0e/JroY
	 6fwLs6usgM/mIiulPcO4K4MYBoJJMs0z80X1y6FKylFDNIbZEm+LqVmqpmgf7O2lpPx9w
	 guc/FzjM5GFM0FGR9gCoY9WYQKmMK3gEJaJZdbuvJjn3v8avZbuRrIvV7S3bQeWlYLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dvGRmRPvxMxvMCiXHPeBnEGXASiz0YkgJiuSUNBBEGo=;
	b=L+j6IejZtBNx/pnqjWYkyRdgJLyxJ+pIp/mrBYNPrxdB3tReBs3eXVklaytfEpDf7ccr
	 5hRNBqyhSB4xvwIouUHyLoqnCkcUzy9zbVLfBdQGxQs5CUMbIDfBYplUSP/oMwLj682xj
	 Sq6KjEfTUKULqEgjJa/Ser+OIKSTyPAbh72KfqoNZusKB3jABgCsuoWr+znTDfF+cfXCU
	 97uv1efR+BaJCrzBzuPWKZVLsA+Y9NOkIvCoyVsdbIZWAOcs2QnHY5MEsaKBKQlCQwj7S
	 gxQNSeW3VJ7yed75joBt/xZoRV70C8NQXuasRvrHvegG/8TQ8JadRFCXrTitcimrHhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J929YCeh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A037F606A31C;
	Thu, 19 Nov 2026 01:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J929YCeh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7371F000C4;
	Thu, 19 Nov 2026 01:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051241;
	bh=dvGRmRPvxMxvMCiXHPeBnEGXASiz0YkgJiuSUNBBEGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J929YCeh87R9nTsEw0o2ASqIrd4P6GWT6PrlORsumRyUwoVS6RMAcUP65MBnk9cSq
	 TyQoDW5IalYvROkTo+I8QvcvT8wks81kUtuAZZ8jxOs9L14n/U14/IF58LX0M2gHDK
	 rTtuFziikEhL95FYZnoGgvzz6ElvJ0NjW6DCi2SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0140/2214] scsi: ibmvfc: check for NULL evt in implicit LOGO and target delete path
Date: Wed, 18 Nov 2026 15:30:16 +0100
Message-ID: <20261118150015.782971512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6b84017625b7a..7ef35dee56e77 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4364,6 +4364,14 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *tgt)
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



