Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042830;
	b=1dmWKuo/4z83eX2NoWUWPjrZpB9/sQNdwC7nWpmLeM5X6vFtfBOKJnQzdSTeJIu/d/J3
	 BwLzn/UwAS/RkxbyANis5TXZeSKnZZXZcVLiLS5Gh/PnRRp7ZWan1f/eznzcp03O/N/LJ
	 L1dL5bKK4PJeJ96ZtlZeoleFjJgYEcNUsBP9RJVIpb9ttazu8HREdQH3zm3FJ5P7sViy3
	 yPtIkIscb42IPb5/tdxe4mMPZurDvhBHpk+107hJFKI6ZoIKN2B9Ap1G0TjVqEQmcCFBl
	 vrIrdy2zhRufbUOt3mUQgtje8MvouWK1UVucm+KIvBwJ/tDb1lkmUpc1Tv5zb7U+YqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vN27bg+nAsmGWdfDvdOdtsXxOpepgecHiYZVU5Af7H4=;
	b=gDBr/PrpdR+VZzzpT2QpyA8Ihd9YCTr/f7o0GSMaufd79TXQbg2pB8DVWfQ0TOxe+SW8
	 dxxGoOgajh8Tzz5sJvfKni5Kuwg9REfWm8UwAJSig8ydezklng/oSLeAi7w5Hk72z60HA
	 IeHNL2lSCkgOkHtIcIGRYNf7NQsBBIxLamZT+hfiWoXtDPYsZ/XEPLeVQz3VAsyjS/Xsr
	 RHM9qYbrZH45uHMi0RomiJx0U1x1cb0s0yTiBsj/JTIR4Fow7tsctHKzo3s/hsmxIPWQC
	 KgTSDycCFq8cnxQmWFmaNqtnX9xgqi4vNaosK+2T1ercVh1PR9cmT4BsvbBVocJ3SYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtfa+mVs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B941606A31C;
	Wed, 18 Nov 2026 23:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtfa+mVs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9802C1F000C6;
	Wed, 18 Nov 2026 23:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042830;
	bh=vN27bg+nAsmGWdfDvdOdtsXxOpepgecHiYZVU5Af7H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtfa+mVsxQ5GpyVPPrg50i0FOwK8slJ2Wg9WxhInzkUlMVB7LwqkSF0HXCEBWGBid
	 d8j/yB3mvXmzz9lmTKm5wMpsjd2htrGqcQg5xbmiW/2asvNJNYg86SLtHemDPhoOMU
	 pjZxG3bV7NGQAargmAJWTWcQLmbe/65kFTydcvxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Petr Mladek <pmladek@suse.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Yoann Congal <yoann.congal@smile.fr>
Subject: [PATCH 6.6 3310/3318] printk: Fix LOG_CPU_MAX_BUF_SHIFT when BASE_SMALL is enabled
Date: Wed, 18 Nov 2026 16:05:32 +0100
Message-ID: <20261118150458.886768614@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoann Congal <yoann.congal@smile.fr>

commit 320bf43190514be5c00e11f47ec2160dd3993844 upstream.

LOG_CPU_MAX_BUF_SHIFT default value depends on BASE_SMALL:
  config LOG_CPU_MAX_BUF_SHIFT
  	default 12 if !BASE_SMALL
  	default 0 if BASE_SMALL
But, BASE_SMALL is a config of type int and "!BASE_SMALL" is always
evaluated to true whatever is the value of BASE_SMALL.

This patch fixes this by using the correct conditional operator for int
type : BASE_SMALL != 0.

Note: This changes CONFIG_LOG_CPU_MAX_BUF_SHIFT=12 to
CONFIG_LOG_CPU_MAX_BUF_SHIFT=0 for BASE_SMALL defconfigs, but that will
not be a big impact due to this code in kernel/printk/printk.c:
  /* by default this will only continue through for large > 64 CPUs */
  if (cpu_extra <= __LOG_BUF_LEN / 2)
          return;
Systems using CONFIG_BASE_SMALL and having 64+ CPUs should be quite
rare.

John Ogness <john.ogness@linutronix.de> (printk reviewer) wrote:
> For printk this will mean that BASE_SMALL systems were probably
> previously allocating/using the dynamic ringbuffer and now they will
> just continue to use the static ringbuffer. Which is fine and saves
> memory (as it should).

Petr Mladek <pmladek@suse.com> (printk maintainer) wrote:
> More precisely, it allocated the buffer dynamically when the sum
> of per-CPU-extra space exceeded half of the default static ring
> buffer. This happened for systems with more than 64 CPUs with
> the default config values.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/all/CAMuHMdWm6u1wX7efZQf=2XUAHascps76YQac6rdnQGhc8nop_Q@mail.gmail.com/
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Closes: https://lore.kernel.org/all/f6856be8-54b7-0fa0-1d17-39632bf29ada@oracle.com/
Fixes: 4e244c10eab3 ("kconfig: remove unneeded symbol_empty variable")
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
Link: https://lore.kernel.org/r/20240505080343.1471198-2-yoann.congal@smile.fr
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -752,8 +752,8 @@ config LOG_CPU_MAX_BUF_SHIFT
 	int "CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)"
 	depends on SMP
 	range 0 21
-	default 12 if !BASE_SMALL
-	default 0 if BASE_SMALL
+	default 0 if BASE_SMALL != 0
+	default 12
 	depends on PRINTK
 	help
 	  This option allows to increase the default ring buffer size


