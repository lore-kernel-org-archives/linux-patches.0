Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024049;
	b=WRmE/3En89FxUj5qAssocofxpjslHgUETleAtnhx57lbkgqJB0Io7pfbpbq1s36MlVeN
	 l7m5BNTVahKdSyrYomIQUvioVn+JZCUn5kISd69uaPv+uMzyJLARwZVr0+tabkPJAR3+i
	 UoiFb2IrGsVjaKUv74fB+7zTqmFlP8TJuBKYyR0owLDQASf+FCb9wKjIeEkKLte+OoyQi
	 rQXsWpBAPO+FLNIsnQJUV3Xx+Sr1sVwsI79VGTuw7DxuumJo6ki5PHqViHTj51YiETEsN
	 xT8TvvUbRVFt0AHKVyPBCi2DdLur18IfB2jLBMfSRJ8EhZTKfDBP5GWQzaHKGvvXpog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dxWcAbQdkzpQAr9LNlamh56RNWTVKsam6/f4yYh64S4=;
	b=wjJrDYaZGACIAP2yFcng+vz+MX0LEjjHXBB0DfYK1NtjpqsbSlhVQ+hguAHzmw4+LD3Q
	 r62jL/dNMV/dNYzQelQtxB5Gf2HA/2AKx5xEeCWYe+KPdcShtW0VEz/n7l5Tpq8DBnilZ
	 DLuujugAfrPZsYr4SXPIsQCtpvSrqrjsbW5GGjUtj17NNPCm9b69B4Fy5pjphF8qvYLgT
	 cpxmTGoEttul2/6+QWSYcwDyQWUdW7N4EmuGN5MKhksaMIjn+5VlhB3E7cVLiXuE8mXYj
	 FYot4dyJZ9ExM5ULg3O1Hj9z75MAFNhu/FhaJZ8RBx5yTN7yAPZweriAbagqUslruIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PSORYS9t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874D8606A320;
	Wed, 18 Nov 2026 17:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PSORYS9t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F1A1F000C4;
	Wed, 18 Nov 2026 17:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024049;
	bh=dxWcAbQdkzpQAr9LNlamh56RNWTVKsam6/f4yYh64S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSORYS9tw9J8AG1lFt+rcWzttUt1+ZeHIakH9EYT69qHxdBfj46hCGPABuO5m+Ib5
	 xWX6ciH3k+1ubQ/P1pgTqIFVWemx2Dg1Fsc2Iwr3U0mzqaouCs8p0wWtXjx6XmNPO9
	 riHlaUDEfsM80U2tKEqopZF4of4mYoMW65GKSFlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0587/2151] perf annotate-data: Show the sample count in the data-type browser
Date: Wed, 18 Nov 2026 15:38:42 +0100
Message-ID: <20261118150143.337749153@linuxfoundation.org>
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



