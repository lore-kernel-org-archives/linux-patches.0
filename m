Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AED355E4C;
	Tue,  9 Jul 2024 11:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524662; cv=none; b=ns9VW4BtVpQDt7Oh4F+wDtbfImdM7AtwPxPS6WC0TvMbrY66x4KDZnIQqi1w1K6lsLlszIKB5BM3FUbh9lF9SfFZ7DSNN7ynVQ7otdeQBhIY5NI19RHGu82H59xwKTvIZFyUJoMe9z3eNAGNaqd8W28y2U2iN3nEnVTaRNa9AFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524662; c=relaxed/simple;
	bh=bqs3qgnsnjwFCFnphByjipu/lgLSxy+JTC23wufxBDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtaaA7y/Azi9Fuu5ELzRWP2gYNMlnhn1PEuv7tPS/EDC5zRNqRsUwcxML+8eYcGOjeKwKeAk4tBu2xg2vKAn3pk6kf0CmIubaWGv18iDkR5g3KlEIMjhkaBStcSWqoYFUTLzCz2fxXvm/ZW4rcFO92W3O0AR+PMu+UveS27DNpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlhF9SdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlhF9SdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65C2C3277B;
	Tue,  9 Jul 2024 11:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524662;
	bh=bqs3qgnsnjwFCFnphByjipu/lgLSxy+JTC23wufxBDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlhF9SdOBUXfduCBV/wKR7kMbEIPHrlQI9lBEhj8wImp+5xNt13MiDYrUsCyyVCbw
	 34+1qcmXTG1DznltxwsrNWsL9v/WWGurTE8b4BPpsCofqK4kyjutf3yKUKTY44yA/q
	 LHrWwacMI1zqdqFgsBnez+l8fshnJPuqasIFqxXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/102] i2c: i801: Annotate apanel_addr as __ro_after_init
Date: Tue,  9 Jul 2024 13:09:50 +0200
Message-ID: <20240709110652.424996580@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 355b1513b1e97b6cef84b786c6480325dfd3753d ]

Annotate this variable as __ro_after_init to protect it from being
overwritten later.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 1c970842624ba..208c7741bc681 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1057,7 +1057,7 @@ static const struct pci_device_id i801_ids[] = {
 MODULE_DEVICE_TABLE(pci, i801_ids);
 
 #if defined CONFIG_X86 && defined CONFIG_DMI
-static unsigned char apanel_addr;
+static unsigned char apanel_addr __ro_after_init;
 
 /* Scan the system ROM for the signature "FJKEYINF" */
 static __init const void __iomem *bios_signature(const void __iomem *bios)
-- 
2.43.0



