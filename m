Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9BC1C1ADB;
	Mon, 14 Oct 2024 15:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919876; cv=none; b=eoqSvCibigRAiUzG8YNoFOoSIX/3O0dlDUv21DidELT7j+oGQNo64XHzLPAxXZmTeF9OpuO45QH+BR1dakwVmnD67v3jNzv9dXzSAA4DN5rP6p7HiX3GdS0GzTtO49b4kRQX+hnIEmV70dFh0wg+dJ2tICt4LDxfQGtlEyXYME0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919876; c=relaxed/simple;
	bh=WajYkgmZ9y6wvKnF/5RizybSj20rWtjxd7WXYvb9HsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iSWEvmsUR0S1bWZXDCm0kRAkhCsa+31RX7Uctf4sQzM2Wlqg2duGyGiCpNXteB7sTbjzFiiJo7nvR+XfFhVFiX+CdltB0l2ne6cvVomWEeJUgq39MFRxrFY//uyNx23dT8y72rLo77ogy1T5ntJp7udearsIY4nIxzySHPf2aJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MN5QBQYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MN5QBQYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB39C4CEC3;
	Mon, 14 Oct 2024 15:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919876;
	bh=WajYkgmZ9y6wvKnF/5RizybSj20rWtjxd7WXYvb9HsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MN5QBQYAk59sFDVkFgqRaAbOZ1uJmaqNzzbfh+UBcsiFcUcW5L01PF1ucNiKWFNuP
	 UW8pU9y8KFXgl/QzsZRDESuAQXnWZAWFIV/VwycekdPpfD5IjY8RTl1tBedQ73evn+
	 CzNXZnhuiQJ/g1/Y+KghEju56vq+LHgN0EZfC4VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 701/798] i2c: i801: Use a different adapter-name for IDF adapters
Date: Mon, 14 Oct 2024 16:20:55 +0200
Message-ID: <20241014141245.609890632@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 43457ada98c824f310adb7bd96bd5f2fcd9a3279 ]

On chipsets with a second 'Integrated Device Function' SMBus controller use
a different adapter-name for the second IDF adapter.

This allows platform glue code which is looking for the primary i801
adapter to manually instantiate i2c_clients on to differentiate
between the 2.

This allows such code to find the primary i801 adapter by name, without
needing to duplicate the PCI-ids to feature-flags mapping from i2c-i801.c.

Reviewed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 208c7741bc681..d3ecd65b0542a 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1751,8 +1751,15 @@ static int i801_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	i801_add_tco(priv);
 
+	/*
+	 * adapter.name is used by platform code to find the main I801 adapter
+	 * to instantiante i2c_clients, do not change.
+	 */
 	snprintf(priv->adapter.name, sizeof(priv->adapter.name),
-		"SMBus I801 adapter at %04lx", priv->smba);
+		 "SMBus %s adapter at %04lx",
+		 (priv->features & FEATURE_IDF) ? "I801 IDF" : "I801",
+		 priv->smba);
+
 	err = i2c_add_adapter(&priv->adapter);
 	if (err) {
 		platform_device_unregister(priv->tco_pdev);
-- 
2.43.0



