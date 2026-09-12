Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DD5344DB5;
	Sat, 12 Sep 2026 08:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203393; cv=none; b=tCHQ1AHIdWyiiyy/fwPdH3XMZA89kM3h1nltrpkjeET7Y1MVyhVrXcPxHi9kNjguImeLHfYZgG4s1oZSDUTj+pKn71NOZlQF1ZgYcTB8EVExa6g9oNezuksj0I4Vyaq0VEMMAG6beWgR9xEeTN76CwZsLm/KEz2wu1YpJjz2Pq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203393; c=relaxed/simple;
	bh=qLLXYIOAfNtD1PoKoP13um5uLRvPKZpLEpuoB/XhXiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n33FENSFj2bLyHLiDLDE8BhUnWhRxueJz53K7l4/EHmtYMTjhJMGs+RfXE+uVVZYDXI1EvcMtrTVs9LuklF5syzAV7sowTyL7h7zhnHuAIiW682WC9csCFnYyzeXk2A129fJ8oZbqXZHo7nHQdnesIyFn5WC8Z3PjZV7IcQFmXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Crmq+SRn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Crmq+SRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD591F000FF;
	Sat, 12 Sep 2026 08:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203392;
	bh=vsCuFS2YXsI4SIplLv3dGPjM6/Cc0ovm8aI1xgjb7V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Crmq+SRnJFNnvxbf9ZDCzPECtFz+U/Kr/Y4UeJA0eU47b7Fd/lg5XEkUUW7ZHVJTE
	 R/aeT5fZpx2PF4BYiItvkjJYB6LUwjP+VgOYixKFSxTgyNYnYmKMy37irKdxS+gpDj
	 PhQgCA4um3WmxARGQkHI3QsWGMLHmg8PV92M1/a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje@dujemihanovic.xyz>,
	Randy Dunlap <rdunlap@infradead.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1399/1815] backlight: ktd2801: Fix unmet dependency on GPIOLIB
Date: Sat, 12 Sep 2026 08:52:29 +0200
Message-ID: <20260912065721.867871590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 5859fa79c7d85d0c242a9a1ffb40bab9732d4ef1 ]

LEDS_EXPRESSWIRE depends on GPIOLIB, so its selector, BACKLIGHT_KTD2801
also needs to ensure GPIOLIB is enabled. Otherwise:

WARNING: unmet direct dependencies detected for LEDS_EXPRESSWIRE
  Depends on [n]: NEW_LEDS [=n] && GPIOLIB [=n]
  Selected by [y]:
  - BACKLIGHT_KTD2801 [=y] && HAS_IOMEM [=y] && BACKLIGHT_CLASS_DEVICE [=y]

This unmet dependency was found by kconfirm, a static analysis tool for
Kconfig.

Fixes: d95963e309bc ("backlight: ktd2801: Depend on GPIOLIB")
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Acked-by: Duje Mihanović <duje@dujemihanovic.xyz>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260719024902.151710-1-julianbraha@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 7aa1c4b21111f..39cb7dfb9c0fc 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -193,7 +193,7 @@ config BACKLIGHT_KTD253
 
 config BACKLIGHT_KTD2801
 	tristate "Backlight Driver for Kinetic KTD2801"
-	depends on GPIOLIB || COMPILE_TEST
+	depends on GPIOLIB
 	select LEDS_EXPRESSWIRE
 	help
 	  Say Y to enable the backlight driver for the Kinetic KTD2801 1-wire
-- 
2.53.0



