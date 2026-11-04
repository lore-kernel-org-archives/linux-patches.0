Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830953;
	b=vsuDGyx2Ppd7g3WX1SwzeVoX4cWFd81KhzKQaaXKK8eB/qiHftM7gBCzF+zvKtYUSWkW
	 CtiNR5KqGoc3Y+c7i/SD86d7meRJX9JBwCoGIkzeaxjjHZlvoIUBrb0/Tr0Em/ixzvr2f
	 ScJeo2tNwbEOyTHY4cofcx1j2L7H8ZcTXnOK57k+iSJGaTYUkXUOtEd8NRXCrmluqTVIT
	 iiLZoal8uesuWO3P5p6h/AcMq1FOT0+dbr0gF7h3X8GvH75y60vi/0QpAL6UTY0TzZFF6
	 m9nX6x3M4+xpRBeoJmRSOpCSyNTAi1Mwe98X85qyqWIQBPOX92e6HMam1RyL25n60yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PvABLrsC2PZezqlr/htZCkEnlvOgM2Z5j5PTVY/LTBM=;
	b=wwqOqxB+N7bEPCs+NRbw/3VWpWTSakZvzFMxSMp+YQ+FUTH/YYA+1SKzujTVc9F99J3r
	 vF7VBS4G+ZiraX+oIWy/bBqmZjf15vAuxudHnr8UQvahJ9+JVNO93swelKheFv6gayelY
	 ngyIulEuf+fm1QTo+ievvmDN+68OWmXmzzRIYVB+ptI+ZJtWFUy7OBdhmokSi+nvkli6w
	 i9RxQ6dS2j9VrMQ8mr+/c63A/PMgRURmHqWJxZHPstuUU/77r2XF7V0c6w2jeUl1phsOM
	 DyNh+usxqITyKmV171JRJ2WoQgBaXvCbRv3LyzpAdhJNfR2uzrEq1maTDSvTQaY8YbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nM/8yTed";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7BA606A844;
	Wed,  4 Nov 2026 22:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nM/8yTed
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1827D1F000C1;
	Wed,  4 Nov 2026 22:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830953;
	bh=PvABLrsC2PZezqlr/htZCkEnlvOgM2Z5j5PTVY/LTBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nM/8yTeda6swLCz75LZfRXGPry/NgP1Gw2sLldaegmjhEdmuESgcZZBlHuc1Bb67W
	 whKyrJyCct2sydIvGPLxhNU0vsLFt2ESE7Qn2JUr3/fviKL1Bgy2qpbCyKHSeMCA+3
	 rZshnEePZXJq3hfRww/DC2Vx4JvlHcbeup0Brp0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0419/1005] ksmbd: reject blocking compound lock requests
Date: Wed,  4 Nov 2026 16:02:32 -0500
Message-ID: <20261104211055.833284573@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 16a7f7c2ecf3c893b65f0fb78fa7a7171ae0ba9e ]

Clients set SMB2_LOCKFLAG_FAIL_IMMEDIATELY when a LOCK request contains
multiple lock elements, and servers reject requests that omit it.
Accepting such a request can leave earlier elements locked while a later
element waits asynchronously, enabling prolonged partial lock ownership
and avoidable deadlocks.

Return STATUS_INVALID_PARAMETER before processing any element when a
multi-element lock request contains a blocking lock. Unlock arrays remain
unaffected.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index edbac6c9b577c..40d7e3b6ed7e1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7753,6 +7753,13 @@ int smb2_lock(struct ksmbd_work *work)
 	}
 
 	list_for_each_entry_safe(smb_lock, tmp, &lock_list, llist) {
+		if (lock_count > 1 &&
+		    !(le32_to_cpu(lock_ele[0].Flags) & SMB2_LOCKFLAG_UNLOCK) &&
+		    !(smb_lock->flags & SMB2_LOCKFLAG_FAIL_IMMEDIATELY)) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		if (smb_lock->cmd < 0) {
 			err = -EINVAL;
 			goto out;
-- 
2.53.0



