Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039260;
	b=eFlcP3C93Bo6rH2HEey6BM4uIcCwbjrf2+0okF+fAJJNlU/1AEueoPAHgLWEjAt7nZuW
	 eUFgHv9TL+XWtxBEbpMmW9fiK9SnYPcL7hOKvqMHm3xfw0xPx/Ltva+4SIVJUzPLnyYis
	 mptSv/YG8TUdRd4z/BUxpRi5oysKAjYGiGm6cvR4OnMu27/lYKxI6IdAtWYVXUPTsUac6
	 8TFQYCdc2GVB6x7i8yzb+ZFvFOyizHnj37iyYS2fcEJziq0cKlz7zdvnWfxZnCbasjt1S
	 On3MlX2DBJdVzaE7oPhFOEBBvqCknE7HdeJxbnZ//LCStlSzbs1aTo92tNvZ3p+/hpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h1q9fdn+kemx3QU/cu13b0f9I/u3VcMM0gOo/eiDkQY=;
	b=XSdBXqWLcutUShfMBmrnx4J0/yhmBkMiYsPfD5D0Gne8CwpMVViYLTUaMU/1MhSjlbmc
	 NLvPCHUlkh6Xu2DXnb4SCKbPimxF6jJcA/VSWPWpwGRaABpQehYqhMnYCEP9IEQ5TDN+M
	 3Hi2/0+H+fH49IKukNbZFX8fkr1YvwmMetizP3vPq1T3iAi5jtTNC9kRQfjowfxgAGRdz
	 0BPLulFmL+je0jCqzzcNqlRDU6h+JIwLWwl9j3Q6fxPv3xjuONfVO4Pbw1szmyAaoR/zT
	 5MJl7kE573B0Ah/ZycUFuWH3ryxmRbxz6Vw1in5hTMOMrVrr/Lgmsr/+Zd4qcxc65BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iBTcywZP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AB1606A320;
	Wed, 18 Nov 2026 22:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iBTcywZP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E391F000C4;
	Wed, 18 Nov 2026 22:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039260;
	bh=h1q9fdn+kemx3QU/cu13b0f9I/u3VcMM0gOo/eiDkQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBTcywZPNQV84ecSrPl8n7IeQF8Wug5cTwzTInW3zGD3AHVgVGE/0FqLKaoAV3lMz
	 uAa0JmYwRiyFIPCHlTWYf2Ntb2BNZvoCwCqmX+UE5bIrnpxLe9SWViBi0FTrf+b+Bo
	 OUq/bWmHWIhTzs3BV4/HpRYsPjj7acpCJg2/otCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Danila Chernetsov <listdansp@mail.ru>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2036/3318] dlm: validate lock modes in recovery messages
Date: Wed, 18 Nov 2026 15:44:18 +0100
Message-ID: <20261118150423.123819021@linuxfoundation.org>
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

From: Danila Chernetsov <listdansp@mail.ru>

[ Upstream commit 7bf1aca6d626944091a5cb218b4e487547edff0a ]

The DLM recovery path restores lock state from rcom_lock messages
received from remote nodes. The lock modes in these messages are
copied directly into the local lkb state without validating that they
are within the valid DLM lock mode range.

The rest of the DLM code assumes that lkb_rqmode and lkb_grmode
contain valid lock modes. In particular, LVB callback handling in
dlm_may_skip_callback() uses lock modes as indexes into the
dlm_lvb_operations array:

    dlm_lvb_operations[prev_mode + 1][mode + 1]

An invalid lock mode received during recovery could therefore result in
an out-of-bounds read during subsequent LVB callback processing.

Validate rl_rqmode and rl_grmode before storing them into the local LKB
state. This preserves the lock mode invariant required by the rest of
the DLM code.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e7fd41792fc0 ("[DLM] The core of the DLM for GFS2/CLVM")
Acked-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index dd2fa54f2b7dd..3dca0234cb84e 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -5345,6 +5345,10 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 {
 	struct rcom_lock *rl = (struct rcom_lock *) rc->rc_buf;
 
+	if (rl->rl_rqmode < DLM_LOCK_IV || rl->rl_rqmode > DLM_LOCK_EX ||
+	    rl->rl_grmode < DLM_LOCK_IV || rl->rl_grmode > DLM_LOCK_EX)
+		return -EINVAL;
+
 	lkb->lkb_nodeid = le32_to_cpu(rc->rc_header.h_nodeid);
 	lkb->lkb_ownpid = le32_to_cpu(rl->rl_ownpid);
 	lkb->lkb_remid = le32_to_cpu(rl->rl_lkid);
-- 
2.53.0



