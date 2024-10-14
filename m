Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFB51AC8A2;
	Mon, 14 Oct 2024 15:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919740; cv=none; b=FMYSiHfihWJeMb5RKuGdb6Bk8xfx2OF39Q1/eZ4/VQwzvdWgujRKgJmIzGOSzCtKkfn7LQ5h4KKZYdFvDQJmmWU9bcf/Rde1F9hiihk1D5vRb8KP6BxiG99SE2qzfldIHRQkeRBafTZs4DlYR97o8ja2Sklw7aPMz7oI+dK8qq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919740; c=relaxed/simple;
	bh=aPLHCZthyP4cO1mNxD3iKABJPBwpHmQBqt5AYv7dxi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmNJ/fiRQmzPHUO/xb47koh7tdwuDYJBVomx34am5UPakC6D3TjBJA3VQKsBl7nvNwCAOmt6b/eUMej9H7b7qcDMMpAo+09OZnxp5XxmA5Kxp7o8HeD9NxpFWJF/W5SdXXTbsOSOVLpE3ry/SL8n8DhHqsJLgv5WELD1EM9c0kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VM5jjoWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VM5jjoWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3F6C4CEC7;
	Mon, 14 Oct 2024 15:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919740;
	bh=aPLHCZthyP4cO1mNxD3iKABJPBwpHmQBqt5AYv7dxi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VM5jjoWjuy8z0vhj5FIxD6FQheDPZSa4CF1VZfQbwqyE5uvW4yj7xWwWP3dz3DYH3
	 5CYiIpWp0hPwx/kY/WX8+z+mDD4qsc3Eup8F6UlCkxYRLLFcm7dM2rUJvHwUDDO0t2
	 F0hSfNx9SEHUh9muGVIfsF3LfkeGGbGbM/uVvi5A=
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
Subject: [PATCH 6.1 693/798] s390/cpum_sf: Remove WARN_ON_ONCE statements
Date: Mon, 14 Oct 2024 16:20:47 +0200
Message-ID: <20241014141245.295520791@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ce886a03545ae..f3b0a106f7227 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1432,7 +1432,7 @@ static int aux_output_begin(struct perf_output_handle *handle,
 	unsigned long head, base, offset;
 	struct hws_trailer_entry *te;
 
-	if (WARN_ON_ONCE(handle->head & ~PAGE_MASK))
+	if (handle->head & ~PAGE_MASK)
 		return -EINVAL;
 
 	aux->head = handle->head >> PAGE_SHIFT;
@@ -1613,7 +1613,7 @@ static void hw_collect_aux(struct cpu_hw_sf *cpuhw)
 	unsigned long num_sdb;
 
 	aux = perf_get_aux(handle);
-	if (WARN_ON_ONCE(!aux))
+	if (!aux)
 		return;
 
 	/* Inform user space new data arrived */
@@ -1635,7 +1635,7 @@ static void hw_collect_aux(struct cpu_hw_sf *cpuhw)
 					    __func__);
 			break;
 		}
-		if (WARN_ON_ONCE(!aux))
+		if (!aux)
 			return;
 
 		/* Update head and alert_mark to new position */
@@ -1870,12 +1870,8 @@ static void cpumsf_pmu_start(struct perf_event *event, int flags)
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



