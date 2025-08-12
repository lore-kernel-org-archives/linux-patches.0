Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3792FF169;
	Tue, 12 Aug 2025 18:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024093; cv=none; b=XQeutcZzlgOv5h1WZi252THM2pFxEVfB8SdH3EHWgKaQcxkUZ6wDcwXkvNY0gmdaTalaqXolap6b13DtkudLI6rpz1s/diuxD4iUbIc/0FtGym/jZmXBPW0c8Nd0JBmJ4gnJ+l+5uLgZ5u4oH+0uzAWY4o7vMHzLF1iTAU1eX14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024093; c=relaxed/simple;
	bh=j3LX5L9ElR9elkUgG/uL9ugGcYffiCiXW5SetMSLZJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKP837MjbbkVigm/Zj6DQzTrp5IjA08VDHYksKf6giYihaNgEjxLFkMd5wZLMK2YS9+4Y2Yqf8tZp5twiOSwMlvv8BAoW2jEWOksyLSsj0HWTJ4i3+VJOgxFufJ31Yd0kf0me//QQ6MPwZC33au9g6pCfJr+5VMyhNAUxTz1D6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAadXylC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAadXylC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F92DC4CEF0;
	Tue, 12 Aug 2025 18:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024092;
	bh=j3LX5L9ElR9elkUgG/uL9ugGcYffiCiXW5SetMSLZJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAadXylCRmeWM4tkAzbR9roptbvrGlDUvHZONqymLvHmtfrUFvWc7W700qqyutn9c
	 BldSUE0/tLNDxQ2uRTCl/aq5uJcPvuNouOyAeNbkOFl1JskCL0Zf4uwAbVWJVtOFiU
	 HWTkFdMNgihaAp74K/IHxyowdt+vrMyH0JC3URp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 270/627] can: tscan1: CAN_TSCAN1 can depend on PC104
Date: Tue, 12 Aug 2025 19:29:25 +0200
Message-ID: <20250812173429.581533876@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b7d012e59627c1d1bb2ad5d71efc69a070ef767d ]

Add a dependency on PC104 to limit (restrict) this driver kconfig
prompt to kernel configs that have PC104 set.

Add COMPILE_TEST as a possibility for more complete build coverage.
I tested this build config on x86_64 5 times without problems.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250721002823.3548945-1-rdunlap@infradead.org
[mkl: fix conflict, remove Fixes: tag]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/sja1000/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/sja1000/Kconfig b/drivers/net/can/sja1000/Kconfig
index ba16d7bc09ef..e061e35769bf 100644
--- a/drivers/net/can/sja1000/Kconfig
+++ b/drivers/net/can/sja1000/Kconfig
@@ -105,7 +105,7 @@ config CAN_SJA1000_PLATFORM
 
 config CAN_TSCAN1
 	tristate "TS-CAN1 PC104 boards"
-	depends on ISA || (COMPILE_TEST && HAS_IOPORT)
+	depends on (ISA && PC104) || (COMPILE_TEST && HAS_IOPORT)
 	help
 	  This driver is for Technologic Systems' TSCAN-1 PC104 boards.
 	  https://www.embeddedts.com/products/TS-CAN1
-- 
2.39.5



