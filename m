Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019478;
	b=kmQQU2sVZCcuHNWzSebOuewNobSpFbfiGHNu/P+Fgg5p8D/68baL2dFD5ZR9QCxHaPBm
	 6uHF97pVD7I3PLBCRTFJDGn2PZT4bNW6ycrUa5XWdprzni7HP+IQxD2Lu6YRyRR6uGtG+
	 qv+qR/AoGUW+9jpm7BS3p2kEKyQx9rbR5N3uTlN55i8jxwH/wykDoUYbh052L/eEJ+WRG
	 Hkp1lRh+Kf3EXDwDobAesrW2GtSE59Y/yHgFMv0jfV6WE0OVAflUvTfJpzpSFsT3et5Nk
	 pJxNlzJKx8qY8EqjoWdX+Z4Yo42F/5siuSX0p7ZOjhx/yh/YgHxkAT0Dy3N18r/32xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1bHDy+UcGjvqPbPkpSmcbIp9EXF9BwL3iGtiq5cQJUw=;
	b=E6MKuEfubAKve1LH80FmtuUI5NPherTHJx47IndoAjEVO4HwypnEjtDOhdS/n/vavXxF
	 ZEoRIWCecvmxtAYRN6O+X3ef5RooMO6Kx7oa+XO+bHW9LYFfxZEmLCEcmbiz1M0aM52cA
	 tTr8+8sSs9Wzkh0F1lYYePPGs1Xeg95Rv1lLTLvq1VMEfA3pnTwQxQdLgHIDpTBXyr97x
	 rcY8Dj0B/4+ZIGZhiHkTEELzhNyzgYeE4Jp2D8VbGMVR5yCwwIfTPkevXQOm8PAWxI+Yn
	 1IdhIdIfDu+u6MBlyzSzxgKN1nP6LeZ7IB9HU5SihaYDfXVbOGs4XIQxCwQWHUEAPqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjHH4vtJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C6D606A7D7;
	Wed, 18 Nov 2026 16:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjHH4vtJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBA61F000C4;
	Wed, 18 Nov 2026 16:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019477;
	bh=1bHDy+UcGjvqPbPkpSmcbIp9EXF9BwL3iGtiq5cQJUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjHH4vtJBhzF9VvpnOEJjsMlDh+fmCl4ClRh94+bmJ/dgMAlz8YS46hl/GK4AZ2os
	 GaWuiDu3bm9HXkw2x7mFx3htyZxJjhES1YKaYnJn7ZQ7IqfjvGe59qz7hmUHEWMeq4
	 gtkDZ8zfvt7KQhPM1ZfvUpklGwPLcF4L1nie9Uns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Tushar Dave <tdave@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1573/2651] PCI/P2PDMA: Safely terminate ACS redirect lists
Date: Wed, 18 Nov 2026 15:46:53 +0100
Message-ID: <20261118150344.561278994@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit fa291d6429ebc1efb7fab011f643b842ae5f23f1 ]

seq_buf marks an overflow by setting len to size + 1. The ACS diagnostic
path unconditionally writes a terminator to buffer[len - 1], so a path with
enough ACS ports to fill the 128-byte buffer writes one byte beyond the
buffer when verbose diagnostics are requested.

Use seq_buf_str() to terminate truncated output safely and remove the final
semicolon only when the buffer did not overflow.

Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/20260830-batch-p2p-fixes-v1-4-5044e8dfbe2e@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/p2pdma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 52974809e1e18..c1702426b45b5 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -772,11 +772,13 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	}
 
 	if (verbose) {
-		acs_list.buffer[acs_list.len-1] = 0; /* drop final semicolon */
+		/* Drop the final semicolon; the list is not empty here */
+		if (!seq_buf_has_overflowed(&acs_list))
+			acs_list.buffer[acs_list.len - 1] = '\0';
 		pci_warn(client, "ACS redirect is set between the client and provider (%s)\n",
 			 pci_name(provider));
 		pci_warn(client, "to disable ACS redirect for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
-			 acs_list.buffer);
+			 seq_buf_str(&acs_list));
 	}
 	acs_redirects = true;
 
-- 
2.53.0



