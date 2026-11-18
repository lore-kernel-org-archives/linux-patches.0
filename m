Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033238;
	b=rB4SPzP9GG2RhduuH7eRolb7gcCd8KhFnNAHKHkuLmFNIY7o2E1tjB7omJ2cNGlvM0Hr
	 JPN2jwHU6VRH2f30iqUlihddns4UqjFAH/y6lfT6/cuy4vKndHd5cor6zEyYXgi7iYpnX
	 2oDQ8CHbiQgLiiKQNiXRXfymnsbNO+Xlr1PmKQo+nfqVYf7hV1eoNVEQLy2j9gPbMBWea
	 wHF107bIiCBdkwMTnRUkqrUaPmQXJAXJkuzGAcv/1nzkXP1I5phL2KVUZbUKmKLgTN8bd
	 sKc1orNwJQtV2rOz5IcrMOrvoiru41vIlFWvHMuUlzgRdASctyZ+OKIaJzvP+QOWxSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/2rYyajuAv/nSWWAYzzxH631YJ9D3b47iHxWV1nIFe4=;
	b=K6R9eLtFRAGylzh9OZbKWs8ExowU0MnuKBcW6hjDDenJwPd+O+oYME9/iPQSkCwgQjfU
	 b4BG3CdL0fyJzbk5o1A0U9JJl+E0tf/iPe0D1GPAm9LcfD67wRA2E6Sa/yMHjwcjEd0aZ
	 PB31psk9erwlRww5EvRJFyd2JPrjjGDcBhOvj0hfxc15ZAbYiDWiVPXXEzJVeZ7/mfLH+
	 8SeCfio9WHZYeqXKW5yWNJ7c7K+nFRVqzN2UcxldHePsuiuRLCSq8IWgKzfmtyeEsnAW8
	 ylnu5q8o9ACvCONYXfJbY4agqByNDULopr9BEAdnJm4ZarBbnBTo4a0A00jHZqRClaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r3OB0UQw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BAF606A337;
	Wed, 18 Nov 2026 20:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r3OB0UQw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDCD1F000C4;
	Wed, 18 Nov 2026 20:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033238;
	bh=/2rYyajuAv/nSWWAYzzxH631YJ9D3b47iHxWV1nIFe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r3OB0UQweqCGVGJbFJDUUJjglTUadhUh8kOkXZ0zWCAbraQBQ4s04gTfblhSerAto
	 AMIIR+MCaKrQL8vEQw3arBf8Roow3Rkr9V1utuHbUH6twXTjb4VWRiyZ3d1k4C7ihn
	 14UWyuA1RGtlLKpdZV6t/nJrCr7n4zULE1L2qdMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1644/1756] blk-throttle: pass the I/O counts of a dead group on
Date: Wed, 18 Nov 2026 16:02:51 +0100
Message-ID: <20261118150115.205639049@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 587edb931fdda032bcd63fdfb0db4ded75159ee9 ]

The recursive io_service_bytes and io_serviced files sum up the online
groups plus what dead descendants left in aux_cnt. That worked while the
counters lived in the blkg. Since commit 7ca464383aec they're in the
throtl_grp and nobody passes them up, so the files go backwards when a
child is removed. Add them to the parent in throtl_pd_offline().

Fixes: 7ca464383aec ("blk-throtl: stop using blkg->stat_bytes and ->stat_ios")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-26-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 83b5390be11d6..75326b8d4868a 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1560,7 +1560,18 @@ static void tg_flush_bios(struct throtl_grp *tg)
 
 static void throtl_pd_offline(struct blkg_policy_data *pd)
 {
-	tg_flush_bios(pd_to_tg(pd));
+	struct throtl_grp *tg = pd_to_tg(pd);
+	struct throtl_grp *parent = blkg_to_tg(tg_to_blkg(tg)->parent);
+
+	tg_flush_bios(tg);
+
+	/* the recursive files of the ancestors go on counting what it did */
+	if (parent) {
+		blkg_rwstat_add_aux(&parent->stat_bytes, &tg->stat_bytes);
+		blkg_rwstat_add_aux(&parent->stat_ios, &tg->stat_ios);
+		blkg_rwstat_reset(&tg->stat_bytes);
+		blkg_rwstat_reset(&tg->stat_ios);
+	}
 }
 
 struct blkcg_policy blkcg_policy_throtl = {
-- 
2.53.0



