Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048328;
	b=nNFAThCF+vD7Higq9a2dfL68gg8zpgbGFjjCq1qZIJZf4Ax/FMcegwBzi8YYyiHRTAsr
	 BhC4hpixgDvklZ3VenXMC6Y7wkr8EM6r8XCAKu/fzslyjUUVhbwKP7MyFcSA1C1SAlo0k
	 yQRYE4yDFkBCQYaXszbOsZQ1LqwLMR59Ne/CKRCfl3JIAzhb0VGAsvUOxOcBv+WBEuFQ0
	 HgAG7zLhWPq+mWYQHCmx7+7ji+xQdmJYIDm1yLQfwDbL321KeTS+aF03TGMDOw7w5Gwv+
	 Y0k1pQHLreuIt50mEG30UHKj1XupTMm5xIJBUmUGn3dSPTF8EWQdDN6UJLUr63iyuyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gzXTNZERmYcQklIKbEKuyzwiYECt3a+uw6yYPoqLNiY=;
	b=JotBUptRpTUGWr//8fYe14+Q8PXise4f7ggnUfeSiMyRkFlrdbJlvsIYVbO9DXI8cwNw
	 llXuNU87Vdf6/n1prwehLeUTd/nR1eAAamZNqxF3ZU4Lzmx5WTZAoUdpfnCgKA85QZiyy
	 n/6NGRSEueykq/d8mSS03rSYZBcx/O5Q6JLUZX6eENVq0TIIgY3sZpKhpGAlrcFfEW27c
	 +sg7r6pABL6vSqgjqT8UL8/JjwHlFVDbJ1+4K0Fr9qmlDzQ2MDeNEmZZoS8G2cLIMzn46
	 cc+hQCApg9YSwD06xLTbjKR/1gasm6Mt8wGzkTlwTbq2km11nb3iq517KZEdrSbWOtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VuaKLJgk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A01F606A335;
	Thu, 19 Nov 2026 00:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VuaKLJgk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2771F000C5;
	Thu, 19 Nov 2026 00:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048328;
	bh=gzXTNZERmYcQklIKbEKuyzwiYECt3a+uw6yYPoqLNiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VuaKLJgk6Fdj0PYkOh80MfWaiYA9vW3eacqu2BKV0CYQyGZZS3Xic6XZPIE6qyTlx
	 e+XwiRuBLrkNPVIgJu+UCykJmzQlm63Pvyv9Pp3WWV+zEdZUDJeo/SOlpJmkbmfjJv
	 w1Pz+h+rpGYdiTMKf02hyTAftEuw7y4A8TtYqbG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1956/2857] md: reject v0.90 arrays with too many devices
Date: Wed, 18 Nov 2026 15:49:50 +0100
Message-ID: <20261118150311.836824251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9aa635e289c3a..8c2c52ac8e01f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1215,7 +1215,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		goto abort;
 	}
 
-	if (sb->raid_disks <= 0)
+	if (sb->raid_disks <= 0 || sb->raid_disks > MD_SB_DISKS)
 		goto abort;
 
 	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
-- 
2.53.0



