Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061001;
	b=P/PrAdYaDxio3BKU8cfENFfNMS/FP/JE2UNC4pH4fytbKCeu3cRJwDv7ORZhnQ3NZFai
	 Y223BT3DtyPo17bUksAvH8ga19WHw1yNhXXKQ+qtuuxdsB8KNBuXH12oCTxCLyq5Tp8ln
	 sv2H3DyTyPIAkL1/yK8OOlxC0psCNWFwmcbe1lvaZsVRofsVt1bW2EUROaOOJF9hRH6bd
	 SUaVQ0ZwrjgDuQln2SwsV7H4oqxWCXJ9uLULflfSx54YLE0PzKAenFoErgJNdhpl9yXns
	 BtaOMlDxFvD/SzTGIv/Yvwrh1fWCRkPKL+62xS+svMRNdNRTyp21SZcYPqvJPi/KzwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=35EP4kugu9nRcRRDTA6npseXplGCtBBBfNttINKbLak=;
	b=0JFw1FQbpZClvtGFFdkCuUIuyOASQoNR80yi+l+oSeYaNY/4N7vHVEJ4QxF9tWgSr/mO
	 WmJRgBz3ghk9XZZEU1l8kDi32oupBJDRjEs63D0d1oERMMxm2JaGEpRoey8gtPS1wUSkD
	 V9SUW8ExmMhNhEesZj8pb/rMInAslWUtNrrLkIZWQ7Uxc5SnZIfqlGVQX5Wyktg1YDuJq
	 kJUnDvO6CYuedq3lHk2YyrVakH60ADi+QwAhfqtIkQUSTdX8VuG7R0CFKfnlBNbALFiq7
	 u2gqroV/P42d5BkJHYSzv8SrjxSUbfJuxWx/XfW+WGZRhoNqPOGYbgRnlyuom2OeApw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vxU9zDL/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A2B606A33B;
	Sat,  7 Nov 2026 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vxU9zDL/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4C81F008A2;
	Sat,  7 Nov 2026 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061001;
	bh=35EP4kugu9nRcRRDTA6npseXplGCtBBBfNttINKbLak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vxU9zDL/CHCuS+Fv06qTgy8Y0/nXdlbXHnKcnlV1JcbWA7AmN/OLDxHfBzL7PRbOc
	 rtY0m9p4wqgI/L1AQPal0zrXndX6ZZRoKUSgRKDhLMQaOSMNLpvKX+YEE+k7e/xikm
	 TcHr+wAQYVQ++ykTWFQBjtZYwnJk2oeoC3mxpsSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0329/1536] HID: amd_sfh: Serialize access to the shared emp2 pointer
Date: Sat,  7 Nov 2026 08:39:05 -0500
Message-ID: <20261107135006.948550660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit c57016bcf6d0b57cda5579e5d6856bd9bbe52a77 ]

The SFH accessors reach the device through a file-global emp2 pointer
that is published at probe and cleared on remove. amd_get_sfh_info() is
exported and called from other modules on unrelated threads, so a reader
can observe a non-NULL emp2 and then race a concurrent unbind that clears
it and frees the device.

Serialize the emp2 publish/clear and all readers under a mutex, so a
reader either sees a live device for the whole access or sees NULL.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c
index 4676f060da261..2365e3c6bab55 100644
--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c
@@ -8,12 +8,14 @@
  * Author: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
  */
 #include <linux/amd-pmf-io.h>
+#include <linux/cleanup.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/iopoll.h>
 
 #include "amd_sfh_interface.h"
 
 static struct amd_mp2_dev *emp2;
+static DEFINE_MUTEX(emp2_lock);
 
 static int amd_sfh_wait_response(struct amd_mp2_dev *mp2, u8 sid, u32 cmd_id)
 {
@@ -78,12 +80,14 @@ static struct amd_mp2_ops amd_sfh_ops = {
 
 void sfh_deinit_emp2(void)
 {
+	guard(mutex)(&emp2_lock);
 	emp2 = NULL;
 }
 
 void sfh_interface_init(struct amd_mp2_dev *mp2)
 {
 	mp2->mp2_ops = &amd_sfh_ops;
+	guard(mutex)(&emp2_lock);
 	emp2 = mp2;
 }
 
@@ -125,6 +129,8 @@ static int amd_sfh_als_info(u32 *ambient_light)
 
 int amd_get_sfh_info(struct amd_sfh_info *sfh_info, enum sfh_message_type op)
 {
+	guard(mutex)(&emp2_lock);
+
 	if (sfh_info) {
 		switch (op) {
 		case MT_HPD:
-- 
2.53.0



