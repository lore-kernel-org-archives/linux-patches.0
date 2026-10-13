Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CC73CFF6F;
	Tue, 13 Oct 2026 11:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892252; cv=none; b=rOkoCTMnVlD25hbfbEfZY1TS6s1ggjzA4+imEgYVgGU1jrGfQHRbssr+8xQCuA2GPoOZg/B1cGoG8sX1obNsLDYRqnANhlWvwuPrqogFKycZHjsYEmKyFwEKnsTsoMua52ZqChceaVYwsHe4TKrGsD/ZWBJzFK0DKvtKD+0NQG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892252; c=relaxed/simple;
	bh=dKTHhYSnP2YW2hDsrcI4kG7Pe3F+0DeKsV0/4y3Di/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hInLiSWT5T0uvuxYOcp1qla+RPaDRpL9RbWK61p6yEE5zLhOemBLZVS18Ilzybza5/Q00h42d2NtqmsOaaZDH6wtzDwoggkcmSt6VNWPFr4urik5sZ7a0E1rNGko+pkR8OFEQXe/chqLl5vPegB7yExFMRLiHljvoFuamCK7BLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I46HDXsc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I46HDXsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276421F000FF;
	Tue, 13 Oct 2026 11:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892251;
	bh=JHIDpGu+DwAD+0O7WddOL87567lp2rZ+Caz58g1ZqQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I46HDXscaX7E1XOw076uLqXkvOcJbFne8YiDXg/e0Hcjj1r/IQ9NgI3FyMnj5dlN/
	 BxR+ozXnRcan3sB+2Y2LIZMXIfqcfeo5PaNWbZ2c+S4cUM5DIhAabWGaSp3wBpjnFv
	 Gy50URY6bGoN4fwrzG0hqqhD/l6D29ECw/PSvIR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Jesse Taube <jtaubepe@redhat.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.2 110/281] riscv: hwprobe: use _BITULL() rather than BIT() in MIPS vendor uapi header
Date: Tue, 13 Oct 2026 13:37:06 +0200
Message-ID: <20261013112857.815013677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

commit edba6017c19f97ecc718fad6b50e0908392247ac upstream.

BIT() is a kernel-internal macro that is not available to userspace, but
the MIPS vendor extension uapi header uses it without defining or
including it. Any userspace program that includes this header and uses
RISCV_HWPROBE_VENDOR_EXT_XMIPSEXECTL fails to build.

Use _BITULL(0) from linux/const.h instead, which keeps the value at 1,
so there is no ABI change.

Fixes: bb4b0f8a1bcb ("riscv: hwprobe: Add MIPS vendor extension probing")
Cc: stable@vger.kernel.org
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Reviewed-by: Jesse Taube <jtaubepe@redhat.com>
Link: https://patch.msgid.link/20260918073650.42586-1-min_halo@163.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/uapi/asm/vendor/mips.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/riscv/include/uapi/asm/vendor/mips.h
+++ b/arch/riscv/include/uapi/asm/vendor/mips.h
@@ -1,3 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 
-#define RISCV_HWPROBE_VENDOR_EXT_XMIPSEXECTL	BIT(0)
+#include <linux/const.h>
+
+#define RISCV_HWPROBE_VENDOR_EXT_XMIPSEXECTL	_BITULL(0)


