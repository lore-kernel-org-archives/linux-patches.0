Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037327;
	b=4EYgeB2+PZZfRL+21f8pUYI5j5b/juo/8eqTkHXdBogW9/G50v48ZOLyM2rbMj7NqK1b
	 lmhyazQElFmw6xfkDxOiRuRTfJq1UjFl92wmz5Iqh/LY5tUfhQ1toAIdCH0d+pKiWRwZG
	 sGbhTbxoiSuHYhpkKfBUJ5W6UAkrKvDhSjxvf0zC0myHx+nRg8O067DE4Yz6osiUaPeML
	 Lun+4USKeeHvaW3edFXg1wUP+wYVc+FeTveAHo0oU0xqAyV+yTQd4R17Xwrv9EqkWiSwm
	 v/Tp0HDRSAAgAblE4lsmIWGam5x50WWpRz7SoCHoeQ8GN8wITfkGxu04vz9OocoeJtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037327;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tYzeAlVrX3PI1nQoRcjqJGRiG4CVVgwWR6lbNVKZNik=;
	b=aDw5dmTbNnUrrW9E6Sp7I+H0Y7vL0Y2wmYgc+lvtA+mnRVSXkh5MU/Gg/CfLtR4dFpbW
	 3ENEkiXaMD0SXix5UX5LNZwdoylwaSaYncIVeJqmbqRT3giIOhgW48GU5zVxDXl9OIUwf
	 +JwhMTMwpcVEBHtLGVwexAlZFr3lek0GDcxyH8UZTtgTKkWQaBRmWF5HS8ISyncT+Bpvw
	 gzwSWR5NUb3ecWbNm1Fb1ToMWUrdMtBsDe5547VokvTGoaZWOQgp3qZEMM5jvHKzAtzoh
	 aRJ3ryHbZYs5joGU50OPup06GwSWcqsLvkIVIOW3Swss50+OYhoquVHRbq5/e4cTg0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KarCed+0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E01606A320;
	Wed, 18 Nov 2026 21:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KarCed+0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0631F000C4;
	Wed, 18 Nov 2026 21:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037327;
	bh=tYzeAlVrX3PI1nQoRcjqJGRiG4CVVgwWR6lbNVKZNik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KarCed+0kSC+c76eV2H6ORy3UdkYBRTyahAu+MPPSq20Nfj8WjkiLBPXFFOXvaURU
	 WibtJou75VcxhvQpXk+TsGWem6OLyLHJ2qSrwVm0S37Yf4Da5lhQ7yUbkBkjcl6tp6
	 dA8U0kwzlbY+Prk2+4fqZ0BGLRaAMyqCcTJTSq7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1365/3318] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Wed, 18 Nov 2026 15:33:07 +0100
Message-ID: <20261118150401.441621390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 mm/damon/core.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2bc93326fb6ae..8fcb8356101b3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1089,6 +1089,27 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 	quota->esz = esz;
 }
 
+
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
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
@@ -1116,6 +1137,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		damos_set_effective_quota(quota);
 	}
 
+	damos_fix_stale_charge_pointers(c, s);
+
 	if (!c->ops.get_scheme_score)
 		return;
 
-- 
2.53.0



