Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590896;
	b=mBmxMgkE7UWvjqKfd1H2sMBp3b0zCRZ/PqJJV1OoZ+hGzLendglsrfNz1xWwh21+4qAO
	 /aJs5L15H2YPOxfZUUMPTfkeq729q9IBsNTRx8xxgR+pfLhxBLnHZCp+DPI7KTwYkz7JO
	 b7cDBy+j8WDB1yLyM2PZrKiwl705mBMdGhhuYbR46zfkmT3rzQUs4cGiF0lIJF2xRn416
	 o+xsOKxT3zXdCpoILse8QR1wkos/AShQRvxYLjzIVuBm7Fpd4Dy7mWDWboFnVl3cdze9C
	 p8vSu3FtkEv54YczXrIjMFCy0gsbNxnM9hb4O7X5086AGslJQRmkre4OXdwFfftAPqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DvfJf3OD99Zipu/lIWgNfAOwb/K+xaOW4dzeshNVn8o=;
	b=4afZbW646LZPD2V2TMo6pgAXYEG7/yzImjA//Cp7RquQVoiyYj9Tf7fvLCl6Q5i3SVQv
	 DV4tTK/IyoBpMtqv8GKKkesgzmm0cB2BN08s9Pu5JCaoZ0bNNyFXX5l2dgZ5aahZNZN6a
	 rPddXldWeujzLkpco1WpFEwYk/CJ7VxxHvUNdm3Zci1hz7h7Y+ry4U7bTEnrajpvTUUSk
	 LPo5CELDZLTmNLjA8NZ4q28cISRNH2Evay7JJTayHb1//Se7vu+znFzLkKgQOK4xJbcpG
	 k461C7BOhwQZd6fpEbO4cJcYXs9cPipY6/biWlHWQxfDBhlbscR9bPkveUBh6fI3KaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KoWIReZ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFA5607EE64;
	Fri, 13 Nov 2026 17:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KoWIReZ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3961F000C5;
	Fri, 13 Nov 2026 17:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590896;
	bh=DvfJf3OD99Zipu/lIWgNfAOwb/K+xaOW4dzeshNVn8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KoWIReZ0DZUVG0EJ4bf3npfu3ciAHWJrornSXkT/uRHqfFjkF/4KOmKU8rokRdEQ9
	 GgWtVCNyvGr5bGaAkQzFUd5RceZ6QzfOHo1qK0zFYn9odPJ5pDPYHK8ATUuySRZmx2
	 ob9HVZTBYp5IgimlCStzmYgGZlmMDH2JhsL8QizM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/670] mtd: rawnand: ndfc: fix gcc uninitialized var
Date: Fri, 13 Nov 2026 10:44:11 -0500
Message-ID: <20261113153814.861940461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit cceca8cb776b03e83985578f84bd730c30d57f70 ]

Now that this can be built with COMPILE_TEST, an unassigned variable was
found. Set to 0 to fix the W=1 error under GCC.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606141301.iyVdFgl7-lkp@intel.com/
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/ndfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/ndfc.c b/drivers/mtd/nand/raw/ndfc.c
index 29198c4af5e6d..a2e2238339ec1 100644
--- a/drivers/mtd/nand/raw/ndfc.c
+++ b/drivers/mtd/nand/raw/ndfc.c
@@ -188,7 +188,7 @@ static int ndfc_probe(struct platform_device *ofdev)
 	const __be32 *reg;
 	u32 ccr;
 	u32 cs;
-	int err, len;
+	int err, len = 0;
 
 	/* Read the reg property to get the chip select */
 	reg = of_get_property(ofdev->dev.of_node, "reg", &len);
-- 
2.53.0



