Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EC7356746;
	Tue, 21 Jul 2026 19:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663238; cv=none; b=maM2/VbQ5B+KGsPsQOBD1aor7KSkrdWzeZSJxHUZG0RI4qulskHgHl25nRSyGaEhJJbYP8dZmsAc+ga800TV7Z/4FEftgN2GCJsr13cNX8RjhzQ20BxZ7CtCzhj60OWg+MqODFkrTtGUQog1yXrq+dsneBv+SyfKT0BXismtobg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663238; c=relaxed/simple;
	bh=+zQ6T0gflNhDpoaa5bu29jSJuwMdryvvxz2BusNBgeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uE1Zm4fgK7Q4hFWbUa5dLscZoJq4cVk+u8oTKW8p9PPTyOtB6GlnXJso5kz2k+ChRNQbb8Ij/UNlsqf3aiDO6ns70IYjHR9Z3El+goa19OEigKmtUQm/J8PvtITU1aOYh3fajhP46q59QPCy7WJgWLQt/ruxLMfvX8Rr6hnmfqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dT+3wVsE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dT+3wVsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3C11F000E9;
	Tue, 21 Jul 2026 19:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663237;
	bh=YYuDSmeTVmZBxwSc3Mp/VxYRTGz+Uj2McfOguRDjwJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dT+3wVsE1GGgL9hSBxQFUoqIkVDf5IErPOxo+ACH4IORfwRm6udX0xHzddeKaVxZj
	 0GuBqGlns9KRL0ArILxrh6ZDqb47H63w6fxb3sKnClWtYzB8rxNoXaMagwIw3u7xbL
	 /hWYdpFndjXtMRydEW30Dxk3J2VTVY2lmA1Y3rTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0748/1276] drm/xe/pf: Dont attempt to process FAST_REQ or EVENT relays
Date: Tue, 21 Jul 2026 17:19:51 +0200
Message-ID: <20260721152502.819225726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit ed8b0d731892c68b41ecbd27c952af284816dec1 ]

Currently defined VF/PF relay actions use regular REQUEST messages
only and the PF shouldn't attempt to handle FAST_REQUEST nor EVENT
messages as this would result in breaking the VFPF ABI protocol
and also might trigger an assert on the PF side.

Fixes: 98e62805921c ("drm/xe/pf: Add SR-IOV GuC Relay PF services")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Michał Winiarski <michal.winiarski@intel.com>
Link: https://patch.msgid.link/20260527183735.22616-1-michal.wajdeczko@intel.com
(cherry picked from commit 1714d360fc5ae2e0886a69e979095d9c7ff3568a)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_relay.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_relay.c b/drivers/gpu/drm/xe/xe_guc_relay.c
index 0e5b43e1518ea5..decee13da3119c 100644
--- a/drivers/gpu/drm/xe/xe_guc_relay.c
+++ b/drivers/gpu/drm/xe/xe_guc_relay.c
@@ -675,12 +675,17 @@ static int relay_action_handler(struct xe_guc_relay *relay, u32 origin,
 		return relay_testloop_action_handler(relay, origin, msg, len, response, size);
 
 	type = FIELD_GET(GUC_HXG_MSG_0_TYPE, msg[0]);
+	relay_assert(relay, guc_hxg_type_is_action(type));
 
-	if (IS_SRIOV_PF(relay_to_xe(relay)))
-		ret = xe_gt_sriov_pf_service_process_request(gt, origin, msg, len, response, size);
-	else
+	if (IS_SRIOV_PF(relay_to_xe(relay))) {
+		if (type == GUC_HXG_TYPE_REQUEST)
+			ret = xe_gt_sriov_pf_service_process_request(gt, origin, msg, len,
+								     response, size);
+		else
+			ret = -EOPNOTSUPP;
+	} else {
 		ret = -EOPNOTSUPP;
-
+	}
 	if (type == GUC_HXG_TYPE_EVENT)
 		relay_assert(relay, ret <= 0);
 
-- 
2.53.0



