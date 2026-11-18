Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029674;
	b=v8wPMhuT3waPgUMet7lmZMaYjO0qDpxvzlRSsP4bv/6fYiRyfVtjIazOf65YDCSU/lEW
	 ZUqTZpC2nU+Q/DSbBlulPFCvtmKHn3R4tuUrrwMBxGVgfF89slWOi/5rVsDAsL2IJor3r
	 T3Dd3Ve8AcrCVZC9lK9OJVP6rZwQTQIUjLXkGRuqS+yaAoCiko8iPEhX3ZXxdPHtqmn8B
	 mKWEoB/0EhTVElkYQuQ/KQenMhTRZsgeEaWeFkrsUSexWb5ET4T366OiY0/tTboZ6A8PY
	 Ye1AQNsVdMcrW8WG50/ApXTzO/1cx7vUPAiJpT4+Ua08b0Q1cQXMoY0GmVtwMevTnEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lDyOF3ExVYEE0C32njuU4kkrSGZkOtlL21m/55v9Hkg=;
	b=BkZCzRQ1wbN7SXrMaVfKUBf9NGuECpTFAm2D44ys4QvmiLFGFZ8geUF4F/4hxAHFtVNi
	 LzamNBIrlfHwNbSOV2zKyuuDpm0+Gas7mC/HNVTVes5vqmieaGzIhypZYlvzgZqGalCzi
	 BqvyLlm1qdsu4AD5tnFy3d31MTVpNEA59isjcxKOp1WE5rVgiyd7IAi8mnro7f0F3PFA2
	 dSM1iMbk2rUKQrq22y6Go9SkFgehcOVB4fkP3w2qawY25yUdn16BqvBgTWnw+78qqIHuz
	 Y2NC1hMtQrqfUbhSv3UPuV/9WvP8wuCky1ApZE0JVhTmPcKnE//FGUAWkdSSrFjZ0eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ANWjRk9Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F03F606A32A;
	Wed, 18 Nov 2026 19:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ANWjRk9Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F7A1F000C4;
	Wed, 18 Nov 2026 19:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029674;
	bh=lDyOF3ExVYEE0C32njuU4kkrSGZkOtlL21m/55v9Hkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANWjRk9Q7Lzk0eNf+9VmulpQm2wV6IS2OP3QBVM8FUOkdXMmgcSq6xLJXQfghB+BX
	 8V6pDPAPDNvfRc39YSh2lGJjDitYkpMPi/K2eHIFDkzzc2QSZIf7TFidcquKAgHJJZ
	 Sktp1Ipy5DzvVl5K4IhdtmCaQt8AwcCs+nRc5/c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0435/1756] md: reject v0.90 arrays with too many devices
Date: Wed, 18 Nov 2026 15:42:42 +0100
Message-ID: <20261118150026.064316199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e54fe6f3319a8..c7214157d12ce 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1263,7 +1263,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		goto abort;
 	}
 
-	if (sb->raid_disks <= 0)
+	if (sb->raid_disks <= 0 || sb->raid_disks > MD_SB_DISKS)
 		goto abort;
 
 	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
-- 
2.53.0



