Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EB526A1AB;
	Mon,  1 Dec 2025 11:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588854; cv=none; b=CXo5RN4qxDnXaEqD9Opka16E8pGUMfIuCp5yX2YEnGVPbiSpvKfTZndagplGTTcqDRyGLqoHz9yxjM5lkZSsDWqOZHzGDZqUENvfQ2L54UU+uP+BNGp6YCHSnV0HqxqJjy9O2MGpJvoXGm5boFgcbechV3+ULr9TJlTeNGzlFsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588854; c=relaxed/simple;
	bh=T+XR65yKaM/A3oqOlnHCXGECvKTpkTbtzRPnY1ehJUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPEvMeym2+ZqQGTKK1cc/P1rO74bG46WSfJkp1LdoD0rMzW3L9lzfUx0nHmUsLsff54uLvcL0JDNfwj3TgHWIpKFaHn6Zxuxqt7ryMACcIczltHOtUio2SR37fImT/dKubEqIzpEZwi3BT4JaKwfNkNax1MqRyxQsRH1zzMz8Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+OQdsji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+OQdsji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A2FC116D0;
	Mon,  1 Dec 2025 11:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588854;
	bh=T+XR65yKaM/A3oqOlnHCXGECvKTpkTbtzRPnY1ehJUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+OQdsjiPQ4Ws2DciPtrfYX03cbtnJjX+x/EMdj2ouCT0H2+K71GjjtWGP9tmK+pH
	 AC/pand4K3m36HkXHUeTf2eM970rW407aCIO7zRGAgoAw1m6dVCd8i+5PXQaxmAVuL
	 HX7mKpm5+9fKjJtNPONkxH6u56O53XzFud5VyZTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 152/187] gcov: add support for GCC 15
Date: Mon,  1 Dec 2025 12:24:20 +0100
Message-ID: <20251201112246.709246359@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit ec4d11fc4b2dd4a2fa8c9d801ee9753b74623554 upstream.

Using gcov on kernels compiled with GCC 15 results in truncated 16-byte
long .gcda files with no usable data.  To fix this, update GCOV_COUNTERS
to match the value defined by GCC 15.

Tested with GCC 14.3.0 and GCC 15.2.0.

Link: https://lkml.kernel.org/r/20251028115125.1319410-1-oberpar@linux.ibm.com
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reported-by: Matthieu Baerts <matttbe@kernel.org>
Closes: https://github.com/linux-test-project/lcov/issues/445
Tested-by: Matthieu Baerts <matttbe@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/gcov/gcc_4_7.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -19,7 +19,9 @@
 #include <linux/vmalloc.h>
 #include "gcov.h"
 
-#if (__GNUC__ >= 14)
+#if (__GNUC__ >= 15)
+#define GCOV_COUNTERS			10
+#elif (__GNUC__ >= 14)
 #define GCOV_COUNTERS			9
 #elif (__GNUC__ >= 10)
 #define GCOV_COUNTERS			8


