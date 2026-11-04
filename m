Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831033;
	b=Y9agbFpAjCWiNbPCkQ0jP6HhUes/XenPiCHlyLe157ak8XlCvElErBjBbFTuPKzcFVNx
	 iqcTFPyBHFodGIoQtNjtH5tz7Ot3qZZYuFR1kEZjJcyBR1DLlroVAjREsCehBF3//2huL
	 EYL/o0ZdFB7e4TRFteQ/WuU25k+xKRznGxHm1twgLrLNvwjSukprRjKA8sxwn13LIZxLM
	 EQ/fRgRaGWmCEXH8nXvdZz39I1hQRx2jnJmTj2zt/Srfp0JNl1IpGR0gqi1101Z0HPhbO
	 ZM1yXSkZVFTdJFCYWkEXfW8VnOP4gT18+uLDwDp1cr30OSENKU/Dg1/hlVe5DpZvC9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lM0swU5y+ZSPNVbri3r7KbjW7jA0WG1QpzG2umL8Tcg=;
	b=PR85Pc92j323NZ2NR58WZKX+xOjwCYNkoagSZ1knqtKUSjD3vVYsNqtykUrvI0En2ri4
	 GxjW2dAbI6LvAytZrD0LSavBty1wR1eCc3RAjQVFzLQKwaF3iluVvZEj9c0yIKdNw+5At
	 ZkwfJ+BRjoLm5EnWyFVqQrIe5BzK6lNeDuxGIaUdZjc9Zlo4Aq0PiL3sMzgfMfKRd7/j0
	 IuCaW3A/0sTZWiLpoeePQKCQhuDRa/CGsZ0pwGFiD2YV/fehrJPe8QH4ltc+Hc0o+w5Yj
	 RtLYB4k4LUkCCN6IGafHrPloxfFkYPRJVP8w5WRBh4qnxd4TnLw26iiVOx9Izeeod5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ig06dbOK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D67606A843;
	Wed,  4 Nov 2026 22:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ig06dbOK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEEB1F000C1;
	Wed,  4 Nov 2026 22:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831032;
	bh=lM0swU5y+ZSPNVbri3r7KbjW7jA0WG1QpzG2umL8Tcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ig06dbOKO1G6HTFKh327GFu9oU9W0Gal2hmR9KB+rla532rUP7a8qotHGIjgKXBG7
	 MnbUs5YrM2U4iyRq5nHaVTxuBgY6I3Rs+VqkNZGKpZ9RSGP+6rQ6pWkY+JY0HLwxUR
	 7gjMnQQRJV7JmdvJOQmpoAH2AYTzfccZos4YPbVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaroslav Dudkov <aroslavdudkov622@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0430/1005] platform/x86: msi-ec: Add MSI Katana GF76 11UEK EC firmware
Date: Wed,  4 Nov 2026 16:02:43 -0500
Message-ID: <20261104211056.139632512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yaroslav Dudkov <aroslavdudkov622@gmail.com>

[ Upstream commit 0b30e6e583b2988864ffa7aeb2905bc2d0c7d575 ]

Add the firmware string '17L1EMS1.107' to the ALLOWED_FW_13 array.
This enables Embedded Controller support, including battery charge
thresholds, for the MSI Katana GF76 11UEK (MS-17L1) laptop.

Tested on MSI Katana GF76 11UEK with EC firmware 17L1EMS1.107 and
BIOS E17L1IMS.312.

Signed-off-by: Yaroslav Dudkov <aroslavdudkov622@gmail.com>
Link: https://patch.msgid.link/20260807180553.869371-1-aroslavdudkov622@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/msi-ec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/msi-ec.c b/drivers/platform/x86/msi-ec.c
index 0157e233e4300..0cec54d497d1e 100644
--- a/drivers/platform/x86/msi-ec.c
+++ b/drivers/platform/x86/msi-ec.c
@@ -1054,6 +1054,7 @@ static struct msi_ec_conf CONF12 __initdata = {
 
 static const char * const ALLOWED_FW_13[] __initconst = {
 	"1594EMS1.109", // MSI Prestige 16 Studio A13VE
+	"17L1EMS1.107", // MSI Katana GF76 11UEK
 	NULL
 };
 
-- 
2.53.0



