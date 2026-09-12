Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA664BEE54;
	Sat, 12 Sep 2026 09:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206081; cv=none; b=hA0uo6W5VTVITpuNcG2GtEOUNIg0/3kb7wUd0s7ITjHnqlwdStxcs1l30PXH/Z0SsI4fyMTjeqt2tc5PpWrIbE10CYcpNsu9eFTo5ikLSl8Qu82SVCiL9SQum5FfgCD68vpobj9zyTd/iCwOFg9Y6tvHBcvSukrBJ6wFVFLXh9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206081; c=relaxed/simple;
	bh=djvuO7yYzyyjIGT7V5ARm/r/VfE51bWjg9NGovSDiiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tbrvc6hT6hq3E/sTz5HBA90OA64+wztcRc+ka5PjUAsOhI0W3HPDGvtPa8d39Hr2REZ2nqR3kjHS7H8L+36N5IPJZs8pj51x9k3CSDzXvn9cXskWTu/FV4umAZDVbz/vzKWlGFZ2aXK3KkTYGR4EVCs82mhk+Oo4VYlQ0E06vzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdlIMw+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdlIMw+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5611F000FF;
	Sat, 12 Sep 2026 09:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206079;
	bh=mkZmELovbUy86S9ROvtX2ZfdbS+3Q2bIRd4GzRA9Ctc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tdlIMw+XsYc4gqFfzaw/u3Fd7Km5R03xrFRBoPKZGT6zX7449VQ1wz1JCoBXmc7np
	 +rRm+WC4w3TXqWfxBH2Ti+7AxcheDGvakGz11m/PIqCMGdSG8W+FPhxhNc3UDtMlXe
	 jCM68aOtBQZEU15rUDHHroQFl8AKxPAThJjTz7q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0131/1518] clk: stm32: add missing bitfield.h header
Date: Sat, 12 Sep 2026 08:38:20 +0200
Message-ID: <20260912065626.452059292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 0bf68e8dcb843f094ed73c2c54e9fe58a7a4f774 ]

It seems some ARM header includes this and the build passes there, but
nowhere else. Note that the driver has COMPILE_TEST in depends.

Fixes: 37ae8501cdb0 ("clk: stm32: introduce clocks for STM32MP21 platfor")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/stm32/clk-stm32mp21.c | 1 +
 drivers/clk/stm32/clk-stm32mp25.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/clk/stm32/clk-stm32mp21.c b/drivers/clk/stm32/clk-stm32mp21.c
index c8a37b716bd55..bdb17419908c8 100644
--- a/drivers/clk/stm32/clk-stm32mp21.c
+++ b/drivers/clk/stm32/clk-stm32mp21.c
@@ -4,6 +4,7 @@
  * Author: Gabriel Fernandez <gabriel.fernandez@foss.st.com> for STMicroelectronics.
  */
 
+#include <linux/bitfield.h>
 #include <linux/bus/stm32_firewall_device.h>
 #include <linux/clk-provider.h>
 #include <linux/io.h>
diff --git a/drivers/clk/stm32/clk-stm32mp25.c b/drivers/clk/stm32/clk-stm32mp25.c
index 52f0e8a129262..eb0bc918ecee0 100644
--- a/drivers/clk/stm32/clk-stm32mp25.c
+++ b/drivers/clk/stm32/clk-stm32mp25.c
@@ -4,6 +4,7 @@
  * Author: Gabriel Fernandez <gabriel.fernandez@foss.st.com> for STMicroelectronics.
  */
 
+#include <linux/bitfield.h>
 #include <linux/bus/stm32_firewall_device.h>
 #include <linux/clk-provider.h>
 #include <linux/io.h>
-- 
2.53.0



