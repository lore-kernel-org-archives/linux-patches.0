Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055119;
	b=nIFu6U9DCPkDTHVnC0/4EI67FNH31Jblfm+dLJchn/uVkEGBGkUfBTb6mo14aENL9A71
	 YaGHIU/bCXvymhH2ap1/y64eqU03pZhnsMeiTVOCOnSw8izdWEsiHIjwZP8aIhF2AHrtg
	 pABjML05RYijPdcGg3jVVq+IHGkC2e2QqKbS9q8hV+s1ulVTdgLQCcv1GYc6m1YKV4UjY
	 clpVMI0V+VAqWUhCEZtYfW59ab8w0CwXtpzo1xkOzEJTUian26DiWut/0lo77HM62VIrO
	 ojLR1rgpuiePtNFUl0AO6f2SazWyvtDa4qeoTM5dQsNq4tpVWwKR+CNVUtyjRAtj3Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PPRWg6FdZWRYACR94p4Wlw3ZA2xDumRHp7NgBKWlouA=;
	b=ac1FGd+S7mfXhCpE9oALDo/8CypKidt0XYRAM5Bsw4aF2FUDYhaiT3O7LhJTcvw1adSv
	 Kkqz+9dFuLJZEt80jJkFlKfWuGmiJmcvpeKWchkCuDYnLefuvKRdB2NQ28aPGw1m6AOve
	 AI/3h/w/2imBlSZEjJtvdU0z6uMGBybxqZonMp3vUnGwS6IyhgqAqiXO3Xulmh1A7G7fN
	 JxucA4ddg0KmaqpPsIo4bl5n3YnSXYpwXkqnSvg4SEMdP6Q5hWvHWxjJwhkTf7Bzf9DCM
	 ev/oGO2xzf0JZS+7VKMXMqxoYdBRZj1m2eS9OMwBbmR11Gn+sVJ0WyJW4+ayc9HSx/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TMOrgFH2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E78606A325;
	Thu, 19 Nov 2026 02:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TMOrgFH2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429111F000C4;
	Thu, 19 Nov 2026 02:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055118;
	bh=PPRWg6FdZWRYACR94p4Wlw3ZA2xDumRHp7NgBKWlouA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMOrgFH2cm7Q5G0NMlJchA9mFOw298sGR8Xe2gVIBye4V8+H0RNVLMxNZ6ZsCB67e
	 XPgcfy+Z+PnkQYOtjYOnmQlGD6pK9NRKLAjtJT5YtatMuRei9Pdc2Ca259sTHByP+u
	 d2lmyUNEl5gXXtdLhA0XEp2sjjMiUmLQwtj+B7lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1518/2214] md: reject v0.90 arrays with too many devices
Date: Wed, 18 Nov 2026 15:53:14 +0100
Message-ID: <20261118150112.795596678@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d86c53606ed1d..bb3d9c52202b0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1229,7 +1229,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		goto abort;
 	}
 
-	if (sb->raid_disks <= 0)
+	if (sb->raid_disks <= 0 || sb->raid_disks > MD_SB_DISKS)
 		goto abort;
 
 	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
-- 
2.53.0



