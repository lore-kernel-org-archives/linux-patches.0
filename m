Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F230F26A0A2;
	Tue,  8 Apr 2025 12:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114405; cv=none; b=ocNjhp4CRSBVgEWARI9NoiHpBEstOvFlpxpLteNXvzIFxOf60IpcFn71L9a0IQw/dShMOfMXIseL1B9vI4RIyNJnLb/g96mPfoXzoHoEmGp89LLUUB7v37HxQtkK4DglHda9HYo6XO9/aTXL0q++zxPUyo9IVtL0Uc6oDqcyUiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114405; c=relaxed/simple;
	bh=745hNRV0hzzpWOGvoSF2tWE5oIgr7PLsvsPa2OZSx3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J5mM4BOW1OwM3XAf7j0scT75xwzq9CD4pYHemV4tIbB+MN/asB+KMvlWJiSwByHCQlpDFs1wEzWmZvAfDSLuvBaox613qG6j6apA7znrqLoBY/KKrlcLwPeSrHJZApq2MAMYQefUZvYa1ubzYb4nY3tHm2RjAPmMENC5RH+R14g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ie34jWqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ie34jWqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821DCC4CEE5;
	Tue,  8 Apr 2025 12:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114404;
	bh=745hNRV0hzzpWOGvoSF2tWE5oIgr7PLsvsPa2OZSx3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ie34jWqWZy7x0rghioV6uJHHDUT3fEYNHcvBaT1mjRPsBpBUiF729S3QKc//VzYMh
	 1YH4s9i4h39OKy/0I9UJsW1P1Y8WqLvW1/H1hLiFAhjKAsMQZ4sh9YdsMhaY+jD/di
	 B3CVAkfBm2Wgt4cCXWFUgmVyCuhPiRDW7Z5Nl1fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashley Smith <ashley.smith@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 095/499] drm/panthor: Update CS_STATUS_ defines to correct values
Date: Tue,  8 Apr 2025 12:45:07 +0200
Message-ID: <20250408104853.588015598@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashley Smith <ashley.smith@collabora.com>

[ Upstream commit c82734fbdc50dc9e568e8686622eaa4498acb81e ]

Values for SC_STATUS_BLOCKED_REASON_ are documented in the G610 "Odin"
GPU specification (CS_STATUS_BLOCKED_REASON register).

This change updates the defines to the correct values.

Fixes: 2718d91816ee ("drm/panthor: Add the FW logical block")
Signed-off-by: Ashley Smith <ashley.smith@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250303180444.3768993-1-ashley.smith@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_fw.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_fw.h b/drivers/gpu/drm/panthor/panthor_fw.h
index 22448abde9923..6598d96c6d2aa 100644
--- a/drivers/gpu/drm/panthor/panthor_fw.h
+++ b/drivers/gpu/drm/panthor/panthor_fw.h
@@ -102,9 +102,9 @@ struct panthor_fw_cs_output_iface {
 #define CS_STATUS_BLOCKED_REASON_SB_WAIT	1
 #define CS_STATUS_BLOCKED_REASON_PROGRESS_WAIT	2
 #define CS_STATUS_BLOCKED_REASON_SYNC_WAIT	3
-#define CS_STATUS_BLOCKED_REASON_DEFERRED	5
-#define CS_STATUS_BLOCKED_REASON_RES		6
-#define CS_STATUS_BLOCKED_REASON_FLUSH		7
+#define CS_STATUS_BLOCKED_REASON_DEFERRED	4
+#define CS_STATUS_BLOCKED_REASON_RESOURCE	5
+#define CS_STATUS_BLOCKED_REASON_FLUSH		6
 #define CS_STATUS_BLOCKED_REASON_MASK		GENMASK(3, 0)
 	u32 status_blocked_reason;
 	u32 status_wait_sync_value_hi;
-- 
2.39.5



