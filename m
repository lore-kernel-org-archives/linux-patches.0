Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590396;
	b=pLOKDun3oMUJW+0izyi+RcIMZeBmYx4JBwGAX8JezFdliOY02NgM5IFhb2pNilxO5bQN
	 s4DMNrywYOQnsWrLteO3tbG4BCorfXrM/D32TvhfYdE1UmlLwOOf+Fyup1tZz2iXyp1JF
	 Ot+kJKpuxlSUtsxBdJTUw62CaWD0TuN1CY6xETOll1AQkScJTBdROlMoQVHpI+DoLsaEN
	 n5GQypxfhnQoB4SKl8GEtQN6QZzrevewUlGISvRsiu/gaTEu/12D+fYVdh6hPKPB3eoit
	 xPtF2f/CSG807dCBE3nXUo1CPGK95y1wlOGXlXhnQf6WB6LjgKg2ebB8CD0AxxY3+HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3K+7gmI8SBzwhqtO81aHNCcDiE7BmNGNZVgQ7EYNtOo=;
	b=exP19/OAyIoW5Ugrcu9UcrtVLyiDhadQg8Y5hfCF8NKwnYKiyYmWnf8mMXj2Lv3cYvSG
	 c1EjjNq6p5iTl49VIzZd6NyJaLYhnVuoLvL7WttfgZHqy/N7tLWbSKZ6lPjq97Jr4p9Fd
	 yJ2+MQAnqqzsrRcpEStpvwSnoxaQxy6HOPVbAa4SLowqQAQ00Hz2z8bsvAPyfhVkJnLvo
	 PGNOHqkLcL/OfKMA7PAwsRZmEEs4wh410U0G1uCCYRtlOOytTUcaHmfUHDIgCfJx9A6tV
	 E2csgfWcHivjf1wxGu1ycbk8xQB1zxNUWvmBCmurHFQDosLvjgpgMt3h6kFm8AMxVzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oD8xkfkp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AFC606B347;
	Fri, 13 Nov 2026 17:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oD8xkfkp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FEC1F000CC;
	Fri, 13 Nov 2026 17:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590396;
	bh=3K+7gmI8SBzwhqtO81aHNCcDiE7BmNGNZVgQ7EYNtOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oD8xkfkpSDaLPfaPqjHClXIis03B12A0jsie0R4F698hk4NYz/bNnhVQVEGALYNca
	 aIQ18D80IPjRfHhTdMFeWJT+3PlxB10jCU15TtEgRdSABATjjlu+pbshpegY/EaTdp
	 AMwhVsnywsEtFWrkmSfQstK3eYqmOgfme81l/ImM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	kernel test robot <lkp@intel.com>,
	Bradley Morgan <brads@mainlining.org>,
	Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 323/686] openrisc: export __mulsi3 for modules
Date: Fri, 13 Nov 2026 10:47:36 -0500
Message-ID: <20261113153831.874657085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

[ Upstream commit 8ff981aa283a0ce516c2dc65a48a185ed336c657 ]

OpenRISC configurations without hardware multiplication fail to build
modules which contain compiler-generated calls to __mulsi3.  The failure
is widespread, affecting filesystems, drivers and KUnit tests at modpost.

When CONFIG_OPENRISC_HAVE_INST_MUL is disabled, the architecture Makefile
passes -msoft-mul to GCC.  The multiplication helper is supplied by the
libgcc archive linked into vmlinux, but or32_ksyms.c does not export it.
Built-in callers can therefore link while module callers cannot resolve
the symbol.

Export __mulsi3 alongside the other compiler-generated helpers.

The omission predates 7c3f4d699f34 ("resource, kunit: stop selecting
GET_FREE_REGION"), which the robot identified when reporting an additional
failing module.  It was already present in the initial OpenRISC export
list.

Fixes: 616257669e1a ("OpenRISC: Miscellaneous")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610290106.o8Fs3NvO-lkp@intel.com/
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/or32_ksyms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/openrisc/kernel/or32_ksyms.c b/arch/openrisc/kernel/or32_ksyms.c
index 212e5f85004cc..c63d7f25bc575 100644
--- a/arch/openrisc/kernel/or32_ksyms.c
+++ b/arch/openrisc/kernel/or32_ksyms.c
@@ -35,6 +35,7 @@ DECLARE_EXPORT(__divsi3);
 DECLARE_EXPORT(__umodsi3);
 DECLARE_EXPORT(__modsi3);
 DECLARE_EXPORT(__muldi3);
+DECLARE_EXPORT(__mulsi3);
 DECLARE_EXPORT(__ashrdi3);
 DECLARE_EXPORT(__ashldi3);
 DECLARE_EXPORT(__lshrdi3);
-- 
2.53.0



