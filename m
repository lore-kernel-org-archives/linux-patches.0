Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045066;
	b=xGWtvBDox1Xw6nFpa0xLnhpS04/EgBrtNuZ13iOlOMEUlMFugc2LhmTL94sDTscjx/ej
	 EblIx/puOnnW1g+HnNnrLNrP9eS+V7HGaInKLZnVF+zEDQcEM/XjDiWqVLFHuluDoXv68
	 ZXxOUM1mdBGHCt136DoiTPlPvf5mPh9PVoAAdiEwipkWBbNy0roX5gzcs/8m22DfV3HdO
	 GRshDaxvivaKaNGU2tS9fYmdgCs1+2DuMDy/5PQlmAZtuK0RKyBjKHhhtrGGlsJM9YwcD
	 I9EIml+xiRL8k3woULck4QpjpyTgWngTk+IeGtMB9YK3wSRCilRXpXIWEIuM0HA37og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LI26Rfz322MWBp+yY9zj0BHRlQmotjJNntAqevVk9MU=;
	b=W+k5Jo22zPUViIN/sYo5BfKRqCjgE4iYfKX1PFrY1cWz/NzhKuhm5wbh3USJF7a4evYX
	 E+X85H6cDOrwS6AEXhZ9NF0/afG7GP/PrtF9p7l2Vd546syMBjms8JFRtMj8kUOn4uF16
	 HVw197CQboDvgV3tqCaMHk8uovyS3MzOF7lBNsv+8twIIr6JoXUG77A9y1iDx7ARMiyUv
	 ddgcNdQNPGGgyTdyLIjtc2tayn6j1ZhASfU7GhZZrMlJLdglgbhoqvnMDall82aapiIR2
	 xPoj8s2k5RxZaX3M6hCMYjyIsXKkQ/+vcTfkfY3wk4bxsxi94ezwp+jW99AUBeelo1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hNLWwGIA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1878F606A31C;
	Wed, 18 Nov 2026 23:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hNLWwGIA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACAC1F000C4;
	Wed, 18 Nov 2026 23:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045066;
	bh=LI26Rfz322MWBp+yY9zj0BHRlQmotjJNntAqevVk9MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hNLWwGIAgLLa4ZPbB5vzCAUFcSx3wdzQCn7WB1S8SLvHRMMlCpZZ/iBGng2bcUb7T
	 e/24JxaFx+LvoW37y0Pb1Z8Of9emLKRKo37XOOLcUiWFIQQW2HjhOLhrSCD6BtckUS
	 GOf5HzoNjYiubUPckuU0KLOS2tWimHZupgT278Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0792/2857] media: ir_toy: Validate the maximum tx carrier
Date: Wed, 18 Nov 2026 15:30:26 +0100
Message-ID: <20261118150230.086254596@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 27303392aa87b61692faadec8b00e0ca66bf98dd ]

Reject any carrier the hardware cannot generate. This also fixes
a divide by zero if a carrier of U32_MAX/16 is set.

Fixes: 8bff1386d62d ("media: ir_toy: allow tx carrier to be set")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ir_toy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index 69e630d85262f..9eb4cc99a1284 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -373,7 +373,7 @@ static int irtoy_tx_carrier(struct rc_dev *rc, uint32_t carrier)
 	u8 buf[3];
 	int err;
 
-	if (carrier < 11800)
+	if (carrier < 11800 || carrier > 3000000)
 		return -EINVAL;
 
 	buf[0] = 0x06;
-- 
2.53.0



