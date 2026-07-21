Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E532A40803D;
	Tue, 21 Jul 2026 18:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660164; cv=none; b=XLWomfrK7paAed7v+mMeZaPqGhESr3Rcvkr90T9n96ywkz5gkxR2OKacLzZFgOnE1kLEb8HGgYGYcnAwiLslBUUhVdRJotlVfzte7eFxTBWbl5i178Q8R//kXeMP3aD0K6T6vEjGz/FwURNpWE8FfxdqyVBWtiniypFjXo2FNng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660164; c=relaxed/simple;
	bh=357wLDh6bsrwcYHp+sRX1GVkv/NMhGPYCN56Oo3UgiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMOW6Os0AS20MwewFOMyTVK00YRTVifOfRgogbKfj8C5stFJRJMOtswKxcsTO2GjF5blPt5+gW5PVjIL0G+o4vFs9xHEm3kFtRbLtZhxDMazbL02sSCI/h4eugtLYUc5ZIUqvEyFNBG0lidp0TL9PD9b0gNu1eekXGqdyPqfpXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAP6hlJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAP6hlJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3031F000E9;
	Tue, 21 Jul 2026 18:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660163;
	bh=ZL3bNWAAeuEow6a6oox31v22sV5JFHYkgp+2C0mXS/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bAP6hlJvsjfOx1+cLt26FQm9DxUJZYMkrzZ8CcHd6oi3R/Ag+/iV2R91dzyRk+Tlw
	 i9Bfdg9cYapPUZP67bC+3EYg3yJxvVTJOLOC+vbOU8LJ6SCFjhzJfq0gvwoK4T3xpd
	 j8RzBFPFfs/ZmS4XYN/Vj3Ty4gUCtloD1BTRLBsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Dan Carpenter <error27@gmail.com>,
	Maksym Pikhotskyi <mpikhotskyi@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0833/2077] staging: rtl8723bs: fix stainfo check in rtw_aes_decrypt
Date: Tue, 21 Jul 2026 17:08:26 +0200
Message-ID: <20260721152612.434804237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maksym Pikhotskyi <mpikhotskyi@gmail.com>

[ Upstream commit 9a3f9b3c47d8f071b0eb9e63906ac0448058278d ]

The null-pointer-guard was incorrect, returning _FAIL on valid pointer.
Invert the guard, so it returns _FAIL on invalid pointer.

Fixes: e23ad1570028 ("staging: rtl8723bs: use guard clause for stainfo check")
Reported-by: Luka Gejak <luka.gejak@linux.dev>
Closes: https://lore.kernel.org/linux-staging/E4BF62EF-C6F6-431F-8EDC-77C1E613E66B@linux.dev/
Reviewed-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Maksym Pikhotskyi <mpikhotskyi@gmail.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Link: https://patch.msgid.link/20260417095452.23440-1-mpikhotskyi@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_security.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_security.c b/drivers/staging/rtl8723bs/core/rtw_security.c
index a00504ff291098..f467cb5b1dca39 100644
--- a/drivers/staging/rtl8723bs/core/rtw_security.c
+++ b/drivers/staging/rtl8723bs/core/rtw_security.c
@@ -1212,7 +1212,7 @@ u32 rtw_aes_decrypt(struct adapter *padapter, u8 *precvframe)
 	if (prxattrib->encrypt != _AES_)
 		return _SUCCESS;
 	stainfo = rtw_get_stainfo(&padapter->stapriv, &prxattrib->ta[0]);
-	if (stainfo)
+	if (!stainfo)
 		return _FAIL;
 	if (is_multicast_ether_addr(prxattrib->ra)) {
 		static unsigned long start;
-- 
2.53.0



