Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028006;
	b=NkHZ4cTlTcVnFwH8cKW8n3X7QgG/3jsX/ii6PuQUnGv35mJD0PMg8XBqWpIv2YI5RENN
	 D7qZHRzUonL07bDwL78ZPQO5AvkiZN+CimrMl4zMqWikm7DIAGoMbMUMdJAnJHzM0DkII
	 jFmbuzmsEiWssU6iSram6omKJdHkrv0JKwQ05Uzl9iH3JpgXuYORmTg3V6j3CUIu5J4Vr
	 poum38rO2H3eeg7E9i/Oh4lICf/con+jEV1isELoQteXLxbArrHfWm+VHs7EZ/XxPMVaN
	 Qq8k1fJydSU5zTCOePKRCyjWxdtdiAsmlFQwaqe1siWXM20dfen8R8ow+cDgvtSXilA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QTzNbX5bE0QgjhsKfxycc4AvevFeh2hpfdo/pSuB3x0=;
	b=mKMFmtcCsb4jW7+bJ0CV/5F238bnvF+OZXN8Gp78dwKPGe90L+XKmJYBBuJPYLhZ2SCg
	 vYGxvy3TIBZrU+3dYYDEMHAkzVbddk5gJM5gd56v1kscLOOVMw6eIRtIF1K3Tr7Rh5yug
	 hZnrHwqhT4Q45rOAN7pcMta+I1kprSSYhGZz2Ah5ViFCHePXBWIWDP86aMxIKmfJHjfEX
	 0FWA6EcEZL+qSNxPd+m2ViQjsU4gml2AEIbUhZRNdlLwBNTujKduykq/S0QA+oEMvjY5/
	 wdLNqU6TiAhfxK3wtDxlbs+EgQqTNKUPMAI+f3AiscmXMwrt6zG6pN3GAO3szw6DNWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nB9xLsvv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306B2606A31C;
	Wed, 18 Nov 2026 18:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nB9xLsvv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B061F000C4;
	Wed, 18 Nov 2026 18:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028006;
	bh=QTzNbX5bE0QgjhsKfxycc4AvevFeh2hpfdo/pSuB3x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nB9xLsvvTbBNz0mVLaC3pAZbtLLUqVYJyp5m+Na0Pl6lKmaY3HSV1cdk7Qd3N5ZUW
	 iZTA9bjt8ma2V5uF2K1S8Ckx/tLhDbbrzlV735A4jjG258MZyYoiSUCRbCGxm3rksv
	 3e4d+dIGdf2y4wPuH1ZB8ygkI/XKh6BnWaduEOuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Tao Gong <gongtao0607@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1990/2151] net: dsa: mt7530: trap frames to conduit in MFC on EN7581 and AN7583
Date: Wed, 18 Nov 2026 16:02:05 +0100
Message-ID: <20261118150234.216519242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 4f391ef797ea3..b9094e36c99ad 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -3280,10 +3280,13 @@ mt753x_conduit_state_change(struct dsa_switch *ds,
 
 	/* Set the CPU port to trap frames to for MT7530. Trapped frames will be
 	 * forwarded to the numerically smallest CPU port whose conduit
-	 * interface is up.
+	 * interface is up. On EN7581, trapped BPDUs do not reach the CPU port
+	 * without this, even with the CPU port bitmap set. AN7583 is set up
+	 * the same way as EN7581.
 	 */
 	if (priv->id != ID_MT7530 && priv->id != ID_MT7621 &&
-	    priv->id != ID_EN7528)
+	    priv->id != ID_EN7528 &&
+	    priv->id != ID_EN7581 && priv->id != ID_AN7583)
 		return;
 
 	mask = BIT(cpu_dp->index);
-- 
2.53.0



