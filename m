Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49E83E9F93
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301055; cv=none; b=PnL8OwtDQIJAYh3PSXrrlg96OdoMWnbQ/8kLTO746hmdR2L54h3EnvnS5lwHQqGbHtf+0OYaeOapCBiuXHpdm1ONKsO7AKMEqKHwdb+gV0Pz1qJdAZSNfPG5csYslUmBcopGQ0iqCMUFPPSAAdenLrsuFBqjGl7eMTg5+aNxQ4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301055; c=relaxed/simple;
	bh=2Ot79I3X2Oj5yUiz/a6rQaX8IY9/oBAy2gEDFuNOjHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJy/O5PTvUZnS6WS0HPW+wBqiClJKb8SwF3mNeusvLfIuGbuCQPydwuNH42iU7GGT13hJOn6ILxGQie6xZM/KhjaFI6pIwRpXBa/gs9s5hKCx59J9uJAbd4ltU+NDGPkFUUcRefP9dUqxKAWS9I+vcLUE/SpogGg6be+3/rHyFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PXq0SkTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PXq0SkTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F4BC19424;
	Sat, 28 Feb 2026 17:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301055;
	bh=2Ot79I3X2Oj5yUiz/a6rQaX8IY9/oBAy2gEDFuNOjHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXq0SkTloVvF7y8eIkafsjEaJOJG3f4IRJ/D86CJTgzYXmuf+4ZGRBPfp0KSpJyP6
	 Sumb4Ps8MZAqanRVnwUqRwuDNSPXfH4aKCcf55K/kfdEY67HcLi1XKsJqY+XFgo8Xq
	 HkoBXhKkOiII8F6TGDsi3P1vSATKAsO+HlvvgW2qO+pfMiIa7Tta9EcFf7VeQNLYXM
	 91gncuaYfntaj3RCGd2xB/b/CRxcz6MUCDbstd5nS/R17YdqVQl02feCbNG305+gn4
	 cYZqo45JQxKqYh6XW9HEucNPSfSPaBbMQL2JzPY2GQQUm/WQ5UDAYKndmTdA5ppJQC
	 5y6rLb0T1nUBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Denis Pauk <pauk.denis@gmail.com>,
	Marcus <shoes2ga@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 196/752] hwmon: (nct6775) Add ASUS Pro WS WRX90E-SAGE SE
Date: Sat, 28 Feb 2026 12:38:27 -0500
Message-ID: <20260228174750.1542406-196-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Denis Pauk <pauk.denis@gmail.com>

[ Upstream commit 246167b17c14e8a5142368ac6457e81622055e0a ]

Boards Pro WS WRX90E-SAGE SE has got a nct6775 chip, but by default there's
no use of it because of resource conflict with WMI method.

Add the board to the WMI monitoring list.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=204807
Signed-off-by: Denis Pauk <pauk.denis@gmail.com>
Tested-by: Marcus <shoes2ga@gmail.com>
Link: https://lore.kernel.org/r/20251231155316.2048-1-pauk.denis@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/nct6775-platform.c b/drivers/hwmon/nct6775-platform.c
index 407945d2cd6a8..0b529a542b0d4 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -1357,6 +1357,7 @@ static const char * const asus_msi_boards[] = {
 	"Pro WS W680-ACE IPMI",
 	"Pro WS W790-ACE",
 	"Pro WS W790E-SAGE SE",
+	"Pro WS WRX90E-SAGE SE",
 	"ProArt B650-CREATOR",
 	"ProArt B660-CREATOR D4",
 	"ProArt B760-CREATOR D4",
-- 
2.51.0

