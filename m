Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420B849EC5D;
	Mon, 31 Aug 2026 13:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183653; cv=none; b=kixJB+7hl7l7v4Pkia1UXqlhQUE0whNF6a0cCGY+p9D9XCeqsh8j17pdbTiH9x6S1Rb5P5O8T/HknQ0aMXMt6uxLRQMYTusJQKOSjHiOHUnZBIRy4G+6Rl+F3s6fXiRiAFQ2kLdn3b0NB+dd0GLiT1DCyRQS9smgd/JE/nPd+LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183653; c=relaxed/simple;
	bh=6GQHGreEhaSHdft71s4xhZbDHO+bTnsSAFAa0HeMws4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UctGhGB7chcqkeWYcG3Ar2GsPx5ISYyhuizB1/nWRFWh6z/e4seZHQ8ZNrSeMJVlS76m/FXWeRky2wFhdZjaiaulRjSogqF0tq6kpGfFDyBQbNt3uZt39Cr+9f+f8blXbhHecWcxe7TrVXIkuvXSqRtchNMPkJwmG1VDQS6ZNDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QP0ilfwA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QP0ilfwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3761F000E9;
	Mon, 31 Aug 2026 13:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183652;
	bh=4MKAJSJrngSB4caqVUmq/Ucm+1QQofYy+/cLNrFbWyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QP0ilfwAdj2Yvj05WzG0AsM7P+L6ZwyD+7iAyGaADmP0RG9oOGl7lCIv+L6dx1MId
	 Bsek9oAkfdRAwiJal/ef6HoBPjCrAooxRoloaCTHngNZdHIv/RlA5WfbUa9E6eU/Dl
	 msiS8zUxbMfFc6gxKYHNgtCdZkIFFrhly6ewLHEBPwRCfvzY2JIs8unUK+R36JRNOv
	 RRBP2IYq6u32Cxs0/Hwb/cmOwuN3Ohfo29s6R3YaCg5/qxQvXiM5ptN3lILvQducYL
	 gYi44m7RYLx9N4W9XvZqBl33Gm1t56xlGz2BEZSQqHU0lXohgRTD0Hub8aBDQkbOd4
	 fXE1BTC7hcxQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nikhil Chatterjee <nikhilc1527@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] HID: bpf: Add Huion Inspiroy Frego M button quirk
Date: Mon, 31 Aug 2026 09:24:10 -0400
Message-ID: <20260831133314.4125787-222-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nikhil Chatterjee <nikhilc1527@gmail.com>

[ Upstream commit 857e71cb0a538b1660743a4267a1e789575f7966 ]

The Huion Inspiroy Frego M pen report descriptor exposes the second
side button as Secondary Tip Switch instead of Secondary Barrel Switch.
This makes userspace see the control as the wrong pen button.

Add a HID-BPF report descriptor fixup for the Bluetooth 256c:8251
device and USB 256c:2012 L610 variant. The fixup matches the expected
pen descriptor and rewrites the offending usage from Secondary Tip
Switch to Secondary Barrel Switch.

Tested by building the HID-BPF object with:

  make -C drivers/hid/bpf/progs Huion__Inspiroy-Frego-M.bpf.o

Signed-off-by: Nikhil Chatterjee <nikhilc1527@gmail.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background git searches finished and match the earlier analysis:

- **`git log --grep="Frego"` / `--grep="Inspiroy Frego"`** — no matches
  in this tree; the quirk is not present in 6.18.44.
- **`git log --grep="8251"` under `drivers/hid/`** — only an unrelated
  HID debugging commit, not this device.

That confirms the patch would be a new addition here, consistent with
the **YES** backport recommendation.

 .../bpf/progs/Huion__Inspiroy-Frego-M.bpf.c   | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 drivers/hid/bpf/progs/Huion__Inspiroy-Frego-M.bpf.c

