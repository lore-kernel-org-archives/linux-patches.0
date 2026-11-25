Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621820;
	b=JGt5i4BLkq/wvY5tf1mQY+VUmn2O7o7TIsBwCSnekSxL/OCaqWG18+4rqc5q7GUv/KKL
	 r1JeXlpEoApxtoKt8iodRnAYDQol5Xq1xg2j4GE+J29A8ZGTeBnZiKz2ScOSlAT5gBJfb
	 nDOtt2sUzAQ3xidkWU0cUNVxFyRYR01+/XISBGUXYm+PHpkJ4KifAxMt4BHwfjKBRwaoC
	 8FNJFhevl14iemFTufVVium8CeED1E+eGb3dXBXYKHXci+ZezoNwGzTyV7BSzkf1pDqk7
	 XrVyIOfSmSup/wVeqEt4w95z8K+Y/2uQybv8HmDCH378x6ztOcOviHu1qmmckMFfytw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kgNVtEnHcv6uUTMxX67ECgEKacwLdAw4H9CSvcdTw/4=;
	b=AZ8AgTdEGsVYCYfsZ+eqBJLDRZmfWBEVTnxd/s5xBKFMmRPB/rI+W+8OLLW3Esh3SPsU
	 1dRAeMyHyhvYHrJvk2HPOFGT+qIyjLcZ46uUfj6IJr8MdMFsi5zS3FEjWKtmrrfU4Hpvp
	 Nu1OkLcIE58Wg+5ExE2LdN4PJ+D3qLG3ec36D7ARJ25m/tLgbQ79a9DBEnsfiTLnJHhwp
	 qwKgnubFY3nMEQGIsZj9KaMdmwvmvLWNlsPBrrfwA0nbCWWXULbxaZqPNJ+0n5P/hVgTB
	 Fa4upXarYFRrLggd2llVguoYLpzIHBE5olseCjuZCQLMJdwSbtUFynVR0CBXCPVv0hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uHOlcXkE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C84606A337;
	Wed, 25 Nov 2026 15:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uHOlcXkE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31901F0093C;
	Wed, 25 Nov 2026 15:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621819;
	bh=kgNVtEnHcv6uUTMxX67ECgEKacwLdAw4H9CSvcdTw/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHOlcXkEkGc12qV6YCBfLhsIbxz6QM2t/n2BK99g9Dkyg7/QUQl7J5vL5Vj6oz66J
	 mlzsD7SPthZ4JH7DiIxBFbQ/Gn84I8t1AqH3oOLqUPrtKRPRku519FuMDr/dHS9IRg
	 h/kT79UzYcEzzt4/mDpkXk2gCPWA4Hv5YNGbanZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 343/990] drm/xe/tuning: Restrict Anyhit NULL-query tuning to render engines
Date: Wed, 25 Nov 2026 15:28:30 +0100
Message-ID: <20261125143830.127231961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Gote <nitin.r.gote@intel.com>

[ Upstream commit ddef200c67d445f978f323d947c8993570ae4756 ]

The "Disable NULL query for Anyhit Shader" tuning uses
xe_rtp_match_first_render_or_compute to program RT_CTRL once per GT.
On a GT with no render (RCS) engine, that match falls back to a
compute (CCS) engine instead, so the tuning is still written even
though RT_CTRL's ray-tracing logic has no hardware behind it there.

A CRI compute-only GT hits exactly this path, causing
igt@xe_debugfs@check-gt-reg-sr to report a save-restore mismatch:

  Mismatch on 0xe530, expected 0x400 got 0x0

Restrict the rule to ENGINE_CLASS(RENDER) so it only applies where
ray-tracing hardware is actually present. Every other in-tree platform
in this version range (BMG, LNL, PTL, NVL) always has a render engine,
which xe_rtp_match_first_render_or_compute already resolves ahead of
any compute engine, so this is a no-op for them.

Assisted-by: LLM
Cc: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
Fixes: 8d8431298f69 ("drm/xe/xe3: Disable null query for anyhit shader")
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20261012171901.19508-6-nitin.r.gote@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 65e2e108e466a2def170797a6d1b4b7849cec3a1)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_tuning.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_tuning.c b/drivers/gpu/drm/xe/xe_tuning.c
index a524170a04d02..84e99f6474e61 100644
--- a/drivers/gpu/drm/xe/xe_tuning.c
+++ b/drivers/gpu/drm/xe/xe_tuning.c
@@ -100,7 +100,7 @@ static const struct xe_rtp_entry_sr engine_tunings[] = {
 	},
 	{ XE_RTP_NAME("Tuning: Disable NULL query for Anyhit Shader"),
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2000, XE_RTP_END_VERSION_UNDEFINED),
-		       FUNC(xe_rtp_match_first_render_or_compute)),
+		       ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(RT_CTRL, DIS_NULL_QUERY))
 	},
 };
-- 
2.53.0



