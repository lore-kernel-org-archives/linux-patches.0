Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062222;
	b=AzNo8qiitvcPjMpt1iVVrM6vaPJFMsuWLzh5oxZLeIe/DrBjWaOhdifTaTCscGRHszS6
	 f9FjA6kBB577pWzgfItadhzgj5tAcgXYsDhTNKgalKHSzD3oWGxPPt5g9S8C07yW9NAg9
	 AyzyYp0cZUDuaBSuUd9q6aXWLmzVTgKuEyNa4RnrZZXj6o/dI9n/ebc5jNoaHtluAeFyg
	 KO4n3Iwo4rKbh9QzBmFKbjGxbd//6u4v7VaEjy1XLZrB8gQv4crfGlS1aD6U76f/jEdE8
	 Gpx3GowBNzNBChh3SjsQPH6BcYpI0eyJ/uCwXF6oueruHdcFHUJBd0r93lSAsGGKAaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q/OZ9vGiInQ1tKlbulDTxfF1ZR1gUu1AY3TpOsdH+k4=;
	b=Gu5oyOnU8DXRp0ESGTD+/mmi5B3sKQD4jDeaN5m9tnS6tkw9JvxzQ2KMHaul2TAPr68S
	 j6Aa+UKn2ANvESqNbFUYSYc3+eEOjBMi/8Nw0/9sq9E4drY8ccn2Nu4OkKJhoAl14KXpc
	 SgkjQPcpe6ypb4Q9GwNDH/iR8wt4SeEyIHm+sDfVz54KMGTVq+jVkjCjXSQevBoaMasWI
	 q/f1GcFE+EZTukUXRJUz45v+vBoCGjnsaOK9rSVhyVm8As3WXCDxFYh9ss98Ozg+ISWC5
	 dOcb6Hn+SW/70IOD1drYKUr8mQketKkSnsoF7zYr/p2g1HJ5Fae8L95sQWlZPF5dyVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TrsTuSp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E666606A326;
	Thu, 19 Nov 2026 04:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TrsTuSp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF9A1F000C4;
	Thu, 19 Nov 2026 04:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062221;
	bh=q/OZ9vGiInQ1tKlbulDTxfF1ZR1gUu1AY3TpOsdH+k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1TrsTuSpYDNUboQRtLgwObff2CrqiUi1MKRsAMnS/sKC8+JMXQJ8hBfG9z7+1r8GB
	 k8O/fKxfCV7dhsl3Q1ImMZZleFdu4kjXMgYBTnTFKefnMk63wWxQpYb28NEz1nylBv
	 +0WSTFXpeQJ92/DXnjWzSvhSB/w+WtWP5k7SvWMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Petr Mladek <pmladek@suse.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Yoann Congal <yoann.congal@smile.fr>
Subject: [PATCH 5.10 1834/1848] printk: Fix LOG_CPU_MAX_BUF_SHIFT when BASE_SMALL is enabled
Date: Wed, 18 Nov 2026 16:04:32 +0100
Message-ID: <20261118150036.400636248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -715,8 +715,8 @@ config LOG_CPU_MAX_BUF_SHIFT
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


