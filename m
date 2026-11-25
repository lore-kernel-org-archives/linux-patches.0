Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618800;
	b=QpIeaLzl0Jdh74bnfOlE+iFbUYZxncN+CdAMAtLMAyU4tCHRRvSZsd7YSgn8ToI9ST9J
	 vM+cIntraeyPVRHcB9igdmKm3SyimoQvUfRvn11IlTP/fV1d5TwrdSJ4MXGR1gUmhaaLr
	 RH4rMVij41mr17SrcUK2S7qaSS2FabvZwknr4B92UjIjw81Ki8s8sBON7oaRhlorNvgpw
	 GpLWe1nAn1eMQ/dMzMY1CFug81BSJxwoW9f/Jgjx4wqU1q4xAD9UR3KNZ1wyrWMbGQSPS
	 Sd0guOnt3/c5bNmtmjMzW2dfwXHhCAd6KYIrCFp7xQ9Y5abcB5LCeoas3znZJnVctcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JX0MYH9x65E9FbDtdDkRfudg6dLseKY/ij/WOc9o/co=;
	b=tUqcQOZS6mOITseHfyYc3RNOGjmZTaBChJUphXDSWWnPJbmcrroE6RcJsqwhORs7Q45x
	 +y07udSJSMYhVBfbxaGdFQtGORonNcwCZlA6z888/D/7gJlhaWZ+YIZO3ZYlHpSSNz13M
	 BgWg8IM5CCJVgLMVBXBwp5Ff22ifMr0sluYEWV+wTUIjmdjSd8480u1pxhV09cR/rfo+5
	 RUOOCYJvfRJXh4QqKtOS/tKeug12KcIt1/pzvCTyOJjkbRp/+kigJ/4RuJz2EK7NIh/+K
	 DLpvrmXdrsHkkMxx4nQHj6ffIwxcJgWvvUrZZ6s9BXr6LJ0Bc5XQud4zM8omX4oaJKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EvcdZ4I3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E69F606A31E;
	Wed, 25 Nov 2026 15:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EvcdZ4I3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB2C1F000E0;
	Wed, 25 Nov 2026 14:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618799;
	bh=JX0MYH9x65E9FbDtdDkRfudg6dLseKY/ij/WOc9o/co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvcdZ4I3eFnDOnlQOptbOq2EJjfd4DcwQSBhx+5i1BDlY9ogylOYAbj7BnTLRV15f
	 E7qBxYlXD9zpIUv+4C2h4nvL+imbsxprXuqmVFWTvy5fD7dsthNQXpmJ5XSav6D2u7
	 3wUNaPHSt1OLxleHl5NkEj43ck37ecRfqqA2uYw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0392/1005] drm/xe/tuning: Restrict Anyhit NULL-query tuning to render engines
Date: Wed, 25 Nov 2026 15:28:50 +0100
Message-ID: <20261125143830.926206212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index bcec40ca2d35f..315221bcccb12 100644
--- a/drivers/gpu/drm/xe/xe_tuning.c
+++ b/drivers/gpu/drm/xe/xe_tuning.c
@@ -116,7 +116,7 @@ static const struct xe_rtp_table_sr engine_tunings = XE_RTP_TABLE_SR(
 	},
 	{ XE_RTP_NAME("Tuning: Disable NULL query for Anyhit Shader"),
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2000, XE_RTP_END_VERSION_UNDEFINED),
-		       FUNC(xe_rtp_match_first_render_or_compute)),
+		       ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(RT_CTRL, DIS_NULL_QUERY))
 	},
 	{ XE_RTP_NAME("Tuning: disable HW reporting of ctx switch to GHWSP"),
-- 
2.53.0



