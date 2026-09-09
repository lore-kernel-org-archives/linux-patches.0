Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30DD563FBF;
	Wed,  9 Sep 2026 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962298; cv=none; b=vF9M3kTA+C4BuM1CA41qiEjEC+Ob/YDLvRG9sYm2iftDRtlLrhIbTBn7EpPMFsRpKx1dbpcq33DptrttCfPcmpIDDSzBM0JP/OdUb8CiFXWG/SjmCvcy/SWXc0e8t+wVLEXcllpl+cwN7O8HF9p/3ISAlFSCC6ka4a5S0arxIDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962298; c=relaxed/simple;
	bh=PJyVAPUdzf+iPTokN5wbWjaI9sW61PgmdJuxT2p08Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hf1qWbuDBnGUhH/ombiior1ARdVamx5HpVmFkDaX+XWjQB/wb6c59RCN6+httPF95Edov6u/q/YvIIeJMEV1/SqRZAMPqo3brYdyrlSfAz1JgVuCZGtm62G8C6ytF8SEL2LyqRmkFMO3+oQQP7i68Kf4F8zpcfgUhzPLOeclcrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQDh1VAr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQDh1VAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272101F00A3D;
	Wed,  9 Sep 2026 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962297;
	bh=taXGQgU5aDiq7Mph5QXSfVI2l6KU4sIwalliSshvEuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQDh1VArqK1M7ql81KQMCKl86F5cLOmSET63botey7lmE3M0SiSqDeoRE+VsMAYys
	 SFhvfiYutEZRzDdZQF7mMDs+UxBLE+m6E0oVsTGtCrvSnlQtCY+ZjZo8LzOgBc9kIS
	 1NnFWx/ucKGBWq2qa+goVnHnpW9j/1PCFcyEmkxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 241/556] ASoC: rt700: drop duplicate reg_default entry
Date: Wed,  9 Sep 2026 15:38:41 +0200
Message-ID: <20260909134238.904511656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 90ad6a29809dc53e8c1af23fc51bafe2133da035 upstream.

rt700_reg_defaults[] lists register 0x7303 twice with the same value.  The
identical rt711 table has the entry only once, so this is a copy-paste
error.

Drop the duplicate.  No functional change, regcache_lookup_reg() only ever
finds one of the two entries.

Fixes: 7d2a5f9ae41e ("ASoC: rt700: add rt700 codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt700-sdw.h |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/soc/codecs/rt700-sdw.h
+++ b/sound/soc/codecs/rt700-sdw.h
@@ -313,7 +313,6 @@ static const struct reg_default rt700_re
 	{ 0x3122, 0x0000 },
 	{ 0x3123, 0x0000 },
 	{ 0x7303, 0x0057 },
-	{ 0x7303, 0x0057 },
 	{ 0x8383, 0x0057 },
 	{ 0x7308, 0x0097 },
 	{ 0x8388, 0x0097 },


