Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2D62596
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C85C4339B;
	Sun, 22 Jan 2023 15:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400915;
	bh=gZAOi5w39ILJ5P1BOpw8MHAnotnXHxNyIkjC/Iz0OrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCqPqenEiCpgmxcCNxS80YK7fTpUttcVjKB+qtTpt7ScbxLVuOeE7jji3TnroK34c
	 BU0Ybdf/1sAwM+xbIl4BU63pnJnHKv4ZaNPUgXFP6beroe2xIrZUEOT28sgF6TeVNf
	 pPyH47vARISA0K6/Xzal5ORRnwp2lcW6OAI6/Pns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chainofflowers <chainofflowers@posteo.net>,
	Christian Marillat <marillat@debian.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.1 032/193] wifi: brcmfmac: fix regression for Broadcom PCIe wifi devices
Date: Sun, 22 Jan 2023 16:02:41 +0100
Message-Id: <20230122150247.883253484@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arend van Spriel <arend.vanspriel@broadcom.com>

commit ed05cb177ae5cd7f02f1d6e7706ba627d30f1696 upstream.

A sanity check was introduced considering maximum flowrings above
256 as insane and effectively aborting the device probe. This
resulted in regression for number of users as the value turns out
to be sane after all.

Fixes: 2aca4f3734bd ("brcmfmac: return error when getting invalid max_flowrings from dongle")
Reported-by: chainofflowers <chainofflowers@posteo.net>
Link: https://lore.kernel.org/all/4781984.GXAFRqVoOG@luna/
Reported-by: Christian Marillat <marillat@debian.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216894
Cc: stable@vger.kernel.org
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230111112419.24185-1-arend.vanspriel@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1218,7 +1218,7 @@ static int brcmf_pcie_init_ringbuffers(s
 				BRCMF_NROF_H2D_COMMON_MSGRINGS;
 		max_completionrings = BRCMF_NROF_D2H_COMMON_MSGRINGS;
 	}
-	if (max_flowrings > 256) {
+	if (max_flowrings > 512) {
 		brcmf_err(bus, "invalid max_flowrings(%d)\n", max_flowrings);
 		return -EIO;
 	}


