Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BCA341678
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 09:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768296939; cv=none; b=MZCgCexTd5deBPlQ/ZCZq2k7QNY3TttYiK+d9PXvSJnZbaFGrBqAQHpxQjTQC0yfHChWAFtbG0YkHO+7o8LX1iO36MLrxHI7YS0XFkOnFzgY8DzhBebBLEpBO1hnMfwWlrMXPkVoCaVu0JXOCmcdf9wYtk4rf6CqeNmBiq6VT5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768296939; c=relaxed/simple;
	bh=FYrx96BAkfwPj+u0lqamDa7OXD7a8yQyXiZ4AXFSL6w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=rLgEqEY3MhNEjLGVK9mRI5d7I1E4aJ+iJNoN/BykQrFOOROtfyDAW9V3rJ7N9zLehb6MZXQyXccjtkeidyPoR480skVFhDutr6iR0i+wZpLJT3Il2RnOVKrSRsoal8XKZn2TPQ2VOPq2lv9fDf01y10W6Tp7ZAGq7/LQ/do1urw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PCz0zZKV; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PCz0zZKV"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260113093536epoutp024b12974fd7e2bf7e515688d7c50ae8b2~KQLHLBUwo1750017500epoutp02J
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 09:35:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260113093536epoutp024b12974fd7e2bf7e515688d7c50ae8b2~KQLHLBUwo1750017500epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768296936;
	bh=JzZ+FcVdPCoQf3WFB34xD6BSGkKSDLkx/PgezjfVtLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCz0zZKVnGROx66VEDqP6L1DQP9ad68jNLehPIHfojbhtfgOUug2zTjfJkB8gpTDd
	 HyO0awOEqI5YTzRz19Hjzk78vZ4ACh03dgu5Te+b/7bfpNQ0b1h7SBtvw2gy3EMt2l
	 kpMY9VMhM4P+2/ycNvQ5SGhFkj9ANwekAEdNjhU4=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260113093535epcas5p43a5990003425d43566350aa99cc74dcf~KQLG1vhrk3080830808epcas5p4B;
	Tue, 13 Jan 2026 09:35:35 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.94]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dr3yG6p0cz6B9m8; Tue, 13 Jan
	2026 09:35:34 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260113093534epcas5p43c9e5f2618cfd0e983ae3ac9f9596b38~KQLFfTFFW2850428504epcas5p4H;
	Tue, 13 Jan 2026 09:35:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260113093532epsmtip22c1d9da93cc921ef5d0e7bc60b2fd418~KQLEFxGnm2852828528epsmtip21;
	Tue, 13 Jan 2026 09:35:32 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: anuj20.g@samsung.com
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>
Subject: [PATCH 1/6] iomap: add write ops hook to attach metadata to folios
Date: Tue, 13 Jan 2026 15:00:45 +0530
Message-Id: <20260113093050.31705-2-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260113093050.31705-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260113093534epcas5p43c9e5f2618cfd0e983ae3ac9f9596b38
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260113093534epcas5p43c9e5f2618cfd0e983ae3ac9f9596b38
References: <20260113093050.31705-1-kundan.kumar@samsung.com>
	<CGME20260113093534epcas5p43c9e5f2618cfd0e983ae3ac9f9596b38@epcas5p4.samsung.com>

Add an optional iomap_attach_folio callback to struct iomap_write_ops.
Filesystems may use this hook to tag folios during write-begin without
changing iomap core behavior.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/iomap/buffered-io.c | 3 +++
 include/linux/iomap.h  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index fd827398afd2..24f6cd119aec 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -696,6 +696,9 @@ static int __iomap_write_begin(const struct iomap_iter *iter,
 	size_t from = offset_in_folio(folio, pos), to = from + len;
 	size_t poff, plen;
 
+	if (write_ops && write_ops->iomap_attach_folio)
+		write_ops->iomap_attach_folio(&iter->iomap, folio, pos, len);
+
 	/*
 	 * If the write or zeroing completely overlaps the current folio, then
 	 * entire folio will be dirtied so there is no need for
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 73dceabc21c8..0f5351fbed63 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -176,6 +176,9 @@ struct iomap_write_ops {
 	 */
 	int (*read_folio_range)(const struct iomap_iter *iter,
 			struct folio *folio, loff_t pos, size_t len);
+
+	int (*iomap_attach_folio)(const struct iomap *iomap,
+			struct folio *folio,  loff_t pos, size_t len);
 };
 
 /*
-- 
2.25.1

