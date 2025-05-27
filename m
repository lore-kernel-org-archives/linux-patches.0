Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746AA367;
	Tue, 27 May 2025 17:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366084; cv=none; b=a4DniJCi+ju4pHdeKLTzZDFIojTRBHAQ3+YdseQ/W+7pVsgHvMZboGljk6BdHm2+jTS92ol1m4jU4JAI3uqZOStC7lGLfwSPU/MKy9Rhvvj5Pmua84ZI7eg8+BfSrF4z+TGgChJ+gfmV557UXd2WTuwXzpB9DN3R9FxYMauOXUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366084; c=relaxed/simple;
	bh=r5qTUD2FrAKo1ps1wYSC9LtRE6Q99CcxBf9DlqaH21Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdM8qKMvfkyRz+MbLAB5tW5l+brhf3+nt0pxImIxF4sh5gWM/fWNLot+AguLM66UT3TfubIM2O7tfxezPs4w6EJHYkcjEPh33dOGF0uyUm1YzEOW7bj2zO6Wo8hdlNmYQ41tKCgZ9zdtS1qucKrTo31UjwFljCKKnsAHkGOVvI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2v/o9Uwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2v/o9Uwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D842BC4CEE9;
	Tue, 27 May 2025 17:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366084;
	bh=r5qTUD2FrAKo1ps1wYSC9LtRE6Q99CcxBf9DlqaH21Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2v/o9UwgJj24GCaPhBg2jRY1hEHRVBmiVTY8jtUyCKSLQhbzjD8ahSIPE64fTqmv5
	 cuXz/drKl4LtsaQ1dPLftfDRypWPm9jbiksH6dTZn6L/MmOy5GRdcKOLxURrWD5tbR
	 Y5gRd0lhXKNar0uoC1RQPYpwnIAD0+WuOlcbZVc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 586/626] pmdomain: renesas: rcar: Remove obsolete nullify checks
Date: Tue, 27 May 2025 18:27:59 +0200
Message-ID: <20250527162508.789613839@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 13a6d4265665201a795a2ff5a3e6e4d183fc9c33 upstream.

All nullify users and helpers were removed, but the R-Car SYSC drivers
still checked for nullified domains.  Remove the obsolete checks.

Fixes: c8d87704444a8ac7 ("pmdomain: renesas: rcar-sysc: Remove rcar_sysc_nullify() helper")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/107f2bf9f13b29f0f623d2959a5347ec151fb089.1745840768.git.geert+renesas@glider.be
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/renesas/rcar-gen4-sysc.c | 5 -----
 drivers/pmdomain/renesas/rcar-sysc.c      | 5 -----
 2 files changed, 10 deletions(-)

diff --git a/drivers/pmdomain/renesas/rcar-gen4-sysc.c b/drivers/pmdomain/renesas/rcar-gen4-sysc.c
index 66409cff2083..e001b5c25bed 100644
--- a/drivers/pmdomain/renesas/rcar-gen4-sysc.c
+++ b/drivers/pmdomain/renesas/rcar-gen4-sysc.c
@@ -338,11 +338,6 @@ static int __init rcar_gen4_sysc_pd_init(void)
 		struct rcar_gen4_sysc_pd *pd;
 		size_t n;
 
-		if (!area->name) {
-			/* Skip NULLified area */
-			continue;
-		}
-
 		n = strlen(area->name) + 1;
 		pd = kzalloc(sizeof(*pd) + n, GFP_KERNEL);
 		if (!pd) {
diff --git a/drivers/pmdomain/renesas/rcar-sysc.c b/drivers/pmdomain/renesas/rcar-sysc.c
index dce1a6d37e80..047495f54e8a 100644
--- a/drivers/pmdomain/renesas/rcar-sysc.c
+++ b/drivers/pmdomain/renesas/rcar-sysc.c
@@ -396,11 +396,6 @@ static int __init rcar_sysc_pd_init(void)
 		struct rcar_sysc_pd *pd;
 		size_t n;
 
-		if (!area->name) {
-			/* Skip NULLified area */
-			continue;
-		}
-
 		n = strlen(area->name) + 1;
 		pd = kzalloc(sizeof(*pd) + n, GFP_KERNEL);
 		if (!pd) {
-- 
2.49.0



