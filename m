Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214661;
	b=P12vDV7Bs2n6YwFo6uEtolMpFgR8R7VIVGhYLG+QRyoFzPbpMv599RpU/fsvJQZtu84k
	 YKfpmsSGeIEtJQO6AU8kD6Ur5Z1RCFeWA35YyinH47afa7V/lhtPwa0AqFRdUu/IQyctk
	 iHwUqNHFz0ujMGikyJckN/KyqHDQESlpdnp5EvHctfL7uqtQKmQeBNiCA1CUKyNUzbElv
	 muXnb+kgSPtN5EVZo9eL+Cb0OMEnBCrL3bJrKYByHpK/Lzav+GuRHe99unPczHYIeQ0th
	 lQ6KG3yr1w1HRg81127nGyXQBqEI2PY/tzNX3JKPnMvgUGDe9UTBSbSh5kkPmx5n+LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FWEv/8MjlJyManFnvGSLSUP09r480rzG9tSTQlNalbg=;
	b=NXO9/LnsgRyQ8aFNeuhfKbU5tHnmmMA8PAY1is4KwvVwkuh6jaVXlWFMTZ06JA2XPf2y
	 Hrzs15tMrqaPpEbCJqCugtVqoV7OaGeQQ4/XkbFTRFPagLC7JX5MX8uCGXYDq5AG1DSH/
	 3L33Eruz2qWe8gCfFD1PKCfSgv9evGlmP7I0xyMWAsA4OHF2/XHqwvtgi1vUGtKGO1jmu
	 xSu/iHriPy4qtqkbr3wiGWQRxUqCi4D6m5bUPNPNUEfRlY0wdy4aLe319S9mNLBkQpaLg
	 doQColEq0d7Dj2nn8JbMgEIFCrkSFyfxwXCukuQOx+veSZLwlEnhw+KEOCVCC06O4ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jyu2c9Kk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76CB606A338;
	Wed, 28 Oct 2026 19:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jyu2c9Kk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0576A1F01829;
	Wed, 28 Oct 2026 19:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214660;
	bh=FWEv/8MjlJyManFnvGSLSUP09r480rzG9tSTQlNalbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jyu2c9KkyQYO1QP3JSzQ1mqoC/Ev7esa93BaeoJ0bimhBLm2aYK/QWyDh6U+39LcV
	 u7st3xCqOfVDQtzUk+gkq+wo70JZMC4fw4WNcYfeNuatQy4Dq2ZbLnb3+/5vkM5KK6
	 RakslPY5QlnffUswbuO9A8TtlalnxBveuO/8kTWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0936/1887] cxl/mbox: validate payload size before accessing contents in cxl_payload_from_user_allowed()
Date: Wed, 28 Oct 2026 17:50:32 +0100
Message-ID: <20261028170520.712564945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit 60b5d1f68338aff2c5af0113f04aefa7169c50c2 ]

cxl_payload_from_user_allowed() casts and dereferences the input
payload without first verifying its size. When a raw mailbox command
is sent with an undersized payload (ie: 1 byte for CXL_MBOX_OP_CLEAR_LOG,
which expects a 16-byte UUID), uuid_equal() reads past the allocated buffer,
triggering a KASAN splat:

BUG: KASAN: slab-out-of-bounds in memcmp+0x176/0x1d0 lib/string.c:683
Read of size 8 at addr ffff88810130f5c0 by task syz.1.62/2258

CPU: 2 UID: 0 PID: 2258 Comm: syz.1.62 Not tainted 6.19.0-dirty #3 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xab/0xe0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xce/0x650 mm/kasan/report.c:482
 kasan_report+0xce/0x100 mm/kasan/report.c:595
 memcmp+0x176/0x1d0 lib/string.c:683
 uuid_equal include/linux/uuid.h:73 [inline]
 cxl_payload_from_user_allowed drivers/cxl/core/mbox.c:345 [inline]
 cxl_mbox_cmd_ctor drivers/cxl/core/mbox.c:368 [inline]
 cxl_validate_cmd_from_user drivers/cxl/core/mbox.c:522 [inline]
 cxl_send_cmd+0x9c0/0xb50 drivers/cxl/core/mbox.c:643
 __cxl_memdev_ioctl drivers/cxl/core/memdev.c:698 [inline]
 cxl_memdev_ioctl+0x14f/0x190 drivers/cxl/core/memdev.c:713
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xa8/0x330 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdaf331ba79
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdaf1d77038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fdaf3585fa0 RCX: 00007fdaf331ba79
RDX: 00002000000001c0 RSI: 00000000c030ce02 RDI: 0000000000000003
RBP: 00007fdaf33749df R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdaf3586038 R14: 00007fdaf3585fa0 R15: 00007ffced2af768
 </TASK>

Add 'in_size' parameter to cxl_payload_from_user_allowed() and validate
the payload is large enough.

Fixes: 6179045ccc0c ("cxl/mbox: Block immediate mode in SET_PARTITION_INFO command")
Fixes: 206f9fa9d555 ("cxl/mbox: Add Clear Log mailbox command")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260220001618.963490-2-dave@stgolabs.net
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 0c90f13870a43..3e89dc2b60d84 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -223,6 +223,7 @@ static bool cxl_mem_raw_command_allowed(u16 opcode)
  * cxl_payload_from_user_allowed() - Check contents of in_payload.
  * @opcode: The mailbox command opcode.
  * @payload_in: Pointer to the input payload passed in from user space.
+ * @in_size: Size of @payload_in in bytes.
  *
  * Return:
  *  * true	- payload_in passes check for @opcode.
@@ -237,12 +238,15 @@ static bool cxl_mem_raw_command_allowed(u16 opcode)
  *
  * The specific checks are determined by the opcode.
  */
-static bool cxl_payload_from_user_allowed(u16 opcode, void *payload_in)
+static bool cxl_payload_from_user_allowed(u16 opcode, void *payload_in,
+					  size_t in_size)
 {
 	switch (opcode) {
 	case CXL_MBOX_OP_SET_PARTITION_INFO: {
 		struct cxl_mbox_set_partition_info *pi = payload_in;
 
+		if (in_size < sizeof(*pi))
+			return false;
 		if (pi->flags & CXL_SET_PARTITION_IMMEDIATE_FLAG)
 			return false;
 		break;
@@ -268,7 +272,8 @@ static int cxl_mbox_cmd_ctor(struct cxl_mbox_cmd *mbox,
 		if (IS_ERR(mbox->payload_in))
 			return PTR_ERR(mbox->payload_in);
 
-		if (!cxl_payload_from_user_allowed(opcode, mbox->payload_in)) {
+		if (!cxl_payload_from_user_allowed(opcode, mbox->payload_in,
+						  in_size)) {
 			dev_dbg(cxlds->dev, "%s: input payload not allowed\n",
 				cxl_mem_opcode_to_name(opcode));
 			kvfree(mbox->payload_in);
-- 
2.53.0



