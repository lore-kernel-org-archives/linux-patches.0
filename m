Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046073;
	b=r+D5dslYVeamX36juPxuNezwFWdszBcrHVsOZviNSkHMRDkCWDCRoOunkLXJLZtK7/C9
	 M8BhF5PgY2Mv/m5TvLpPsYtNQx5sXD2fRPseM97pNFEztvvMdcLgW6NzLqdjlyQWqaOZx
	 yvODL0InKulGpohp7e7+zqiajWFMj4gMjD5GaMJAiDZ5ejVAOH+v+/YN8QC2s69yMwJ9M
	 La9M6MCNOrdS3vaT6dzcZJNfob3UOS72oMgLpyHxo5EZhrQhZz/SFXS521IkZjMzQ+lSD
	 9cADn2z3mRIq2EkBzQ1r7LMqQo2eE4Q3/BH8Esx1c7Jvje682tu9KnHWP3CRZcSsU5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OlFaVu8nN7u1vs4KpRDick6mAI0Csw3ipZrWgDK6ytw=;
	b=EyPiR//MSc87eQ8Shjo/hnOKgSZehlARmTLDuTjKdr6GpgtjBq+aa+r5QXoJ6MJEB+Va
	 d5kVZrZJSi29uqNIzEebHUJG6WwbTu2HDIF9FHiklomJbdTpT8cJkLAJVik44KSkvqAN9
	 rnVyeQ1rtlUv1W1ZpVzYcSA+9Asd98TbaCV58FTHVcLancACxyn/FMylW/sfnsJEtUSJx
	 1VQtjMF3jaEWaShrPdVRrYj4dwM/7oWGGM/N2JZnyzZK3DxqIT1YNpxtNHK3Z2w9tEE/r
	 qqj5g7FE1Wm3Pf7iWaD3/a4pGJFkJ1KBbteEU76EVJAP0wjv0lXQK2XneLzM4iCv4Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MvHxAsYc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7C8606A31C;
	Wed, 18 Nov 2026 23:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MvHxAsYc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA7D1F000C5;
	Wed, 18 Nov 2026 23:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046073;
	bh=OlFaVu8nN7u1vs4KpRDick6mAI0Csw3ipZrWgDK6ytw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MvHxAsYcCU2pdJ9SkZSgcaSEQtM9fcoLYxTGPDtctKF1QdlzVbs257z//bKWbv9A7
	 m0A3p/lT5eINcuLvtHnL7nb7pYxXs1bSqEn02E0EiRXlaRB4/xZJnFHdvExWCDcUcf
	 RyNfBxUTQY2wtXZIkQiSzfuTH/517HyjUtTkD/6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1150/2857] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Wed, 18 Nov 2026 15:36:24 +0100
Message-ID: <20261118150242.989813105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 5695abc4e742b947f586bfb6a080a80ad9957e5d ]

damos_quota->charge_{target,addr}_from saves the target and region the
scheme's quota limit is reached.  damos_skip_charged_region() skips the
target and regions before the point.  The target that was assigned to
charge_target_from could be dynamically removed from the context by the
runtime parameters update (aka commit) feature.  In this case,
damos_skip_charged_region() cannot find if the point is passed or not,
so the scheme is effectively disabled.

Similarly, the user could also remove all the regions of the target
using the runtime parameters update feature.  It would be uncommon to do
that, but it is a supported feature.  Because the skip pointer detection
logic (damos_skip_charged_region()) works for each region of targets,
this result in the logic is entirely skipped and the scheme is
effectively disabled again.

The user impact is that the DAMOS scheme could suddenly stop working
under certain uses of the runtime parameters update feature.  It could
surprise users. No crash or leak happens though.  Users could also
simply work around by re-installing the scheme.

Catch the corner cases in damos_adjust_quota() and reset the pointers.

Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-cd0c55fc-0cc8-45d8-9637-3334811c49b8
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9206737d05ae7..01f93146b92fe 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -860,6 +860,26 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 	quota->esz = esz;
 }
 
+static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
+		struct damos *s)
+{
+	struct damos_quota *quota;
+	struct damon_target *t;
+
+	quota = &s->quota;
+	if (!quota->charge_target_from)
+		return;
+	damon_for_each_target(t, c) {
+		if (t == quota->charge_target_from) {
+			if (damon_nr_regions(t) > 0)
+				return;
+			break;
+		}
+	}
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+}
+
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
@@ -890,6 +910,8 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 			damos_set_effective_quota(quota);
 		}
 
+		damos_fix_stale_charge_pointers(c, s);
+
 		if (!c->ops.get_scheme_score)
 			continue;
 
-- 
2.53.0



