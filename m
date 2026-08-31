Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE1E45516B;
	Mon, 31 Aug 2026 13:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183269; cv=none; b=E0nM/buRBJlGZ5ZlT7X1PNIsYx3A6n8rd0ZZBluWthozWkK3uMi+a3GU62supsjpS7vZM0i7wrjGrxJ7CwoxibrlXgbOHvF/cIPE7HmkUqNbB8k+ixLTTYctUcsfP94puxTjnhiWmQKi4of3Ya3olXhJ149ZjK6yb2hUaeeTTeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183269; c=relaxed/simple;
	bh=XRay3Doli4vTKPbKTg7eZ/rKosWN5w62tR2S1jg5ynI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hH6kPPJE1uEWRE3zq6SqtXK+mp8ZkSkSTbfq1BdzFHsGYJQZtY5iHuZ5LymUaO/j6eUhWnMpI7oSn/4sf139I4vhQBZukfC/d2k+yeZ2VXjcd0EwrTidNrUJVWlHxrrGkBeDI+MfRqFbw/ZRp2hUW4aykeAbFMcj1WZ/86AgY2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UDuvXzxn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UDuvXzxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0641F00A3D;
	Mon, 31 Aug 2026 13:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183268;
	bh=Hj/Sru1MpYmSqAf8IEAHEIQKz3XLgAISvfBzl3Dvexg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UDuvXzxnS+sA5rZAGKBbcmGpJOoDBYgC0G09hXfT+X/p94Vr1jlkgWPkSeuXq53FR
	 4gtes8clHPvzhBI2KbmY0GkrRpfmHujaoabcLEyIrjcALCT8LZ3uZzMQcTid2R9YyO
	 b6CYsqd1K0q/sW4Yc33rkjUEBazw3fim0eZr/yzfmpX5DU+vlcQfNACMnYezY/n18Q
	 p4dFxM0PesGL5w/urL7sGzDizmMygPSas4XulBxZ4JPu9icyJ+po2CpWMjZooT+cKA
	 Kq3b1OHMFAxxrFpYul9uBT9PuXsXlws4ylCkDb8tZRW4Zb0he4zjcp4y7mRToxgsl5
	 NGQdRP2KVWayQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	nick.li@foursemi.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: fs210x: Make cache write through again during resume
Date: Mon, 31 Aug 2026 09:21:14 -0400
Message-ID: <20260831133314.4125787-46-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 7dcf091da4b4596f7dbfb403d946ee4aac423af3 ]

The fs210x driver currently puts the regmap cache into cache only mode
during suspend but at no point does it make it writable again, meaning
that device can't work after suspend other than basic powerup which
bypasses the cache.

Mark the cache as writable again when we resync the registers, it's not
clear to me that the cache only mode is needed at all but this is a
fairly minimal change.  Since this is setting a flag it's safe to do
even if the cache was not previously in cache only mode.

Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260715-asoc-fs210x-fix-resume-v1-1-dd81d9c62c05@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background check finished. The original mainline driver commit
(`756117701779`) is **not** a git ancestor of this tree’s HEAD — typical
for stable backports where content lands via cherry-picks rather than
the exact upstream commit object.

That doesn’t change the conclusion: `fs210x.c` is present in 6.18.44
with the suspend/resume bug, and the fix (`1b9e1abadee04`) is already at
HEAD. **Verdict remains YES** for backporting to this tree.

 sound/soc/codecs/fs210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/fs210x.c b/sound/soc/codecs/fs210x.c
index e2207c53c50d5..caed2951e23e6 100644
--- a/sound/soc/codecs/fs210x.c
+++ b/sound/soc/codecs/fs210x.c
@@ -607,6 +607,7 @@ static int fs210x_init_chip(struct fs210x_priv *fs210x)
 
 	regcache_cache_bypass(fs210x->regmap, false);
 	if (!ret) {
+		regcache_cache_only(fs210x->regmap, false);
 		regcache_mark_dirty(fs210x->regmap);
 		regcache_sync(fs210x->regmap);
 		fs210x->is_inited = true;
-- 
2.53.0

