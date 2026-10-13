Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB544F7975;
	Tue, 13 Oct 2026 12:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893068; cv=none; b=Cur63rSzRR32OEsU8JSL4hPGg747fMUzXOR6xsiVIKA/5mgG8ydubZtKTSmHRUK+9l2Xy2bCAnH7Uh+oFb9me6cVi+NtI8dDDnuKcVBJ3NtEQpU3OGubj9RoiB96DROONvuDqyLeMSLGtY/MI95D/aHMpPxZdGCYL6REb7DoMZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893068; c=relaxed/simple;
	bh=6l3ys3Lm+sItx4mBilRapanBO7ElLuX3zDoV/cm5qWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dL9yLlp6ra4sL+5eQ7B2iXF+gURkz4iqjHAQNgWnxdqzFHHKaxFxGaOVu9LkCQiEKEy/UxILWwIZKwQbwByj1VZ8YZO+JpiawjiBmyUKKhnMaYgmoJmEvfU1fSmCi7L7C2lmo8pQGLLmGSfuQcVWF71Yf7NkMiMpCsYbPM1F/3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmGDxlz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmGDxlz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59AC1F000FF;
	Tue, 13 Oct 2026 12:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893067;
	bh=B3v3QPY/t9ItMNmkdXI3HGy5RuT6htyx247yGHJG0TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmGDxlz6RzvcNOGnQD4HqOmorNpOZkb2548uHkefKjWtE38Y5HsFQaUIdvaho1OYf
	 w5ivcbCk/QwSFExLf0tGLLCt5lR014Ni6pzwctNpEEotWGzuixSJBdsU4Yji4QJ+dB
	 iZq4DnhE33rz9r4deeTtxIcAsQq5GDHOJCSxjGeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Jesse Taube <jtaubepe@redhat.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 100/621] riscv: hwprobe: use _BITULL() rather than BIT() in MIPS vendor uapi header
Date: Tue, 13 Oct 2026 13:31:35 +0200
Message-ID: <20261013112923.221869689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
 arch/riscv/include/uapi/asm/vendor/mips.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/uapi/asm/vendor/mips.h b/arch/riscv/include/uapi/asm/vendor/mips.h
index e65ab268b265..a31c23afe74f 100644
--- a/arch/riscv/include/uapi/asm/vendor/mips.h
+++ b/arch/riscv/include/uapi/asm/vendor/mips.h
@@ -1,3 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 
-#define RISCV_HWPROBE_VENDOR_EXT_XMIPSEXECTL	BIT(0)
+#include <linux/const.h>
+
+#define RISCV_HWPROBE_VENDOR_EXT_XMIPSEXECTL	_BITULL(0)
-- 
2.56.0



