Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618635;
	b=GnGTM+uUAoh/hZXA/mNbw0rvUr/XRphCVsC/RIcGX3Sm/eDF8lvuMbjZF8Zg8WYMyoCC
	 0IsnOZhUZ5OOZvA8qBQipWejAz/qdcBQuw9pv4c94lIL7GzOyMXNCbrRBC+352ipE1dWa
	 iUh9v9bLyW9vZ2ksKhZlucHGHkgiql2uc7p+nag6ThY4BO8tKsVZZPSmkzScidPF5Ort3
	 dDjSMue8mklpMQ9gPhGEWgqgsO0CZu/RDEsBvbJqvp7apDq2kUvfG2Wlps7XGkhT+pqHF
	 GvCRXiN4Aml6+BRygrv4l4hIDgMIMBSlpPBXhLC483fJnaRpFNIB+AqOez0k87cT5Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=39o6zZSG3RgU/xfmW3hU17wczg97zj0VK2EJ8Ma0+kc=;
	b=TpMrG7eIQqe9AB5bZIb622dirlm2K+RRiAlGwiVG+YL0VhFgtu+NT98BEYTKXputyjjW
	 uDFhMfORFMtVyV7gnISA1o51I4sF9Mn7hMJ+cEhPM9AjDoFnjxrMvCNnMTFMY+Gb9n/v4
	 fEykBiRPFbrGCzf3mesKyMBbgxqn8+ZdxEhXvWUpR4cdqok509ZnKLrhOUiYhn29cRCXt
	 cY5ahtCL6W+PSArS/ZHd1+XACYEJtqlCwjEzr+a7hHZCo6E1nLq/U2J4MSTadXHXjFviX
	 tTytEWRpR8nQEvKr+61G7X7DaoQ+EBx1P66lfZ2vCS6lGEZaFFmCNvweVXZipnkOgEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ly7yauKC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D66F606A323;
	Wed, 25 Nov 2026 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ly7yauKC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BC41F000D4;
	Wed, 25 Nov 2026 14:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618634;
	bh=39o6zZSG3RgU/xfmW3hU17wczg97zj0VK2EJ8Ma0+kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ly7yauKC+pkvdwLmJWd0fUz0XaCHit8V+roYfFz+BVszl5jiMk9RzO2y7flX9fR67
	 SjQPqdtrir6Zuc5ig/XduK/D/i9p28XLDlZHpHPfmZPuzyHLreiVNKrJLIR9Svs179
	 36/CiSanPzoiabtI6nDHjR+yNlftCFfD8O38B3d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0340/1005] perf: Move and enhance has_extended_regs() for arch-specific use
Date: Wed, 25 Nov 2026 15:27:58 +0100
Message-ID: <20261125143829.698508006@linuxfoundation.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 05fe8825796e6b5557656c6c984486f0e66154fe ]

Move has_extended_regs() to include/linux/perf_event.h so it can be used
by arch-specific code.

While moving it, enhance the check logic and rename it to
event_has_extended_regs() to match existing perf event helper naming.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260824082731.1013973-9-dapeng1.mi@linux.intel.com
Stable-dep-of: b61c12527223 ("perf/amd/ibs: Fix kernel address leak via REGS_USER and REGS_INTR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/perf_event.h | 10 ++++++++++
 kernel/events/core.c       |  8 +-------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2d5e7687875b0..6df5b4e33dcf4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1518,6 +1518,16 @@ perf_event__output_id_sample(struct perf_event *event,
 extern void
 perf_log_lost_samples(struct perf_event *event, u64 lost);
 
+static inline bool event_has_extended_regs(struct perf_event *event)
+{
+	struct perf_event_attr *attr = &event->attr;
+
+	return ((attr->sample_type & PERF_SAMPLE_REGS_USER) &&
+		(attr->sample_regs_user & PERF_REG_EXTENDED_MASK)) ||
+	       ((attr->sample_type & PERF_SAMPLE_REGS_INTR) &&
+		(attr->sample_regs_intr & PERF_REG_EXTENDED_MASK));
+}
+
 static inline bool event_has_any_exclude_flag(struct perf_event *event)
 {
 	struct perf_event_attr *attr = &event->attr;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7a01f4480881a..c32450e322b98 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -13110,12 +13110,6 @@ int perf_pmu_unregister(struct pmu *pmu)
 }
 EXPORT_SYMBOL_GPL(perf_pmu_unregister);
 
-static inline bool has_extended_regs(struct perf_event *event)
-{
-	return (event->attr.sample_regs_user & PERF_REG_EXTENDED_MASK) ||
-	       (event->attr.sample_regs_intr & PERF_REG_EXTENDED_MASK);
-}
-
 static int perf_try_init_event(struct pmu *pmu, struct perf_event *event)
 {
 	struct perf_event_context *ctx = NULL;
@@ -13150,7 +13144,7 @@ static int perf_try_init_event(struct pmu *pmu, struct perf_event *event)
 		goto err_pmu;
 
 	if (!(pmu->capabilities & PERF_PMU_CAP_EXTENDED_REGS) &&
-	    has_extended_regs(event)) {
+	    event_has_extended_regs(event)) {
 		ret = -EOPNOTSUPP;
 		goto err_destroy;
 	}
-- 
2.53.0



