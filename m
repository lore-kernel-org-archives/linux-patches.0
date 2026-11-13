Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585350;
	b=bQ2p5pm3IPYVftYXMhB/zPWij4YU8Vruxuim2K9qvRQW9TGqxmaKmdCzjKacZqTAT5M3
	 r0zSn+khzkO6S9Pd5VgaDdZrL6iud3c0AriC5YCu6LMqJG8WeKcNaNlEUaOQsdh7F7u77
	 yAhPSR0q7z3UWigS6vaSq1dyNCyHjVyl6cDmKGqjcw/q34u9DG3DYuXZ0vko3I/Rq5U6f
	 hWDXzjS4wZNGj3Z7QAH7C2jOZu00qes+aJECihLl0keKH63JqpActd/LA7Y9h2Lr4h7NG
	 DLwQkjBI8phB2iV9SlJ23wbAeGQONd5rRMgTBql1jPVYY3NWvUfKlf15ZOz6ZZFovSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Xr3g6JplAfEAcs3cPyh2xrpTV778hnXbtSBieGBxtI=;
	b=FBsAznU17KeCnc+7KrLpmDMurKhJrYux+nPNJxuQIQOVvnTC1gPG6PaRYbAH5jOkbqna
	 7+tSlqPAOqRBaLtfogatSIPcTLWX3Mq+PfdU+11NrWKdDhMB8k7bnJ/esNjj1RUhyxrVa
	 3ojGsbQyo2STUna0JWzgzcscWewSJ86FTIRJJMlyohOfZ02+5/XtkyHLp4gDsGjmRRl6o
	 YB+fFJjTiYkLC/pmNk7o+roufhD0H9JZh2MJ7bJNidZEQK1NSmRDcAdI4vsxFC7VTEDPc
	 r2PNIpfSRcs7La0BXK+STkdOHYBglr+R4pTzFW/M9M+FjG/pHRjTNFPWMhrO5XZQ1EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RACEo2dB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414FA606A8A2;
	Fri, 13 Nov 2026 15:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RACEo2dB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B6A1F000CB;
	Fri, 13 Nov 2026 15:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585349;
	bh=1Xr3g6JplAfEAcs3cPyh2xrpTV778hnXbtSBieGBxtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RACEo2dBrI6NG+uTSFmd6Ai9a211dKcLYkriILkGK19VGHaU24SM49kWXMECaHpWU
	 UrOB2zNsCOel95wB5gKOIyVecX15bJV7ehD349TXQrxOx/HGwJtSO3ka1l0HosWWr6
	 90y70gyiTjD9IuDWSwZPaGw5KTWfmfdj0mJZY6wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 031/507] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Fri, 13 Nov 2026 10:45:35 -0500
Message-ID: <20261113153754.437820308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index e018635774be5..229ab1674b4c1 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3200,6 +3200,26 @@ static void damos_trace_esz(struct damon_ctx *c, struct damos *s,
 	trace_damos_esz(cidx, sidx, quota->esz);
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
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
@@ -3235,6 +3255,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 			damos_trace_esz(c, s, quota);
 	}
 
+	damos_fix_stale_charge_pointers(c, s);
+
 	if (!c->ops.get_scheme_score)
 		return;
 
-- 
2.53.0



