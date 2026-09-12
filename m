Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F130F3C1D43;
	Sat, 12 Sep 2026 07:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197034; cv=none; b=MVSCLv7qFLTnjbR0SkIBbGydbMv9BBLgTHu28banPNJtq9e9oZmTq7pYZWa+ct9jzuzdQWvrIy2XxdBlL/QrXmaBCzllIE3HyYQtk9OaGgpP51ktMFxd/7f2TYRTLwLxW48nvnBsTu8YSiHol54gglN+sv01+9RKq9goJTesbCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197034; c=relaxed/simple;
	bh=S1X5IUhTaw7KeijiefLBX9L1dSNqkJydC2iUMOr090k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPGjYg2WCMo0b10EGA11zAbiZQikrv6ikt4VF5vlWiPtXYswKkh+9hBZHHRLoAe62C1vDgcMnXfxqQD3yL3+Ehr8KznIADG62h+ARFXCK5eRYFfvIslyy7RyF7Vyj5kDM5GpNP8Lf7akePLAghI9wq823OwQVifdeNo+AljeGpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1x0yRQ92; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1x0yRQ92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1061F000FF;
	Sat, 12 Sep 2026 07:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197032;
	bh=fyowHnTPSpvIIGY1aFbIpo/pv4D8RzMmfrQ8pSSoOhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1x0yRQ92M5OBbsg4J7MY38XGGURykYaBh3zi5REA383pxrO/dl6PFG43yWgnwzxMV
	 ibaIDApJV2V+8lKVdwvFNg0dxYilnmxlV5Zt0/hFlpZQFQzcQEWaQvvuQNiK5DpbGx
	 JLP/ICEorr1imDIgNf9m9M35yXz3d3Gkq6fkT7Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0085/1815] clk: stm32: add missing bitfield.h header
Date: Sat, 12 Sep 2026 08:30:35 +0200
Message-ID: <20260912065651.002798951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



