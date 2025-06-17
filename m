Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D014D2DFF3B;
	Tue, 17 Jun 2025 16:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178350; cv=none; b=qWdzEA/FW7+JpKueGoiJFL3rr0aYdnot1T7Uw3xDPo6ltIF+3Htr3F7lVAKHirsaA2+37fOW2BMpaUWejn89II8LFme14N5b/OUawRTR/fbQifDmd636ptTS7azA1P1mzBLpnUEXMN3qmmkus5GO0SDyU0f3RLs633GGCK/nUE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178350; c=relaxed/simple;
	bh=QLitYBQgP8GImp3855rm7NiUvQl2a/3O2dce40UJDDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G268kSvzRHzvOhbcYch1UKgXP36lNZKuQiTqXn9o6LcDIEtnLEDFUMDWk1T6NJkMsz8f3BoIw+W2uYPbqp3IcUtdV9y6NGcD8mezH13ifStai0IVxqoe9l3xmlLY3YwxW45NtcXhFh72uphbWscj0e6gjh1sWRKOSnOnW3GBYRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7Q8iQta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7Q8iQta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4050EC4CEE3;
	Tue, 17 Jun 2025 16:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178350;
	bh=QLitYBQgP8GImp3855rm7NiUvQl2a/3O2dce40UJDDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7Q8iQtaIpCuAHAVKAw5zrKj6kpjL9PV6vM9CK6UI+MHx9DTbMwQgzfm7J1Q5lsHj
	 FkCNfDcd+1ae0YTAPEa8F38Q4HhVzMSU3vMVKwRU/XwL1jK/0PwiL/4bsD6bthUdrJ
	 zdmUWEWBLArL8gdVDbn0kp1849Lj3E+9k/UDCmuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 430/780] HID: HID_APPLETB_KBD should depend on X86
Date: Tue, 17 Jun 2025 17:22:18 +0200
Message-ID: <20250617152508.976249968@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2a647d400afecdf12ba5905424e1337fbc2d6750 ]

The Apple Touch Bar is only present on x86 MacBook Pros.  Hence add a
dependency on X86, to prevent asking the user about this driver when
configuring a kernel for a different architecture.

Fixes: 8e9b9152cfbdc2a9 ("HID: hid-appletb-kbd: add driver for the keyboard mode of Apple Touch Bars")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index a503252702b7b..119e5190a2df7 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -163,6 +163,7 @@ config HID_APPLETB_KBD
 	depends on USB_HID
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on INPUT
+	depends on X86 || COMPILE_TEST
 	select INPUT_SPARSEKMAP
 	select HID_APPLETB_BL
 	help
-- 
2.39.5



