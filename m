Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212564;
	b=qnhpqL+8cmbcTgR/qfj0aEpgTC25URwxRWZENL+GDWgFI+MhfSXBJ5Tpr99W3RrJGb8s
	 oc3AFqwC42v0eV7+33xSQ2jKxSwywI3f+4VADvbJ6Jf630s+Z8p7eNzQFTYG0vxr0BsTE
	 7Xmi8LYTIk1GP6EN49C3iQw+T1A8mID2DYzN4AS85PnA2uTe3o8jBitKiC0TC+/cJDmJ6
	 wU7cWtbxyV23U0OF098N3GtlupEFn1XR3bjhzITuWlywwsoVtP/VtQmPYIashzl70Hyo0
	 vmONXgmvVZlYwM1jKJKsWY8WrD7q8deGna2T9ESGzMuiUnQp/sEdlNHC0xqAPcThvjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KBHrJJLwjNh1eHyjydDFovQw5Zc0v/nMi1Vm1PzYZmA=;
	b=1pzCMAaa7Y5KrjIJGxkwQpmHM/6nlFa20MCFnWkkaPKws0z0QQzlDi3/LRGG8ih85Fq2
	 h9FDkL3v1A0sFBjmH65odTHgHohWae6lgesvpw/7ounVki5wyua0xeZ+OmWVAUhMzAbIC
	 Tijy7aM0ei0yZnpp97/ku7MTCsxmPTpJnzszj5HMN8/ThK9RB8x2h4DwJHVC2vgON7/tT
	 nIF+W7lBU2Vs6t5l+6DndroVEwZna+dpEYrxnKhSkzlzS9XyhU7rMxk0FIuvf0M2Vvupm
	 QTkC7Rz8VGLaK5Pwyw9hFveNJ07dVEvrbzN/YMxuoxK9yxGdEMnj8MPb+8LL70+/PmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POPiR0aX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A38606A31C;
	Wed, 28 Oct 2026 18:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POPiR0aX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4484D1F01825;
	Wed, 28 Oct 2026 18:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212563;
	bh=KBHrJJLwjNh1eHyjydDFovQw5Zc0v/nMi1Vm1PzYZmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POPiR0aXRnIPz+OKxmrGY/Ch8X0Nvv9dQoZzPT5eK0am4gYCssH4WavsDxz4UBQvK
	 b7zLGZ/lU0Z3FevSztf6/st6WqdMe1q5L/+28nonMoEw9JbkhJQSYuq5klBuvCWUum
	 i2E/p+EVNdfi1Wps1JW5QcLd/xknGe9lfuAUiAOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0196/1887] media: av7110: fix a spectre vulnerability
Date: Wed, 28 Oct 2026 17:38:12 +0100
Message-ID: <20261028170503.696008656@linuxfoundation.org>
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

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 458ea1c0be991573ec436aa0afa23baacfae101a ]

As warned by smatch:
	drivers/staging/media/av7110/av7110_ca.c:270 dvb_ca_ioctl() warn: potential spectre issue 'av7110->ci_slot' [w] (local cap)

There is a spectre-related vulnerability at the code. Fix it.

[ Backport to 6.1.y: added the explicit linux/nospec.h include required
  by the older source. ]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/deprecated/saa7146/av7110/av7110.h  |  4 ++-
 .../deprecated/saa7146/av7110/av7110_ca.c     | 26 +++++++++++++------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/deprecated/saa7146/av7110/av7110.h b/drivers/staging/media/deprecated/saa7146/av7110/av7110.h
index 9fde69b38f1ce..c2956c23d9c1e 100644
--- a/drivers/staging/media/deprecated/saa7146/av7110/av7110.h
+++ b/drivers/staging/media/deprecated/saa7146/av7110/av7110.h
@@ -86,6 +86,8 @@ struct infrared {
 	u32			ir_config;
 };
 
+#define MAX_CI_SLOTS	2
+
 /* place to store all the necessary device information */
 struct av7110 {
 
@@ -166,7 +168,7 @@ struct av7110 {
 
 	/* CA */
 
-	struct ca_slot_info	ci_slot[2];
+	struct ca_slot_info	ci_slot[MAX_CI_SLOTS];
 
 	enum av7110_video_mode	vidmode;
 	struct dmxdev		dmxdev;
diff --git a/drivers/staging/media/deprecated/saa7146/av7110/av7110_ca.c b/drivers/staging/media/deprecated/saa7146/av7110/av7110_ca.c
index c1338e074a3dc..642af03fbac81 100644
--- a/drivers/staging/media/deprecated/saa7146/av7110/av7110_ca.c
+++ b/drivers/staging/media/deprecated/saa7146/av7110/av7110_ca.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/nospec.h>
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
@@ -26,23 +27,28 @@
 
 void CI_handle(struct av7110 *av7110, u8 *data, u16 len)
 {
+	unsigned slot_num;
+
 	dprintk(8, "av7110:%p\n",av7110);
 
 	if (len < 3)
 		return;
 	switch (data[0]) {
 	case CI_MSG_CI_INFO:
-		if (data[2] != 1 && data[2] != 2)
+		if (data[2] != 1 && data[2] != MAX_CI_SLOTS)
 			break;
+
+		slot_num = array_index_nospec(data[2] - 1, MAX_CI_SLOTS);
+
 		switch (data[1]) {
 		case 0:
-			av7110->ci_slot[data[2] - 1].flags = 0;
+			av7110->ci_slot[slot_num].flags = 0;
 			break;
 		case 1:
-			av7110->ci_slot[data[2] - 1].flags |= CA_CI_MODULE_PRESENT;
+			av7110->ci_slot[slot_num].flags |= CA_CI_MODULE_PRESENT;
 			break;
 		case 2:
-			av7110->ci_slot[data[2] - 1].flags |= CA_CI_MODULE_READY;
+			av7110->ci_slot[slot_num].flags |= CA_CI_MODULE_READY;
 			break;
 		}
 		break;
@@ -264,15 +270,19 @@ static int dvb_ca_ioctl(struct file *file, unsigned int cmd, void *parg)
 	case CA_GET_SLOT_INFO:
 	{
 		struct ca_slot_info *info=(struct ca_slot_info *)parg;
+		unsigned int slot_num;
 
 		if (info->num < 0 || info->num > 1) {
 			mutex_unlock(&av7110->ioctl_mutex);
 			return -EINVAL;
 		}
-		av7110->ci_slot[info->num].num = info->num;
-		av7110->ci_slot[info->num].type = FW_CI_LL_SUPPORT(av7110->arm_app) ?
-							CA_CI_LINK : CA_CI;
-		memcpy(info, &av7110->ci_slot[info->num], sizeof(struct ca_slot_info));
+		slot_num = array_index_nospec(info->num, MAX_CI_SLOTS);
+
+		av7110->ci_slot[slot_num].num = info->num;
+		av7110->ci_slot[slot_num].type = FW_CI_LL_SUPPORT(av7110->arm_app) ?
+						 CA_CI_LINK : CA_CI;
+		memcpy(info, &av7110->ci_slot[slot_num],
+		       sizeof(struct ca_slot_info));
 		break;
 	}
 
-- 
2.53.0



