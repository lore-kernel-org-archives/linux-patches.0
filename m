Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830907;
	b=nY2aVb+oPNzhBlH0p1aG6h287vNfQbECX7p49xJfmJQmG2C8fvNJET73Un9XI2uRHGaZ
	 W+p1Kv3LGvQMTMbVSPs/5aMLMVBLlPrHhzRWnTFD0bh2hhn3GHaJ+TFGWG4BA2+K/Ep1q
	 yt6m69b9U4/DQPS0tN8NDaXsv6MGYpH+L/hKPXXrcf8f7kG/0tdIooGPjtVGO6yOnJU6l
	 X+5Isn0rBt4lh6QKL1sZI5kEcoGc7ejs5GNdS0eAjP5cUyC6a1ECGDkvSy1TyerTHRqFQ
	 kbarUGibCsJMnUkV5kDnuBfAQ0DOMO/FutaAS7TDZSWLNBQd8qLXyw0LINSHEeUmaKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e8bmKdZpRIELd31AAoPJgcDATWb4fi4H66zqW1nZjXw=;
	b=LqOP5/FrNxdEjvuzrPKyuR0FLSi6lAetAlEZMhVsurdTCGGU2i9v3cegYkmYqcoVNKHO
	 kMpabG1AI7lFLjloob3LKuMd9WIK2I4uvNCMP+5x9XNPgzLZZB+J4MU/VLIlBl0/JBYhk
	 KdePi0EJYHWP63HI8AZDRsi7/Y1WeloYNyvNYyYpKtH9+1dB5XSlQob5910tr06h9VdGD
	 omToo25ArQiTmxcHm9jmVOFmpHg6ZbjG/Bube5jw1V67T+xW6PwML13dDW+WEIBYhJbeJ
	 vQLpTRS+wXu3Q31M99wWHDEAdji0deUPMfqth9T3oRV2WPkJwX4Lftliyl0IwtN0tZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=klPWGQjk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390E0606A848;
	Wed,  4 Nov 2026 22:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=klPWGQjk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4551F000C1;
	Wed,  4 Nov 2026 22:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830907;
	bh=e8bmKdZpRIELd31AAoPJgcDATWb4fi4H66zqW1nZjXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=klPWGQjkO1ZUcVWrkOL2YBbr4P8hOepFWfkAvNV9RGpK/BKHrs9CQrKqChHVV+EQy
	 RzsSal1XSQaK8R0ZUfNRHMBfLE3EtYDsgq2t+TxmJgjIyEDmwMSFL8rPwXeFx+rSLO
	 Uraq0NxzsiGOIXayb0H6soDE5lmluCMCxRZy6SBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0395/1005] HID: amd_sfh: Serialize access to the shared emp2 pointer
Date: Wed,  4 Nov 2026 16:02:08 -0500
Message-ID: <20261104211055.136586973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 837d59e7a6610..dd2720bae65c3 100644
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
 
@@ -160,6 +164,8 @@ static int amd_sfh_als_info(u32 *ambient_light)
 
 int amd_get_sfh_info(struct amd_sfh_info *sfh_info, enum sfh_message_type op)
 {
+	guard(mutex)(&emp2_lock);
+
 	if (sfh_info) {
 		switch (op) {
 		case MT_HPD:
-- 
2.53.0



