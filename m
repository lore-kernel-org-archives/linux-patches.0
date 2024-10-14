Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ABA4A24;
	Mon, 14 Oct 2024 14:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916785; cv=none; b=pjnskMo7At0ETwIpbuMbQzPJKotyhuZeaI7AYfj5vOsTjlBJ10D5LaULpm2NQHjs/igBu/OdRNF/4EA4/yhjjjTcPfp7V4QYDjIRQfW1IEYujVJltVy1wwAKbsDQOjVzCbdTA/pXnJSu5w9Di7hJ55HruuD9LMAsOsQ2VaavzsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916785; c=relaxed/simple;
	bh=GQYWWEr1Fs51+EpSxe6Fso+7dKz2Hca+NsB1oShX2Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lq9T/0DcZOBWzDsgbb+uCHPqpa+mDi3Igpz2ITrYpRUu5+Qej9f4Ya7+Y86NOj3GnueYmpsd8GjvDJF3IUNtHxpuURlALpvKzP6XDRXl2EzOV0yjoISeBTscrzLLqNqrs5Rl51zu1n3E9j0NubvE5nv4IrJmJhuIyxSEf+zsAds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdia2h3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdia2h3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE4DC4CEC3;
	Mon, 14 Oct 2024 14:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916784;
	bh=GQYWWEr1Fs51+EpSxe6Fso+7dKz2Hca+NsB1oShX2Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdia2h3oM+akJQoFVBaEFQfLSUkoyZ1nFDQi/SxVic9PV4ySpBx94fdSFZxWBB5mE
	 BNbIZ8NGHhjClQNT8vrhqyQKgpCgKcmeYRS4AxtpWwZw4yimBc3Y1zRnMOmf1JnxFD
	 GOsYZGZ4b3jAEXi388tHxvxmXnOAmqgin7GnTEN8=
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
Subject: [PATCH 6.6 064/213] s390/cpum_sf: Remove WARN_ON_ONCE statements
Date: Mon, 14 Oct 2024 16:19:30 +0200
Message-ID: <20241014141045.484677291@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 06efad5b4f931..a3169193775f7 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1463,7 +1463,7 @@ static int aux_output_begin(struct perf_output_handle *handle,
 	unsigned long range, i, range_scan, idx, head, base, offset;
 	struct hws_trailer_entry *te;
 
-	if (WARN_ON_ONCE(handle->head & ~PAGE_MASK))
+	if (handle->head & ~PAGE_MASK)
 		return -EINVAL;
 
 	aux->head = handle->head >> PAGE_SHIFT;
@@ -1642,7 +1642,7 @@ static void hw_collect_aux(struct cpu_hw_sf *cpuhw)
 	unsigned long num_sdb;
 
 	aux = perf_get_aux(handle);
-	if (WARN_ON_ONCE(!aux))
+	if (!aux)
 		return;
 
 	/* Inform user space new data arrived */
@@ -1661,7 +1661,7 @@ static void hw_collect_aux(struct cpu_hw_sf *cpuhw)
 				num_sdb);
 			break;
 		}
-		if (WARN_ON_ONCE(!aux))
+		if (!aux)
 			return;
 
 		/* Update head and alert_mark to new position */
@@ -1896,12 +1896,8 @@ static void cpumsf_pmu_start(struct perf_event *event, int flags)
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



