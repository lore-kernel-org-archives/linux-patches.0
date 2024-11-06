Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DB21F7069;
	Wed,  6 Nov 2024 12:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897973; cv=none; b=r/iSiktpcuf22wf8rapF8vDFwKG4CASdGN/ByR3JgWbAGpycRb7xMOxYaU7u1kuUoRS1aPxNV7w8UccVBntIXNzhvsjQav7lR+qCN8Bi3sABxMRce6VM4s41pDrZoMYKlkTTSWaklqtFtWTkXfeXqni1RlseuKtzW8N5fIGAWAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897973; c=relaxed/simple;
	bh=+LInmZ5Q7T6RKVbPQDpJaNlVS66ibrZLC7Nr80rA2Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfpUtIq5M2ThwznhjpvPBsZ0tc9BSbBsAXUdrn/ltNPvmSYwXvBrNAYehCK+5s7QAJSVovDOple6SOte4lU+GlhygZzd6NkgMDLdKFSyxn9u49U1QoF5jgwEGcyncsx3NOmPpXXH5k+xEmdWp1tZNvewbCDRju4Mp41OEjuv2ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKWo38yj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKWo38yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33583C4CECD;
	Wed,  6 Nov 2024 12:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897973;
	bh=+LInmZ5Q7T6RKVbPQDpJaNlVS66ibrZLC7Nr80rA2Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKWo38yjHQ9+fOpiM0riDLMHMY9NGPMlJ0T7pcEzlJ4rH/kW0ym9XSRNFO6FML9dh
	 u5Vur8AzoRbt3VpoxWrzsjYGpy+CF/wGp0ovswAna/YRpJ5iee5V42Ei6D/LFA0Vyg
	 +qJ465qRD2D++fQQpX3W0Ap1n8T72StRqK3XwylI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/462] ipmi: docs: dont advertise deprecated sysfs entries
Date: Wed,  6 Nov 2024 12:59:35 +0100
Message-ID: <20241106120333.533178340@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 64dce81f8c373c681e62d5ffe0397c45a35d48a2 ]

"i2c-adapter" class entries are deprecated since 2009. Switch to the
proper location.

Reported-by: Heiner Kallweit <hkallweit1@gmail.com>
Closes: https://lore.kernel.org/r/80c4a898-5867-4162-ac85-bdf7c7c68746@gmail.com
Fixes: 259307074bfc ("ipmi: Add SMBus interface driver (SSIF)")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Message-Id: <20240901090211.3797-2-wsa+renesas@sang-engineering.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/IPMI.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/IPMI.txt b/Documentation/IPMI.txt
index 5ef1047e2e663..f3c6530d9f354 100644
--- a/Documentation/IPMI.txt
+++ b/Documentation/IPMI.txt
@@ -518,7 +518,7 @@ at module load time (for a module) with::
 	[dbg_probe=1]
 
 The addresses are normal I2C addresses.  The adapter is the string
-name of the adapter, as shown in /sys/class/i2c-adapter/i2c-<n>/name.
+name of the adapter, as shown in /sys/bus/i2c/devices/i2c-<n>/name.
 It is *NOT* i2c-<n> itself.  Also, the comparison is done ignoring
 spaces, so if the name is "This is an I2C chip" you can say
 adapter_name=ThisisanI2cchip.  This is because it's hard to pass in
-- 
2.43.0



