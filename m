Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619566;
	b=2TukWr+ssusoTQELtka8XpwenNEeZkMM5Dtzy04ib0sbZ5qZ61RJCNkm4mKQ11Jc6xnl
	 4w293GWKw2kUdMWhigkPpN0HvsO2Oh/VR2Ax7n2j38VTdVYApXQXqi9CoUZHIw/eL223K
	 86ZO1RtyCn4evCCuzHKGEEWJKJCVaZUw1nfjbarc5u5dX5/urAqzWwyZj09fC2EUVps6g
	 qZcWLwYX3HS0YVPidLMsmQSWIjn0zsAeo416YABKtlAOICxwCNaPtFgZBtUEuFRV6C5YZ
	 iLpfrsVdN/4ddQuhGVRAHMxWhpPnNcQbpCBzRhUOqVYRIoc+eGS+pDdubmmGyOKydAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zb+viAhd/rpLzFtEeoCQ/A0yXCfO0j5DP+i66dDt2/k=;
	b=BLcyj7UF6mZKV9SRXlDJh9NOuLw6rwptPfB8tseoZMv77shx7BailU5vsn/iQNXTqkqZ
	 wBpcgnPS4ExhMhzjfVNGM5vydXHtwhilWksJZ/JQLggux6vqbm4ikDCRg3m2PYBjkllbX
	 mQ/fmHe2Qhli2QMVtzpLfx8ybUUVFNHrApeo6ijVVx2Q/6mba5nqoVI3lStF0O94mnZXP
	 93NSFq+j3jdt3oNVQC7VjH5MHuRvy5822lNKjzKaTactrpr5Njk4fgdGQVt8ZQOr3Yvqq
	 LfAUapOZE2GMLxJ9Xs8JtDjZCHY4Bt1DaU0+XYDS7L1hO0OlF9YfrtKm0cNVS4CHy+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbQIQ3qE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA3C606A323;
	Wed, 25 Nov 2026 15:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbQIQ3qE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771CC1F000C0;
	Wed, 25 Nov 2026 15:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619566;
	bh=zb+viAhd/rpLzFtEeoCQ/A0yXCfO0j5DP+i66dDt2/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbQIQ3qEr7fRs14JmQ3GaHezn/oKN7/hGgeRgMs7TTXEDZixn5zFTJkw9X4bt4shM
	 ccVo7+glck7Dht+QnEsH835uVjq95rBUW417192Q/2MWcuEW477RTextq1a6Blm6Bk
	 4xjU1agn5ASbX6sm/xmtGtZJ/dIc7bwRC3A9Sna0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Kerkmann <s.kerkmann@pengutronix.de>,
	Ian Rogers <irogers@google.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.3 0636/1005] vdso: Add VDSO_UNALIGNED_PACKED config option
Date: Wed, 25 Nov 2026 15:32:54 +0100
Message-ID: <20261125143836.652693927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

commit 2727aca4439ee4b9085141a3babadc8de580397f upstream.

Commit a339671db64b ("vdso: Switch get/put_unaligned() from packed struct
to memcpy()") switched __get_unaligned_t() and __put_unaligned_t() from
using a __packed struct to __builtin_memcpy() to avoid strict aliasing
undefined behavior.

On targets without efficient unaligned memory accesses (such as ARMv5),
GCC may not inline __builtin_memcpy() into byte shifts and instead emit
stack spills or much slower out-of-line memcpy() calls. Add
CONFIG_VDSO_UNALIGNED_PACKED, defaulting to
!HAVE_EFFICIENT_UNALIGNED_ACCESS, to use the __packed struct
implementation on strict-alignment targets while keeping
__builtin_memcpy() elsewhere and in tools/.

Fixes: a339671db64b ("vdso: Switch get/put_unaligned() from packed struct to memcpy()")
Reported-by: Stefan Kerkmann <s.kerkmann@pengutronix.de>
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261020163210.742728-1-irogers@google.com
Closes: https://lore.kernel.org/lkml/47f8c30b-e326-4ff0-a2bc-5683209a9e2d@pengutronix.de/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/vdso/unaligned.h | 16 ++++++++++++++++
 lib/vdso/Kconfig         | 10 ++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/vdso/unaligned.h b/include/vdso/unaligned.h
index 9076483c9fbb..726fd15efc82 100644
--- a/include/vdso/unaligned.h
+++ b/include/vdso/unaligned.h
@@ -4,6 +4,20 @@
 
 #include <linux/compiler_types.h>
 
+#ifdef CONFIG_VDSO_UNALIGNED_PACKED
+
+#define __get_unaligned_t(type, ptr) ({							\
+	const struct { type x; } __packed * __get_pptr = (typeof(__get_pptr))(ptr);	\
+	__get_pptr->x;									\
+})
+
+#define __put_unaligned_t(type, val, ptr) do {						\
+	struct { type x; } __packed * __put_pptr = (typeof(__put_pptr))(ptr);		\
+	__put_pptr->x = (val);								\
+} while (0)
+
+#else /* !CONFIG_VDSO_UNALIGNED_PACKED */
+
 /**
  * __get_unaligned_t - read an unaligned value from memory.
  * @type:	the type to load from the pointer.
@@ -41,4 +55,6 @@
 			 sizeof(__put_unaligned_val));			\
 } while (0)
 
+#endif /* CONFIG_VDSO_UNALIGNED_PACKED */
+
 #endif /* __VDSO_UNALIGNED_H */
diff --git a/lib/vdso/Kconfig b/lib/vdso/Kconfig
index 597f5f0f9681..2436c20ee0ef 100644
--- a/lib/vdso/Kconfig
+++ b/lib/vdso/Kconfig
@@ -23,3 +23,13 @@ config VDSO_GETRANDOM
 	select VDSO_DATASTORE
 	help
 	  Selected by architectures that support vDSO getrandom().
+
+config VDSO_UNALIGNED_PACKED
+	bool
+	default !HAVE_EFFICIENT_UNALIGNED_ACCESS
+	help
+	  Use packed structs rather than memcpy() in include/vdso/unaligned.h
+	  for unaligned memory accesses. Enabled by default when the
+	  architecture does not have efficient unaligned accesses, as GCC may
+	  emit stack spills or out-of-line memcpy() calls instead of inlining
+	  byte shifts.
-- 
2.56.1



