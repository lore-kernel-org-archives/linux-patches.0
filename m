Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024747;
	b=EarjpLRpxImivDrE62Yzw/L7679AhW/bzNF6979G6bWEL/5yLqKM0rZK7cYsQcV+vLaz
	 R07xeJx5ouxuo8jItvR9g3hFZXpwYXuHBiJdUEv9nuMU/hbQUtTzLr1PQJteEYu/K9BkQ
	 qZOlv3bLkbUYJXW7AgEwLG+IZOhkqOugbpf/SkjK3FQ4Aa56+mrOIKNETzth1NePmJel1
	 bNqFcwFI3Sn6po9Km7qXkFPZW4M5OmZZ8ywHr66gf9eBuSHJRAAjAEkFkjHLEtSOHKJ3W
	 fkrnTNdlXua73rs+Fpl4200VclyJN6nsyWd5Du4yCHWWxjeF4mlC6p7Vl74VcrI6rPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hz3jC+ImZIQvKc4Jhl/35LZJYiCzlHYtb2jbe5oP5/s=;
	b=nnTpbdLU/hCqm41R2svOrXa2Ma7g6cLKpwWP5aOklBZ9MO0SF383O8y1Y4EbsKeV/Sxw
	 7no5GABNgNd0WxvR4kFqHhDBO6JFYmZc9H7w1h5b11PPjynacsV9yXPxpNBW1OEkQXo3W
	 0XvA+r9EO39XIT1iaVHrZR+NxrtCo0wApNWRdPHNRrCvxyFgCu6lsKrz2bh3p3AsSoj3O
	 9jL/lKqW8Ttisel2jz3ku7alt/RU7iualUWPsisjj7yue2yj1SC+AMMqsg//sldyBs7Py
	 /BD+5jqqeCFRf4Htbk0K3msxLFKP4NWQ4CSQRe31vun+a5S7i9EvwR2uVCnUew/QpQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9NsOThu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C2C606A336;
	Wed, 18 Nov 2026 17:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9NsOThu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7114D1F000C4;
	Wed, 18 Nov 2026 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024747;
	bh=Hz3jC+ImZIQvKc4Jhl/35LZJYiCzlHYtb2jbe5oP5/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9NsOThuLEdKPzKCo4mUfQkYo98WIXWzY5bAlMexs3BuxIBAZfux3WRXSCO/V1kDZ
	 hm74lEgxb3T66gLXoponHtjY0ssTWkVPjCh2JRQ0bwNHPRJlLpijt3RrfRFoFMutbf
	 rOkzVHMaVsgcP61Uk+4BIEyaE7hVr90jWw7SV3hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0836/2151] perf vendor events intel: Fix skylakex umask encoding.
Date: Wed, 18 Nov 2026 15:42:51 +0100
Message-ID: <20261118150152.658856293@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit f37e7dfbd34c4e48d2bea4c5e0e64c398671e87b ]

Fix UMaskExt that was wrongly encoded when the UMask was 0.

Fixes: 748d5cf71948 ("perf vendor events intel: Fix uncore topics for skylakex")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pmu-events/arch/x86/skylakex/uncore-interconnect.json   | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/pmu-events/arch/x86/skylakex/uncore-interconnect.json b/tools/perf/pmu-events/arch/x86/skylakex/uncore-interconnect.json
index eef801c68bd25..08311bdb2b203 100644
--- a/tools/perf/pmu-events/arch/x86/skylakex/uncore-interconnect.json
+++ b/tools/perf/pmu-events/arch/x86/skylakex/uncore-interconnect.json
@@ -13462,6 +13462,7 @@
         "EventName": "UNC_UPI_TxL_HDR_MATCH.DATA_HDR",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x800",
         "Unit": "UPI"
     },
     {
@@ -13472,6 +13473,7 @@
         "EventName": "UNC_UPI_TxL_HDR_MATCH.DUAL_SLOT_HDR",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x2000",
         "Unit": "UPI"
     },
     {
@@ -13482,6 +13484,7 @@
         "EventName": "UNC_UPI_TxL_HDR_MATCH.LOC",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x200",
         "Unit": "UPI"
     },
     {
@@ -13514,6 +13517,7 @@
         "EventName": "UNC_UPI_TxL_HDR_MATCH.NON_DATA_HDR",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x1000",
         "Unit": "UPI"
     },
     {
@@ -13524,6 +13528,7 @@
         "EventName": "UNC_UPI_TxL_HDR_MATCH.REM",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x400",
         "Unit": "UPI"
     },
     {
@@ -13567,6 +13572,7 @@
         "EventName": "UNC_UPI_TxL_HDR_MATCH.SGL_SLOT_HDR",
         "Experimental": "1",
         "PerPkg": "1",
+        "UMask": "0x4000",
         "Unit": "UPI"
     },
     {
-- 
2.53.0



