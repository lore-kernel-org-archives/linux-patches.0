Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062286;
	b=EuOWZ17ZTfISkL6TH8rCCgU2w9gfHSLfaHer5II254qHYNikXI5y23whxhOB2x2bn4vC
	 0NUPVBISvNkI5gdZ2rF/bJeya5TV+hrsZ5SXQ65ktuul7+ZnBNIuVBVoUhtu9DkEfrTJw
	 E7zIfuDgwuW1PIn6IXxGXDsOivE3PnpA891ZT9hnwq8ia4WtKnOzl9BmgTBlxWR9Licdd
	 22ThMEdwpWp4v4RvyIQdbiV8iYrW1kAQckLd/ktWVedm4mWRInx8rIO9NzuThpRBkkbLV
	 iN4hOy++hTAmHaZ4EFtSP5ZmYzTLnqwuFsIzSFgg8kTjrrMJy6NqcbwWLclLf+MaXxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=URHFUW1r0f+1/MHxdMlnrsvKlga26PfdqNoxgLQP7II=;
	b=Gw5GQjsoY0CUN7KNErjSWNwG5vCmOaz/xoJAk93a5xCxfBHbtC9SHCb9qtrni0yosONj
	 WO8IuNRaghTinMVqEVjiz6/qyJmedY2iyPWSSue9Ng2R2Qj4MDku+ilts05gxdK2rMnpk
	 UM6kTbUDGnbjrUN7OeA83w204Bwc/X4XKZ9ndq6PJMkwxMp4xyJHrR/qSgmJLDHPvfCWl
	 uf1JWU05NiqJ8JVH5+TsPUydjao3fdrefwQu+zrAQ8OxFTJChgUjITGxC4ZQsUmNKvXTI
	 Jh7hTqbFsCGYwYxoaIFN8Q7840SCjtqpCUvLfCAWRAUIaD51HUNFDb+QndeSylPIPeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2NRmpo/1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0840606D816;
	Sat,  7 Nov 2026 14:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2NRmpo/1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA1B1F0089F;
	Sat,  7 Nov 2026 14:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062286;
	bh=URHFUW1r0f+1/MHxdMlnrsvKlga26PfdqNoxgLQP7II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2NRmpo/1jyMRuo03fwTj/VnbofYUNd/q5BF2zKWvX78yLGXWA8dUFnlCGxQ3dXgiX
	 IRlFpRnBz/oxihkQyhdU7NNb6gSKS/Bdf1Jfz/NBa3Dc+33khVwAgt8WQEZm83/wcm
	 sObtQMc88rAf2I37epP6sg1qneRUn6hAp1qnm/68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drobyshev Vladimir <enigma_137@icloud.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1224/1536] USB: cdc-acm: add VeriFone VX820 device ID
Date: Sat,  7 Nov 2026 08:54:00 -0500
Message-ID: <20261107135032.134539871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Drobyshev Vladimir <enigma_137@icloud.com>

[ Upstream commit ddbddee6592ecf6cf6c24d888780f9ad45a3e30b ]

Add USB ID 11ca:0219 for the VeriFone VX820 to the cdc-acm device
table and apply the SINGLE_RX_URB quirk.

Signed-off-by: Drobyshev Vladimir <enigma_137@icloud.com>
Link: https://patch.msgid.link/20260929173833.105208-1-enigma_137@icloud.com
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 884dc80868ca9..990482982a28e 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1819,6 +1819,9 @@ static const struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x11ca, 0x0201), /* VeriFone Mx870 Gadget Serial */
 	.driver_info = SINGLE_RX_URB,
 	},
+	{ USB_DEVICE(0x11ca, 0x0219), /* VeriFone Vx820 Gadget Serial */
+	.driver_info = SINGLE_RX_URB,
+	},
 	{ USB_DEVICE(0x1901, 0x0006), /* GE Healthcare Patient Monitor UI Controller */
 	.driver_info = DISABLE_ECHO, /* DISABLE ECHO in termios flag */
 	},
-- 
2.53.0



