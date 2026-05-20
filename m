Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4CE37DE8A;
	Wed, 20 May 2026 18:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301016; cv=none; b=mok67FoIjcUtFzyL81nlecIVvuF12awpmHotzOItPqWOKFWI9NflhsSDxL6vijNeubsdPXFG8VqBNFnkGE9IcDCnPQhG3mIZOEDjCxq3dr9Q2c5o0beAzj2edZy4aFCYWh7gAT5dKljYka08Ucf9YtJ9mqY9WHTW0RKIPmaUQik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301016; c=relaxed/simple;
	bh=SvVVxWDo2kH5kI5MRClKhot9a3VTEwW6ynOHtAOsuZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBs4tb+ynE005GdoNEWjMvgwELukQjtU9BW5tuW1Ryi7j2G1fUAP42Yg/9PVCytfF9xRNSzSs2AsyYLDR5uy0gums2JmGk3ND+DjCzmppXo0udtXO8SmRL7M5tBejv3MYUDgifBixeou1atPSc5BzGybSfsVMzs7JC0g+L1iawQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/uz0S6z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/uz0S6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6301F00893;
	Wed, 20 May 2026 18:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301014;
	bh=phOWArra3esdRPNvnM25QsXxy9bazT75m7jz5I2+PvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/uz0S6zuQT1xzKTGsZAynV0e2h+8i+a+TZ93JePIDayYHwSkqLxmt95ikf3BaSL5
	 SadTx4arXkglJ6nlMkOqx7HruzDhqlO8IW6i5QplGlTykudVt8CyldA6P3HJ7Ubc64
	 hf5vs4Q4vb0PgoiV7dXgN45fMIIfBBM8RARQ08aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 395/666] tty: serial: ip22zilog: Fix section mispatch warning
Date: Wed, 20 May 2026 18:20:06 +0200
Message-ID: <20260520162119.818659439@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit a1a81aef99e853dec84241d701fbf587d713eb5b ]

ip22zilog_prepare() is now called by driver probe routine, so it
shouldn't be in the __init section any longer.

Fixes: 3fc36ae6abd2 ("tty: serial: ip22zilog: Use platform device for probing")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202604020945.c9jAvCPs-lkp@intel.com/
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Link: https://patch.msgid.link/20260402102154.136620-1-tbogendoerfer@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/ip22zilog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/ip22zilog.c b/drivers/tty/serial/ip22zilog.c
index 6e19c6713849a..a12101dc05546 100644
--- a/drivers/tty/serial/ip22zilog.c
+++ b/drivers/tty/serial/ip22zilog.c
@@ -1025,7 +1025,7 @@ static struct uart_driver ip22zilog_reg = {
 #endif
 };
 
-static void __init ip22zilog_prepare(struct uart_ip22zilog_port *up)
+static void ip22zilog_prepare(struct uart_ip22zilog_port *up)
 {
 	unsigned char sysrq_on = IS_ENABLED(CONFIG_SERIAL_IP22_ZILOG_CONSOLE);
 	int brg;
-- 
2.53.0



