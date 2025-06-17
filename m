Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16842FA62D;
	Tue, 17 Jun 2025 16:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178886; cv=none; b=aZZ5G7Wo/ESHkQT8uAWU/k2lIm9DmxGLQLZIMSnMq4AGSYjRsX8atkEfpQEJ4qmXE7ym9bzK+vE22W60J7DN4oubGA6hO0jOkJKqWN2aGfrm1B5fj5XCwpyGGm1ukTmpuOCO2a2QTxylvxR8NtpGgr8O2IO18nIOWWTZ5P5eHsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178886; c=relaxed/simple;
	bh=frNbLBIhXU/4UxpFfNcFoAaYWSMQtZI5oofYHu+sGGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S+Qc9oQO8pf8OhqJ/22rre64pkb1tG2arOiO79GS7p+g67JyR/xY6dYaUnpKj/vsoLkX1rJpAVW64etswESRz3/1fsKvVPm1A7VVM8EGOCGZwSXCxonhiuNNADIec6vsJzicFx3+ytA7opB7KdCBULHrLaZfuocXQp+dI5N7lpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=by5pJlAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="by5pJlAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21513C4CEE3;
	Tue, 17 Jun 2025 16:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178886;
	bh=frNbLBIhXU/4UxpFfNcFoAaYWSMQtZI5oofYHu+sGGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=by5pJlAVNm+hKV5/MUTF/jXzaK/s9o2J1cnjBNdqgVSRXhmy8bnPRjEsauMWDPuU1
	 2Bu5HW53FnQiy8WXkLotB/BfUP1kAWrbuHs0v6JocUHjb/9UelfRG2VDljPPzLtSmD
	 yo0kGxWE1mMXFJt9k+kOwEZ4zOoQlxXNIYonMegg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 583/780] drm/i915/psr: Fix using wrong mask in REG_FIELD_PREP
Date: Tue, 17 Jun 2025 17:24:51 +0200
Message-ID: <20250617152515.227508836@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 57d63c6cd0851d3af612a556ec61b0f2a9bd522f ]

Wrong mask is used in PORT_ALPM_LFPS_CTL_FIRST_LFPS_HALF_CYCLE_DURATION and
PORT_ALPM_LFPS_CTL_LAST_LFPS_HALF_CYCLE_DURATION.

Fixes: 295099580f04 ("drm/i915/psr: Add missing ALPM AUX-Less register definitions")
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://lore.kernel.org/r/20250526120512.1702815-12-jouni.hogander@intel.com
(cherry picked from commit 8097128a40ff378761034ec72cdbf6f46e466dc0)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr_regs.h b/drivers/gpu/drm/i915/display/intel_psr_regs.h
index 795e6b9cc575c..248136456048e 100644
--- a/drivers/gpu/drm/i915/display/intel_psr_regs.h
+++ b/drivers/gpu/drm/i915/display/intel_psr_regs.h
@@ -325,8 +325,8 @@
 #define  PORT_ALPM_LFPS_CTL_LFPS_HALF_CYCLE_DURATION_MASK	REG_GENMASK(20, 16)
 #define  PORT_ALPM_LFPS_CTL_LFPS_HALF_CYCLE_DURATION(val)	REG_FIELD_PREP(PORT_ALPM_LFPS_CTL_LFPS_HALF_CYCLE_DURATION_MASK, val)
 #define  PORT_ALPM_LFPS_CTL_FIRST_LFPS_HALF_CYCLE_DURATION_MASK	REG_GENMASK(12, 8)
-#define  PORT_ALPM_LFPS_CTL_FIRST_LFPS_HALF_CYCLE_DURATION(val)	REG_FIELD_PREP(PORT_ALPM_LFPS_CTL_LFPS_HALF_CYCLE_DURATION_MASK, val)
+#define  PORT_ALPM_LFPS_CTL_FIRST_LFPS_HALF_CYCLE_DURATION(val)	REG_FIELD_PREP(PORT_ALPM_LFPS_CTL_FIRST_LFPS_HALF_CYCLE_DURATION_MASK, val)
 #define  PORT_ALPM_LFPS_CTL_LAST_LFPS_HALF_CYCLE_DURATION_MASK	REG_GENMASK(4, 0)
-#define  PORT_ALPM_LFPS_CTL_LAST_LFPS_HALF_CYCLE_DURATION(val)	REG_FIELD_PREP(PORT_ALPM_LFPS_CTL_LFPS_HALF_CYCLE_DURATION_MASK, val)
+#define  PORT_ALPM_LFPS_CTL_LAST_LFPS_HALF_CYCLE_DURATION(val)	REG_FIELD_PREP(PORT_ALPM_LFPS_CTL_LAST_LFPS_HALF_CYCLE_DURATION_MASK, val)
 
 #endif /* __INTEL_PSR_REGS_H__ */
-- 
2.39.5



