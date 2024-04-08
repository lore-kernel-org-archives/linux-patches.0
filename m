Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7004A62148;
	Mon,  8 Apr 2024 13:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582407; cv=none; b=gEIy4LPNmYYKPU4kvKufvUsCToqrdJzJ0FL609TFGwLbWs3c7sTZpruQlCUE2DQjbmzm7V8qLTjiQoW0dG4NK/2brU/ynsrlTa8oKHwQ6ISXr7xdcqeLa3cgZkVtzKBHcvxXDPTMJn/KiZOBYXTgvzSZ28pgMsE05Md1Nuo0284=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582407; c=relaxed/simple;
	bh=0KM69m01CIIbnNYGbMATOUO36QdoxP9KD2s5vkBRyA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaSSNhF82jM/OkugDoms49yXmgPioE30GYxkEDoDx3ummc5D4yyJb+M816uCxuZmVZS8kk3Hr6LgnVbsVCy0ZnSrA1maLQHynAoYXUcAoT80yG5jvQ0RLaotR+5cud6UQ1zrM+T59PywgTEqukGoVmM2tTqPFpGzZNhCxFAoERQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fG4fJ+8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fG4fJ+8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC59C433F1;
	Mon,  8 Apr 2024 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582407;
	bh=0KM69m01CIIbnNYGbMATOUO36QdoxP9KD2s5vkBRyA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fG4fJ+8C+/vFgGY8d4vdj7E87DlM+FnzbNlDCp71v5mBf6C7iEB6GXyv4usnCbWLs
	 YnfYBgDkt0tgYyF2nkEQu371oGKBlBN+Pgmw2TNv4wL3TBNBIX7OV/cKwkiUKFYhjA
	 E7xgE1kR6xprDp3Nmp1X+SXuwUw0IdH9mUuyY+mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/690] clocksource/drivers/arm_global_timer: Fix maximum prescaler value
Date: Mon,  8 Apr 2024 14:50:05 +0200
Message-ID: <20240408125404.563979190@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit b34b9547cee41575a4fddf390f615570759dc999 ]

The prescaler in the "Global Timer Control Register bit assignments" is
documented to use bits [15:8], which means that the maximum prescaler
register value is 0xff.

Fixes: 171b45a4a70e ("clocksource/drivers/arm_global_timer: Implement rate compensation whenever source clock changes")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20240218174138.1942418-2-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/arm_global_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
index 44a61dc6f9320..e1c773bb55359 100644
--- a/drivers/clocksource/arm_global_timer.c
+++ b/drivers/clocksource/arm_global_timer.c
@@ -32,7 +32,7 @@
 #define GT_CONTROL_IRQ_ENABLE		BIT(2)	/* banked */
 #define GT_CONTROL_AUTO_INC		BIT(3)	/* banked */
 #define GT_CONTROL_PRESCALER_SHIFT      8
-#define GT_CONTROL_PRESCALER_MAX        0xF
+#define GT_CONTROL_PRESCALER_MAX        0xFF
 #define GT_CONTROL_PRESCALER_MASK       (GT_CONTROL_PRESCALER_MAX << \
 					 GT_CONTROL_PRESCALER_SHIFT)
 
-- 
2.43.0



