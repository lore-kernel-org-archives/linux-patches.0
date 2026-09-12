Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8232D2D0C94;
	Sat, 12 Sep 2026 11:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212784; cv=none; b=SBoJF7pAPNnnXqWlk7U17jpuagAt8KuEadObjR/QFErtDIYJ+7y9Gi+d2nY3b4eaifyiKe/ZXopLqp9VkGkh+e54KRvPKmElv4qrhpUsH93/kxXT93yc158mKO2TZFMp9ID2ZqRxRaKZo3BdwJX1hIgJb/PmaCRLe+sfa8qHG6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212784; c=relaxed/simple;
	bh=SqOitSHjkXz9byDfynuF+jeuPgCjykxiFn9SdVvqOGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PR8e7mTV+Lw4was3qhp2PPfU9gOArkzKR5kw1eTvdcPGL4lVeZ+rPaysQVyZLWr7g8kGhMcwtQXFdRMLxInOs47D2bS2qPEr8ljptmhG5V0IKe4pduRCu5mixCP+svoXGfS3Mk4g4TRYUrBoscmpyQOVTtAwPmDewluugUJfN0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAQVKrH1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAQVKrH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0BD1F000FF;
	Sat, 12 Sep 2026 11:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212783;
	bh=8U/V+8i15avCT2V1PS6Y4iA9ck9Ol+ECeoxfrumgBdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dAQVKrH1GZU7n/wWKoSjSXasr0tso9eRn23QzfmUiLetvSm1rjsKU/lHWRwTbq3+B
	 DSgvn5EuWiJtDDOcXKD3evx6kFsbqGpw3CUB95HRH1gtg++2xgvRdlFzC0ydgpzGqo
	 oq/Lpy6LgcuahSnZvAKppYqZLoOAQgh/qnCwDkr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1506/1518] cpufreq/amd-pstate: Fix some whitespace issues
Date: Sat, 12 Sep 2026 09:01:15 +0200
Message-ID: <20260912065657.635619737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit e9d62ca86a5525a742742fe69e9aa316cfd4f471 ]

Add whitespace around the equals and remove leading space.

Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Stable-dep-of: caa822d312be ("cpufreq/amd-pstate: Use "epp_default_dc" as default when dynamic_epp is disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 108d5e01459f6..0d58291a133d6 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -132,7 +132,7 @@ static unsigned int epp_values[] = {
 	[EPP_INDEX_BALANCE_PERFORMANCE] = AMD_CPPC_EPP_BALANCE_PERFORMANCE,
 	[EPP_INDEX_BALANCE_POWERSAVE] = AMD_CPPC_EPP_BALANCE_POWERSAVE,
 	[EPP_INDEX_POWERSAVE] = AMD_CPPC_EPP_POWERSAVE,
- };
+};
 
 typedef int (*cppc_mode_transition_fn)(int);
 
@@ -188,7 +188,7 @@ static inline int get_mode_idx_from_str(const char *str, size_t size)
 {
 	int i;
 
-	for (i=0; i < AMD_PSTATE_MAX; i++) {
+	for (i = 0; i < AMD_PSTATE_MAX; i++) {
 		if (!strncmp(str, amd_pstate_mode_string[i], size))
 			return i;
 	}
-- 
2.53.0



