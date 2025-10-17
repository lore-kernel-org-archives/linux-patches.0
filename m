Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CE5258ECA;
	Fri, 17 Oct 2025 15:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714455; cv=none; b=l3nzdPxf7+Z/xE90Nwh5Yq3WXlTcHUZDGNQ2GFdXi2yjng321FHZli74l/6XWHS7TP4xOEwkSljDUTVjd6cr02oO2eEm5CbtK6LfftbjGV9wbMAkTozbddN8a37oLVrhimZuLdBCv+qThb0WwSlsvYTqeXfo/KPj1EW5reoe7fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714455; c=relaxed/simple;
	bh=aBjk32AYAkXY64RwJCBDCxqvV8qFDRVGW+PMJ17OHBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2vzg8+SOHCItQQ94x5kcAOOd+ofaqtUp/pXkbj60IOkSE931roY0QNRRrRF6fBBmQKQEPWcdzLB+gNuGY2jqLEsoBhcSaVmcobfNM5d0ED840xbMU+hmjdevDvjNh2u1tooVN8l24trjPv2Nhf6HjumfNxzDtVvMIxPV+tfkfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUriYYC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUriYYC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B38C4CEE7;
	Fri, 17 Oct 2025 15:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714455;
	bh=aBjk32AYAkXY64RwJCBDCxqvV8qFDRVGW+PMJ17OHBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUriYYC9xhJg8BsHcTEiZsCvUjsVUvN5DNsWj8Ttd1e/nYi3Oo1eIXlDXcIooE4SW
	 MjeTN460/QGL+vooKk1dF1UGXx2sscybCwC5rK1x7Qtj524aRqusjqjlT2HDCeB5cX
	 sSkIP8KVH427RiLqueykVTRUwOLiEf7ToCldzlBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 152/277] parisc: Remove spurious if statement from raw_copy_from_user()
Date: Fri, 17 Oct 2025 16:52:39 +0200
Message-ID: <20251017145152.673883435@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit 16794e524d310780163fdd49d0bf7fac30f8dbc8 upstream.

Accidently introduced in commit 91428ca9320e.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: 91428ca9320e ("parisc: Check region is readable by user in raw_copy_from_user()")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/lib/memcpy.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/parisc/lib/memcpy.c
+++ b/arch/parisc/lib/memcpy.c
@@ -41,7 +41,6 @@ unsigned long raw_copy_from_user(void *d
 	mtsp(get_kernel_space(), SR_TEMP2);
 
 	/* Check region is user accessible */
-	if (start)
 	while (start < end) {
 		if (!prober_user(SR_TEMP1, start)) {
 			newlen = (start - (unsigned long) src);


