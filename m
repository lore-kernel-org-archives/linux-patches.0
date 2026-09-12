Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BDC3630A5;
	Sat, 12 Sep 2026 08:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203261; cv=none; b=UvTXTYzrzuXqvgmdeqmt6N7AignG1oR1p8GFqtyPTZKylM8AZweQgHXuUmW9MDt/hSPRpKpTJupNhfUF+55zI9xO2BmOr7OyVNhKj5L0nlaaFTaCA1QuEb1k8YCCGmtyPD/jGqrDVtNjpa7UgH9VVViin3GlWdHOi3jdseV3zmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203261; c=relaxed/simple;
	bh=vCKE/C3g3XJ7wLHlKF/98q4LnYVLgWGNDh92H0eVyu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S95LXgbtOJ545RqPdVf+9eEwTiuVoAJpZ+aT/gvy5Iv5RtYEYm/hCl0S6pEUqU8qP27L1qImCvtOWmgU+x4/Ntt++KC6QesGALivsWd5zjqsbpCLqlxkMcxc0r1lf51SyPQvPpSPYwypf96kQ6B1C/SJWrx8ay0y2Oaa+gvu1jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7KeXqba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7KeXqba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A03F1F000FF;
	Sat, 12 Sep 2026 08:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203260;
	bh=jGx3s4xF4pGUlyHuolnpK0uOpnqiojxwl4lyvvyppTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J7KeXqbaK2DZcTHJn57at6tRIZG7OtMzKWy6R6uDNbbzJRossVCzol3J+JaUmZwt/
	 p+K304g4EAMrp0wIRPjXzbhFJYcS2m0W6bxXwDDVJbIR3xpjTXg6CyGaOETu3XLimv
	 6/DFPPjzJjgSyuBM4Dgmc0Cqo3AzqXN240dC/bgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1329/1815] powerpc/configs: enable CONFIG_RAS to fix EDAC support
Date: Sat, 12 Sep 2026 08:51:19 +0200
Message-ID: <20260912065720.223910102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2b19c20a9a2c4..6b84718101432 100644
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



