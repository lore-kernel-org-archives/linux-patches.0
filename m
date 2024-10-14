Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5D21AE01F;
	Mon, 14 Oct 2024 15:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919057; cv=none; b=B3JIYIQJxhLEa5lm27LplGBD0st85aWUdnOFkS1DvG8DO98ltigLlmFN3UKehdndoDKjm8N75ZLO/dWykf6h4JD7897pLVSYM6QD8qgrS2TZAgNgqW6ukuBDHmZNbcdmPS6fY3WIsHPFJ+ysbKnqdr3Tpj3Jmm14nCcT1ZvS6dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919057; c=relaxed/simple;
	bh=QHkiL1j6NWEyF4Hkz3FZR8xTePLqMKm60YdGvamFnvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6zlbh1CZ1Xl3VDigmtR6+NYL1J4Sr/aewvpw2ivAY+01Uo+j30REugqHt75f0Z7RNn3PfdatPHUGwxUwMyWij74FeoOW6mfnPu8T9j0+SIogJN6b/EQtp1BwqEdAkSnF+wus4k9zahTPu/HrrFSWDXWtvKZrUnX5rpea8BZs6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=132MoPrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="132MoPrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA08FC4CEC3;
	Mon, 14 Oct 2024 15:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919057;
	bh=QHkiL1j6NWEyF4Hkz3FZR8xTePLqMKm60YdGvamFnvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=132MoPrx87Ybh4EmD7LkwLK2hxU3TdTPWU3anZRRNTxUPVwZwY0qqoqvvIZ4HvgNV
	 fX8AlhhKyf/UoYjScIvSUAS1MiU7ds7XvZXi5bp56F4VuTvPzyOw0zoQ8txYKEXXdc
	 U5QUfTUXlri3zPfK0kda95Xm5TjXdLr6eTPU68D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 469/798] power: reset: brcmstb: Do not go into infinite loop if reset fails
Date: Mon, 14 Oct 2024 16:17:03 +0200
Message-ID: <20241014141236.400255575@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0f2944dc93551..a04713f191a11 100644
--- a/drivers/power/reset/brcmstb-reboot.c
+++ b/drivers/power/reset/brcmstb-reboot.c
@@ -62,9 +62,6 @@ static int brcmstb_restart_handler(struct notifier_block *this,
 		return NOTIFY_DONE;
 	}
 
-	while (1)
-		;
-
 	return NOTIFY_DONE;
 }
 
-- 
2.43.0



