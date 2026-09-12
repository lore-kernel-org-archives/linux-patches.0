Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC73377A9F;
	Sat, 12 Sep 2026 16:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231210; cv=none; b=gaseIOHxU7S1GXswgCeVIwv7zlqovBEJbxhpIEK/TAZjw6/aH0e7FyKCpAQ2LTy7CFrYUwoHGYYmRvG0WuSRKTnw2KfIDwbI6yvmyO/gOFefmqSaM2NpjkLedsyWrWihp32IawFhpTkHMb6jO9JXSm3JePILF02Tnsrq5FQOAeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231210; c=relaxed/simple;
	bh=vx6KIHYsikauS3SNs9CvRLonKlMcFMBXwTrhsuF0Hfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/03wj4w+p1BiQ5wiwe/U/gdsLXoF+xEq/PWatCSRNO7H2Qd5cWE0IqjgfY5mhTNWcycozsBACXhotvojttZuTTVkYBM5jSzN+7nEYOUbu+C7ejQvaC3Br8KzHlzd6HfutWPFqBjmaN1pfnr1DRHG0ojReSYblcrBn8TX1ST92Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAHf/ANP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAHf/ANP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4661F000FF;
	Sat, 12 Sep 2026 16:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231209;
	bh=rHM9VqEaXCeyzGLGrZUOHNG6WXlRwTfnvbPJd+hz13c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TAHf/ANPaSGxxRjDppa8KUYsdI9a75ySL7Xo5L2lPTySFVFI7Dr69r9gVYeEN3rzV
	 douV2kHHuPCYLlIBxjiCfvgB1pZL+fPVxsbuCp9PqgHxQvQKIPh7MgIrcrlbfj/SXM
	 J4+DbeD5fYHm1ouoyCeumRTL7zFtGj8SSlz3fuVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0951/1191] powerpc/configs: enable CONFIG_RAS to fix EDAC support
Date: Sat, 12 Sep 2026 09:01:19 +0200
Message-ID: <20260912065609.584911989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 3921cfc2e8155a767235801be88cbd0e4c73508d ]

Before commit e3c4ff6d8c94 ("EDAC: Remove EDAC_MM_EDAC") EDAC_MM_EDAC
selected RAS, after that commit, EDAC depends on RAS, but nobody enables
it. Enable it in the config again.

Fixes: e3c4ff6d8c94 ("EDAC: Remove EDAC_MM_EDAC")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260730105546.3658570-1-mwalle@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/configs/85xx-hw.config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/configs/85xx-hw.config b/arch/powerpc/configs/85xx-hw.config
index 8aff832173977..b655c36e56dad 100644
--- a/arch/powerpc/configs/85xx-hw.config
+++ b/arch/powerpc/configs/85xx-hw.config
@@ -90,6 +90,7 @@ CONFIG_PPC_EPAPR_HV_BYTECHAN=y
 CONFIG_QE_GPIO=y
 CONFIG_QUICC_ENGINE=y
 CONFIG_RAPIDIO=y
+CONFIG_RAS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_CMOS=y
 CONFIG_RTC_DRV_DS1307=y
-- 
2.53.0