diff --git a/drivers/hid/bpf/progs/Huion__Inspiroy-Frego-M.bpf.c b/drivers/hid/bpf/progs/Huion__Inspiroy-Frego-M.bpf.c
new file mode 100644
index 0000000000000..e6ba2295dc775
--- /dev/null
+++ b/drivers/hid/bpf/progs/Huion__Inspiroy-Frego-M.bpf.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "vmlinux.h"
+#include "hid_bpf.h"
+#include "hid_bpf_helpers.h"
+#include <bpf/bpf_tracing.h>
+
+/*
+ * Huion Inspiroy Frego M Pen Tablet
+ * Model L610
+ * 256c:8251 (Bluetooth)
+ * 256c:2012 (USB)
+ */
+#define VID_HUION			0x256C
+#define PID_INSPIROY_FREGO_M		0x8251
+#define PID_L610			0x2012
+
+#define PEN_RDESC_SIZE			125
+#define SECONDARY_SWITCH_OFFSET		17
+
+HID_BPF_CONFIG(
+	HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_GENERIC, VID_HUION, PID_INSPIROY_FREGO_M),
+	HID_DEVICE(BUS_USB, HID_GROUP_GENERIC, VID_HUION, PID_L610)
+);
+
+/*
+ * The pen descriptor reports the second side button as Secondary Tip Switch
+ * instead of Secondary Barrel Switch.
+ *
+ * Relevant part of the original pen report descriptor:
+ *
+ * 0x09, 0x42,       // Usage (Tip Switch)                  12
+ * 0x09, 0x44,       // Usage (Barrel Switch)               14
+ * 0x09, 0x43,       // Usage (Secondary Tip Switch)        16 <- change to 0x5a
+ * 0x09, 0x3c,       // Usage (Invert)                      18
+ * 0x09, 0x45,       // Usage (Eraser)                      20
+ * 0x15, 0x00,       // Logical Minimum (0)                 22
+ * 0x25, 0x01,       // Logical Maximum (1)                 24
+ */
+SEC(HID_BPF_RDESC_FIXUP)
+int BPF_PROG(fix_secondary_barrel_rdesc, struct hid_bpf_ctx *hctx)
+{
+	__u8 *data = hid_bpf_get_data(hctx, 0 /* offset */, HID_MAX_DESCRIPTOR_SIZE /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	if (hctx->size != PEN_RDESC_SIZE)
+		return 0;
+
+	if (data[0] != 0x05 || data[1] != 0x0d || /* Usage Page (Digitizers) */
+	    data[2] != 0x09 || data[3] != 0x02 || /* Usage (Pen) */
+	    data[16] != 0x09 ||
+	    data[SECONDARY_SWITCH_OFFSET] != 0x43) /* Secondary Tip Switch */
+		return 0;
+
+	data[SECONDARY_SWITCH_OFFSET] = 0x5a;
+
+	return 0;
+}
+
+HID_BPF_OPS(fix_secondary_barrel) = {
+	.hid_rdesc_fixup = (void *)fix_secondary_barrel_rdesc,
+};
+
+SEC("syscall")
+int probe(struct hid_bpf_probe_args *ctx)
+{
+	ctx->retval = ctx->rdesc_size != PEN_RDESC_SIZE;
+	if (ctx->retval) {
+		ctx->retval = -EINVAL;
+		return 0;
+	}
+
+	if (ctx->rdesc[0] != 0x05 || ctx->rdesc[1] != 0x0d || /* Usage Page (Digitizers) */
+	    ctx->rdesc[2] != 0x09 || ctx->rdesc[3] != 0x02 || /* Usage (Pen) */
+	    ctx->rdesc[16] != 0x09 ||
+	    ctx->rdesc[SECONDARY_SWITCH_OFFSET] != 0x43) { /* Secondary Tip Switch */
+		ctx->retval = -EINVAL;
+		return 0;
+	}
+
+	ctx->retval = 0;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.53.0

