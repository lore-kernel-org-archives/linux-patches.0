Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45BA1DF25D;
	Wed,  6 Nov 2024 12:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895288; cv=none; b=WTknaOuvONLJfetVgeCEGBB1wyXyJs7nhF1uUD7cl4hs5MDHx2b/D9dy3eoVQyXBcFieUX7nxkO4AMr5T1Ki7f9mLrx0NLTCkk9mSJr/1jQnZbEAy3KYYtl8BGskhbcpSNkrybvt3SYyQCmDaeE/IMxgXceieEcIIPEDFp0T7/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895288; c=relaxed/simple;
	bh=JSKWggX96I/Bs1W0TW/8FL4hd+byMmOmBNhjRCcE25k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qee3ZG6T1c+UGZlyIMNJXOWvSUpbhCaCv9u8qZdtxMJNOHW3FYm/MVwUurhxs4Kb5gCV1iFjb+rzV68x8zxCWearmPcaaYNc3H2/AYQGDVsx1ffz5s0LXpn4ihzm2cALcVAyY0oeWO+QHe1oNhIMWTfThEgYsGC1cwBXNIk5cQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRqegEid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRqegEid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE039C4CECD;
	Wed,  6 Nov 2024 12:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895288;
	bh=JSKWggX96I/Bs1W0TW/8FL4hd+byMmOmBNhjRCcE25k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRqegEidxUNv457NJYN1/X2pPyJknoXWLFNahmUOj+GXTWFqJBLkoxWhbxYOqMeJ0
	 CUng9rC0dJdZfchLss6u5hacRHktUMKjIijj3SoR0SW1grfFXSnGLCobtmvqeV/vBR
	 eCYFhkL0C8Dqn/807Qarkv+ve9okm4Qwtko7GxrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 166/350] power: reset: brcmstb: Do not go into infinite loop if reset fails
Date: Wed,  6 Nov 2024 13:01:34 +0100
Message-ID: <20241106120325.022279247@linuxfoundation.org>
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

From: Andrew Davis <afd@ti.com>

[ Upstream commit cf8c39b00e982fa506b16f9d76657838c09150cb ]

There may be other backup reset methods available, do not halt
here so that other reset methods can be tried.

Signed-off-by: Andrew Davis <afd@ti.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20240610142836.168603-5-afd@ti.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/brcmstb-reboot.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/power/reset/brcmstb-reboot.c b/drivers/power/reset/brcmstb-reboot.c
index 884b53c483c09..9f8b9e5cad93a 100644
--- a/drivers/power/reset/brcmstb-reboot.c
+++ b/drivers/power/reset/brcmstb-reboot.c
@@ -72,9 +72,6 @@ static int brcmstb_restart_handler(struct notifier_block *this,
 		return NOTIFY_DONE;
 	}
 
-	while (1)
-		;
-
 	return NOTIFY_DONE;
 }
 
-- 
2.43.0



