Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784B82ED843;
	Thu,  9 Oct 2025 15:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025534; cv=none; b=LRU9ieq5k5tp+a6TPYtJ74ixk7GPycf/EIFEUlZubpg1ve//NATAwHvyc3qcC1E48OeTkF0Dx2JlHZP53Pv0lpaL3zG+cnWh7XoBMtM0HNRxYw+NN482dSG7hkdI7M+S/w01wkhHJPmcnsXvfhSVyT68QkNDDlIgB4KbBDrlyx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025534; c=relaxed/simple;
	bh=pFTThtf7KZ6EwW9obqFdt9IaxE8oJnMDP+FuGnAKfJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n3Izih4LI6rqwaYS5CV47p8+pSMulAC/prd+Z4tze48styLGQUcFF6uVGmH+70rJopveeBW7ogZkkg/3hfJ2NY95j85RXxF97QYscLetbpx7hUU/WsjzQuEz3gPyJJsbgNE1J7uBVdN9jr/XBhrCgBQxlg0M6OHUgQSXK4hmtF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ISR0jXo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ISR0jXo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79782C4CEE7;
	Thu,  9 Oct 2025 15:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025534;
	bh=pFTThtf7KZ6EwW9obqFdt9IaxE8oJnMDP+FuGnAKfJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISR0jXo7xj4QshBFe1veBLUsQjDtTA5xd+j9dZxx2hi/5AK0XVumsq+LpaEvu5WRq
	 ChkPZ47B0vIwywR43gcRvyaG91IUEcbVhJWwe+whIW7+DA7uPXmVwZZKPIkWUgXx8N
	 /2NHkkJzF2QitVAJrAgfYkTxMM+lNNiQWkSKy7XKmBfT28/e0kDtfQ6X4kVol2Pabp
	 4bJxsbt/Vgyw5VW+nFfwkmg62EOCN7srNUaoTZOCa3vxGkdA1C9It3nIFcI4T5aftG
	 8aNrNnqTevCVWzEKPyQHiYkzfbxyf7WH99uDUUwdty7UGCv33rjblQHhg/FMAIc/WQ
	 a+NTZ4FwRYHvQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-6.16] mfd: qnap-mcu: Include linux/types.h in qnap-mcu.h shared header
Date: Thu,  9 Oct 2025 11:55:00 -0400
Message-ID: <20251009155752.773732-34-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Transfer-Encoding: 8bit

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 5e1c88679174e4bfe5d152060b06d370bd85de80 ]

Relying on other components to include those basic types is unreliable
and may cause compile errors like:

../include/linux/mfd/qnap-mcu.h:13:9: error: unknown type name ‘u32’
   13 |         u32 baud_rate;
      |         ^~~
../include/linux/mfd/qnap-mcu.h:17:9: error: unknown type name ‘bool’
   17 |         bool usb_led;
      |         ^~~~

So make sure, the types used in the header are available.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250804130726.3180806-2-heiko@sntech.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: The header now includes `linux/types.h` at
  include/linux/mfd/qnap-mcu.h:10. This ensures the basic kernel types
  used by this header are always available.

- Why it matters: The header defines and declares interfaces using
  kernel types:
  - `u32` in `struct qnap_mcu_variant` at include/linux/mfd/qnap-
    mcu.h:15
  - `bool` in `struct qnap_mcu_variant` at include/linux/mfd/qnap-
    mcu.h:19
  - `u8` and `size_t` in function prototypes at include/linux/mfd/qnap-
    mcu.h:22 and include/linux/mfd/qnap-mcu.h:25
  Without explicitly including `linux/types.h`, inclusion-order-
dependent builds can fail with “unknown type name ‘u32’/‘bool’”, exactly
as reported in the commit message.

- Scope and risk: The fix is a 2-line, isolated include addition in a
  private MFD header. It does not change runtime behavior, only makes
  the header self-sufficient. Risk of regression is negligible.

- User impact: This resolves real build failures when clients include
  `qnap-mcu.h` without having previously pulled in `linux/types.h`
  transitively. Multiple clients include this header (e.g.,
  drivers/hwmon/qnap-mcu-hwmon.c:10, drivers/input/misc/qnap-mcu-
  input.c:10, drivers/leds/leds-qnap-mcu.c:9), so inconsistent include
  orders across subsystems can hit the error.

- History/context: The base driver landed in v6.14 (commit
  998f70d1806bb), and the fix (commit 5e1c88679174e) is from Aug 2025.
  Stable branches containing the base QNAP MCU support but not this
  follow-up are susceptible. Backporting to all stable series which
  contain the QNAP MCU driver (v6.14+) is appropriate.

- Stable rules: This is a clear bug fix (build failure), minimal and
  contained, with no architectural changes or side effects, and confined
  to the MFD/QNAP MCU area. It fits stable backport criteria well.

 include/linux/mfd/qnap-mcu.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mfd/qnap-mcu.h b/include/linux/mfd/qnap-mcu.h
index 8d48c212fd444..42bf523f9a5b0 100644
--- a/include/linux/mfd/qnap-mcu.h
+++ b/include/linux/mfd/qnap-mcu.h
@@ -7,6 +7,8 @@
 #ifndef _LINUX_QNAP_MCU_H_
 #define _LINUX_QNAP_MCU_H_
 
+#include <linux/types.h>
+
 struct qnap_mcu;
 
 struct qnap_mcu_variant {
-- 
2.51.0

