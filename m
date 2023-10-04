Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0741D522
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE708C433CA;
	Wed,  4 Oct 2023 18:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442947;
	bh=9/ccnkcjSSbRoRTyIDD+dK7h2hDx5FUzcGp1G4JqJUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+m2KHM3y4PSTbOnj2jY+qbWw75c+KmweBQ+rQL+eKQMRU0Cwp4wAvd11u09sy479
	 wkS06nlalZLHpQ74MgCocXv0IrGw3vNDy9C0HyqM1GD46U+qgw35U0LZiKidLX33Lc
	 CU35wsDt1Z+Rk5AKuoHxUHcotrjRocHo/TugLHOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jean Delvare <jdelvare@suse.de>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 166/183] i2c: i801: unregister tco_pdev in i801_probe() error path
Date: Wed,  4 Oct 2023 19:56:37 +0200
Message-ID: <20231004175210.987683731@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 3914784553f68c931fc666dbe7e86fe881aada38 upstream.

We have to unregister tco_pdev also if i2c_add_adapter() fails.

Fixes: 9424693035a5 ("i2c: i801: Create iTCO device on newer Intel PCHs")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-i801.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1861,6 +1861,7 @@ static int i801_probe(struct pci_dev *de
 		"SMBus I801 adapter at %04lx", priv->smba);
 	err = i2c_add_adapter(&priv->adapter);
 	if (err) {
+		platform_device_unregister(priv->tco_pdev);
 		i801_acpi_remove(priv);
 		return err;
 	}


