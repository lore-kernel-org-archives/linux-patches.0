Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76A4403AE1;
	Tue, 21 Jul 2026 17:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653640; cv=none; b=IzNkQ3R9MLu4wCFf5F1CfSjlDtDXobijf0cXOEPrKZ7KB9zBg4J+uMtzSyz1mjHtEZ31shYgO6yLXLbeQScnivHcafgvc5DPVlG3wYZtdSaZJVSN+FIc/JMxdyv/sm3YHOrHwuV+bQ6Wx5WGa9heil6RnWIN9ltqwjXIXHobH0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653640; c=relaxed/simple;
	bh=E5K4EZvtBhJSRXxtFHxYZE+gxQ+gW/pJJQ+KXeWR1Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KME26iNbwYKI3YHB0AAo6nqaMrAOp2IVA7EogPa38CIV6HL/8Eyr2+lmwjzjQw5i0BtAANCZTQ30GhOmFAZKBhRLfKhM40WgNwDNJ2RYyF30i+mIcqkrInRf5lRyIBA+J4CxW0iGp1x2BaJVyfcRfe9107q72z0wO59hJqjyU2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sN72Sgte; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sN72Sgte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174991F000E9;
	Tue, 21 Jul 2026 17:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653639;
	bh=3Zj1LMI5280xnVtEH4RoGMnNh39X601SYIvwYwWNK88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sN72Sgteqxm4b0H/XjrjU2slaVHmaRg9DwDNi1qQP5uzbUGxjGIBrS13rvoPz9neC
	 i7rbeYtgpOQ3fziZ/InvrKaMKPar9IoYw4QkoHUb0Ttq3uh/9H42uMjJaVDexLI9nW
	 IEHL/cu4Qg3vY7ME3xVkbawo1q8+ucX5M7L4gtjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1403/2077] drm/xe/pf: Dont attempt to process FAST_REQ or EVENT relays
Date: Tue, 21 Jul 2026 17:17:56 +0200
Message-ID: <20260721152625.900263412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 577a315854afcf..eed0a750d2eb2a 100644
--- a/drivers/gpu/drm/xe/xe_guc_relay.c
+++ b/drivers/gpu/drm/xe/xe_guc_relay.c
@@ -689,12 +689,17 @@ static int relay_action_handler(struct xe_guc_relay *relay, u32 origin,
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



