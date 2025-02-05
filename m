Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1355213C9C4;
	Wed,  5 Feb 2025 13:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763490; cv=none; b=eSYZjuxbYMNXFIMZS9upKzgcTRurFP3cgf2YjXN1Uc6pN21RjBRPLcM4tw6Qv0icYw+BdYmi3kbr/gJXMvghAavnecow7+KWsqimnTQ/m9eCyfALdioV6r/ysZEBl8VmOdeSujklC3sYlnlMir1kVeEC3mkUDyCmN/TtgtQ+w74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763490; c=relaxed/simple;
	bh=iIhOwqwsT8nFNaGI9bgfrhKu4jIVKpmkPDqwm1h1+M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e3XmyoRgfOBCOftcSA/xZw64GQnVTBFtqeYOmsStj3Pe2eZhEVBEBZ8zx2HG7wUqev3WrA6fdEG7T4TFmSlz2HgHURIYGt/EOtiCvMKoBIk4PVt2H3micC9Xrv1pCa3niQJfb/l3Okfti39msp2Q46dpdUCKkl0Ohk5mtHcJm4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJWA6SRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJWA6SRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730FEC4CED6;
	Wed,  5 Feb 2025 13:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763489;
	bh=iIhOwqwsT8nFNaGI9bgfrhKu4jIVKpmkPDqwm1h1+M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJWA6SRBAbToPHJV30m9586B0Ol3dlpfnhTZ4oGpF/a+nUSsnFj/t8NE2dFfkzDYk
	 r3oQA4Yez9PRkqJldXuf+Rf6j9wimryMnrPqpX/0mnOf6W7u67V/xz6s5kBKTTjfGP
	 S7dPV7dexZL/yuvYpsLHGXS27lFWvVtRTMm3fkcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Hamer <marcel.hamer@windriver.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/393] wifi: brcmfmac: add missing header include for brcmf_dbg
Date: Wed,  5 Feb 2025 14:39:51 +0100
Message-ID: <20250205134423.046893228@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



