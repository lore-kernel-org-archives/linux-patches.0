Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021947;
	b=lqNlkGF59/HmObFvE/WJ5jXX0PaU063vmJA2T46AM+aJCL3Y8abx+ehzymlTJYvfrGyq
	 EtclLiJjWqyO7P37SWrm1wQi4iQCcrzWDm1lApPtN3vlK3PKzFFKVq8DVSqmWYZJQPHey
	 KKQTf/7mDcO/+YZerzsFGx4eMRgLESUGhqojdah+hAnZKm6UxWCHBLbvT74n7wyn4jpno
	 KGI/dZVREYXNE4ddoltUPpVcxliAEWFP/z+hrrlf1JlrFOv4cvTZiKnbHLC+fhmtJDbjV
	 pmRnO8jP+2K7+qAuYHHS6tOgyb7Phb3CqhRB38SoeSlsYaQCIJ3/xGWHMr0IJmE9XEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=APB5q+3A+ikme7yvQpCONje3UdVr+qja+pJlBM4jcfk=;
	b=GCw56U386+d1wSGo9k9KjAF9B6LoQ7gnCfhhAzDiiC1MLTVz4qlHKUWigTHBbzjH8cwc
	 UvsyMzE39HmZU0CqvZJVLtWEmRMvfXm47oz1FKPIKQQHbWU0QgpS1cbFflFdfQDA+Kuyl
	 PXh47xks+hIt0mH3dTuoh5rvbagQKify8edxfW4HhILIn8AjJntNOGVM+O+SLFoYkbQvw
	 VprDHu3z1cHo9jq437arW+916YV6XC/O9VH9Hk9faCCrQ4TtsypMOFtaNvGaw5r3xsPJp
	 6FFR9ohj35VtMjgcPY+idJ04aT419pOA7W0pkrzFl90FbeywH/SOxWfPMwGVLL8+nZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1IDsIoUL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511FD606A32C;
	Wed, 18 Nov 2026 17:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1IDsIoUL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A390E1F000C4;
	Wed, 18 Nov 2026 17:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021947;
	bh=APB5q+3A+ikme7yvQpCONje3UdVr+qja+pJlBM4jcfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1IDsIoULA2502GU4KOHzuiCPFZzHHWJp6Jyf9ShgAHkCoCt3O9zpJNama3kT6eHbq
	 UdftfYsL7gQUJmYEI+hOHM3bfnnnlpEZeUq8o33cilQYniFkhobwhveLNmTo6YWLGD
	 6gRDKzjKqApGsiAeCOtjS7XjQRpx9Y/qKUSPjRaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2451/2651] clk: stm32: fix clock array size for STM32MP21
Date: Wed, 18 Nov 2026 16:01:31 +0100
Message-ID: <20261118150413.346584351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Fernandez <gabriel.fernandez@foss.st.com>

[ Upstream commit 40e5d379cc19fa7fa477414087df5e915d5e843f ]

STM32MP21_LAST_CLK is used as the number of entries of the onecell
clk_hw array allocated in stm32_rcc_clock_init(), and as the bound of
the clock IDs it can hold. It was wrongly set to CK_SCMI_KER_ETR (112),
which belongs to the SCMI clock ID range, whereas the RCC clock IDs
go up to CK_KER_STM (289).

As a result the array is too small, and registering a clock whose ID
is greater than 111 writes past the end of the allocated clk_hw array
(hws[cfg_clock->id] = hw), and consumers requesting such a clock
get rejected or read out of bounds.

Define STM32MP21_LAST_CLK as CK_KER_STM + 1 so that the array covers
all the RCC clock IDs.

No device tree node uses the STM32MP21 RCC driver yet, so there is no
need to backport this patch to stable kernels.

Fixes: 37ae8501cdb0 ("clk: stm32: introduce clocks for STM32MP21 platform")
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@foss.st.com>
Link: https://patch.msgid.link/20261012131859.215240-1-gabriel.fernandez@foss.st.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/stm32/clk-stm32mp21.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/stm32/clk-stm32mp21.c b/drivers/clk/stm32/clk-stm32mp21.c
index bdb17419908c8..961a228d8c640 100644
--- a/drivers/clk/stm32/clk-stm32mp21.c
+++ b/drivers/clk/stm32/clk-stm32mp21.c
@@ -17,8 +17,8 @@
 #include <dt-bindings/clock/st,stm32mp21-rcc.h>
 #include <dt-bindings/reset/st,stm32mp21-rcc.h>
 
-/* Max clock binding value */
-#define STM32MP21_LAST_CLK	CK_SCMI_KER_ETR
+/* Number of RCC clock bindings (highest RCC clock ID + 1) */
+#define STM32MP21_LAST_CLK	(CK_KER_STM + 1)
 
 /* Clock security definition */
 #define SECF_NONE		-1
-- 
2.53.0



