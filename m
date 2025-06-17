Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5EA285059;
	Tue, 17 Jun 2025 16:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178390; cv=none; b=PN6Krss44QBDTdSwUkvki0Czrb5ooYfW/1954bdkFsv7yYJJWv9qTEWxoyAEc1SK394247+5URhW2mo2cKFVT0mqc133yVyKVGFUBpfj/9qT/g2FpgTJx6BASSBfmFg+Kds9agSs2lWFYYsTl9VgkAzMrZr+kpaTAjf/Aw+MEkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178390; c=relaxed/simple;
	bh=PLG3u3XmciOcQEyl4JoZL//NFQ96LhVjdxU7P0WtoGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOkICMjZFYUsRmo2CADu0BXTPFtiXqa2wwmkPvqitCcM5crCW9cBHBeZxpze8/53Y1tX5z0iTnz97ywW/tgTKWKbY3OhtC5L86atqpFfDBTK4ys+nKw0WZ4Nse+B0HCdJbbIBXhIltnoj6tjyg4zvi4/NZv5h8bXatLIvZQNyyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I45fKjDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I45fKjDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76031C4CEE3;
	Tue, 17 Jun 2025 16:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178389;
	bh=PLG3u3XmciOcQEyl4JoZL//NFQ96LhVjdxU7P0WtoGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I45fKjDMt5jAQljFhrLeT9lqKkhsLKukxFV7txHpvaZ8XXdFajF0hfBSLd81m3TQn
	 dJI0Omwp5rzV+ZHIFhtvAD8jnIA6BEpS/oLlcWrJq94xGUxpbR4RnfTfYx5UJ7jAn2
	 OzG4U2+ykATACJKtmiggB3NFWaoGr3EKkgRSXEjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 431/780] HID: HID_APPLETB_BL should depend on X86
Date: Tue, 17 Jun 2025 17:22:19 +0200
Message-ID: <20250617152509.019353397@linuxfoundation.org>
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

[ Upstream commit de7ad66b16b4d397593eafbbb09e9557b558a7e3 ]

The Apple Touch Bar is only present on x86 MacBook Pros.  Hence add a
dependency on X86, to prevent asking the user about this driver when
configuring a kernel for a different architecture.

Fixes: 1fd41e5e3d7cc556 ("HID: hid-appletb-bl: add driver for the backlight of Apple Touch Bars")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 119e5190a2df7..43859fc757470 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -151,6 +151,7 @@ config HID_APPLEIR
 config HID_APPLETB_BL
 	tristate "Apple Touch Bar Backlight"
 	depends on BACKLIGHT_CLASS_DEVICE
+	depends on X86 || COMPILE_TEST
 	help
 	  Say Y here if you want support for the backlight of Touch Bars on x86
 	  MacBook Pros.
-- 
2.39.5



