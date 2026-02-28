Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A308373BE1;
	Sat, 28 Feb 2026 17:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301542; cv=none; b=TANGtKY1VsNzhe5QJflGlZpxE9FfPjbu5n72q01S/+jGauYIggQsOBjzOwhDYMCce/pq0M1kdNNZidgKs8tUa+sYubNHoQpfw7qwS8mTmelaSHT/k4kZsiQz4a3Rmqj4IK82W4Rk5jL75vspFUuz+fq/kbRIHJYVB6GXJ54DWGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301542; c=relaxed/simple;
	bh=jUjjMNenqznaulyi0XDKar7u63OL6y1eRN3dTt635WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnkFOqLYE5pC9Tb37EFL+SSrlRIfnbiIYmsGd3uwhMm9pMjndebVfGHgsfdNCoBJjE2OgpiMdoN3031uK63gDcKyM0zpw5612bpegSC+bRwDBoppjE492u/tTgI9IXln2OTcnkE4vkcm/tQVHeRup/y9BVOQT8iDBd/QnD7ekAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DPuF9aC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DPuF9aC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE1AC19423;
	Sat, 28 Feb 2026 17:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301542;
	bh=jUjjMNenqznaulyi0XDKar7u63OL6y1eRN3dTt635WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPuF9aC9dBjkHjD6STzlOtLk+7wwiB7zgKr9Eki8Q5vSLWqOwI50e+swcyzfuhBIr
	 H1WpP1BXfe7o2Ts1DoTnLgdX3QfEI5NP3e9rdo68cL5AmAHp5NtJGQo9YV8KH7c5GZ
	 xx97bBJXgjKfTpTGxWLs++0+gzwrEfkqzzyLmLoGa63yH8sUcPamkeH48A/XntpTHT
	 u0Fd/Cl8dTHV/g9XQpHL3+uxI5I6e2JEnAVB0kI/6lrw/vY9JJyGC+p91ktOMfVXUR
	 bByQKloha7TBxa1jPn/uLlL1PhsWYPNFR24TL4Nxl+5vuWPidVYDntqWgxBSMf0T82
	 waN0ezYTDlYxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Zimmermann <tzimmermann@suse.de>,
	stable@vger.kernel.org,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 724/752] fbcon: Remove struct fbcon_display.inverse
Date: Sat, 28 Feb 2026 12:47:15 -0500
Message-ID: <20260228174750.1542406-724-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 30baedeeeab524172abc0b58cb101e8df86b5be8 ]

The field inverse in struct fbcon_display is unused. Remove it.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: <stable@vger.kernel.org> # v6.0+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcon.h b/drivers/video/fbdev/core/fbcon.h
index 4d97e6d8a16a2..7e21c8b336692 100644
--- a/drivers/video/fbdev/core/fbcon.h
+++ b/drivers/video/fbdev/core/fbcon.h
@@ -30,7 +30,6 @@ struct fbcon_display {
 #ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
     u_short scrollmode;             /* Scroll Method, use fb_scrollmode() */
 #endif
-    u_short inverse;                /* != 0 text black on white as default */
     short yscroll;                  /* Hardware scrolling */
     int vrows;                      /* number of virtual rows */
     int cursor_shape;
-- 
2.51.0

