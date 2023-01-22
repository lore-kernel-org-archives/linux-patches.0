Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4B07E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175E5C4339B;
	Sun, 22 Jan 2023 15:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400131;
	bh=c751CSjymc7u2PLUjoaS+DAek80QM1vKmXfQCgGr6XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAX6u331GftbhVY8wNgdUzvME5hsHpMDIzNyggXkIND4ftrpPsBl/nEgo1wI9tgT9
	 LSX2XH7KyvWpjxI5jbqcH2tLDq5kWcCbAIaXMRxOR/pWWo2Nio1XTEDaHxlVB3BmMq
	 2q/lgGprdg67Pwv67Lt1iIiVl5XBdou4wPbvbj24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chainofflowers <chainofflowers@posteo.net>,
	Christian Marillat <marillat@debian.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.4 06/55] wifi: brcmfmac: fix regression for Broadcom PCIe wifi devices
Date: Sun, 22 Jan 2023 16:03:53 +0100
Message-Id: <20230122150222.504238123@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
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
@@ -1109,7 +1109,7 @@ static int brcmf_pcie_init_ringbuffers(s
 				BRCMF_NROF_H2D_COMMON_MSGRINGS;
 		max_completionrings = BRCMF_NROF_D2H_COMMON_MSGRINGS;
 	}
-	if (max_flowrings > 256) {
+	if (max_flowrings > 512) {
 		brcmf_err(bus, "invalid max_flowrings(%d)\n", max_flowrings);
 		return -EIO;
 	}


