Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0B915B138;
	Tue,  9 Jul 2024 11:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524067; cv=none; b=eEmfGH2YLB2maVjmdGRZWAzuKE3aTKhI0NWwF37j8dbJVXx3onQUMmpy2bmc3iDeur4NuN/Fbuo82bad/QEzX674e4SEazhlQenjzKWhN07TRVpUgKwBlCiTeqQPBG3peQpAN5GSUNt4sKT5Lb1Sh8vQ/ogDeEvmJPirBku198Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524067; c=relaxed/simple;
	bh=YujurhwuE8/UBmyT1ykaEU7eLWMIRRIzZgo6FNhcKVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FP2ccZSSHxSlOWvjRLBUIdpvPr42ll6qCiga9G3opbPB0etfejgkzHjIGgYnqJ6t0FCm1S2KQKkTx/Kqv2y4j4ZWG4uX3hrBgM+tvSo7FGEWRa9fLrvGo6WWjWmTl+/sg0rxqMnIywyyVDX9jS+SqYqFg+hqxt+sOYpINua7kWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhI0WlmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhI0WlmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AC6C3277B;
	Tue,  9 Jul 2024 11:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524067;
	bh=YujurhwuE8/UBmyT1ykaEU7eLWMIRRIzZgo6FNhcKVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhI0WlmBNJKFOr3pjzeEDOpi8M4Ichq3JJi9858dZMmtF5o/tQqioFIt4TJQOQif4
	 IxQnAxIfn837UlGcYHxp5TXnPXlll24p7LoROPT3xW72h6mGQqrHD8kAz4tNouifqy
	 /ghNkJYYiuhPrlR5GZdBxHEe52Ry+A/jhmX2ZeDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 059/197] i2c: i801: Annotate apanel_addr as __ro_after_init
Date: Tue,  9 Jul 2024 13:08:33 +0200
Message-ID: <20240709110711.248001154@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 355b1513b1e97b6cef84b786c6480325dfd3753d ]

Annotate this variable as __ro_after_init to protect it from being
overwritten later.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 79870dd7a0146..fafd999b4bcb2 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1059,7 +1059,7 @@ static const struct pci_device_id i801_ids[] = {
 MODULE_DEVICE_TABLE(pci, i801_ids);
 
 #if defined CONFIG_X86 && defined CONFIG_DMI
-static unsigned char apanel_addr;
+static unsigned char apanel_addr __ro_after_init;
 
 /* Scan the system ROM for the signature "FJKEYINF" */
 static __init const void __iomem *bios_signature(const void __iomem *bios)
-- 
2.43.0



