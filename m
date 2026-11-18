Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039832;
	b=MXUim1k85vcmxslnVTxRIDQ4iJmi/u2ok72Sr7lSBWE4zLtAiRqK3HuJvGql+fBiehFe
	 eevDA3YZmrsMzbjQEJb7WxuvaGEoY29ZEO9MOQPRGDBnggpX9Ca19Sl7bCp8mUqKpqZHY
	 ra3Hbp+w2pikl6c0im1kGwgOrahbBS3YTLEYxbFxhC+0TXyypPjQ7BoqGGxlW7pTItx6M
	 TWH7C4SjidjQzelm7puh5hLQ01t3ISd3Mg6uDWLeTyLO7ci45T82nV1DY8QyuNs12VJSK
	 LXwRfailA4WY84r4ShYd2lk5+IHBJj6sKE6pB2aCfXDvMXuvcEdW6j1q5neTQD2Qotw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tSSeCuEZQFKK7i9Pw+LeUNPxY0syE9MCaAMa9iMSZlU=;
	b=DeuXUUjx85/j6ihY1g4c29dpInTciD6Pqd52O8QzfBI9CkPRvPUND6gqqqTEFu6kJ93T
	 e1KvzcYlo5pdAPyNvVfr//rnFzE3EbpFps8Lq6gu0SQQrNlJo0ZSLUbByEIAQLq+PYWCM
	 A/0RU7gRlCi5TBR0frPa+AXsLsruPjgYgQQZsynadd6/t04h6YAjaLm8oCx/sxNVq3390
	 /snqAPsgZ6++iyT49QFmp3vYiCAqaSqA5moqUuFrcW5IwiteMUVEWLAskQzVPoG1jQO+t
	 HvgvcKQ/yLcE3LcbzgDI4XZgWsWwFtzXe8lqHiZlR6RO/EGWBtwFhiKAE7X7SIlO+aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jSvT08oK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D50606A31C;
	Wed, 18 Nov 2026 22:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jSvT08oK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BF81F000C4;
	Wed, 18 Nov 2026 22:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039831;
	bh=tSSeCuEZQFKK7i9Pw+LeUNPxY0syE9MCaAMa9iMSZlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jSvT08oKkarksTmcvUaIW0+vfYQNxxdyH1ZOy4w8+KPaKUMeHxKrPC6QuVU0+ytfn
	 uQRfkfXsJLXgzd4Gv3/yrfwMYT0qdwHg9YEZAhlWlBjom+Z2axnMf98vXIz30zAkg6
	 Np/mZlQIxaTo5HBJB0qCWzRwa/w2wyUaQqs5/eYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2242/3318] md: reject v0.90 arrays with too many devices
Date: Wed, 18 Nov 2026 15:47:44 +0100
Message-ID: <20261118150429.112420528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 91eccc10a8d62..398461e01273f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1317,7 +1317,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		goto abort;
 	}
 
-	if (sb->raid_disks <= 0)
+	if (sb->raid_disks <= 0 || sb->raid_disks > MD_SB_DISKS)
 		goto abort;
 
 	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
-- 
2.53.0



