Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C461B34DCDE;
	Fri, 21 Nov 2025 13:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732356; cv=none; b=S1zy5McmvihwRFhV1slbguOGz4OUbbBLqLEPEfTIrSljlFp4JcN4LDwHnpuCW8iuulfjjLs65RAWqtF8sqARR4AllJbWRy1RS4/bC9KwSIE7z7FStaC4EC8Up043dSkjK7ey53EqqU6JPqbqCx4nZYr8poCUMNMv7cCevDJl660=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732356; c=relaxed/simple;
	bh=13EGy/qL93/V16XlbDL/IV8UwA+pf0BHw1J29YF9BzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBvb/gpaApxn7nYzzpzFVzLWSm+4+7MMRhfYO26zApFEYkNu6WvjScpBjFLhVxhY5jiZPlqnNBBEP1F8hkyQCe5BrqKok8XjVV4Ou0xnW2He8F9rDwJctpQEwN7txaTBLm8xFLiSlcy0NIQXtqDGgp1KmieRYZmtykm15jBJqGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+e1R2HK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+e1R2HK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D758BC4CEF1;
	Fri, 21 Nov 2025 13:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732356;
	bh=13EGy/qL93/V16XlbDL/IV8UwA+pf0BHw1J29YF9BzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+e1R2HKx8FQPZ60rmkjMzKcrnonPQWqxAJnztWdEpz5NaQ1GsG2hD7JcCBX/RZBZ
	 AeLZMqN3JNqDc7aanOKe9fMco/Tmw517J1Byi/HTqdJRXyR8xuMh/ktn/P317NLO3j
	 eOKXZS5vcCvuV/oHSa9BvofyNj/CRx2xgRWRjg8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/529] video: backlight: lp855x_bl: Set correct EPROM start for LP8556
Date: Fri, 21 Nov 2025 14:06:30 +0100
Message-ID: <20251121130234.266775879@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 07c7efda24453e05951fb2879f5452b720b91169 ]

According to LP8556 datasheet EPROM region starts at 0x98 so adjust value
in the driver accordingly.

Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Reviewed-by: "Daniel Thompson (RISCstar)" <danielt@kernel.org>
Link: https://lore.kernel.org/r/20250909074304.92135-2-clamor95@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/lp855x_bl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 7075bfab59c4d..d191560ce285f 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -22,7 +22,7 @@
 #define LP855X_DEVICE_CTRL		0x01
 #define LP855X_EEPROM_START		0xA0
 #define LP855X_EEPROM_END		0xA7
-#define LP8556_EPROM_START		0xA0
+#define LP8556_EPROM_START		0x98
 #define LP8556_EPROM_END		0xAF
 
 /* LP8555/7 Registers */
-- 
2.51.0



