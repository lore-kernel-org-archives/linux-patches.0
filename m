Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031844;
	b=Xxj53TR5vNtXtyk9mvrkFw8izIXRagvhalo/ZKzWlGc/rc54DQbFCyFWtWazBnyU/fYO
	 6iCWRGKnKA17bTMTsvb7kYAEVwW08p/gg24VntxjfcuTNRauIosO1eEE4uUbSi4V6EQ+u
	 kqEA1E+fuQR2NUyNhBrVs2zLvKuw2LCaU0o0aXDjBjTSbnPbllzJOB54Y2l2gwk8EDIEE
	 7SMRRB9OOtJ8TJV2+XO99KTRFzK7BWMOIEnFt/I02mtk9ODhMDC+8qmTx5u3H+5UxndGb
	 QtjpO1pbuhlNgTRtny89uW5g8vHov5Guxxh93Q5jjcnoWpg6ezgPGozpljBW3vKIhjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HjF5WBcdFZnIOn+Exv9c4swMixIZIPj+YM9gKz2RVmg=;
	b=sr/f+vqCYGHgLpwUjae9Wm2tKQjX7cxlwtNXsXkKlbkBzmEdKSMMxopKy9xfo+/Tuo+6
	 ADi+RuJqWJUBgI1mLxwoAo9YSv3efVA3KPc8BE5DBWcARin1DyQoArA4ytaBJIj6LfzfD
	 UWazyHe8Z+bUmKnu9jY8Klbh4ri/QKI9yIalxaxiPErRGXmng9x0Z7PhlDlynsTUNbDYE
	 GEXxYl0zFMxO4xhg1NMXVmUwlIXIC8i3mrVIJrjpflNE2yA0Cohfu97ahc19b2yrRU4gb
	 3cl6q4W0/N4pIJMAs0hc8ORkyGdog/SO92LZq0w9+Kf2tIz0qee2kVyOKb4UuAHH0qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AhO/fsQa";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34854606A31C;
	Wed, 18 Nov 2026 19:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AhO/fsQa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF0C1F000C4;
	Wed, 18 Nov 2026 19:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031844;
	bh=HjF5WBcdFZnIOn+Exv9c4swMixIZIPj+YM9gKz2RVmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhO/fsQao/X0bnpunP7aL5G2GvlubkWe300UnWcdTkaOa/Le2wtK41qKmUFVg4okI
	 6WknPauRH/zo1QsoHYtTLMpqv7rawupKU5EE7BNpUemPS6sTkgop7FeNMG9RqPytlR
	 O0mZZfeLiMRlESddpqV9Wjc2DpbIG8W/nzI77qww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1202/1756] ASoC: codecs: wm8955: Fix definition of Treble Cutoff control
Date: Wed, 18 Nov 2026 15:55:29 +0100
Message-ID: <20261118150057.691703851@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 71911bf5bb3fe97da2124d17fc1dd3dbb9379e03 ]

Treble cutoff (TC) is at bit 6 of Treble Control, not at bit 2, which
is part of the treble volume (TRBL[3:0]).

Fixes: 54db41c116c3 ("ASoC: wm8955: Use SOC_ENUM_SINGLE_DECL()")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/b398bc6dcf8dc2b93504608cdf952823ca238cd5.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8955.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8955.c b/sound/soc/codecs/wm8955.c
index bae52a8a2e117..c0fa295dd7375 100644
--- a/sound/soc/codecs/wm8955.c
+++ b/sound/soc/codecs/wm8955.c
@@ -426,7 +426,7 @@ static const char *treble_cutoff_text[] = {
 	"High", "Low"
 };
 
-static SOC_ENUM_SINGLE_DECL(treble_cutoff, WM8955_TREBLE_CONTROL, 2,
+static SOC_ENUM_SINGLE_DECL(treble_cutoff, WM8955_TREBLE_CONTROL, 6,
 			    treble_cutoff_text);
 
 static const DECLARE_TLV_DB_SCALE(digital_tlv, -12750, 50, 1);
-- 
2.53.0



