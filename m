Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63FC1DE3B8;
	Wed,  6 Nov 2024 12:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894968; cv=none; b=AbwD8zl9q1URruieWevpNFchEtr10B2jgIOQPHnLvKyd9VYWaIShBx1DMp2feL2Sfj+rogxLijMQnqScOO2t5GbPvfB8pPnURKpnMGMB7AfaX04J/35UMmtYItJQg37XsmLHpvSiuLRpYdulpU7iiNT8CcMq9x0X6r86yrte2Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894968; c=relaxed/simple;
	bh=tEGbv1Apo73rITp0whjjeo8KR16pFUs7Erkph8GGylA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ramkGC0oJvcEfaTSU58IfmTwlpzbCcLy1SF4daBTdE+9V5YfMA2T2JyPMXJnpxwCWMNjpSBVwob/5hG4wNqFL1Ln5VbasQxHSkb6J/fohz4eqV7RQ4rEdg/RWoTUurE5U0HhouTztGH5sknwFtcQ/rZNMbCXcaGC4a1E4c3aCn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDySxxlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDySxxlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60D7C4CECD;
	Wed,  6 Nov 2024 12:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894968;
	bh=tEGbv1Apo73rITp0whjjeo8KR16pFUs7Erkph8GGylA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDySxxlL9cT/MQkTXbSc/SV8O8AeD7t9pYLoWiEh6J3kA75jhkNMkEeCRt+3cQbjq
	 MFmNZMkdkliswRcuNAtNY5wTKVq+zBhrjf/C1S7QNbelx4p99+Xad0ZXC5GDXvoRft
	 NJSX5ZhNeAyV6AVQm/cYKYUzJq+g6q4MA27/OzcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/350] ipmi: docs: dont advertise deprecated sysfs entries
Date: Wed,  6 Nov 2024 12:59:49 +0100
Message-ID: <20241106120322.399043839@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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



