Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016915;
	b=HGELHkWoP6A0P0R4jgzUNnRYKYHWyNovVmucbpH7LIfQolHYYLAhG5eUWR0+Rlmzot5A
	 IvyTEojUaOUgM7tl64csBf5Ug1rY9F7rH+YvSvc+9res53XfjQrinCd54Nf2N7pjB+mcW
	 MoOCKh+A8F8gdiUXkIYA+I3yH6Lf7tWYKKET4Nh8kSMGVPkMXfVHgRElEPaBv4uZGOa5x
	 ZrFzhJtLuqu8jSWK+7HF6NzrnJRtGSFuBRAQzHLQoxb1Ed8mTbBPV8JH/QRG4+qEVed1K
	 m4LMM5UTp9aPsaQQwdPgfm02zWawf8uTJmiqQkkuNlsct+7NVkTyk8Eo6i72lV5V+KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M2XlEIqOVK5ms+96ZXfiTza4ozOTOAlqtuu/18WU9EU=;
	b=wpNg2smzScV5Mw5enzVXOxrghDFbEK9vpzktAee7/EOkqKbGv9Yb/EpnmjlM6eKm1QAk
	 N0wkTektUj41mQcO0RwwNwULrxhBRD0EiZn7t+8km7soCWC4nkvg27TqExIBA/DMFx+t5
	 wPV/B4TLK+KvKQE9ykLpXtxqH2ME8jMfvzHlzLtqhPktxFw2uSW6k7w+YdjIHFclAAn6w
	 Kn9wbRH48DD4KVFS9NqykgrcpACC2bmLOTyiE2OLbmbk5+dh/ihIAuu1Pzu9vaTkYa3tc
	 j3b9MgkTIweAxXua4QEg9miFF0KWEbv9mnYLSue2X0SyNS9jF1jnz9wf+sgpU2iqCCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kKj/+AvL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BCC606A325;
	Wed, 18 Nov 2026 15:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKj/+AvL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0411F000C4;
	Wed, 18 Nov 2026 15:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016915;
	bh=M2XlEIqOVK5ms+96ZXfiTza4ozOTOAlqtuu/18WU9EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKj/+AvL4Pm9HZq/PpXDo89XU+zwIoz22Vb198Uj9TWRY0aL/76En2l6m18UQJgWg
	 hbee6uRnoJeJSB+zhlVXYOLLTc1fs3/6aKSJ37l0MjA3j3wibDGwy8fHmKKhxL0C7L
	 tz12Lck3BvvrEOfAv8bCiDVKvcbxXFS1GH7rfnWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0647/2651] perf annotate-data: Show the sample count in the data-type browser
Date: Wed, 18 Nov 2026 15:31:27 +0100
Message-ID: <20261118150310.973573771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 9db4e9d6cc7c7d318fb6d6bb73abe3fed27385a8 ]

The data-type browser has a samples view, selected with -n (or with
annotate.show_nr_samples), in which browser__write_overhead() prints a
local nr_samples variable that is initialized to zero and never
updated, so every member is listed as having no samples while the
period and percent columns for the same entry are filled in.

Print the histogram entry's own count instead.

This predates the load/store counter split, so fix it ahead of that
patch: the split then only has to adapt a line that is already correct,
and this fix can be picked on its own.

Fixes: d001c7a7f4736743 ("perf annotate-data: Add hist_entry__annotate_data_tui()")
Acked-by: Namhyung Kim <namhyung@kernel.org>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/browsers/annotate-data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/annotate-data.c b/tools/perf/ui/browsers/annotate-data.c
index aa8c89fe2e82c..1080ed1a40d26 100644
--- a/tools/perf/ui/browsers/annotate-data.c
+++ b/tools/perf/ui/browsers/annotate-data.c
@@ -370,7 +370,7 @@ static void browser__write_overhead(struct ui_browser *uib,
 	u64 period = hist->period;
 	double percent = total->period ? (100.0 * period / total->period) : 0;
 	bool current = ui_browser__is_current_entry(uib, row);
-	int nr_samples = 0;
+	int nr_samples = hist->nr_samples;
 
 	ui_browser__set_percent_color(uib, percent, current);
 
-- 
2.53.0



