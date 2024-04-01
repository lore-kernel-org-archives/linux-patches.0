Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3305A1DFF4;
	Mon,  1 Apr 2024 16:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990222; cv=none; b=DEsrgb2AN2cQK6DG3c3hP8cHiVsuK71WIscyUKKx0XBDYIerKBq83jrZFTvMWWg9I8E1Ze+0jNKy7fdT3krlgG972RYVKkNVZ01DConpPi7HBxLTSIGQsFENFmd86Q5CWBBrRqTW9mLJJ2a8pzbtse3baBx16hZPVo3lNHuzmj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990222; c=relaxed/simple;
	bh=ajgTVfiTWNkEARLoh8XyRxUFWZM9LsgJrxsv11FyKnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROihcrBY5nJoZNCDiUsD9wYm11J0I/5ym1gtZmOJzx11MRubTXH6P2zfPvIaf49Hf3WkbXwFU8OIyUkoUOZkgNpFnBZEJu3v3y36K9ep8i1hGj16aByHQlHMdxe4rumQNuk6D1Eqi6KdOYTPDaWjRawoJaDD/D7QdilD9a6V4sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9QXvKmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9QXvKmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969DCC433C7;
	Mon,  1 Apr 2024 16:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990222;
	bh=ajgTVfiTWNkEARLoh8XyRxUFWZM9LsgJrxsv11FyKnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9QXvKmXhSWNGfERyZC8mikTuGdcQ71ynXMDv1Orwg54JSwzeucOYhWLJHSdrtpUz
	 rV2XDagraO2DwI9XlYf3gWSuwzQ3JzFQOZ33ntubgyz27sNcsG+KWfz4p1XCS1G2nr
	 NSYfUK90cdUWyD815ZeTD53scgUZW4LjS9BhyI1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 284/396] clocksource/drivers/arm_global_timer: Fix maximum prescaler value
Date: Mon,  1 Apr 2024 17:45:33 +0200
Message-ID: <20240401152556.375164488@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



