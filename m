Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016544;
	b=aVc3LbUGoXWJ2h8UNH0Xcni0iWqNY+oNf2fy91B1DYJvMczV4cTD2EKiikqW3X2zCCaG
	 qnuCrA9Vccdm5ndSA+bVuEqD0rMLSr3U1qXPCxzrav6L8gQbM6k7izDjAvXbAFZmnj22U
	 Byz59EzBxycU51gcPcyIXFYsKQihtP6fzDK4x+2BS6hWL3SfbkT6gVZDwYt08uZBSBjUh
	 JKun7TzMgx+vsd9WuylkuNTEhm8pc4ByxSDo3rgTvN4Lg8Ep/bEUx7XoBGMs+tWiLyA4r
	 0phptPAN3+jcWd85Pu01gcZUj6vUpqakMvD13J0Ou6sXdvaMUYTlGHxg4PuTcXJKGpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=prhJrcHS3ASyyh7Ja1u99KEtkR7KwEm9VXTZCH+YFrA=;
	b=vZDQrtMsP3yU5JQWz2xnHLGj85C0cVYffDv3dNn9yjjPqQ6V7fTSTOm74NKK4qCOS1lF
	 DgZlm0aCRIm7yfj3WwAJ7cgBzcPWU5TnUNmMc4B8ePmlSmGgCZciuFgEwQTppEAxM5l4O
	 LUmq2VruaIrG7+kRnZWh2gz7vo9+q9KqFiOgqgQb40OBL+pBWVHOCWQFbGwE/EXNB9wiW
	 JfeotwGZzuow/4yHbtWjxjDHNcGpUmv9Fk+8ZzX7eUsUI/epJx9NjJgOSfH0ScfA/z5jt
	 RyG/e+KDO3q0l3Xhf8LYCZd2S+cVzJv2UYhk1Iu05+tb9jzMEswDd2PWG+Od/BdKEvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J41U57aq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC22606A331;
	Wed, 18 Nov 2026 15:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J41U57aq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62FB1F000C8;
	Wed, 18 Nov 2026 15:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016544;
	bh=prhJrcHS3ASyyh7Ja1u99KEtkR7KwEm9VXTZCH+YFrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J41U57aqFooGAXazUz92Digr5AunDsbczY9V2yUbeDt6ImN1ZbeIUZpaxUVNW+gz6
	 JLTpb6FYtLZ7liF1Afh4qaNwCTBuDasbjqu2MW3d4autO1H9ve1BcD19vE7nk7NHaS
	 dS2WYeb2A5LplyqFy+deb3uiAxb6VR1Auf80Xq4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0513/2651] md: reject v0.90 arrays with too many devices
Date: Wed, 18 Nov 2026 15:29:13 +0100
Message-ID: <20261118150306.219275840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d8ecf76d4a5f1..ef46a7ffeddd2 100644
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



