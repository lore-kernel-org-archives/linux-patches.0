Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793305591;
	b=zmIfOJGvTZXX0PkeIWGlHJBRD3oLtiMlVTCfbG+r2VgFWnrfvKUllvhBTCo0KkwfvBPN
	 4K5bVPA1lEklnYPZjAb39SxrtGevNGzIszdzBvCFP+I/pfO1LLKiD1sGupcgYmgzvxsOT
	 1f3Ycr2tK+EqFYE0xkFqhw67LGhXky/RWz92jefXUQGvaNeIlegtghcbFEVbE0Z2qnM9d
	 uK9GbkzRyoWFHvPkGliSc6eLdYoaZx431teGhXUFPqFbfLHFgIi+7jO1LIfjt+XO7/fy2
	 QeqP/zj1NX98CXOp+XbZtTXeBibW+F5cxJv4tWTrTZBuJtrP09oUg/uxDTkVUX67j/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793305591;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aEfbkM7G3/fLiHwfdz9aDuJ089LeDutDgsdfd1xWO7g=;
	b=wXyzDC2boMGXVVifDGjKzpbDDuKWHuOhHoe1BRJmyTo7nxMpnQE7zW+9o5p5YpI8ZK/F
	 4ehgplCAP1GmvY86aEccn9+LdbrlrE7ugG4DDSgCkXdqVzeKxkDu+1K2/5P3dEK0H8ZfV
	 dN6LIRRnNmPefLD7PG7Cod7U/tXSXhj4DpKiWwIHSjA8+Sg7zFdrlfSoLctNEnYsCi88h
	 A/pzqSGZIJ1/oJBDBT2glLjMCRdkNn62geVYaWcN3fKSYQ0WdWVvx+J4Y5n+LyXYFhMEU
	 HNMfErK100UDyYXE4cF7CqQT5Bg37OzVHgoxDBPNfYHrvXZHgL9CkNUZwY7YVE9Cncg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=WIjwpIOg;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BBA606A31D;
	Thu, 29 Oct 2026 20:26:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2BBA606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=WIjwpIOg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aEfbkM7G3/fLiHwfdz9aDuJ089LeDutDgsdfd1xWO7g=; b=WIjwpIOgHHQoDO2a6WJtD8oDlf
	TalY5HSurO7RGslf4Bs6VhLYZwcJzcrL0SaamDoVOSky1+o1YbwhJIIgNTAz5rIi8DKMU4v4xZbIH
	TN4UF5ra/KbCJRqqEH+sdvBxQ/K0wmp6OqLBvv4zn0z8EN2CIt0X4EIo1UAev/uBqxZbSnd+ipMnz
	f8SnTgVi70Rn3xw+hXJtPUzVKCzXzCKk29cJOCABMqdkL05oVPBQuyU/O4q728C72ffQzYnX4DYOq
	XfsFj8fYtsBYIKWC06OyJ4RHoQadFBDKOHV/a+2x5ZaGvG+J+yXfdFqOj1QkRtsBPXgls/hBnDgnD
	AnUmktVQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMWhi-0000000AJot-1RiK;
	Thu, 29 Oct 2026 20:26:30 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Guo Ren <guoren@kernel.org>,
	linux-csky@vger.kernel.org
Subject: [PATCH 2/4] csky: perf_event: add missing prototypes
Date: Thu, 29 Oct 2026 13:26:22 -0700
Message-ID: <20261029202624.2685097-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029202624.2685097-1-rdunlap@infradead.org>
References: <20261029202624.2685097-1-rdunlap@infradead.org>
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

Add missing perf_event prototypes to prevent build warnings:

arch/csky/kernel/perf_event.c:90:10: warning: no previous prototype for 'csky_pmu_read_cc' [-Wmissing-prototypes]
   90 | uint64_t csky_pmu_read_cc(void)
arch/csky/kernel/perf_event.c:878:6: warning: no previous prototype for 'csky_pmu_event_set_period' [-Wmissing-prototypes]
  878 | int  csky_pmu_event_set_period(struct perf_event *event)
arch/csky/kernel/perf_event.c:1197:5: warning: no previous prototype for 'init_hw_perf_events' [-Wmissing-prototypes]
 1197 | int init_hw_perf_events(void)
arch/csky/kernel/perf_event.c:1292:5: warning: no previous prototype for 'csky_pmu_device_probe' [-Wmissing-prototypes]
 1292 | int csky_pmu_device_probe(struct platform_device *pdev,

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Guo Ren <guoren@kernel.org>
Cc: linux-csky@vger.kernel.org

 arch/csky/include/asm/perf_event.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- linext-2026-1007.orig/arch/csky/include/asm/perf_event.h
+++ linext-2026-1007/arch/csky/include/asm/perf_event.h
@@ -11,4 +11,14 @@
 	asm volatile("mov %0, sp\n":"=r"((regs)->usp)); \
 }
 
+struct perf_event;
+struct platform_device;
+struct of_device_id;
+
+uint64_t csky_pmu_read_cc(void);
+int csky_pmu_event_set_period(struct perf_event *event);
+int init_hw_perf_events(void);
+int csky_pmu_device_probe(struct platform_device *pdev,
+			  const struct of_device_id *of_table);
+
 #endif /* __ASM_PERF_EVENT_ELF_H */
