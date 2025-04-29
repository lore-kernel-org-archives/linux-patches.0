Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F19248878;
	Tue, 29 Apr 2025 16:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945616; cv=none; b=ncPDDlf5RMNY+Lf9Xi3JRLpefWL21ThIDyatijR8i/r71iB2gnnSPqnJyXrq+V0eFx9UJNDbH/LlQvZq7zj/t5QBuSvpDCGxz/Ua1IQBR/xh58dQTpYhWl8KwKpWyShgaGvKHOYzidyeNVyUEETvjohq/8xoUJ+2NcugjsKCRgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945616; c=relaxed/simple;
	bh=pXLfMNw9TwSBmF+FikWqUATitGy13XDUzr+hRQjl8I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiMMUOEcF+hE35PAkSmx6t9iYoo13NN3zYcCrBQ2vtDTJ3W7ykHD4eDQqMrchQs07j7I+Sy++3do5q0Hiy+chrvIQALPqpVEf9PA7ca0t8LXTB0fpfYGCB70fSRIZQ/EmGydHl5JTJNIEYiBOFkL32DAQHUz2frspxmDj6aEmrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wiqSL7XI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wiqSL7XI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACA1C4CEE3;
	Tue, 29 Apr 2025 16:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945616;
	bh=pXLfMNw9TwSBmF+FikWqUATitGy13XDUzr+hRQjl8I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wiqSL7XIAyAqoEwZ08RLXg8dnZDJGYo/YXCmidK3NzbsE+OHQlneDzpqFM9gXFkSL
	 iUCC6nBh0sLrTN4Da7gzJNxmytjoZPCsEuLleX0Ej39gsew/jZw1LgMKLKKkDrLaHB
	 A4Lsa4xmJYLiwg0zdL6doPJwjfAAFIUYulRNxPz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Marc Eurin <jmeurin@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 172/179] ACPI PPTT: Fix coding mistakes in a couple of sizeof() calls
Date: Tue, 29 Apr 2025 18:41:53 +0200
Message-ID: <20250429161056.355340331@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f31544d3656e3..c1c7727ab9324 100644
--- a/drivers/acpi/pptt.c
+++ b/drivers/acpi/pptt.c
@@ -216,7 +216,7 @@ static int acpi_pptt_leaf_node(struct acpi_table_header *table_hdr,
 	node_entry = ACPI_PTR_DIFF(node, table_hdr);
 	entry = ACPI_ADD_PTR(struct acpi_subtable_header, table_hdr,
 			     sizeof(struct acpi_table_pptt));
-	proc_sz = sizeof(struct acpi_pptt_processor *);
+	proc_sz = sizeof(struct acpi_pptt_processor);
 
 	while ((unsigned long)entry + proc_sz < table_end) {
 		cpu_node = (struct acpi_pptt_processor *)entry;
@@ -257,7 +257,7 @@ static struct acpi_pptt_processor *acpi_find_processor_node(struct acpi_table_he
 	table_end = (unsigned long)table_hdr + table_hdr->length;
 	entry = ACPI_ADD_PTR(struct acpi_subtable_header, table_hdr,
 			     sizeof(struct acpi_table_pptt));
-	proc_sz = sizeof(struct acpi_pptt_processor *);
+	proc_sz = sizeof(struct acpi_pptt_processor);
 
 	/* find the processor structure associated with this cpuid */
 	while ((unsigned long)entry + proc_sz < table_end) {
-- 
2.39.5



