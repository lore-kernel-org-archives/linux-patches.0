Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC85CF510;
	Wed,  5 Feb 2025 14:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764213; cv=none; b=kApLJwGyIH1Kz2afXFBvvSSpxV1qzoGVtIR1qQpEkXkc4l+r5iNgtpZwb5EZRxXSNZx7T7/7zQon4cNU6RrNxwCJp+3Noaq6CRqrJ85G819P1FmxB/GPXL1l7bOWBVU6dDiqYNm6z/e37TklgN8I+mVy6OQG1qyuQrRBWoTFcm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764213; c=relaxed/simple;
	bh=NcPiZSAr/xEVqoEFFG2zoltGPlKbTGkr76Fd+chfIoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U+8/M5pWQG0Q+H0B+XloV+qvR3p2J3QTQ//uIHO91pM90yvoH8uVVOTjo6TNRzvx8596B9qZhSHIE7gxa+p8tMTgo0M/voa1/gxhkz+yNm2T0E7K7L/i6NQjlP4RL4Gr3DPG2sMwu0X8ZaqiGGQ9ynFRfJQm3KNx2ykRg2bSl5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgeTWzzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgeTWzzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B589C4CED1;
	Wed,  5 Feb 2025 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764213;
	bh=NcPiZSAr/xEVqoEFFG2zoltGPlKbTGkr76Fd+chfIoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgeTWzzn7eVfqmVfNvYghUnY5Vtz2hA1vovi+RO4VVlOm5NTtFdiTIVYsKVQ05Hcv
	 3mx7MHN71tWV5iUDu19VGqIh/sgNdeYV2I+0GW0NkExd2fddd36zr25AtziR1wFrir
	 N2hPeo5NGLaJ/CcCF7yx+s+7r7f+829TEEu1Uapg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Hamer <marcel.hamer@windriver.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/590] wifi: brcmfmac: add missing header include for brcmf_dbg
Date: Wed,  5 Feb 2025 14:37:34 +0100
Message-ID: <20250205134459.045186413@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Hamer <marcel.hamer@windriver.com>

[ Upstream commit b05d30c2b6df7e2172b18bf1baee9b202f9c6b53 ]

Including the fwil.h header file can lead to a build error:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h: \
	In function ‘brcmf_fil_cmd_int_set’:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h:90:9: error: implicit \
	declaration of function ‘brcmf_dbg’ [-Werror=implicit-function-declaration]
   90 |         brcmf_dbg(FIL, "ifidx=%d, cmd=%d, value=%d\n", ifp->ifidx, cmd, data);
      |         ^~~~~~~~~

The error is often avoided because the debug.h header file is included
before the fwil.h header file.

This makes sure the header include order is irrelevant by explicitly adding the
debug.h header.

Fixes: 31343230abb1 ("wifi: brcmfmac: export firmware interface functions")
Signed-off-by: Marcel Hamer <marcel.hamer@windriver.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241211133618.2014083-1-marcel.hamer@windriver.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
index 31e080e4da669..ab3d6cfcb02bd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
@@ -6,6 +6,8 @@
 #ifndef _fwil_h_
 #define _fwil_h_
 
+#include "debug.h"
+
 /*******************************************************************************
  * Dongle command codes that are interpreted by firmware
  ******************************************************************************/
-- 
2.39.5



