Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA19261B91;
	Wed,  4 Feb 2026 15:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219303; cv=none; b=h7RmMIVBEo7NI8v9WTHcrntlzv7RC+2GwDe0XAGKdyP5aW/sr+8mqaIlOCqjrgQdjHke8YmpmUJsBR9jTtanLiddeRgTg5pA6IUivDMqA2fJdRVj03HIyKoBb0w74DGYGSJJ8qRR/OJE4x5d1sd8DsB8E9j6PZTMrNUFK4bMPVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219303; c=relaxed/simple;
	bh=CR+SxifRT9isAy2sM2ll58QOmJ4F2AF+83vRvdHjLIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mr6u2E+9t6p4wnDMeVbWSk/AVNahaKLw2HoAERB+dHU+o8wbStamBJLlt4WR2rD5Tyz7yEG6q7/UKRY954MoSvZt6I+ZwLwHlgRnMu7ndVl9xqK0nnugPrrE5ji/jLcKmxeyuRsCpkon3HQEJK+wR5u+3o9jegwcqyT8AuPwL04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYxOVYih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYxOVYih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC7BC4CEF7;
	Wed,  4 Feb 2026 15:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219303;
	bh=CR+SxifRT9isAy2sM2ll58QOmJ4F2AF+83vRvdHjLIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYxOVYihMRBlhPNxJE+A9W5miILPRsHQq/G8XMOHeGThpdVacOU8dVnBowK6v0JXZ
	 ed03uut+ZX+x3TlkueyqSeC4eNrtRwSFncLZ0bGlH9DDdBXw/hh1scRa1QjGIGOlWL
	 WmHQCF2ZX1fdGsvtAZs1znYAVUVQCE9SG6M3TULc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18 101/122] drm/xe/xelp: Fix Wa_18022495364
Date: Wed,  4 Feb 2026 15:41:23 +0100
Message-ID: <20260204143855.483304776@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit 051be49133971076717846e2a04c746ab3476282 upstream.

It looks I mistyped CS_DEBUG_MODE2 as CS_DEBUG_MODE1 when adding the
workaround. Fix it.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: ca33cd271ef9 ("drm/xe/xelp: Add Wa_18022495364")
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: "Thomas Hellström" <thomas.hellstrom@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: <stable@vger.kernel.org> # v6.18+
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patch.msgid.link/20260116095040.49335-1-tvrtko.ursulin@igalia.com
(cherry picked from commit 7fe6cae2f7fad2b5166b0fc096618629f9e2ebcb)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_lrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
index 281286f2b5f9..b8c1dd953665 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -1185,7 +1185,7 @@ static ssize_t setup_invalidate_state_cache_wa(struct xe_lrc *lrc,
 		return -ENOSPC;
 
 	*cmd++ = MI_LOAD_REGISTER_IMM | MI_LRI_NUM_REGS(1);
-	*cmd++ = CS_DEBUG_MODE1(0).addr;
+	*cmd++ = CS_DEBUG_MODE2(0).addr;
 	*cmd++ = _MASKED_BIT_ENABLE(INSTRUCTION_STATE_CACHE_INVALIDATE);
 
 	return cmd - batch;
-- 
2.53.0



