Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625504;
	b=DGwtrB+/Sc90QwGheLyBIUm0IuV8joqgA4zBIeMviFs+YUkWYVqTtQIet3jB4BQLjOM/
	 I7aotDCqYc6e+RB7MxR76NezdYQJvakUs+p8evXjTlY/1bvcn/aGycWA0OR6KsYKt5Kdy
	 2mMsGV9wZbJryznoI7n4am3Zjm823o8GHHvdH6/EGsJlL40PXdRU6t56fyQMJEzIgqifw
	 TItCJ/sJz7274yalFT7Aj8zW1lk5pbsuvuBm4yvRrh/s4PYhENQLJ7mCk+Y0b8SxSrqRi
	 d5bWq9Oqb/+Xs2jCpgw5HeOk7VbNj+xo+ogXa3B4FJJmHqgwiKk55tHM3FhLz5+2JnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I1tNQXEAUlVq139imBwVeiPrtJ6k2AaSSUGZxFNXMEo=;
	b=Xlf2kc2ZW2N/5VZuukAUH6G+zTs8DPVWnvUQtSvSBoONzDrb7Nt2SIqwifCqJfPiCxHY
	 y0fNdvXQFJKrl1cV+aJRDCSL22JNFhjhtDEQ4t2JO5AZyom5uM+/qHNefuTFfYjp1DFwZ
	 qpQKeWaaUlAsQ8d35No4PDuPbvDIqLLsojs0qmwfyd8iK8XNDLkpMKE63uyfoPFmmFkVr
	 ENYOUl35i4nB3VbV/iJDgAR0oIlpvo9SBKZfWbRpNbVS5n51HpE4yoxn6ntK2QWLNnKMM
	 v4M+q8pwV3boQp0qFNVt6+1QN9bl1guWyQ/c+JWevybYUG6frLs+UtwQ8hZB9zIRNuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7AbcA1+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACDA606A326;
	Wed, 25 Nov 2026 16:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7AbcA1+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE001F000C0;
	Wed, 25 Nov 2026 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625503;
	bh=I1tNQXEAUlVq139imBwVeiPrtJ6k2AaSSUGZxFNXMEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7AbcA1+IevjYkB08mcVzeyecMXFZV34d0LnZalY33N8Nd5l6PscUGasItyru0cYd
	 3qb91D11LGj02WrOtAddPTjy+OjpeMlJGeWrHuISobjafGLSS+TH2E3k/cJ8KhuJ1e
	 yRsTEKwJbjCt9Q0bZCHy/yabNmUXgd1RZHHy7Baw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Tao Gong <gongtao0607@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 538/816] net: dsa: mt7530: trap frames to conduit in MFC on EN7581 and AN7583
Date: Wed, 25 Nov 2026 15:34:46 +0100
Message-ID: <20261125143901.641615111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Gong <gongtao0607@gmail.com>

[ Upstream commit a58b221496dd576191095d12996f39cee58cf6a8 ]

On EN7581, STP BPDUs received on switch user ports never reach the CPU.

Like MT7531 and MT7988, EN7581 and AN7583 only set the CPU port bitmap
in MT7531_CFC and are skipped by mt753x_conduit_state_change(). On
EN7581 this is not enough: trapped BPDUs reach the CPU only when
MT7530_CPU_EN and MT7530_CPU_PORT are also set in MT753X_MFC. Add
EN7581 and AN7583 to mt753x_conduit_state_change().

Tested on an AN7581 board (Gemtek W1700K, airoha,en7581-switch), where
only lan3 and lan4 are switch user ports. With RSTP BPDUs arriving on
lan4:
- without this patch, none reached the CPU;
- setting CPU_EN and CPU_PORT by hand delivered them, and clearing them
  stopped them;
- with this patch, they are received from boot.

Only BPDUs were tested. AN7583 is untested and is included because the
driver sets it up like EN7581.

Fixes: 2b0229f67932 ("net: dsa: mt7530: Add EN7581 support")
Fixes: d76556db10bf ("net: dsa: mt7530: Add AN7583 support")
Acked-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Tao Gong <gongtao0607@gmail.com>
Link: https://patch.msgid.link/20261022205649.2351696-1-gongtao0607@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ sashal: Dropped the ID_EN7528 and ID_AN7583 references, which don't exist here, so the condition only adds ID_EN7581, and removed the AN7583 sentence from the comment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 8c9eafb6af7be..8db1095720c1e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -3137,9 +3137,11 @@ mt753x_conduit_state_change(struct dsa_switch *ds,
 
 	/* Set the CPU port to trap frames to for MT7530. Trapped frames will be
 	 * forwarded to the numerically smallest CPU port whose conduit
-	 * interface is up.
+	 * interface is up. On EN7581, trapped BPDUs do not reach the CPU port
+	 * without this, even with the CPU port bitmap set.
 	 */
-	if (priv->id != ID_MT7530 && priv->id != ID_MT7621)
+	if (priv->id != ID_MT7530 && priv->id != ID_MT7621 &&
+	    priv->id != ID_EN7581)
 		return;
 
 	mask = BIT(cpu_dp->index);
-- 
2.53.0



