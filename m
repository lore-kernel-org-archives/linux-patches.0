Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028475;
	b=p1yaNxuLrNThXK/J/CzxobXJA3d9wYmurNGb09G2UewUpeb3TOjPwazS/you2pQ6WnfH
	 7EfKHYgia5+gZM2oMI5FfQ617VBLZghMeW2b+RK+AFklpb91jVCZBk/kX1fhdxiZX/VLM
	 9VPD2DlFLLr+SIxi22sQ2wZoHalFJMZ18iYnMZkAl7Z/zy/aMblEdNtjVMLDGFQFsLFeB
	 lxkvYe5jiG1+AfAKDzm/hZe5cL68IfaAHmJPkWK5JlYk83E4l23oBVDGsO1CzhRq8DAol
	 W5AIBOIDAzXWDK47QRACg+FYA+iJ2R5lOFcg/Gp87c4RcgydBBFI4z7jRdulT3UsfQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x4EDdx7YEaZ8amtyS6wPDy7XDS5S8jmnbaq1LG5TW28=;
	b=nQgNIap33q+xPSQpltJjM+d1SHCydSbD8NpvZ/3EhOqWBgkBaCiyxGBElhTSi/3SY4jB
	 SMUnv3s2rU8VzNqhBuPqe4AUzFzAlgo1Og7xK1IbjhXhQkBT2cdlbCwhf7EYZd3oGv85q
	 /cdNTMEG41h4q4dZL4AJ2Re9u84C4PXFPOll7KsyKGD8sTW4Rl2+cSkIreZlKwo0IQfYe
	 6Q7Ql0HbxGp5FaV/SonmYf5VX27ZNqIfCoAFUR2YPkGSSAJuCmxg780DeZd+uB01KD9YS
	 G54UoEEhW5OziLbdDd9HAvabCXKqhyfOg1/jXEtNtO0hvSR7/8N4IkFLpOLLx7fmgeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EHl9dNEE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116D7606A32A;
	Wed, 18 Nov 2026 19:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EHl9dNEE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F001F000C4;
	Wed, 18 Nov 2026 19:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028474;
	bh=x4EDdx7YEaZ8amtyS6wPDy7XDS5S8jmnbaq1LG5TW28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHl9dNEEFFucZdvQT5jC6x9zxHjG1vHBdaKB+Zq+q861fAJaPlnG35aykSzFXue7p
	 4rSPr1LgZ3k+4rxih0F4456YeyywCaGyy/rsbE/zVFhkhp+9nhGiZsoROeJ5gjKjbF
	 dh/+yVZ/HoKdJg6vBZFRaxz3SyWocLulEOsarODg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anubhav Shelat <ashelat@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.18 2139/2151] perf pmu: fix duplicate conditional statement
Date: Wed, 18 Nov 2026 16:04:34 +0100
Message-ID: <20261118150239.591601925@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Anubhav Shelat <ashelat@redhat.com>

commit 87c75fa75559f5501b5a03caf442f18899e388be upstream.

Remove duplicate check for PERF_PMU_TYPE_DRM_END in perf_pmu__kind.

Fixes: f0feb21e0a10 ("perf pmu: Add PMU kind to simplify differentiating")
Signed-off-by: Anubhav Shelat <ashelat@redhat.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Closes: https://lore.kernel.org/linux-perf-users/CA+G8Dh+wLx+FvjjoEkypqvXhbzWEQVpykovzrsHi2_eQjHkzQA@mail.gmail.com/
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/pmu.h |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -333,8 +333,6 @@ static inline enum pmu_kind perf_pmu__ki
 		return PERF_PMU_KIND_PE;
 	if (type <= PERF_PMU_TYPE_DRM_END)
 		return PERF_PMU_KIND_DRM;
-	if (type <= PERF_PMU_TYPE_DRM_END)
-		return PERF_PMU_KIND_DRM;
 	if (type <= PERF_PMU_TYPE_HWMON_END)
 		return PERF_PMU_KIND_HWMON;
 	if (type == PERF_PMU_TYPE_TOOL)


