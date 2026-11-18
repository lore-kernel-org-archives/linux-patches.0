Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022763;
	b=4FQq1IVRAf70CWLe/1mWJigIDNuiUL5Gm37QYu1V+3hXzeuiruCQLj7KAv/eQgr5/B1H
	 loQaODU0/OAm/GFVBpKIngCmf6nlKWrRRS5HdQF4JwrwbHBQz0qYzw4s3X56wb9VOoxHU
	 ZnvDpcjjnNVJzmyEIblLovzpB/awqm9u4+erlTv/CO4cthjI4GD3Rjm+1mFeaxwpg4wee
	 FwrjkXzpu0kOlXAY3mM5tSyhCaHpdJlUd19QzqATiNJRjKYr35v8T0dfoH9eKSPhLoaeu
	 NxK74UMgRIaL3ClVNab84shbgl16eNkloQ7DCCO8JdYD0pi0decOOfSvwGuUUdnUTUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OAGdTvfvWZfywh5G7+z+0RV6Y/a6Dnk9dKXZJiqQyls=;
	b=2tkG5MTNoUKgr0tohyL0ti1iC9dh0qQkQVP4EF0Ni99wwsNZ+81iyUijg4AEb4A2Vod1
	 NJv4h5dFOcl0F4LXdTBln1JynWqdpfUfXAYAQZP+dQPvSoTfLAtaypCymcahK5FW4Xaj9
	 U9ELBHPNsSRpq1SPLzCZc7ZmwS9vbv+UFBjsIIY7mqm9nxO9zcVbrBSbTtwDfM/ZKpilU
	 LgENFDIzH4QivUC5C9BTThr4A0D0XpJsAo5IqPRhXsAwC7Ep0MvBtFN68AvT0QqPVBvAW
	 yhhdPZ1gNErTN0Qr+fKqLSC9cY3DC41PcH9nKSYSRIAP05NSlVgzM491N2EO0lwXssw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3OVsQKT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5882E606DA8E;
	Wed, 18 Nov 2026 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3OVsQKT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0D21F00328;
	Wed, 18 Nov 2026 17:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022763;
	bh=OAGdTvfvWZfywh5G7+z+0RV6Y/a6Dnk9dKXZJiqQyls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3OVsQKTDKQE8IHko4dMS2Xp7AM8tm7ZUoJni8nbr9oe/tZSe+NnTQuZiHBP2N+N9
	 yfeZ93H7d2dJ1/65EyDLIoz8eJcPsYnD9eRPWfHSsVGF8ekubXP9GrVpRLbvjIVlFJ
	 iL5oGkv6JcW3Sx/XPcHgj2V7nVJgx03yDvG5SNy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0128/2151] accel/qaic: reject BO sizes that overflow page count
Date: Wed, 18 Nov 2026 15:31:03 +0100
Message-ID: <20261118150126.454397397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Hao-Qun Huang <alvinhuang0603@gmail.com>

[ Upstream commit 568d4cb5dcc5ec4e22975699b6ea67a30806884c ]

create_sgt() receives the BO size as a u64 but stores the number of
pages in an int. qaic_create_bo_ioctl() page-aligns the user-supplied
size without an upper bound, so DIV_ROUND_UP(size, PAGE_SIZE) can exceed
INT_MAX and truncate when assigned to nr_pages.

When the page count wraps to a small positive value (for example a BO
larger than 16 TiB on a 4 KiB page kernel), create_sgt() succeeds after
allocating only a handful of pages while the GEM object still records
the full size, so the request never fails with -ENOMEM. The temporary
pages array and the allocation loop both use the truncated count, so the
backing SG table ends up smaller than obj->size. Later slice operations
validate against obj->size and then clone ranges from this short sgt.

Compute the page count as a u64 and reject sizes that do not fit in
nr_pages before the narrowing conversion.

Fixes: ff13be830333 ("accel/qaic: Add datapath")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Hao-Qun Huang <alvinhuang0603@gmail.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260708031959.966009-1-alvinhuang0603@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_data.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index 3335c92b0d7dc..ebb2bab7a4c2b 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -15,6 +15,7 @@
 #include <linux/math64.h>
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
+#include <linux/overflow.h>
 #include <linux/scatterlist.h>
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
@@ -454,7 +455,12 @@ static int create_sgt(struct qaic_device *qdev, struct sg_table **sgt_out, u64 s
 	int order;
 
 	if (size) {
-		nr_pages = DIV_ROUND_UP(size, PAGE_SIZE);
+		u64 nr_pages_u64 = DIV_ROUND_UP_ULL(size, PAGE_SIZE);
+
+		if (overflows_type(nr_pages_u64, int))
+			return -E2BIG;
+
+		nr_pages = nr_pages_u64;
 		/*
 		 * calculate how much extra we are going to allocate, to remove
 		 * later
-- 
2.53.0



