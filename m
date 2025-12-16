Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5992B749C;
	Tue, 16 Dec 2025 12:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887152; cv=none; b=ikmNQFKAi5uPeoy9NKR7sDePWpfDTd0D99gHlE9fOeQiPyKbrI82jZLfK6duZGHzeyW7/9CjGIDZs5TMBfalJ+ZCP6VoRlBuSdir4g9lG3xA3RFpVA+LmzS0l0udcattzzwzX/LniBnWpsgOpSmwI0B7Rv2TCRvXCvX8CfmUwfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887152; c=relaxed/simple;
	bh=2njQImmUuqr//3tK1SMhvb/odYYGusP3xbgcXQKkUbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2t/C0tHELSZtOOsPT+H0ht4AoONWXa/2iguV7q4sEZI78/fzFBAbVkga1oRg4ftYFZEjDPIg9uzLQ45XRjO0VfopuAk0VIdfycOioQOiFuhnyZ0qWCRgflTDmWtgHZCn5iqQ0D5WfUFRbh33CYZA5bDHsurQqxjJwVN26/3ogU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2l5Myqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2l5Myqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18A9C4CEF5;
	Tue, 16 Dec 2025 12:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887152;
	bh=2njQImmUuqr//3tK1SMhvb/odYYGusP3xbgcXQKkUbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2l5Myqz8BLQaQuHHFCnEkaRTre9xSASdP8omQXDpiPRH1gNdYuabJFcrnGbEmy8R
	 tScKkmIhYgKzTvBB57rpXVuIJK4qf6Zr4DHRhE0KOgtVfqPOa0IGs4MtHLWOyB1roR
	 UIfnDeMU+CZtt7EULRrt/zBnTrmK+iExfpbOAnwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 143/614] drm/rcar-du: dsi: Fix missing parameter in RXSETR_...EN macros
Date: Tue, 16 Dec 2025 12:08:30 +0100
Message-ID: <20251216111406.516777981@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 42bbf82b73bda18bbc3e158cb6fda040bb586feb ]

The RXSETR_CRCEN(n) and RXSETR_ECCEN(n) macros both take parameter (n),
add the missing macro parameter. Neither of those macros is used by the
driver, so for now the bug is harmless.

Fixes: 685e8dae19df ("drm/rcar-du: dsi: Implement DSI command support")
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reported-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Link: https://patch.msgid.link/20251028232959.109936-2-marek.vasut+renesas@mailbox.org
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi_regs.h b/drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi_regs.h
index 76521276e2af8..dd871e17dcf53 100644
--- a/drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi_regs.h
+++ b/drivers/gpu/drm/renesas/rcar-du/rcar_mipi_dsi_regs.h
@@ -50,8 +50,8 @@
 #define TXCMPPD3R			0x16c
 
 #define RXSETR				0x200
-#define RXSETR_CRCEN			(((n) & 0xf) << 24)
-#define RXSETR_ECCEN			(((n) & 0xf) << 16)
+#define RXSETR_CRCEN(n)			(((n) & 0xf) << 24)
+#define RXSETR_ECCEN(n)			(((n) & 0xf) << 16)
 #define RXPSETR				0x210
 #define RXPSETR_LPPDACC			(1 << 0)
 #define RXPSR				0x220
-- 
2.51.0



