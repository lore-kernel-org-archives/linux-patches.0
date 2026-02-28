Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A62347FCC;
	Sat, 28 Feb 2026 18:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302435; cv=none; b=qvkf08iVjiTZQYjsacIvLv+wXnH/Nu++tRyW709749iomadsE0o2Ttn6+G74ml8iNLk0bxRdkOSbRmr7q0hkT2LDsS6omhN4RnVR7sNEUcXYxW4FPKjI9Pw7acZiqA8ElOm6X+EGfxfbrc35dII4GS2mGwMZITdfHS0QQOH/qgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302435; c=relaxed/simple;
	bh=Z8+l7qWIdCKFqTzr0cK8Uul3NJQ9Fy5cZ/Uw7L35OtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+GjjsCJyhiSI0FhhXRGT9NNZtfjLcL6hzrlQB20MfcijOspEOZxT28zLQgWT+QzEUaVf1Za+fW2/qIdZ6O/cEnPK0NN/EDSqBrDG9aJxN/WxwwrpHYcZN9LHncj2HUiJHtV/bE7pxA+DjPhjSOLtcaRzJolf9A1M506X+w3EnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V5j5Af9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5j5Af9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA25C116D0;
	Sat, 28 Feb 2026 18:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302435;
	bh=Z8+l7qWIdCKFqTzr0cK8Uul3NJQ9Fy5cZ/Uw7L35OtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5j5Af9ePxVObCvWRRkaiUBgkXtdQu09PuGd31cnKDT78JwNk8kkPWg9mVTNt9VpT
	 /t5r4hNDaVusxb26qtyhzfQGhP7rH4Vr4MYvAByy0r1Psl3rM9oVqQZHVGnryW0tPS
	 UnjpollVxWZogrs2Anpood9jkWjsedX9AEow2tkIKvsGPDSgVsJ9rC+bzYnoMJQi2F
	 PoLj/LTBtOxUSVU3zscBSiXISdPn9aTjxV4d8R/KCxF5ItfXYvrQ7A+8KgaBDTjv50
	 zMygmnyKedzRbG+2bXvRepuYtvbcWSW6mxc5qUjmI1bza2oziTMBIeL3RTcohj5wgS
	 Z+1xQJ1eFJOtg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Linus Walleij <linusw@kernel.org>,
	stable@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.1 173/232] ata: pata_ftide010: Fix some DMA timings
Date: Sat, 28 Feb 2026 13:10:26 -0500
Message-ID: <20260228181127.1592657-173-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Linus Walleij <linusw@kernel.org>

commit ff4a46c278ac6a4b3f39be1492a4568b6dcc6105 upstream.

The FTIDE010 has been missing some timing settings since its
inception, since the upstream OpenWrt patch was missing these.

The community has since come up with the appropriate timings.

Fixes: be4e456ed3a5 ("ata: Add driver for Faraday Technology FTIDE010")
Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/pata_ftide010.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/pata_ftide010.c b/drivers/ata/pata_ftide010.c
index 092ba6f87aa31..47e0ba9036875 100644
--- a/drivers/ata/pata_ftide010.c
+++ b/drivers/ata/pata_ftide010.c
@@ -123,10 +123,10 @@ static const u8 mwdma_50_active_time[3] = {6, 2, 2};
 static const u8 mwdma_50_recovery_time[3] = {6, 2, 1};
 static const u8 mwdma_66_active_time[3] = {8, 3, 3};
 static const u8 mwdma_66_recovery_time[3] = {8, 2, 1};
-static const u8 udma_50_setup_time[6] = {3, 3, 2, 2, 1, 1};
+static const u8 udma_50_setup_time[6] = {3, 3, 2, 2, 1, 9};
 static const u8 udma_50_hold_time[6] = {3, 1, 1, 1, 1, 1};
-static const u8 udma_66_setup_time[7] = {4, 4, 3, 2, };
-static const u8 udma_66_hold_time[7] = {};
+static const u8 udma_66_setup_time[7] = {4, 4, 3, 2, 1, 9, 9};
+static const u8 udma_66_hold_time[7] = {4, 2, 1, 1, 1, 1, 1};
 
 /*
  * We set 66 MHz for all MWDMA modes
-- 
2.51.0

