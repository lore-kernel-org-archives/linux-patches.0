Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE407183CA6;
	Mon, 12 Aug 2024 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479739; cv=none; b=WwoiUeOb7ic2FAvpk+QsM2QTD9ucJcDE/7tqhylPMBcLDYBolzFGLIKhyt+AuKQQS8xT2kJfUL0BbmiHUF5LOj+8KJHZDrzdWVzX8Bj/eMrZHHSLXAQZF+bEsafZDlnnl2XPzdQwNIF7x387YCBhqpg+yKagZHiOMN/UAyW30Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479739; c=relaxed/simple;
	bh=kPR9MZJHXP39iL8vtEfMQPiPfwrygOYltlGWh4xziKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdxTZZan3CyiO/o9VqQZeTqdoONE3VSp5HejSD9/LChpEPvdVnDJW97nLgBUGNR3H9RUPBHHOX0c2xYr1cC/LxyxZUVAzop1f6W01OxYGFcZYywoD4SSiZ+s4NkrrTIGekHdhODARLY7m17JZnUj5jaZ+AgGpt74ucukSRXQ3p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uV/ScJoW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uV/ScJoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EDBC32782;
	Mon, 12 Aug 2024 16:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479739;
	bh=kPR9MZJHXP39iL8vtEfMQPiPfwrygOYltlGWh4xziKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uV/ScJoWvMkgnCY+Ynyr49++J+MAs6kHD6QrkRs3vjnF5oCd5biIda8ci6OQWDX4I
	 By+IG7jhXKLWuBM7PvWN4K2Lxs2UznkThP8htuWrZW0iqS19ZDN+Qr9o4vG87na3XU
	 Db1SVISZdHun1a5SpLjYSxUVbjtrdoEu3gXYy3C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Besar Wicaksono <bwicaksono@nvidia.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Will Deacon <will@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.6 178/189] tools headers arm64: Sync arm64s cputype.h with the kernel sources
Date: Mon, 12 Aug 2024 18:03:54 +0200
Message-ID: <20240812160138.999317751@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit dc6abbbde4b099e936cd5428e196d86a5e119aae upstream.

To get the changes in:

  0ce85db6c2141b7f ("arm64: cputype: Add Neoverse-V3 definitions")
  02a0a04676fa7796 ("arm64: cputype: Add Cortex-X4 definitions")
  f4d9d9dcc70b96b5 ("arm64: Add Neoverse-V2 part")

That makes this perf source code to be rebuilt:

  CC      /tmp/build/perf-tools/util/arm-spe.o

The changes in the above patch add MIDR_NEOVERSE_V[23] and
MIDR_NEOVERSE_V1 is used in arm-spe.c, so probably we need to add those
and perhaps MIDR_CORTEX_X4 to that array? Or maybe we need to leave this
for later when this is all tested on those machines?

  static const struct midr_range neoverse_spe[] = {
          MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
          MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
          MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V1),
          {},
  };

Mark Rutland recommended about arm-spe.c:

"I would not touch this for now -- someone would have to go audit the
TRMs to check that those other cores have the same encoding, and I think
it'd be better to do that as a follow-up."

That addresses this perf build warning:

  Warning: Kernel ABI header differences:
    diff -u tools/arch/arm64/include/asm/cputype.h arch/arm64/include/asm/cputype.h

Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Besar Wicaksono <bwicaksono@nvidia.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/lkml/Zl8cYk0Tai2fs7aM@x1
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/arch/arm64/include/asm/cputype.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/arch/arm64/include/asm/cputype.h
+++ b/tools/arch/arm64/include/asm/cputype.h
@@ -84,6 +84,9 @@
 #define ARM_CPU_PART_CORTEX_X2		0xD48
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
+#define ARM_CPU_PART_NEOVERSE_V2	0xD4F
+#define ARM_CPU_PART_CORTEX_X4		0xD82
+#define ARM_CPU_PART_NEOVERSE_V3	0xD84
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -153,6 +156,9 @@
 #define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
+#define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
+#define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
+#define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)


