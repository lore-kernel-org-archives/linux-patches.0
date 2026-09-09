Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C862563FC5;
	Wed,  9 Sep 2026 13:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962388; cv=none; b=iRuZctTljcdrnSdBoFF7FVKldqGdF5PyvOWzXac3NxEkl9OZZAu3wVz8V9vfSguUILmg90vxVzAPT/0FUvAfCkvng+3qb+uROCmjJsUtjfqXMSZr86+pPQPV+anzm8GR7/PpeS2va2V+I3MkLZwtrnfGq57c8UGanDjj53ltOoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962388; c=relaxed/simple;
	bh=U4dtIRJw9TC31D6pWSV8JYM4ozl0gluXg3hfBv5pXPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pjmzj8litKVP9PKvV0shl76eoJG7gPcx216akIAHSxNY1IXhHVfjVR4q2odRr8CH5CnBlW2OPPYFgsP4NqbJjV7MAh14P1qvGaM3M/MsZ9uL4jAuL083DSi+Bk1IaeekfTeEoBaChMngKvuMsw8l51blU8JMYAREZG1QUo11+l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0binNVV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0binNVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9892A1F00A3A;
	Wed,  9 Sep 2026 13:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962387;
	bh=IYt6OhMCaJyJJXSeAu0wdCQY3eFVpemXpWfyhZ/Vg8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w0binNVVMwTwcI5r6Th4qJCOmLHIqRF/9rfDnmpirNbVPob4bVXnq66FDZ26RbDjy
	 nuGKhUvph3zwHmUf2/g2E3pDq4/3pVbi8n7tLamGjvcTpRowOZKjevzesmxTmIr+0n
	 6zKILtrZIhBywwVZx/64/G27zOe69ZS0b7BEfQVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 273/556] iio: dac: mcp47feb02: add missing select REGMAP_I2C to Kconfig
Date: Wed,  9 Sep 2026 15:39:13 +0200
Message-ID: <20260909134240.217147471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit 739aac87638f06fcf851df41ecd52d30ab7b0570 upstream.

The Kconfig entry for the MCP47FEB02 is missing a 'select REGMAP_I2C',
causing build failures.

Fixes: bf394cc80369 ("iio: dac: adding support for Microchip MCP47FEB02")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -552,6 +552,7 @@ config MCP4728
 config MCP47FEB02
 	tristate "MCP47F(E/V)B01/02/04/08/11/12/14/18/21/22/24/28 DAC driver"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  Say yes here if you want to build the driver for the Microchip:
 	  - 8-bit DAC:


