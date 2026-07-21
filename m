Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C723443B490;
	Tue, 21 Jul 2026 21:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670495; cv=none; b=g9jkaFR0SkBvJIrYxeIGK3zWxeOwuFTeS/aC3J4tsnUJdWZ1KexjXA2ouVikoyKvKpanFd474B4sSEynUY4TOMP/Amok5ac0aMws+g3NBBsuM64mgSRPCWDeoe95GJwLu0HNw8F6FieBKX7mYd9ckEQUC/hQiat1XVNkZ1CWAH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670495; c=relaxed/simple;
	bh=8uBY9NHVapEaClxTAQlA4mPC8apZ33qPjqtgrkhrcGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ri2uWf2PzM1SdjQCdxKtbBsYl0fRCdvo1CmPFDReVUGlkAp5wLk5Dv8nBSnRjRV7cXywKN4Hq2vvSn1iON0vM9KG2GhR1PvqKiipuOV08+EX+cgUdtBBtHxu20CQfxG3s2Kz5CHLKQO87ZO43BNQLc04sqrY5q8XgCgj7f+Cm4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+9eTnjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+9eTnjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8213C1F000E9;
	Tue, 21 Jul 2026 21:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670487;
	bh=DUpUWscoBdL8dqaTH/zFuxDpq4SciPKNPWVI9ECdAfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+9eTnjUqz2+V7uOu9mitXf3rK3Wxspympd5itn00eh9FkxSXO0tCabMANhTHXDx2
	 rXvTbvXPBtqoOGEUI6aqnP5mXwbQnZOhoV1tvsxbIimP4LPcndPMR0xVcQ4PHvFZqU
	 uHksBPMJPQGHOE6EE553ogD5xchmqXX8oKRcNo8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Yury Norov <yury.norov@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0951/1067] bitops: make BYTES_TO_BITS() treewide-available
Date: Tue, 21 Jul 2026 17:25:52 +0200
Message-ID: <20260721152445.815161834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit 7d8296b250f2eed73f1758607926d4d258dea5d4 ]

Avoid open-coding that simple expression each time by moving
BYTES_TO_BITS() from the probes code to <linux/bitops.h> to export
it to the rest of the kernel.
Simplify the macro while at it. `BITS_PER_LONG / sizeof(long)` always
equals to %BITS_PER_BYTE, regardless of the target architecture.
Do the same for the tools ecosystem as well (incl. its version of
bitops.h). The previous implementation had its implicit type of long,
while the new one is int, so adjust the format literal accordingly in
the perf code.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Acked-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 55052184ac90 ("iio: common: st_sensors: honour channel endianness in read_axis_data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bitops.h         |    2 ++
 kernel/trace/trace_probe.c     |    2 --
 tools/include/linux/bitops.h   |    2 ++
 tools/perf/util/probe-finder.c |    4 +---
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -21,6 +21,8 @@
 #define BITS_TO_U32(nr)		__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(u32))
 #define BITS_TO_BYTES(nr)	__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(char))
 
+#define BYTES_TO_BITS(nb)	((nb) * BITS_PER_BYTE)
+
 extern unsigned int __sw_hweight8(unsigned int w);
 extern unsigned int __sw_hweight16(unsigned int w);
 extern unsigned int __sw_hweight32(unsigned int w);
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -535,8 +535,6 @@ parse_probe_arg(char *arg, const struct
 	return ret;
 }
 
-#define BYTES_TO_BITS(nb)	((BITS_PER_LONG * (nb)) / sizeof(long))
-
 /* Bitfield type needs to be parsed into a fetch function */
 static int __parse_bitfield_probe_arg(const char *bf,
 				      const struct fetch_type *t,
--- a/tools/include/linux/bitops.h
+++ b/tools/include/linux/bitops.h
@@ -20,6 +20,8 @@
 #define BITS_TO_U32(nr)		DIV_ROUND_UP(nr, BITS_PER_TYPE(u32))
 #define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_TYPE(char))
 
+#define BYTES_TO_BITS(nb)	((nb) * BITS_PER_BYTE)
+
 extern unsigned int __sw_hweight8(unsigned int w);
 extern unsigned int __sw_hweight16(unsigned int w);
 extern unsigned int __sw_hweight32(unsigned int w);
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -304,8 +304,6 @@ static_var:
 	return ret2;
 }
 
-#define BYTES_TO_BITS(nb)	((nb) * BITS_PER_LONG / sizeof(long))
-
 static int convert_variable_type(Dwarf_Die *vr_die,
 				 struct probe_trace_arg *tvar,
 				 const char *cast, bool user_access)
@@ -335,7 +333,7 @@ static int convert_variable_type(Dwarf_D
 		total = dwarf_bytesize(vr_die);
 		if (boffs < 0 || total < 0)
 			return -ENOENT;
-		ret = snprintf(buf, 16, "b%d@%d/%zd", bsize, boffs,
+		ret = snprintf(buf, 16, "b%d@%d/%d", bsize, boffs,
 				BYTES_TO_BITS(total));
 		goto formatted;
 	}


