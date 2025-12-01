Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152162BE655;
	Mon,  1 Dec 2025 11:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588410; cv=none; b=b8eEx4IUL5XQIB7vphHHmFHzs8izzsgEa+e7vgQpr3E1bTJtKpFtiy/B821F2zCCMVneD5+77YSJoukDxidjQZhxd1pDnkSQyia150FjJwIY+cOjDhYX1ddrqomniqGo4hTGmUmL0DcuNzaYcHEZs1XsG+jYCek92tGTGeWxLYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588410; c=relaxed/simple;
	bh=83yTRh4Htnq+bO1eh/xaX54gRoMRPE3VDBc8pCy+bXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwTGcbC9O75vcy+msQ+B0eZi6mZBdkyWhZfxT5mQ1OfN3GkWLOdMJhoaqntRdAQTxEg6KF2DMrP+5ThPDOqDT+hUI2d94aP8rUQoTXl2vZUauNhQf1n2n/eQF+rqU8ieFH+9amAkbzu0tqqpHT3A4/BG9QghypegkhtpziPz8+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciAAJTs9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciAAJTs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2A1C19423;
	Mon,  1 Dec 2025 11:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588409;
	bh=83yTRh4Htnq+bO1eh/xaX54gRoMRPE3VDBc8pCy+bXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciAAJTs9Q0sGReij3gBf2968ipCodN6W9YxWlL2u2zrY+0F6NaqJpYxO6sldZonEo
	 nh7ewZwxWMVBrFW83/kUAnGvMMIKk+jRQ6lpc5xSCVMzfG11kwTsfrm/TmLHzgGfe3
	 /spPmmnIAFz44UtD3yKhejuh4mQzGkTm5K79MQtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/187] video: backlight: lp855x_bl: Set correct EPROM start for LP8556
Date: Mon,  1 Dec 2025 12:22:26 +0100
Message-ID: <20251201112242.626305916@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e94932c69f540..80a4b12563c6f 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -21,7 +21,7 @@
 #define LP855X_DEVICE_CTRL		0x01
 #define LP855X_EEPROM_START		0xA0
 #define LP855X_EEPROM_END		0xA7
-#define LP8556_EPROM_START		0xA0
+#define LP8556_EPROM_START		0x98
 #define LP8556_EPROM_END		0xAF
 
 /* LP8555/7 Registers */
-- 
2.51.0



