Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336532E7649;
	Thu,  3 Jul 2025 15:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555049; cv=none; b=edYnLxtHoC+OP+KArMoW9Tt+sdLvyfTNqWlqJ8VXw251nUInbfNnJ87N9WDtXQSxpSWWP9jaUarg3HOC8U7r/KD7Ttr0REg9wGgpAGoxxUZTehb2Q/yoaiKjThCEd2+TLq0wXBltn/KBaEhZV+QcKZBj2QH4P7W6ZjdGjzSdCKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555049; c=relaxed/simple;
	bh=T8p3L0LJCrjRfteKt/44sfHdiGxzwUbsGCdo3mRSMTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TksKwP1ngPofQUkb42fPjtqbFI9kFtnkHViHPxDWYCeV7FHBy/kt1S51wa6sSa9ddsptUXzivBpnFlZpDbDqAZ/S+qWiB08TSO20kHSt8mbyPprps+VLeyylqpgWYSlZu73M0EMsbeJQCHJM7XAz06lNQkwKamcM/uK83mFylOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oipJoHQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oipJoHQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC72C4CEF3;
	Thu,  3 Jul 2025 15:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555049;
	bh=T8p3L0LJCrjRfteKt/44sfHdiGxzwUbsGCdo3mRSMTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oipJoHQTRAI2HoluzVHkXhuT4w+8tLoS1J9Fi2+799OlthZ3/gme6sVzDnAWPtQln
	 mYsTqpehvS4JMQ72anc9J+NBQkUN6gr99+PuSIGtMR2LFeclXUm7Og4N+JRHHWIZ/w
	 jl7AxsNn9mJtd2pWlc7wAGylURkBjRTaJryp0Tck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.15 130/263] drm/xe: move DPT l2 flush to a more sensible place
Date: Thu,  3 Jul 2025 16:40:50 +0200
Message-ID: <20250703144009.578453730@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

From: Matthew Auld <matthew.auld@intel.com>

commit f16873f42a06b620669d48a4b5c3f888cb3653a1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/display/xe_fb_pin.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/display/xe_fb_pin.c
+++ b/drivers/gpu/drm/xe/display/xe_fb_pin.c
@@ -164,6 +164,9 @@ static int __xe_pin_fb_vma_dpt(const str
 
 	vma->dpt = dpt;
 	vma->node = dpt->ggtt_node[tile0->id];
+
+	/* Ensure DPT writes are flushed */
+	xe_device_l2_flush(xe);
 	return 0;
 }
 
@@ -333,8 +336,6 @@ static struct i915_vma *__xe_pin_fb_vma(
 	if (ret)
 		goto err_unpin;
 
-	/* Ensure DPT writes are flushed */
-	xe_device_l2_flush(xe);
 	return vma;
 
 err_unpin:


