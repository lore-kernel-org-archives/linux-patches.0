Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061824;
	b=RgFSYUF9itHBFRS2UwF73LRDFel2b5ehgNccpcFA8ajXZIEB899QvUxh0P0yi8lNJtQp
	 mBHPdV2zt0crkxjudPTxXZuJMEfRHLJeaNi1479jm/ruqgsqU6ABdjKITNmeNjPNYW15s
	 k3lgGATZ8NmLjCCWkj9c1mPeGdB9gaIrB4aat4suWZiClUhfjSpGoTM4NCm0wMWN+mXSJ
	 csvDE9DsJ0WCjNGoNwsHMh85osmxcNtLLmmENQHb81zlwbr5+nUVj2BqLMhaXCx5mbwdT
	 nP8uYvASZbEE8hC8fApf9yuHH/E7cmQMuk0YJ5UBlrqxugZp8fr1rihVRH9pAYeUIPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2spbn9r7Hib7MpcYa5JLKPoqY8EnwsOssTwXt6J3ga4=;
	b=cO/sdphhLt/e7nYCchzGQhX1oZWLLTHVHHabONupePGP3QAO27EVRPPbDHhiE8hdLXKP
	 AjlwAy+PRQ/QsmRczKxNPCYs15nqTN5ksWVcoPM/2iVFuDFSPE+GKGqqxIjg6L0R9xgUD
	 YCqKQoBQTe3LAhaHP9G9EW/IOoJRwAnf2HFvVmjwCbOL4CruF2XqSx4v6ixo/0jVA2fpR
	 a9YuGaxOXqO4N3mNiUhsNkMRebVTw92sQnSRYhEMvm3BY1SGiRkqJM931QuCblicz7UET
	 /GKcBgdfoYBe4hBgI/lWYs3R0D+onbz//kVUAj7fnxaHG2aZwGynTyDFV13txtFH1rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1metneqM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2C5606A325;
	Thu, 19 Nov 2026 04:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1metneqM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE101F000C4;
	Thu, 19 Nov 2026 04:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061824;
	bh=2spbn9r7Hib7MpcYa5JLKPoqY8EnwsOssTwXt6J3ga4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1metneqMzxYaqgG788HJ2NoZ9DJnVgy6/5vW0Lj3ACY/ovCj/dWnVaon3UCn+AO/b
	 P8M+XKjMISau90pJNJhL26liHq3bK6Uy//45aH0g0XTbj0p1Qb77Pt1ZT8kYqkwX9q
	 Rkm47PHysP1QFrgGJHfuNi/idSF0jWmOWdF7MXZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1639/1848] ASoC: codecs: wm8955: Fix definition of Treble Cutoff control
Date: Wed, 18 Nov 2026 16:01:17 +0100
Message-ID: <20261118150028.266072854@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 513df47bd87d6..2b34a5d1100fb 100644
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



