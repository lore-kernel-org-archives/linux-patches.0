Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9968320C488;
	Tue, 29 Apr 2025 18:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950111; cv=none; b=Vk3wRo7GtQPOr8wPkdBWM9MdTsSAIphWvpbxP1YJbM+ae5RkAKKujbLNUx8e80joYPRvI5Dbyp51/PgaPRrCCor0Ycq7AQ3VjiaznKJAPu2T03mAsTa7qHVIj8rBYyFq3Xq/ZogNzdCJbaveGUicRxnxB1yHIjCUh8dsjlZgfrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950111; c=relaxed/simple;
	bh=Q9yQ91nL2BHYGSEZskYqtb2MoU9oRKbhO/7GdEeUQrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZ2JP0HylOWslhdOwLx64eKh53W/YV27FE+n0oErUi3aiQ6qrl4xajd6jTdzd4zKI6H18G7YLBMrYLnIJmZGhf6r82WssykSmHAAtBnjanyjj/2KBEoaRmdqa0p0SjWrvLFefQFyTCYfXdjcLRy26ZMdQ2GvBqVzWYcPLaG5msA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Gc5in8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Gc5in8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D12C4CEE3;
	Tue, 29 Apr 2025 18:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950111;
	bh=Q9yQ91nL2BHYGSEZskYqtb2MoU9oRKbhO/7GdEeUQrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Gc5in8+i1Ogll9gfYa2ejQA3FAzN9hMw0EAtu7HOE2ySeD8cGaR/TWAau/xAy8Mb
	 1AKfqxT9MgChtxLR/f7t2qKu8hO62ikEly+whnHZoJfvCKOSw6Ippm6AVdvTFIXTkI
	 J3Y7wOkQL1m5Lc1zW57YE+/4Vmd2NlO4GI0OPxS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Marc Eurin <jmeurin@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/167] ACPI PPTT: Fix coding mistakes in a couple of sizeof() calls
Date: Tue, 29 Apr 2025 18:43:58 +0200
Message-ID: <20250429161056.997449193@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jean-Marc Eurin <jmeurin@google.com>

[ Upstream commit 7ab4f0e37a0f4207e742a8de69be03984db6ebf0 ]

The end of table checks should be done with the structure size,
but 2 of the 3 similar calls use the pointer size.

Signed-off-by: Jean-Marc Eurin <jmeurin@google.com>
Link: https://patch.msgid.link/20250402001542.2600671-1-jmeurin@google.com
[ rjw: Subject edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pptt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/pptt.c b/drivers/acpi/pptt.c
index ced3eb15bd8b7..79a83d8236cb3 100644
--- a/drivers/acpi/pptt.c
+++ b/drivers/acpi/pptt.c
@@ -217,7 +217,7 @@ static int acpi_pptt_leaf_node(struct acpi_table_header *table_hdr,
 	node_entry = ACPI_PTR_DIFF(node, table_hdr);
 	entry = ACPI_ADD_PTR(struct acpi_subtable_header, table_hdr,
 			     sizeof(struct acpi_table_pptt));
-	proc_sz = sizeof(struct acpi_pptt_processor *);
+	proc_sz = sizeof(struct acpi_pptt_processor);
 
 	while ((unsigned long)entry + proc_sz < table_end) {
 		cpu_node = (struct acpi_pptt_processor *)entry;
@@ -258,7 +258,7 @@ static struct acpi_pptt_processor *acpi_find_processor_node(struct acpi_table_he
 	table_end = (unsigned long)table_hdr + table_hdr->length;
 	entry = ACPI_ADD_PTR(struct acpi_subtable_header, table_hdr,
 			     sizeof(struct acpi_table_pptt));
-	proc_sz = sizeof(struct acpi_pptt_processor *);
+	proc_sz = sizeof(struct acpi_pptt_processor);
 
 	/* find the processor structure associated with this cpuid */
 	while ((unsigned long)entry + proc_sz < table_end) {
-- 
2.39.5



