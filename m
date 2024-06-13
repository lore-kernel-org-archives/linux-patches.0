Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2748E82C76;
	Thu, 13 Jun 2024 12:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280139; cv=none; b=KjSwUkeO2Kdn/eXcnXfMZmFMiKXHnpzJ9ASREGjS9/HtkdzYb81HJlpfQwJWJ12q7sn3ZbclJ+ZrjL4VkCQBnUKwrmLvws2bL8SH0PpT5Y5balunNVwD8s99Zxoy4QZMj4d96Zh+g9ptC5ssgY2raW+uBcNfrrNorTwKoLApPGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280139; c=relaxed/simple;
	bh=NkQ19nYYLrOjmysEePtp7y4cRo3KmbmYd/Yf3Z5YNbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEHHJx0xFbDNpmgHB102Chr/7LMoY9PIf1iwBfqHBruYp2+Hq7q+WMQ+nNLx+LslsiTTQ6r4sNKEvpwk57Cr+0Z6DTH0zLF9XLOBKEvzbmJsHZLq7weUMVz4toXzeB7gBK1DMjnGdIo649eTVszZtqcWTSUCVaW5IZuNNBOk1l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GuTaQhE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GuTaQhE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7C3C2BBFC;
	Thu, 13 Jun 2024 12:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280139;
	bh=NkQ19nYYLrOjmysEePtp7y4cRo3KmbmYd/Yf3Z5YNbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GuTaQhE1rPJ8O6AHq40By0lUBZD6JVD1+Uw1SM8qkOhAd8hvwHq5xpnwaUQ+jGe17
	 uoWW3AukmrH+KuY0XMXAUQoEH76qL3bH2fi6FRYzggM4H+sU/cvtaFXI81gio+7fkf
	 3zEzBQxTfhbFvoRt19t/Uj8MaVVySggo0NgR0ZII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenglin Wu <quic_fenglinw@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/202] Input: pm8xxx-vibrator - correct VIB_MAX_LEVELS calculation
Date: Thu, 13 Jun 2024 13:33:43 +0200
Message-ID: <20240613113232.586917365@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

From: Fenglin Wu <quic_fenglinw@quicinc.com>

[ Upstream commit 48c0687a322d54ac7e7a685c0b6db78d78f593af ]

The output voltage is inclusive hence the max level calculation is
off-by-one-step. Correct it.

iWhile we are at it also add a define for the step size instead of
using the magic value.

Fixes: 11205bb63e5c ("Input: add support for pm8xxx based vibrator driver")
Signed-off-by: Fenglin Wu <quic_fenglinw@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240412-pm8xxx-vibrator-new-design-v10-1-0ec0ad133866@quicinc.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/pm8xxx-vibrator.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/input/misc/pm8xxx-vibrator.c b/drivers/input/misc/pm8xxx-vibrator.c
index 53ad25eaf1a28..8bfe5c7b1244c 100644
--- a/drivers/input/misc/pm8xxx-vibrator.c
+++ b/drivers/input/misc/pm8xxx-vibrator.c
@@ -14,7 +14,8 @@
 
 #define VIB_MAX_LEVEL_mV	(3100)
 #define VIB_MIN_LEVEL_mV	(1200)
-#define VIB_MAX_LEVELS		(VIB_MAX_LEVEL_mV - VIB_MIN_LEVEL_mV)
+#define VIB_PER_STEP_mV		(100)
+#define VIB_MAX_LEVELS		(VIB_MAX_LEVEL_mV - VIB_MIN_LEVEL_mV + VIB_PER_STEP_mV)
 
 #define MAX_FF_SPEED		0xff
 
@@ -118,10 +119,10 @@ static void pm8xxx_work_handler(struct work_struct *work)
 		vib->active = true;
 		vib->level = ((VIB_MAX_LEVELS * vib->speed) / MAX_FF_SPEED) +
 						VIB_MIN_LEVEL_mV;
-		vib->level /= 100;
+		vib->level /= VIB_PER_STEP_mV;
 	} else {
 		vib->active = false;
-		vib->level = VIB_MIN_LEVEL_mV / 100;
+		vib->level = VIB_MIN_LEVEL_mV / VIB_PER_STEP_mV;
 	}
 
 	pm8xxx_vib_set(vib, vib->active);
-- 
2.43.0



