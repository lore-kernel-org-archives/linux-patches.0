Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774357;
	b=m9125Qt9eM3uYsb5ZtevJswMzEaW7NsRCki3shDxpHZ3/9PCvIOsw3ywWvaVRNi8/XX3
	 jp3rscTW4kq5w9Ab7K8rNUEHcHXX82D0CTz9rF3HsYH7Dc8Vaq4eiE9E4iWJJbwKhbQlk
	 7VCBmFtctM6XJy7zHq80KAZNFV3IGTXtogeqMRFD8Ibo4AXQctBKU9FfXG31qAK5VZ8tn
	 gIWTqt33hnyH1JeZ8oWOiAf45Wbj3Bus2pbMq1P2Xcl1MyDLvc87oxqPOhQoxq/bYooer
	 qJwXLvRJ2i7nA8oAFJ7qhxYYQn9rDfWMhCHuVKS4ht9FPAHoYAq5rhdst1xLgAoSn3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rT6GNgoiSKhBxH+JsGsust0Awm06OCjl1kt2w/fSEHM=;
	b=cZSeXoKrIMIx6Rc7CaUAZLf6cWNG6vUIgU9sclA56YqLvjq5cYlpyOPN3dwkGKf97oU/
	 LNgQUWg5zBPUY1ib/AlNpwOYa+TkJSVZrls3E+DGMasF7YZtUhFpUNPz+itTCVwR8Hme1
	 V9J/LCGp3giJeJ1qcsjxVGuRJBbwIVXB+Ob+oK9DvQR1BtQgsYwoVOf4FE2D+t1IKbLSI
	 eon5pf9ZV2IPeqCDCuAyn99zNYDChNRJGcPqKiy4yfDNGxp6h5L5Vsm1imllOLXVi/S1Q
	 P7lCY13uw9G6qxUt34KJ1495Gr9gwamdUzRlfgiw/zxQwBikbFVsVqnFkh8rUYtWbqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aEK5N4U0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C430B606A31B;
	Fri, 23 Oct 2026 16:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aEK5N4U0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13B81F01829;
	Fri, 23 Oct 2026 16:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774356;
	bh=rT6GNgoiSKhBxH+JsGsust0Awm06OCjl1kt2w/fSEHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEK5N4U0bubqj2atOI7i5WSWRU42fnVQocf9Fhi1n07+68r8cyQ9hezsKpih1GDHC
	 72/0e1QpCcQz4c3w51CGMstTApdFqjfPmSxHeZOY6OvX/BAToRUq/EUWHAsiZap29w
	 G9bDWX3s6jVTyuRj3+veuuyXpVTreXTuTVqayPwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 014/242] ARM: configs: sama5: enable current Microchip KSZ DSA symbols
Date: Fri, 23 Oct 2026 18:37:36 +0200
Message-ID: <20261023163714.128703743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit afb1ecfeda3fc31d6300a176f4854cc62e289bf3 ]

The Microchip KSZ DSA family now uses NET_DSA_MICROCHIP_KSZ_COMMON
for the common provider and NET_DSA_MICROCHIP_KSZ_SPI for SPI-attached
switches.

sama5_defconfig still enables the removed KSZ9477-specific symbols even
though SAMA5 device trees contain KSZ SPI switch consumers. Replace the
stale entries with the current provider symbols.

Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Fixes: 07bca160469b ("net: dsa: microchip: common menuconfig for ksz series switch")
Fixes: 4658f2fe8fbc ("net: dsa: microchip: common ksz_spi_probe for ksz switches")
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Link: https://lore.kernel.org/r/20260814075310.11613-1-pengpeng@iscas.ac.cn
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/sama5_defconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
index bd7f0b5f7d660..46e7f554faa18 100644
--- a/arch/arm/configs/sama5_defconfig
+++ b/arch/arm/configs/sama5_defconfig
@@ -70,8 +70,8 @@ CONFIG_BLK_DEV_SD=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_SCSI_LOWLEVEL is not set
 CONFIG_NETDEVICES=y
-CONFIG_NET_DSA_MICROCHIP_KSZ9477=m
-CONFIG_NET_DSA_MICROCHIP_KSZ9477_SPI=m
+CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON=m
+CONFIG_NET_DSA_MICROCHIP_KSZ_SPI=m
 # CONFIG_NET_VENDOR_BROADCOM is not set
 CONFIG_MACB=y
 # CONFIG_NET_VENDOR_CIRRUS is not set
-- 
2.53.0



