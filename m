Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14711519AA;
	Wed,  5 Feb 2025 14:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764759; cv=none; b=YeOHcYwuyAIb0t7zBVOe+cOzLfOkQr605ZsHD756y4mP1Vptt8A1O7BrfpR+zIQ4am0FpcDKHr2ztZ4rjPXT6Zq/5+mmB/WcykHTG9rpxmZJAOliY23RfPpsn8C6J3sUErUJr9GAea7GXvUrPm7qCusIlGXUaDgfzd8+x3ZPqh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764759; c=relaxed/simple;
	bh=ETy/LVQyN3RnaaAluKnrgOfwl9wbVDxb/GL2hiR4Wcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BgpDGjvGjwskKNjuo9dhpCGrqu6J77sJfk32yot2EAggwqom1zUh5kmDXJESFn8yXw7bFDnqWgl3Dj6dRLoU7i3wo3Mb9/G7jwVfxeT9RogvjYm8Rg+o4SWRTzVGa90IxgmCE5vT7iRh/2qKVOTFIeLDD5WNACyofrLM8Ebwyr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJ1lA6HN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJ1lA6HN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF409C4CED1;
	Wed,  5 Feb 2025 14:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764758;
	bh=ETy/LVQyN3RnaaAluKnrgOfwl9wbVDxb/GL2hiR4Wcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJ1lA6HNTMovl5wpunRbDUW2STL4fqSts2pQlE+qvoGqiigB21JPnSWA/gu7Vjn5c
	 sS/QUS5beZOOKPQ/CJMO0GPp/vKC6so7B3p8PiVezcuJ/Wws3dow3cCiOBaPGB7dbW
	 MYvhiQCH0AdW04OlY8ZhaMZ7RgdmTN5BAtzKKTDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Hamer <marcel.hamer@windriver.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 111/623] wifi: brcmfmac: add missing header include for brcmf_dbg
Date: Wed,  5 Feb 2025 14:37:33 +0100
Message-ID: <20250205134500.461573814@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



