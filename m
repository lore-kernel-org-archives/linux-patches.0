Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57024332610;
	Sat, 12 Sep 2026 11:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212794; cv=none; b=pE/sEX3bsbdLIlJSDKh5ShPTi2ZdxfuZyj3xfai0ZTdGUlS+bSk6D0Ynd0vnV5mo1o/n/Oks2qFJmq3PfmSUB6hTr2jv59eM+GmrPTa/ivOZzYfVh20V0HFS6ld/tWWSJupExzYvWUIGERwBxTnoV8Dn/AJL/3BKP2Q+HtZM2s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212794; c=relaxed/simple;
	bh=RVW/3Er2htWn+CBoKApFArfwxK0AnBuqKCxUIKSB3wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E381ELgj7sgZr6la1E9JJZx85XbUnDmjyETxxsGYxhH/87KByRrNOKd7kT36latqNPN/a7Rk9aP0Of7ZdMtXuVnEvc+xxeqxCfL1oCEini+9YsTp+uYezUpPoa/VxNx0ORXZDWa/IEDmstlKnayJKDWV7PN3xROT2FaXnIEBR0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hhtm5KXa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hhtm5KXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E821F000FF;
	Sat, 12 Sep 2026 11:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212793;
	bh=+KLp3k58GxTu2TgIBnPrNBgdfLmc51R5Sn5SZXxZROc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hhtm5KXa/VW3IxopaGd8GpocwGLnplY0hJFHh4b918MnqnlIKxmHQLhmqfCD6dSwe
	 PpQ5hPGDuV2Kp6MoW0G110oQCeNpgQgRE0ZN4czQCTJ1JERIfGcIVfTFYrJ8TPygVa
	 e5MqLFu8omLcQqGBvduF2NBskSOkb+Dun0FRrXhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1507/1518] cpufreq/amd-pstate: Add static asserts for EPP indices
Date: Sat, 12 Sep 2026 09:01:16 +0200
Message-ID: <20260912065657.658142894@linuxfoundation.org>
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

[ Upstream commit 077f23573d29d063a950e90aa77c8e1f79580147 ]

In case a new index is introduced add a static assert to make sure
that strings and values are updated.

Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Stable-dep-of: caa822d312be ("cpufreq/amd-pstate: Use "epp_default_dc" as default when dynamic_epp is disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 0d58291a133d6..10727eb0914fa 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -116,6 +116,7 @@ enum energy_perf_value_index {
 	EPP_INDEX_BALANCE_PERFORMANCE,
 	EPP_INDEX_BALANCE_POWERSAVE,
 	EPP_INDEX_POWERSAVE,
+	EPP_INDEX_MAX,
 };
 
 static const char * const energy_perf_strings[] = {
@@ -125,6 +126,7 @@ static const char * const energy_perf_strings[] = {
 	[EPP_INDEX_BALANCE_POWERSAVE] = "balance_power",
 	[EPP_INDEX_POWERSAVE] = "power",
 };
+static_assert(ARRAY_SIZE(energy_perf_strings) == EPP_INDEX_MAX);
 
 static unsigned int epp_values[] = {
 	[EPP_INDEX_DEFAULT] = 0,
@@ -133,6 +135,7 @@ static unsigned int epp_values[] = {
 	[EPP_INDEX_BALANCE_POWERSAVE] = AMD_CPPC_EPP_BALANCE_POWERSAVE,
 	[EPP_INDEX_POWERSAVE] = AMD_CPPC_EPP_POWERSAVE,
 };
+static_assert(ARRAY_SIZE(epp_values) == EPP_INDEX_MAX);
 
 typedef int (*cppc_mode_transition_fn)(int);
 
-- 
2.53.0



