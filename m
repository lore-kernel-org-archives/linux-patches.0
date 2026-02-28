Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FA8340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301061; cv=none; b=MDK1WYUzJMDSzRMGBaP+SFQo8g7b5Tr4Ng62cY6Bb/8h9JS5hr9I61b1wZOfEgOD2RdsohSv7yPG5+kgxKhx5yQRwAwlZ0YR98TsyvZzc0IokoX9WXoc3Ks/kzG4dAEyBpfY1sDtWGZPA7cyhfj2gTiw/t8qGAmzLH/Zk0K6V9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301061; c=relaxed/simple;
	bh=rMUKUdWUcPbxLck9uhMrYsO565EP6ZZSL3ZtvQrKu10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KleabG0K4Aj+RoZ2ahtAcDRnTL4XVLJHbPG45k8tTE6lEqMIg48aJTjHeumiXmFROgiMSyKX2eHQ3a3XNcvZTcdV0uKK0zTS//DjSU/NlILyQjcYD6lojCUqeE8wY55iBVpS+MWokqfEtkqYKTs/GIcEJQeafSjbPcV+pnYAJUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dktGsRgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dktGsRgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1C5C19423;
	Sat, 28 Feb 2026 17:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301060;
	bh=rMUKUdWUcPbxLck9uhMrYsO565EP6ZZSL3ZtvQrKu10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dktGsRgDVAJXSggBmt8S4XHyrN0UiMvl3RlqJTz2XFFeT2TWyIGadeftltt/UPvSY
	 /6LtYElbm2bqI1zDHH6AwBDbWMvRtXa4p7sze7g4VaFZN0vgCdocvBMhzYQ+91hbiB
	 Ryh4YNtADuE1Smk0aUu+KQeXtNgNFPlT1g8MfKJyyLQqVvlhVWrBJRCJCRrTRfscNz
	 +BNk5kDCYHguSngeS7OU9OaXXbGGIP6Tr8V+9UEaY0nvVH05c+NHLFafvWLDWL9MvM
	 Mp5Jxf8YzEEYiRU3ZHidTrkwW8ah883KUcy22puVeWf63Y5iq/xEhxooYV5gQ7LuHV
	 f29KYhdxS+seA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 203/752] modpost: Amend ppc64 save/restfpr symnames for -Os build
Date: Sat, 28 Feb 2026 12:38:34 -0500
Message-ID: <20260228174750.1542406-203-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: René Rebe <rene@exactco.de>

[ Upstream commit 3cd9763ce4ad999d015cf0734e6b968cead95077 ]

Building a size optimized ppc64 kernel (-Os), gcc emits more FP
save/restore symbols, that the linker generates on demand into the
.sfpr section. Explicitly allow-list those in scripts/mod/modpost.c,
too. They are needed for the amdgpu in-kernel floating point support.

MODPOST Module.symvers
ERROR: modpost: "_restfpr_20" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_restfpr_26" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_restfpr_22" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_savegpr1_27" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_savegpr1_25" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_restfpr_28" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_savegpr1_29" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_savefpr_20" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_savefpr_22" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_restfpr_15" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
WARNING: modpost: suppressed 56 unresolved symbol warnings because there were too many)

Signed-off-by: René Rebe <rene@exactco.de>
Link: https://patch.msgid.link/20251123.131330.407910684435629198.rene@exactco.de
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 47c8aa2a69392..133dfa16308a3 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -602,6 +602,10 @@ static int ignore_undef_symbol(struct elf_info *info, const char *symname)
 		/* Special register function linked on all modules during final link of .ko */
 		if (strstarts(symname, "_restgpr0_") ||
 		    strstarts(symname, "_savegpr0_") ||
+		    strstarts(symname, "_restgpr1_") ||
+		    strstarts(symname, "_savegpr1_") ||
+		    strstarts(symname, "_restfpr_") ||
+		    strstarts(symname, "_savefpr_") ||
 		    strstarts(symname, "_restvr_") ||
 		    strstarts(symname, "_savevr_") ||
 		    strcmp(symname, ".TOC.") == 0)
-- 
2.51.0

