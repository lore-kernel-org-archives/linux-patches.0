Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023861;
	b=UWbbPw32En9gUq4l2L6/I2BO9J0t4j9hA7OxZZXS/32Ok0GxFEW+6xtwY3iqqZqLtm2o
	 2F0dypiVUDRUn0EnSZ/adidbOrs1858j9FHYoqdwsHzqFCJsdnkGtuDiJy8yt9s3DjmkW
	 7DhYSeI6uoWcI1T/Ex2k9z4QzXJH2NNGQMTV4mRJyD7MVPE5wPf/UVmZlSqV4A3BX4AMY
	 JrMbiJeK1DgiqNq3E6Q4L4+FO0mmcSodBSTQHNRM3Tg0EOSZSK/S6UsjcM9BR/lecg9ye
	 v1xWFxHhXGIfODjX6K+VYpw8GNTmh4+RFzYlW1/uuXm2tQBFkVQjcw2Q3ZmIcHay+PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=k947mV2DaygqV0wreWrYQYjS0WnTH7JcfUjY2ichPp8=;
	b=QkgkiEeAzomWH+lSYnYSv/gK9p1Yj0YDrONcNdkIU/AiQV46eWERMAgzbBnAx//R+mGM
	 k8r5cRHVBC9K+zHBES5CFHuIMNpY9qvFGpPhwht7GVgLeo2MdANwxiiORziNb+cqLivEx
	 2pjQrWbnCCFJZqBJ+NE1q1Q6PUm0fSTG4CD1SQQ3UalnP6T7P0p/FvsSFm6nTTGdn06T2
	 ULVkPcCUrI9cdFqv4r3ddQfM3VxRy+wZlbYkITO4PVv1mE7qLDPkozeWn22Sm9coQ/vH3
	 VUyLUyLFIuvqOvp93KncygQ8Zw/jpoCmIylYem6A6wFBB62ZPnA4irSwGl/d/09rcmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kl8FZGC7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E38A606A31C;
	Wed, 18 Nov 2026 17:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kl8FZGC7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395DE1F000C4;
	Wed, 18 Nov 2026 17:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023860;
	bh=k947mV2DaygqV0wreWrYQYjS0WnTH7JcfUjY2ichPp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kl8FZGC7Dyr7W/ReGU5fGMlbwPzzMOgKvW51eKwd80RNZXSeh88AetPPTmPiWJ311
	 VnAWnfu/4iQN0kc3YTzImi3ulzdYJ+63DmMDxMlUCsMRcvMr0wc6BkGQgz8jRqTBkJ
	 qPiBBTUGt/oQHr3xskPUtXrm5MrsxRl2CMUPQpvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0479/2151] md: reject v0.90 arrays with too many devices
Date: Wed, 18 Nov 2026 15:36:54 +0100
Message-ID: <20261118150139.467083598@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 1a33a379e67853d6d778e6e80b214bdf1208f6f8 ]

The v0.90 superblock has room for MD_SB_DISKS device descriptors, but
super_90_load() only rejects nonpositive raid_disks values. A crafted
superblock can therefore copy a larger value into mddev->raid_disks. When
metadata is next updated, super_90_sync() walks sb->disks[] up to that
count and reads and writes beyond the 4 KiB superblock buffer.

A checksum-valid RAID1 member advertising 64 devices can be assembled by
mdadm --incremental --run. The first write to the array then produces
out-of-bounds writes from super_90_sync() under KASAN.

Reject device counts that cannot be represented by the v0.90 format while
loading the superblock.

Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://patch.msgid.link/20260820210703.3035608-2-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 937a2f4da84ba..8b750af486b69 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1393,7 +1393,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		goto abort;
 	}
 
-	if (sb->raid_disks <= 0)
+	if (sb->raid_disks <= 0 || sb->raid_disks > MD_SB_DISKS)
 		goto abort;
 
 	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
-- 
2.53.0



