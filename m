Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809D1146D40;
	Mon,  6 Jan 2025 15:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177104; cv=none; b=DPcdNl9rMN27nCJ6mQvt/GGlkhguafJy4o9/0QTiwHb2Q/5gHoq2cGuEiJkzv8cSpr0brmZuiGzyC5YCvfFK+ymSz6a8yZIix5MSZrLmKaeoCqr1FHRz/9mXMvZWVup9xLSY8TCKi9CmSLmSSYuO5KHbMnUCIRBHWBEb42AoINA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177104; c=relaxed/simple;
	bh=udD90DUoH21PDE3a1tOUNjceshm0YbpVokgZKbBucEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RM+vgUfBWmfS28sBAXa+HBsiSqIw5w+Fl6TLSqIuuwn3oaCLcHELXXTRWMgzItcVYksvTwdZMyof2gFjKKncKRMWmExnUFMkmbQVgoV003vXCabUHaVApn+txI3rCuPLlE+HK7mmTJsb+MddhkBN8hlyi2+dAfhsgYfg505j/nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/0UGMn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/0UGMn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E5FC4CEDF;
	Mon,  6 Jan 2025 15:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177104;
	bh=udD90DUoH21PDE3a1tOUNjceshm0YbpVokgZKbBucEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/0UGMn6r1oUKriU/wp5UZ4txiqqy3nQ3xkx91oWbhlP+h5JTNeyiKXcGiJwFGQ46
	 BzcDrp4AnR921h4VlLJQSbtd02MT2Rp6i5puT5czwoWVka2W4oZJzzcWbaIEgD/sth
	 1KyesMvnh3R8F4whx7+dNyBjDeYFR5tvPX1O8JP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/222] ACPI: PCC: Add PCC shared memory region command and status bitfields
Date: Mon,  6 Jan 2025 16:14:15 +0100
Message-ID: <20250106151152.537012382@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 55d235ebb684b993b3247740c1c8e273f8af4a54 ]

Define the common macros to use when referring to various bitfields in
the PCC generic communications channel command and status fields.

Currently different drivers that need to use these bitfields have defined
these locally. This common macro is intended to consolidate and replace
those.

Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20230927-pcc_defines-v2-1-0b8ffeaef2e5@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 7f9e19f207be ("mailbox: pcc: Check before sending MCTP PCC response ACK")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/pcc.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/acpi/pcc.h b/include/acpi/pcc.h
index 73e806fe7ce7..9b373d172a77 100644
--- a/include/acpi/pcc.h
+++ b/include/acpi/pcc.h
@@ -18,7 +18,20 @@ struct pcc_mbox_chan {
 	u16 min_turnaround_time;
 };
 
+/* Generic Communications Channel Shared Memory Region */
+#define PCC_SIGNATURE			0x50434300
+/* Generic Communications Channel Command Field */
+#define PCC_CMD_GENERATE_DB_INTR	BIT(15)
+/* Generic Communications Channel Status Field */
+#define PCC_STATUS_CMD_COMPLETE		BIT(0)
+#define PCC_STATUS_SCI_DOORBELL		BIT(1)
+#define PCC_STATUS_ERROR		BIT(2)
+#define PCC_STATUS_PLATFORM_NOTIFY	BIT(3)
+/* Initiator Responder Communications Channel Flags */
+#define PCC_CMD_COMPLETION_NOTIFY	BIT(0)
+
 #define MAX_PCC_SUBSPACES	256
+
 #ifdef CONFIG_PCC
 extern struct pcc_mbox_chan *
 pcc_mbox_request_channel(struct mbox_client *cl, int subspace_id);
-- 
2.39.5



