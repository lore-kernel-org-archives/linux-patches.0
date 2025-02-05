Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66AFFC0B;
	Wed,  5 Feb 2025 13:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763569; cv=none; b=WnyKw5iz3F+jSvLs2ZRk4g921XXVJoWN1HYH91rhROyTrPnLlVxedIr+WQM4+NKMfG3+QFJ7z98KAZjpkQubtEY+Dv78t0zCAvJtiMFbhI3EWS/YsI8X2N++39aoqZ6qD0SI/9FI9sTu9ysPflGk6N/mIQQNTyQ+tWFR8h7UhE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763569; c=relaxed/simple;
	bh=MmcoINcfdK71Fx0kp28QW4XeOU7NRmFwizPl7MqxOHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1+t5T5Ri9Z+sD9ZCTGNHJQPE423/JrvcUWKlL10f8lwtt1Yp1otgCjh+F9/vypXRBYajGBSlsq3nPxix0FaqHgVzl/CTkJjjC8+g9mlHKEhjit2iHqFRijZKh3CTOBgk406/xt4EpwUueo8Ve4dI8Qmw5EQZSZiWZHlJDyCrjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3bH6oVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3bH6oVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22028C4CED1;
	Wed,  5 Feb 2025 13:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763569;
	bh=MmcoINcfdK71Fx0kp28QW4XeOU7NRmFwizPl7MqxOHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3bH6oVJTNe9Ol7/2zsUqzBKAcP7tm6b7EybKGZqAqUzimdOVJV0rVkR7H950F+d5
	 bzY9LuPnfGFrumVssermGxiWZeUQsQQSw6rtSj0XADcLe6LOZUUpQ1OUbMBmf9uS4p
	 BE89Kigi8IwLMzsrmcC1i6ct40SkyT2PjYv/d3v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <perry.yuan@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/590] x86/cpu: Enable SD_ASYM_PACKING for PKG domain on AMD
Date: Wed,  5 Feb 2025 14:36:26 +0100
Message-ID: <20250205134456.437548599@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Perry Yuan <perry.yuan@amd.com>

[ Upstream commit b0979e53645825a38f814ca5d3d09aed2745911d ]

Enable the SD_ASYM_PACKING domain flag for the PKG domain on AMD heterogeneous
processors.  This flag is beneficial for processors with one or more CCDs and
relies on x86_sched_itmt_flags().

Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Co-developed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://lore.kernel.org/r/20241025171459.1093-4-mario.limonciello@amd.com
Stable-dep-of: e1bc02646527 ("x86/topology: Use x86_sched_itmt_flags for PKG domain unconditionally")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/smpboot.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 766f092dab80b..b5a8f0891135b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -497,8 +497,9 @@ static int x86_cluster_flags(void)
 
 static int x86_die_flags(void)
 {
-	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
-	       return x86_sched_itmt_flags();
+	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU) ||
+	    cpu_feature_enabled(X86_FEATURE_AMD_HETEROGENEOUS_CORES))
+		return x86_sched_itmt_flags();
 
 	return 0;
 }
-- 
2.39.5



