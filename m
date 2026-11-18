Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053287;
	b=qukwlp+Tcol1rsVFMebyVXkKMre/96jgkH9yDQWTkHzLRhbnBmupaJwBa87QzLWNMjUr
	 TAsGBBxIrJgUteQ03zSAPtBtXd3ZVkLf+Rrnqx6hIEpndCyZKoaeFy2udncWl9z0pc/cA
	 NLyDjRyMMX63oGJkKi9umwkDjFk1BGkjYxuo/L7nEAKI/SxRi/BDdk4Wy1FXDcYI240Qp
	 fx8ZRWL+K1+8NvrM1jwwTH3hCI3iE3Nr7IVRCzs1iAyevAySnyjA6CJ01TsDA9ZBz42aV
	 ibcZI7D5dF883GtHXBEkLQSX4sPl1MteJTTf/VCmlwhYd2xHqOwRRXKtOd0eU76KSEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L3dy09w+kxXYB6F30koEEgOmKUIlr+94FxQVMYTDsVY=;
	b=MSwf6p9j1+7BbVyRnMV6vC3XtohfwHwpvWflM2g5bVZa2bLT05RdsOCFWB0PubTuuoPb
	 alTTyAX4+G8VqIHYuTIxjk5ARdGk+CScy8WOXZpu7gf8k43ECvS8qw5wux6G/umoikgi8
	 1UkvhmHIXX2I+5CGcHxBeSp5r8hw+3scuikuqw5bAVMEPWWuD+SookoVBeQIU/1VphOxf
	 2Rpm3uy+1h1JcV0wRmlnhPltYyO35BWwGF1eFyK7R1g5BnTWgQD2hDMVt0NclHbRx9wy2
	 Di7GumvsAV6pcWjn4MNRVHX/loT3ifAcxdW5b/KM07qePNrPZMfuXZ8D/8etdzuwLug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XGPMHTuJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8C4606A336;
	Thu, 19 Nov 2026 01:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XGPMHTuJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097871F000C5;
	Thu, 19 Nov 2026 01:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053287;
	bh=L3dy09w+kxXYB6F30koEEgOmKUIlr+94FxQVMYTDsVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XGPMHTuJJTXb6K4guEwnLftNxdf0os7yvtPTX/x+B3uJWLN2yuMCD9T5ATFA3Ks7V
	 qTf3SZ3zdbp1KmlkoX8BRErSkSVz1aWXr3SbRF7nihSFsLm5QWW7Rtzj8zc/QJYq8o
	 U5iF/445nwbbocgeiDqV1qMjPK4G0CSGtGr90qLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yongji <xieyongji@bytedance.com>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0866/2214] vringh: bound top-level re-entry into indirect tables
Date: Wed, 18 Nov 2026 15:42:22 +0100
Message-ID: <20261118150046.784332337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fang Xieyan <fangxy@xiaopeng.com>

[ Upstream commit f898439ace7f89922e853b43bcbfcd26ea2e0a98 ]

In __vringh_iov(), the F_INDIRECT branch descends into the indirect
table and continues before the descriptor accounting runs. A top-level
indirect descriptor is therefore never charged to count. If such a
descriptor sets NEXT to point back at itself, returning from the
indirect table resumes at the same top-level descriptor, which is again
not counted, so the walk never makes forward progress.

Because count stays flat and indirect_count is reset to 0 on every
return to the top-level table, neither bound in the loop check trips.
A guest can spin the vringh worker at 100% CPU inside __vringh_iov(),
an uninterruptible host DoS.

Move the descriptor accounting above the indirect switch so that a
top-level indirect descriptor is charged one top-level traversal step
before the walk descends into its table, bringing this re-entry under
the existing vrh->vring.num bound. Each top-level descriptor is still
charged at most one step and indirect_count still bounds a single
table, so legitimate chains (including the multiple-indirect case in
tools/virtio/vringh_test.c) stay within vring.num, while a cyclic
indirect descriptor is now rejected with -ELOOP.

Fixes: dbd29e075228 ("vringh: Fix loop descriptors check in the indirect cases")
Cc: Xie Yongji <xieyongji@bytedance.com>
Cc: stable@vger.kernel.org
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260922122955.69433-2-fangxy@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index e478a2c88f95f..37b4ca96c5276 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -334,6 +334,17 @@ __vringh_iov(struct vringh *vrh, u16 i,
 		if (unlikely(err))
 			goto fail;
 
+		if (up_next == -1)
+			count++;
+		else
+			indirect_count++;
+
+		if (count > vrh->vring.num || indirect_count > desc_max) {
+			vringh_bad("Descriptor loop in %p", descs);
+			err = -ELOOP;
+			goto fail;
+		}
+
 		if (unlikely(desc.flags &
 			     cpu_to_vringh16(vrh, VRING_DESC_F_INDIRECT))) {
 			u64 a = vringh64_to_cpu(vrh, desc.addr);
@@ -359,17 +370,6 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			continue;
 		}
 
-		if (up_next == -1)
-			count++;
-		else
-			indirect_count++;
-
-		if (count > vrh->vring.num || indirect_count > desc_max) {
-			vringh_bad("Descriptor loop in %p", descs);
-			err = -ELOOP;
-			goto fail;
-		}
-
 		if (desc.flags & cpu_to_vringh16(vrh, VRING_DESC_F_WRITE))
 			iov = wiov;
 		else {
-- 
2.53.0



