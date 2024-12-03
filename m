Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6483BB24;
	Tue,  3 Dec 2024 14:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236581; cv=none; b=EtJasj2yi51qCLsmCspD8Nol9kXZbx+1OWkLafLEqGp2eLIO66cnfMRMKDcbDgOP7OoPcPDhOl4d9qviCFvRbIvrtl1v/0VloE6ZrnLa4qrrQ5jXbse48Z48b+Kc9ANdUw5COa20MY9jejbkb/vkqa5XwdB2gDKDtJd1l5bLBW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236581; c=relaxed/simple;
	bh=55luEMPZc0t3lyL+Hg8uus4TZdMtcFw4CSmgb+7OIRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGNb+4yJ2pcvrtfFbo1x85bByfkrpWrxwKj3xwPD0QsrN4Dn1C1LKuDbt8r+Yi42FksXoYW9echusfQuwT4qxQaPZpCnP5qXG5QCsr7jNn14j17ii5SZhuwf9upybEgiYAOUPNguDA0QFSkrz7r4lgOuXLD59OWD9rLsLhTIo9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOIgTOEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOIgTOEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F68C4CECF;
	Tue,  3 Dec 2024 14:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236580;
	bh=55luEMPZc0t3lyL+Hg8uus4TZdMtcFw4CSmgb+7OIRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOIgTOEl+J9Qc/mNJH9+OZmfzShBfB2Mqs5HWmRNX21z0KovcJSCtDmJWwp7GAtBM
	 iF/J+Zo5UaQk4mVKzMnCHS/52WOVyZ4+Y7UEumhiPK3r5B5ZLCk9d/0zsIdhrq7vrx
	 TzPose1SP47nTHmfmFxiOsqbkzLELZy6xecMLxEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/138] mfd: da9052-spi: Change read-mask to write-mask
Date: Tue,  3 Dec 2024 15:31:29 +0100
Message-ID: <20241203141925.855568461@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 2e3378f6c79a1b3f7855ded1ef306ea4406352ed ]

Driver has mixed up the R/W bit.
The LSB bit is set on write rather than read.
Change it to avoid nasty things to happen.

Fixes: e9e9d3973594 ("mfd: da9052: Avoid setting read_flag_mask for da9052-i2c driver")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Link: https://lore.kernel.org/r/20240925-da9052-v2-1-f243e4505b07@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9052-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index abfb11818fdc5..5fb5af5108ab9 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -42,7 +42,7 @@ static int da9052_spi_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, da9052);
 
 	config = da9052_regmap_config;
-	config.read_flag_mask = 1;
+	config.write_flag_mask = 1;
 	config.reg_bits = 7;
 	config.pad_bits = 1;
 	config.val_bits = 8;
-- 
2.43.0



