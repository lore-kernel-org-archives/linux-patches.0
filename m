Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061026;
	b=KCuQp74/Mtn14TvWN2F9OKv5GnrRPqWy4RLG/Ry0j53tzJ0Ta3LQV1y5zzVhlSWQdZ+E
	 XgQX9TEFLf+HhCuc8kw7QJLsxH0TC4XjFWBzkM7RonjpbGKb//AL5LVrSiej59+CkcM0X
	 H16GDvSSq757LiR3XgN9dkJnB360dqZVOwN+Q2XnolZK5yRp1rqdDWpgUmXYh3EsThuLv
	 DA66Gsu4mztWYRUhFd4l1MPQLDJ/OrTZ/wglo1lbMDNueip4uPE0FPDXF3bQJrFAlitko
	 yOux2tBVXo5bpgsGXraP+QZaYeXny8eoxS07lyrDIqaYzy2s0UYkFLFlf0bgLWvIFcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=J/NXUiuvQ1I/7JcRCVXYKpfQ5f/0xRqILnjIbNKH6X8=;
	b=E+6WUE9o4HDgYyHCj8upXZc0fV93itcXSBcopYFXFp4JIJD6ccLY6OZr2UCUtkqM0UyD
	 pFSAJi6XK5mEiQ8a8sAj4GFW60WZacnyI+N3dhcaJbyEw9sSzmHhjBQVnTZs0Q5GcTK4t
	 KkofdaI1cbFn9oBMr8052oFrt4YY//+UBIO0nrltGB/BrD+YnxDrkev8QucFE23klWQCe
	 YqEpJ5zASZssbiCzWrjzqwrFzOJoGjvYjxHQatmWzTABKLPRd/7FXUm4GueKxb21xWxfU
	 in4cbAcxEwOYlmVbqR3HU7kKgMBbaU5xumgOBxaMh0qCyJE8ZZD9AUkvI3PD6nqxEAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a8g/2B/n";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10637606D83F;
	Sat,  7 Nov 2026 14:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8g/2B/n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BC31F0089F;
	Sat,  7 Nov 2026 14:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061025;
	bh=J/NXUiuvQ1I/7JcRCVXYKpfQ5f/0xRqILnjIbNKH6X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8g/2B/n4Uepbk4mggCvm+LFxVdrw/DcdPUqyDn4aa0RdnuKvnjh7leXXOzuSufpb
	 lEfGbDDPu4ICOR80XrkTlKAhQ+LQNKdmdyOYk8NId80dbMWJssNJooJzRUP8Gbj0ft
	 xdwyqixiobh+xE8d2K3Z8kR+ma35I/e3ON0kXkoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaroslav Dudkov <aroslavdudkov622@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0362/1536] platform/x86: msi-ec: Add MSI Katana GF76 11UEK EC firmware
Date: Sat,  7 Nov 2026 08:39:38 -0500
Message-ID: <20261107135007.827515641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



