Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4402E20B7EE;
	Tue, 26 Aug 2025 11:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207017; cv=none; b=Jly1KBxJ5ETd0kI0SOB1a4/HtiRH/e3I5LL8TAeDLZsBm2T0/Pn8fbMW92hJbJmznQmxdQEqm6ZU1axvOx0w33UW0yicOn6rK/NNz2wM+jpHl6wMZRnEI10ZygsnTUz/MEoUF3EgoAtCkkIhON9Ryz/GAApO4KoMBv4iUoZrs70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207017; c=relaxed/simple;
	bh=HVZx9S9y1IcVOlM11qrfkc/FWOCZu7wC2jlPZinAK8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8gAtELMqgh1noPcdybtDn9mGiUOu7hJBPoD322kTUsNgJTxbT2P9R0M3XyCVt+txtEmAN76rSrYYaZq6yZ2HqvA9M30RWpxYj3ttFoQmB003IwugeKjlabBlhQ2NxC4Xk4sfmHpTezXH7x3DbxYNXdZxMlkFeiM8h+U/dzeVIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKa35DVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKa35DVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4DDC4CEF1;
	Tue, 26 Aug 2025 11:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207016;
	bh=HVZx9S9y1IcVOlM11qrfkc/FWOCZu7wC2jlPZinAK8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yKa35DVyPh4Su2jZgRmk7vURd3FEOKbAQ0R5vQJzAhe/ve+YFldlKhUmi9ft56Dfb
	 HpVl5O7sjdxrRF3erXZ2mpaKyZZLWM0gJRGz17yFNeQDrWukiJf+oodNNZkb8Sh1iW
	 W7XxDnsygE0zFVV8QaYM5nA6kAasjuTvI4I7pD8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.16 002/457] ata: Fix SATA_MOBILE_LPM_POLICY description in Kconfig
Date: Tue, 26 Aug 2025 13:04:46 +0200
Message-ID: <20250826110937.358644446@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit ed62a62a18bc144f73eadf866ae46842e8f6606e upstream.

Improve the description of the possible default SATA link power
management policies and add the missing description for policy 5.
No functional changes.

Fixes: a5ec5a7bfd1f ("ata: ahci: Support state with min power but Partial low power state")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/Kconfig |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -117,23 +117,39 @@ config SATA_AHCI
 
 config SATA_MOBILE_LPM_POLICY
 	int "Default SATA Link Power Management policy"
-	range 0 4
+	range 0 5
 	default 3
 	depends on SATA_AHCI
 	help
 	  Select the Default SATA Link Power Management (LPM) policy to use
 	  for chipsets / "South Bridges" supporting low-power modes. Such
 	  chipsets are ubiquitous across laptops, desktops and servers.
+	  Each policy combines power saving states and features:
+	   - Partial: The Phy logic is powered but is in a reduced power
+                      state. The exit latency from this state is no longer than
+                      10us).
+	   - Slumber: The Phy logic is powered but is in an even lower power
+                      state. The exit latency from this state is potentially
+		      longer, but no longer than 10ms.
+	   - DevSleep: The Phy logic may be powered down. The exit latency from
+	               this state is no longer than 20 ms, unless otherwise
+		       specified by DETO in the device Identify Device Data log.
+	   - HIPM: Host Initiated Power Management (host automatically
+		   transitions to partial and slumber).
+	   - DIPM: Device Initiated Power Management (device automatically
+		   transitions to partial and slumber).
 
-	  The value set has the following meanings:
+	  The possible values for the default SATA link power management
+	  policies are:
 		0 => Keep firmware settings
-		1 => Maximum performance
-		2 => Medium power
-		3 => Medium power with Device Initiated PM enabled
-		4 => Minimum power
+		1 => No power savings (maximum performance)
+		2 => HIPM (Partial)
+		3 => HIPM (Partial) and DIPM (Partial and Slumber)
+		4 => HIPM (Partial and DevSleep) and DIPM (Partial and Slumber)
+		5 => HIPM (Slumber and DevSleep) and DIPM (Partial and Slumber)
 
-	  Note "Minimum power" is known to cause issues, including disk
-	  corruption, with some disks and should not be used.
+	  Excluding the value 0, higher values represent policies with higher
+	  power savings.
 
 config SATA_AHCI_PLATFORM
 	tristate "Platform AHCI SATA support"


