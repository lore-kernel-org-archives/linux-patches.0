Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D540A1EDA0F;
	Mon, 23 Jun 2025 21:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714147; cv=none; b=Nh/RUIS1l3OxSQ/L8+Ur2kibxKuFh4aorcz/c25pE9okTPffb/WUsoU4qEXDd8E29ZQnX2Q30GBmdKkhrc5oe8+k6oU3x79yyB5o1dtSNXSCVB62z2KJJ8GHgebkxf21+yzvlQjkYw59t1BqHoPkl95Lo4wUjdn+egsNB1OkCfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714147; c=relaxed/simple;
	bh=ntgaNXtJAaERJoSo/gKK4XgSO1EAx9fAWYWLeCOLpRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHbuZFQEGoN6hAj73kxBr9zn6bA0P6fR9TM+qnspgE50U4uOAi48FreyXsHtuAZkXMQiL4Ouf8Ni9sh9xSQ8N1b3XoiL5SxWhhBmYVm/fIiw1IPrwxk+l3mxMHwJteBaQcik3BVBV6SPN/RvvSej4PfFRRDHSwEUBAlE7NDXDkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCpGp8fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCpGp8fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5B9C4CEEA;
	Mon, 23 Jun 2025 21:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714147;
	bh=ntgaNXtJAaERJoSo/gKK4XgSO1EAx9fAWYWLeCOLpRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCpGp8fweD6zMdQ/tQ/nPO2jcw2xfw0sv8H5R38oib3VscSLSomTbYdAFehVrfu2Z
	 cdMIZ2oNSs5Yc9jApuscLDd+2vWBmFZqxA/F6j3Se0XyXvVS13hbS9EBO7ifL8T5AK
	 PKLOIiIX2VkfhI9oNtYRo7G4HtBzItuOVCBQ3wKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 105/414] net: ftgmac100: select FIXED_PHY
Date: Mon, 23 Jun 2025 15:04:02 +0200
Message-ID: <20250623130644.723958455@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit ae409629e022fbebbc6d31a1bfeccdbbeee20fd6 upstream.

Depending on e.g. DT configuration this driver uses a fixed link.
So we shouldn't rely on the user to enable FIXED_PHY, select it in
Kconfig instead. We may end up with a non-functional driver otherwise.

Fixes: 38561ded50d0 ("net: ftgmac100: support fixed link")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/476bb33b-5584-40f0-826a-7294980f2895@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/faraday/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/faraday/Kconfig
+++ b/drivers/net/ethernet/faraday/Kconfig
@@ -31,6 +31,7 @@ config FTGMAC100
 	depends on ARM || COMPILE_TEST
 	depends on !64BIT || BROKEN
 	select PHYLIB
+	select FIXED_PHY
 	select MDIO_ASPEED if MACH_ASPEED_G6
 	select CRC32
 	help


