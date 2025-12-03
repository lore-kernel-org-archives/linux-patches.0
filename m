Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0DC357A54;
	Wed,  3 Dec 2025 16:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780284; cv=none; b=Sw8vF9JGb8b/xrvfaRJgy1PMi+vmpgW6wyN4O5/tsOTLZRq013snfva2bV2AoKP6VyWO30zjO8ljBBhURbkvD8wNYInuZtlCYDtK6Fp7P/F2iQskKkuWz0VqNZiL1W3OZlNZctLNijZaJJczuJDa4rEc/evvEhDhZaClOYmCn/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780284; c=relaxed/simple;
	bh=A6TvQzYRTQgdatVer5L5x9Z4Pa94wN8V7St1TgCb11E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Teo/af72/W7EofSKsQZ8c4qMVPFjukJeGYo748/ZOyioio61amX0aP4ojKyyQQApiQF0z03SmJysor5NmsOLorVWp40vBgsEvvlbSPtEU1/pEYU17llnYmVz6eraKkgSUnH3FLhvKH4ewiRhFSWYR9HL3j2/1ptHhU067tLvXbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1qbbzJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1qbbzJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7957EC4CEF5;
	Wed,  3 Dec 2025 16:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780284;
	bh=A6TvQzYRTQgdatVer5L5x9Z4Pa94wN8V7St1TgCb11E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1qbbzJP545Q2yM8iP53zGhVyvxYh4MioqFuiotIomodktYsSH+HlKbR8utYjCc7g
	 mA6U8mf9jTF23InSOvuC0lT6oWKiYTOa4Zq3+vvf0oSbiMAuUcNaWWTHmXp6F9ujz7
	 5Wye/bOEx1zASCsd+btGhfEHvA9GFfqv8rvmejUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 511/568] ACPI: PCC: Add PCC shared memory region command and status bitfields
Date: Wed,  3 Dec 2025 16:28:33 +0100
Message-ID: <20251203152459.429312144@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
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
Stable-dep-of: ff0e4d4c97c9 ("mailbox: pcc: don't zero error register")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/pcc.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/acpi/pcc.h b/include/acpi/pcc.h
index 73e806fe7ce70..9b373d172a776 100644
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
2.51.0



