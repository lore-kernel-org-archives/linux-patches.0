Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829647;
	b=5MusAZa1U6TOt/jSLhS88JpsZcbmAt9duVL15goGVGwZxiQ4mghjN4XwZN2iRrvK3PZU
	 rjd5pAeiR8cqo5wmBrReyEw6djNkYsRYsYNz3sdaI9DTAtRpenQpugzC6B0HXumF1giKm
	 KfM21AbBLbiu//LenMJYXSVidOnNiq+p1F+sXZ9Wfc6KR9DlQoXNbzWWNd6KlWdwIXOjl
	 Zw5es8XF5g2lqsjOosaIJO5Bbtv1n6DAQZgRMMq+37ihJQok7oI1qhl64Xm33OlKk4+mY
	 0NBRAE0KtyKqaMuU3UHw9n7y4unCK4RaYGvNiyl9V9bmSUJgWGCaa3bZJVWuKR6bIaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pns+Dw0Wx1YW4ICKcnXH4ZtEtBNZbuPw2k+R7QmFK6c=;
	b=g5wMZqsvbuZVKZXZlQptQW+y4D/NeT14fzz+If5n420cv1KQXLEszrWVWY4IBZPYq4zo
	 UOmiqDeX/cp5aHTXJspXRFY3nDZDQxSFHvlGMDlxeOK9Jzm2RndYStEQjXZDGMxE09PLL
	 OlCR5NZEUF0wA2oMfMJnfy97Hyek30wHEMdG8f07rnOf8cAMNBb760rKaSySe6dMZAS3r
	 24qyhloMOWQOQF5pdZ6Att+M6L/VXM7AAGqQpYwaTXPEej9zMjZm717LzecUiiLWCbYcG
	 hXlZirWKW6RLMnbrUdWh/I2PPdd5DmrNwWg6jCIb32Y9CRKhps1BZkopRE6UIujX8Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QGuDxB9R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53480606AC30;
	Wed,  4 Nov 2026 22:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QGuDxB9R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B681F000C1;
	Wed,  4 Nov 2026 22:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829647;
	bh=pns+Dw0Wx1YW4ICKcnXH4ZtEtBNZbuPw2k+R7QmFK6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QGuDxB9RS+UazJ51Obvmunl7Psa5A8aVAjEBwx8hWm7I9Q9TV3cqYpHM6f89CK9J9
	 YtgG1yl9WvFvEGim61xfXJlkc43WmCxR+p83KBS+4vRIwWMf8Fr1IUOdwneK/GrVxg
	 MDiY8fnbZxTqnFNvjV7b7FvD1ioVHFiqP6Bm7gFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0254/1005] scsi: ibmvfc: check for NULL evt in implicit LOGO and target delete path
Date: Wed,  4 Nov 2026 15:59:47 -0500
Message-ID: <20261104211050.978185151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8d7c304636d99..63cc569284ded 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4403,6 +4403,14 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *tgt)
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



