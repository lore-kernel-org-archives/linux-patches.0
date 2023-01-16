Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFD433EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0E4C433EF;
	Mon, 16 Jan 2023 15:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884563;
	bh=15CuBQ3xtBo7zBWTK3dHeO+e9DFE05/7gRrOYSQjV+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlZmlsRAVJPHhzX4TrWFn0P2PDAl9LEmS6HMKjiPBKuFDHMy2qBqBdRq09EVWP6F4
	 Umz6roYZgjvFQfCASISWyegBNFH7Yv5lY2+M+Ea7/C/mEut1+G1kkj6KVihGu238Op
	 rtOuDfwJbCf1upOwIAdUHX7XowgnHzjl1rfiramQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 054/183] firmware/psci: Fix MEM_PROTECT_RANGE function numbers
Date: Mon, 16 Jan 2023 16:49:37 +0100
Message-Id: <20230116154805.638480450@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Will Deacon <will@kernel.org>

commit f3dc61cde80d48751999c4cb46daf3b2185e6895 upstream.

PSCI v1.1 offers 32-bit and 64-bit variants of the MEM_PROTECT_RANGE
call using function identifier 20.

Fix the incorrect definitions of the MEM_PROTECT_CHECK_RANGE calls in
the PSCI UAPI header.

Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Fixes: 3137f2e60098 ("firmware/psci: Add debugfs support to ease debugging")
Acked-by: Marc Zyngier <maz@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20221125101826.22404-1-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/psci.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/psci.h b/include/uapi/linux/psci.h
index 3511095c2702..42a40ad3fb62 100644
--- a/include/uapi/linux/psci.h
+++ b/include/uapi/linux/psci.h
@@ -58,7 +58,7 @@
 
 #define PSCI_1_1_FN_SYSTEM_RESET2		PSCI_0_2_FN(18)
 #define PSCI_1_1_FN_MEM_PROTECT			PSCI_0_2_FN(19)
-#define PSCI_1_1_FN_MEM_PROTECT_CHECK_RANGE	PSCI_0_2_FN(19)
+#define PSCI_1_1_FN_MEM_PROTECT_CHECK_RANGE	PSCI_0_2_FN(20)
 
 #define PSCI_1_0_FN64_CPU_DEFAULT_SUSPEND	PSCI_0_2_FN64(12)
 #define PSCI_1_0_FN64_NODE_HW_STATE		PSCI_0_2_FN64(13)
@@ -67,7 +67,7 @@
 #define PSCI_1_0_FN64_STAT_COUNT		PSCI_0_2_FN64(17)
 
 #define PSCI_1_1_FN64_SYSTEM_RESET2		PSCI_0_2_FN64(18)
-#define PSCI_1_1_FN64_MEM_PROTECT_CHECK_RANGE	PSCI_0_2_FN64(19)
+#define PSCI_1_1_FN64_MEM_PROTECT_CHECK_RANGE	PSCI_0_2_FN64(20)
 
 /* PSCI v0.2 power state encoding for CPU_SUSPEND function */
 #define PSCI_0_2_POWER_STATE_ID_MASK		0xffff
-- 
2.39.0



