Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304782E49A8;
	Tue,  8 Jul 2025 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993013; cv=none; b=ZQ26oYoVaA1GH97L1vX8YZ/TTqxt1FczylYUsHGT4BMr8w7amqEaefEiJPTQjko4SoNewMaNNaHKJm+e25M237r6OePeNgVJm5sFK4FN0RRDWlToI4OwrCewDgokdC00y+j0HgvVPghvxPjhcEdyxhKPQdAJ9likKLHAqWBhLPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993013; c=relaxed/simple;
	bh=9SyLkXoIqnQr5iu1TSqt0hIm6HS85GM7E7VjMf5h4Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nKR1OTS4W/8aVj/npf4Xdv4ccAVNomuGzAJnTHgxM2J/iIT03vDL2Hl865c441ic8uWB57zRWpPcUiRVc5Ojh0d92PauUUjm+9ojMvMUftGf3Pr2gw0fFsnwSo0gfTv3JwV1Z6B8TCDgTWX0IADqXftajZ/BvBz87HbW6PT6J70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxZPchmg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxZPchmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA788C4CEED;
	Tue,  8 Jul 2025 16:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993013;
	bh=9SyLkXoIqnQr5iu1TSqt0hIm6HS85GM7E7VjMf5h4Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxZPchmgSXclvQCvmx01zWKEAFukiOsrOijHrhRPnnUA33D0Cd+T8JURbCvqJutg1
	 KIYaeX6w/r9AHqlQmPEXK016q9c7hLzWOOUlDxKEUdf824OmgVO39v3tQghIEtjcvp
	 0kMDo/ZisHh6KyNtN3JeeEnbYQgfuHyacjrFGKL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 157/232] drm/xe: move DPT l2 flush to a more sensible place
Date: Tue,  8 Jul 2025 18:22:33 +0200
Message-ID: <20250708162245.544959612@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit f16873f42a06b620669d48a4b5c3f888cb3653a1 ]

Only need the flush for DPT host updates here. Normal GGTT updates don't
need special flush.

Fixes: 01570b446939 ("drm/xe/bmg: implement Wa_16023588340")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: stable@vger.kernel.org # v6.12+
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250606104546.1996818-4-matthew.auld@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 35db1da40c8cfd7511dc42f342a133601eb45449)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_fb_pin.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/xe_fb_pin.c b/drivers/gpu/drm/xe/display/xe_fb_pin.c
index 972b7db52f785..0558b106f8b60 100644
--- a/drivers/gpu/drm/xe/display/xe_fb_pin.c
+++ b/drivers/gpu/drm/xe/display/xe_fb_pin.c
@@ -154,6 +154,9 @@ static int __xe_pin_fb_vma_dpt(const struct intel_framebuffer *fb,
 
 	vma->dpt = dpt;
 	vma->node = dpt->ggtt_node[tile0->id];
+
+	/* Ensure DPT writes are flushed */
+	xe_device_l2_flush(xe);
 	return 0;
 }
 
@@ -318,8 +321,6 @@ static struct i915_vma *__xe_pin_fb_vma(const struct intel_framebuffer *fb,
 	if (ret)
 		goto err_unpin;
 
-	/* Ensure DPT writes are flushed */
-	xe_device_l2_flush(xe);
 	return vma;
 
 err_unpin:
-- 
2.39.5



