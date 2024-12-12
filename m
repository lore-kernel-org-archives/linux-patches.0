Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D8D2054F8;
	Thu, 12 Dec 2024 15:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016809; cv=none; b=LJd3/3StFCy4nShmVKA9GqoLfo222ADv8Ko5sRgPHKjNe6f4wRP/ILn+TBZdBN8BpjpnzFbEKAgMGjwFhSAgFHDHtWHXXUEZJee3kDshA/ASZh/0ZFQjW6Maz5mJXNBr8aBtpcstvhrI+KZt1bfJstbIgMfs9j5BwehYqS2rH9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016809; c=relaxed/simple;
	bh=kZvzeTVs7wBR6BEVmJmeOTMiSGGi5bcUBsAn7c/TQIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jeOGo8rGrrzy+X/eRBEL6AOwgtQT+TPNJKY/wV7+6dSH4JHSt6WSgPfvUv8LOMDFyRLfbJkMcj8wyAGLhGYmZ8owy8NehhRjUDvHvskcxKBru3S6If7NhXdLmdn6wHxUZT0OsbRIzEDC6SQMvPJVGz1zNjZl5OuowOOP3TQ7DZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoipyRFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoipyRFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8D9C4CED4;
	Thu, 12 Dec 2024 15:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016809;
	bh=kZvzeTVs7wBR6BEVmJmeOTMiSGGi5bcUBsAn7c/TQIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoipyRFLOvv9GDBU6tCxvxHZB1tXRjbJlllcWsiMxLaT7OEH/U+cdUN5M9S0ubKFq
	 ugvYIOR+jRApmOJytPeUBGqs2cybKzGizjQ8Hq6z9vO8YDZduvD4L6HqPlvWswMZeq
	 2kfLU/i06g/yuPyuDyYsqTlyCJ9/Fa9uSQ540o0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badal Nilawar <badal.nilawar@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 303/466] drm/xe/guc/ct: Flush g2h worker in case of g2h response timeout
Date: Thu, 12 Dec 2024 15:57:52 +0100
Message-ID: <20241212144318.748707968@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Badal Nilawar <badal.nilawar@intel.com>

[ Upstream commit e5152723380404acb8175e0777b1cea57f319a01 ]

In case if g2h worker doesn't get opportunity to within specified
timeout delay then flush the g2h worker explicitly.

v2:
  - Describe change in the comment and add TODO (Matt B/John H)
  - Add xe_gt_warn on fence done after G2H flush (John H)
v3:
  - Updated the comment with root cause
  - Clean up xe_gt_warn message (John H)

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/issues/1620
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/issues/2902
Signed-off-by: Badal Nilawar <badal.nilawar@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Acked-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241017111410.2553784-2-badal.nilawar@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index 9c505d3517cd1..cd6a5f09d631e 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -906,6 +906,24 @@ static int guc_ct_send_recv(struct xe_guc_ct *ct, const u32 *action, u32 len,
 		}
 	}
 
+	/*
+	 * Occasionally it is seen that the G2H worker starts running after a delay of more than
+	 * a second even after being queued and activated by the Linux workqueue subsystem. This
+	 * leads to G2H timeout error. The root cause of issue lies with scheduling latency of
+	 * Lunarlake Hybrid CPU. Issue dissappears if we disable Lunarlake atom cores from BIOS
+	 * and this is beyond xe kmd.
+	 *
+	 * TODO: Drop this change once workqueue scheduling delay issue is fixed on LNL Hybrid CPU.
+	 */
+	if (!ret) {
+		flush_work(&ct->g2h_worker);
+		if (g2h_fence.done) {
+			xe_gt_warn(gt, "G2H fence %u, action %04x, done\n",
+				   g2h_fence.seqno, action[0]);
+			ret = 1;
+		}
+	}
+
 	/*
 	 * Ensure we serialize with completion side to prevent UAF with fence going out of scope on
 	 * the stack, since we have no clue if it will fire after the timeout before we can erase
-- 
2.43.0



