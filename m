Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C7F73451;
	Tue, 11 Nov 2025 00:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822153; cv=none; b=f92ZorMp7v5yOHsLD9Vrz6KJHdX/teWTiOhAjoOR+IAnp5bsR1KFo5btCRcbzH4Ye4sewuUHzUNr9YVvzuVW3VySdThSuuNQfutrD9IHDEsqdtEWyygx8W60pLwN4H4OfVOxb4rFuEtMzGIA1qlHbE8tl3Vg6oXLAdBLlRlKslQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822153; c=relaxed/simple;
	bh=OS9mAyh1f/Gxo/k7ariML793bR/zO8PesxijDb5CL6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9Kd3gu7Yb+rz0hiYKyV3e0kT9E9mhsz31pEvWzlSIusRspmY6nzfBu8teTHQgL5FZXDJUKeWix2AfFo5V+cBgAxkr64A98vBKN1UKM2ZZJJEYIxjemEIGS5SkGgrf8ynvfhM9JXhIzlh5hIuUgK5f0VjX+BJCv98hRlQihuXO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7DltC08; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7DltC08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB320C19425;
	Tue, 11 Nov 2025 00:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822153;
	bh=OS9mAyh1f/Gxo/k7ariML793bR/zO8PesxijDb5CL6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7DltC08D2j49TasoqDDiy0ct9VGSh44ZatNBF4dCxWa0Jii5JgFT+VCufglTl/TS
	 foRyeULtIkR+lDxJmpW1gSww80ay+Qu3j/70/ehv74M6DurulpPUOyTCzwkWuNwyWN
	 fl+NEcWQiDbd0C/0f/r9ZUK31K7SNBN9uLhgPuSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 038/849] ASoC: cs-amp-lib-test: Fix missing include of kunit/test-bug.h
Date: Tue, 11 Nov 2025 09:33:28 +0900
Message-ID: <20251111004537.361693163@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit ec20584f25233bfe292c8e18f9a429dfaff58a49 ]

cs-amp-lib-test uses functions from kunit/test-bug.h but wasn't
including it.

This error was found by smatch.

Fixes: 177862317a98 ("ASoC: cs-amp-lib: Add KUnit test for calibration helpers")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20251016094844.92796-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs-amp-lib-test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs-amp-lib-test.c b/sound/soc/codecs/cs-amp-lib-test.c
index f53650128fc3d..a1a9758a73eb6 100644
--- a/sound/soc/codecs/cs-amp-lib-test.c
+++ b/sound/soc/codecs/cs-amp-lib-test.c
@@ -7,6 +7,7 @@
 
 #include <kunit/resource.h>
 #include <kunit/test.h>
+#include <kunit/test-bug.h>
 #include <kunit/static_stub.h>
 #include <linux/device/faux.h>
 #include <linux/firmware/cirrus/cs_dsp.h>
-- 
2.51.0



