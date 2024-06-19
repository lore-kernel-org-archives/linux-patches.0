Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196C212FB31;
	Wed, 19 Jun 2024 13:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802506; cv=none; b=uRAq59lvmLaWw5X/lX7JAwn/etKAIeg5c80wFJSa8fMe+gyFJ+lCmaizLaySBKQ41w5YkrR6NJ8T2/XrNJ2T26EQmg+CEK/Qa0zTxkB2Bqr6jWExsb1ic2fk7hDQ1brLJA4fIVroqpI9aqclt5AVYmktk9dMIe0gwJp8wQlkCjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802506; c=relaxed/simple;
	bh=gh9sFv8YCEjwh6onXerNR9flz2WbtmazLG5I/TV0CKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aT7hN4OUlWPtPj0REDUSCHUVPhW3b7q9y0a48K44Jy1mxj6r78h03cEambynpUVnlJhlCIPjtp3jCZAyrVfMTJVPoLP0ev2fNjr3KLCP+t7qogltihGEcUGJ4uemsA3DrBRi9Yl2oNIjYtBj7TAnlc9IcQ7ePfk4D3rpQYB0N3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A61UgWQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A61UgWQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B17FC4AF51;
	Wed, 19 Jun 2024 13:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802505;
	bh=gh9sFv8YCEjwh6onXerNR9flz2WbtmazLG5I/TV0CKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A61UgWQJqjbDzMreZctdBrSxMA6RiM6RNA5mPwRKhVy57rclBoJLsl7kJvmi/4MEd
	 gG6mc/u9Npelq+aag4tFaeP1uv9V/JeKaraZGc/6LKL57a1eO/qh2qaDwDiRCHBjF9
	 GDKRD7FSBekPa2a6QZkjZUarLlSmH3oDTcS2eDfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 188/267] clkdev: Update clkdev id usage to allow for longer names
Date: Wed, 19 Jun 2024 14:55:39 +0200
Message-ID: <20240619125613.557162266@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

commit 99f4570cfba1e60daafde737cb7e395006d719e6 upstream.

clkdev DEV ID information is limited to an array of 20 bytes
(MAX_DEV_ID).  It is possible that the ID could be longer than
that.  If so, the lookup will fail because the "real ID" will
not match the copied value.

For instance, generating a device name for the I2C Designware
module using the PCI ID can result in a name of:

i2c_designware.39424

clkdev_create() will store:

i2c_designware.3942

The stored name is one off and will not match correctly during probe.

Increase the size of the ID to allow for a longer name.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://lore.kernel.org/r/20240223202556.2194021-1-michael.j.ruhl@intel.com
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clkdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -144,7 +144,7 @@ void clkdev_add_table(struct clk_lookup
 	mutex_unlock(&clocks_mutex);
 }
 
-#define MAX_DEV_ID	20
+#define MAX_DEV_ID	24
 #define MAX_CON_ID	16
 
 struct clk_lookup_alloc {


