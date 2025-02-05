Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0998C127E18;
	Wed,  5 Feb 2025 13:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763251; cv=none; b=s4px1kEwUHRo6grx1Cagb6xxftDrA5OUT3wpeGyZyCWCLkuZeeYv4RGxMH3iwaFMUxyKQqZQEbOCdydDi18RfqEjeLQqA7k8e/xl2qdR7wPEVPmoQ44TPb/SfqACIb+28EJ0cjy8H1JXybHvMnPL1aiwh614FbKXJ60IWZB8o5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763251; c=relaxed/simple;
	bh=sy6yzxcbmRApSus4DL5w8//cus6MsRDZXSuzt7eRKhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbn+qxSxvWU/lwDJpMsHvUoqJvYOLfkIJgOcedI75MPFCmwsVvy4LlwQ3wgtawg4qg3191INDKhR0xcPCzQbpHO+628CxOx8PEyzlfECYFm4Fs8ZLv6qU9YhzGuHF/wkdTCNtBjl1BwfCfm649eM71csORLya8gcFOi8//GaIag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsMEx47Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsMEx47Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF54DC4CED1;
	Wed,  5 Feb 2025 13:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763250;
	bh=sy6yzxcbmRApSus4DL5w8//cus6MsRDZXSuzt7eRKhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsMEx47YZoWuyGL8EPSGuAC1hhmjFv7+WmOTngv4ElAOawe0NygPq8SPbY3F+CLpV
	 yW6kKXJNTyQ9LzyQmIw8+GrFjjgO7oq7RVq4Ok4POuJSlO0d02qYsip1BuE0PZmIUu
	 K6v4DS/sV+rSeH+PJW+lKKY8hHQF6C14hNNZb5NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <perry.yuan@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/393] x86/cpu: Enable SD_ASYM_PACKING for PKG domain on AMD
Date: Wed,  5 Feb 2025 14:38:59 +0100
Message-ID: <20250205134421.073898318@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e4781e7496f6f..9150bd5147d01 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -606,8 +606,9 @@ static int x86_cluster_flags(void)
 
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



