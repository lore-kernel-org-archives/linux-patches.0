Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAC1379EC4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301641; cv=none; b=Jarzk4BDFScR3dlet8FnYKab0AQrSWvQFbv6HC/PVdo1Pr/pndya/GCV4dcASrGhlqjDizgJkLH9fsfKL+o7zffDbPiY5lMbS/yefS5X4NiVg9I8+JQBX1o+hdJKMV9e+ya+FmpmescPflYEhMiFb+famy6crncY4yBykm2EYSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301641; c=relaxed/simple;
	bh=cbzc6yjBqBY38KXgaUCTZmM0aIWX7Z752JpR7IxoyjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXn1MVMJ6QhXQfq8utqNgOns72wlcsGiRbJ7Wpdja6+ABrovfwAGVyV6L3sdAQ4oIyM1ci/6jEpwtwfiECV75wnwGdTNCGteeqI7GjmMsajVSrg+mJfZPpJlT/fnLxEt32uv0wU/fgSlfnFSeHlJAwuG9C4uwsZkt04Ek+CHlPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=keylHDsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="keylHDsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAB3C19423;
	Sat, 28 Feb 2026 18:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301641;
	bh=cbzc6yjBqBY38KXgaUCTZmM0aIWX7Z752JpR7IxoyjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=keylHDsmT1q9yR93Q66Xm5a2zZjV9fT6rdhzVSguf+MitZXewAMPQGF7F1gT3qYlB
	 UNYrGrzZDMJCTiHnfivbvmFXmOWOPvvxaqzhVuKKtk0ualzeLnLda3xjaxu7prF91F
	 K8uSdrOke0Andkly9pyzhoteGMu5D3z7kLTIOEJWt/wlH7oXc8JAjnCbIJi5cjzw91
	 F4HlmMpSGAyPcM5/bthzQCBSq0JmuEaV+MQJOgR6XoiwqHhFBSfLAHR6G2jF0NXRR3
	 1XYJPV+8QCTuTJsSMOFHkEQrx27lWF9wbWKtJKeEzIq8tVwwx3dL1snO/tFKlFR/oH
	 Hqysw+inpQVXQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Aleks Todorov <aleksbgbg@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/385] OPP: Return correct value in dev_pm_opp_get_level
Date: Sat, 28 Feb 2026 12:54:17 -0500
Message-ID: <20260228180011.1568201-35-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Aleks Todorov <aleksbgbg@google.com>

[ Upstream commit 0b7277e02dabba2a9921a7f4761ae6e627e7297a ]

Commit 073d3d2ca7d4 ("OPP: Level zero is valid") modified the
documentation for this function to indicate that errors should return a
non-zero value to avoid colliding with the OPP level zero, however
forgot to actually update the return.

No in-tree kernel code depends on the error value being 0.

Fixes: 073d3d2ca7d4 ("OPP: Level zero is valid")
Signed-off-by: Aleks Todorov <aleksbgbg@google.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 5ac209472c0cf..b5df41ce3afff 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -226,7 +226,7 @@ unsigned int dev_pm_opp_get_level(struct dev_pm_opp *opp)
 {
 	if (IS_ERR_OR_NULL(opp) || !opp->available) {
 		pr_err("%s: Invalid parameters\n", __func__);
-		return 0;
+		return U32_MAX;
 	}
 
 	return opp->level;
-- 
2.51.0

