Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D5B1C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1xdOqj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73485C433C7;
	Wed,  4 Oct 2023 18:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444493;
	bh=MudhFSa2MnjPFbNsOOIIBJpT0reh4DMUI3DFH8vQyoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1xdOqj9NeFwF9EN2lDGjHTBYKegnXGDzf17nOR4uBp5sVn0twz+TL4wqeMw7wMQ8
	 p8TealH69Lpfcn3ZrYsor8mtQKEiEEpZ38fPgbGFBrvzekiZgWW9BAT3n4IMUWE/9R
	 vy8EBV5HLXWpKSpl6BQt950F7MREJjUUloE6yEx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jean Delvare <jdelvare@suse.de>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.5 269/321] i2c: i801: unregister tco_pdev in i801_probe() error path
Date: Wed,  4 Oct 2023 19:56:54 +0200
Message-ID: <20231004175241.745149288@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1754,6 +1754,7 @@ static int i801_probe(struct pci_dev *de
 		"SMBus I801 adapter at %04lx", priv->smba);
 	err = i2c_add_adapter(&priv->adapter);
 	if (err) {
+		platform_device_unregister(priv->tco_pdev);
 		i801_acpi_remove(priv);
 		return err;
 	}


