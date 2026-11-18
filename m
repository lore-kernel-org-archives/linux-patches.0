Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060626;
	b=dHdVvjiV1Jgvig5TMksiwfbs9VNC2UihP0NgJFacCjDHSN3A4i5F1FMqlLypzCp3Y0hS
	 DrVYA8/FwDAhhrBHJTnkwRXlWSH1OjOkAtedqm8EpckXyZuEaELAaQrIti1nwMnp0y3Sb
	 3BSTZJUyBKZUccsE7JnKNM0l4ApYQRGKYCL+HsNQ7ewJiL2Lu/jKVniROXkXU76drFRAu
	 IxHGR5EpJuiVcpo0v4UVfnjbm51vna7eMAutgo1JZX2qHFZtVuK+RF09MAjEnimcDl24O
	 f89RbxEjj9JOFJ4Lx53OfldQIVGdS5ayu4qcO7mdeFwshaoaHY6j+M+Yyqz9zWh71Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Z55F+TMsN7XFAiHBt5yx9Poh++m6Kz3xF2gmrOS3f0g=;
	b=FR/RiWG3cVox+pAm6FA1Qm2RensfSzAj2143kyZ5m7MR1LIhHhKCdgG6Oal6bbv1f5L4
	 aBl+2bEk6nppDYxPL5sCBYpNcI31bCplKm0jkfFSAQP3eqsqBNui34isDeLs3w+00AJLc
	 y53Z+cB2yVMkepPidCA6+lISHlQlYYqyeO8qTnM/mvgY2rmElpmw6G5Ejht3hXfeJVTMT
	 JGy30BJd+cGxVldwydy6Ytv0S1niKpBSirfh8+wuMRfECwpH5TW09SIhA6sXoPX56x7sB
	 vED7/xLcJf85CmXNFkmQRdYbwGZ062tSQ0WsDVPv9M9D40qnhvsm92BlczThk6hHwRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VOiAyOOO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8AA606A326;
	Thu, 19 Nov 2026 03:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VOiAyOOO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145061F000C4;
	Thu, 19 Nov 2026 03:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060625;
	bh=Z55F+TMsN7XFAiHBt5yx9Poh++m6Kz3xF2gmrOS3f0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOiAyOOOecX8xgsLT5a9ingHFk/0jenAmtIhCH/JC1NfDKb/r5PR+VQx0VBYWr/xW
	 c3z2vggnNVwrznP6RydaMUeNx0oPS9ECIxEbMvsZZM+7CbXZe4abv6AA8qR5ZzT9AX
	 ZpqraOzzojMV9lkL8oGHrx4TiAY02Oyxb3vgDfjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1266/1848] md: reject v0.90 arrays with too many devices
Date: Wed, 18 Nov 2026 15:55:04 +0100
Message-ID: <20261118150012.684933560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 99ce84d296555..ed528f3c778ef 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1246,7 +1246,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		goto abort;
 	}
 
-	if (sb->raid_disks <= 0)
+	if (sb->raid_disks <= 0 || sb->raid_disks > MD_SB_DISKS)
 		goto abort;
 
 	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
-- 
2.53.0



