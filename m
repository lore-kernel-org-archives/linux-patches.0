Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837EB1DFD8C;
	Wed,  6 Nov 2024 12:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895502; cv=none; b=abCLp/hu207C+F+DLxP4X1v4Nc6/7d7Yqt+odbOGrTWVEWlaP8taBgGC2g9Xl+FyB9NvRaeOdqZfuB4PkoBWMVTg3F6i20uKPMS5VYf/xzlDcw6WQGj2U1r9J+TskB+Pt8wh+s6RcQEXeIo3450ZNp5TyO8P9FnadsC0PtyzRF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895502; c=relaxed/simple;
	bh=ykagLwHJ/1mabuCUqAaRemqjl6u9kR5lnuVj0N9FPt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bl7eEvNzGAqAZuArvxzDNqA6Q0n5jCgNsniNFoxPcetminZFtFrXuIjE65eyUj1/9lFYtR7ZgZh9Ki+u68Mwg9zNldEFaJ+4D3Ay34HfCnMYTAkYjzwhV4nLkTE9N/M1aj25780vhWj+DQqZcWmJeO+udxzFPYAnsnLSHxa5f0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3J2udE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3J2udE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076BDC4CED9;
	Wed,  6 Nov 2024 12:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895502;
	bh=ykagLwHJ/1mabuCUqAaRemqjl6u9kR5lnuVj0N9FPt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3J2udE6HpTK8loI2zVywhM6VWjauKrAYbVLzO5Ra0d1r9Rsqed2t+bja/uW22/0X
	 o91vmffu3jqfH8ceniUkRrEhoG9nNvt8lAy9MNrXOAWBNV8c78sKyIvP4VJgiRkb9l
	 sQHLXoaUWDp+LLy+Bnq890hiYSBCCTSp0Wpd55PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 238/350] s390/cpum_sf: Remove WARN_ON_ONCE statements
Date: Wed,  6 Nov 2024 13:02:46 +0100
Message-ID: <20241106120326.832464591@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit b495e710157606889f2d8bdc62aebf2aa02f67a7 ]

Remove WARN_ON_ONCE statements. These have not triggered in the
past.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_sf.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index c8e1e325215b8..c7f94b5d93968 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1360,7 +1360,7 @@ static int aux_output_begin(struct perf_output_handle *handle,
 	unsigned long head, base, offset;
 	struct hws_trailer_entry *te;
 
-	if (WARN_ON_ONCE(handle->head & ~PAGE_MASK))
+	if (handle->head & ~PAGE_MASK)
 		return -EINVAL;
 
 	aux->head = handle->head >> PAGE_SHIFT;
@@ -1528,7 +1528,7 @@ static void hw_collect_aux(struct cpu_hw_sf *cpuhw)
 	unsigned long num_sdb;
 
 	aux = perf_get_aux(handle);
-	if (WARN_ON_ONCE(!aux))
+	if (!aux)
 		return;
 
 	/* Inform user space new data arrived */
@@ -1547,7 +1547,7 @@ static void hw_collect_aux(struct cpu_hw_sf *cpuhw)
 			debug_sprintf_event(sfdbg, 1, "AUX buffer used up\n");
 			break;
 		}
-		if (WARN_ON_ONCE(!aux))
+		if (!aux)
 			return;
 
 		/* Update head and alert_mark to new position */
@@ -1746,12 +1746,8 @@ static void cpumsf_pmu_start(struct perf_event *event, int flags)
 {
 	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 
-	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
+	if (!(event->hw.state & PERF_HES_STOPPED))
 		return;
-
-	if (flags & PERF_EF_RELOAD)
-		WARN_ON_ONCE(!(event->hw.state & PERF_HES_UPTODATE));
-
 	perf_pmu_disable(event->pmu);
 	event->hw.state = 0;
 	cpuhw->lsctl.cs = 1;
-- 
2.43.0



