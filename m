Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFA9135A50;
	Tue, 23 Jan 2024 00:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969658; cv=none; b=khV3smLftHKnqTzigu94T4PTyJKhr2NrEaaK85RXvS4SomCVrXIVNEbEeqdgMAQ5cjMpa0t7baHnKPM4GlglgHbn7PN62SstljvhsBqAQvsGRpd11Yi4TFYWEYj7JdIdz7v30IYtJXS699MZP/EeR2dCX4YBcmv0YPTrZOUHqZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969658; c=relaxed/simple;
	bh=13o+lABzbsEz7d4N0rJMYPo/9dzka3PVPNxYTPAIAPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kX1R9GslSsShSRAg/Y/PhILZJGwmmwFm32mcOwPz4/vpb9YJdBpxNXn/uqjr+L6+uJM4i4607kg+Q3EY/CH8QYSXJSFIrD+l/fI5QWSLV1/9v2Y1UpSLo2urPPTkNWj2X1uFWi1d5/FptefdAEQy1W60Hn+I9S/D31mUVxJPnCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/owo0ls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/owo0ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D12BC43399;
	Tue, 23 Jan 2024 00:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969658;
	bh=13o+lABzbsEz7d4N0rJMYPo/9dzka3PVPNxYTPAIAPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/owo0lsfHkvFZwrjI+onGroBzIVxyFM7yR29S9JU6ChvcZvizvwDVmkmLmuZ7bQt
	 X/dnnAYgtQ0Dio954HGPFLWA4go/JbI/Ut7gx8UTt5tO2TDwtxKwP3Tc6euT9KE1tw
	 ooYtEUkow0p62jMo869C6TS20iLoQYWeX5DbRqxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Tony Lindgren <tony@atomide.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.7 388/641] clocksource/drivers/timer-ti-dm: Fix make W=n kerneldoc warnings
Date: Mon, 22 Jan 2024 15:54:52 -0800
Message-ID: <20240122235830.098774764@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit b99a212a7697c542b460adaa15d4a98abf8223f0 upstream.

Kernel test robot reports of kerneldoc related warnings that happen with
make W=n for "parameter or member not described".

These were caused by changes to function parameter names with
earlier commits where the kerneldoc parts were not updated.

Fixes: 49cd16bb573e ("clocksource/drivers/timer-ti-dm: Simplify register writes with dmtimer_write()")
Fixes: a6e543f61531 ("clocksource/drivers/timer-ti-dm: Move struct omap_dm_timer fields to driver")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311040403.DzIiBuwU-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202311040606.XL5OcR9O-lkp@intel.com/
Signed-off-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20231114072930.40615-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/timer-ti-dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clocksource/timer-ti-dm.c
+++ b/drivers/clocksource/timer-ti-dm.c
@@ -183,7 +183,7 @@ static inline u32 dmtimer_read(struct dm
  * dmtimer_write - write timer registers in posted and non-posted mode
  * @timer:      timer pointer over which write operation is to perform
  * @reg:        lowest byte holds the register offset
- * @value:      data to write into the register
+ * @val:        data to write into the register
  *
  * The posted mode bit is encoded in reg. Note that in posted mode, the write
  * pending bit must be checked. Otherwise a write on a register which has a
@@ -949,7 +949,7 @@ static int omap_dm_timer_set_int_enable(
 
 /**
  * omap_dm_timer_set_int_disable - disable timer interrupts
- * @timer:	pointer to timer handle
+ * @cookie:	pointer to timer cookie
  * @mask:	bit mask of interrupts to be disabled
  *
  * Disables the specified timer interrupts for a timer.


