Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7572B78C92;
	Wed,  7 Aug 2024 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043210; cv=none; b=kYo36NKxNMqO//l7cAhW9Oi/FMsnXRuQkoJVozsKGsZ1jPujAzHghYAD4kyXYf2zv7YReCzGtkanPg7cm1TltLjuQbWhBusYDRMoBAhMkq0HHzd7XW1YmQ1DihgT9YgyTg/BKESaD2KURm4mvFX5t87qClYjZt/w3P9t55oIAao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043210; c=relaxed/simple;
	bh=1Rrakb5Ehev8qEaNZugvlTgPKyIWq/48y8hG9Qqq0TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A0Z7tub4rAR0JRdJQyqFb6reKtEnn1VOJnGeSvJtQ7MOEYblFpaQIm5PbGFI/XvUwlJDG8fSKA+4LVWY/1RMR+DIO8H3a5XMzsRQ3c3PqXf4Nq2QcC0WZ0gwoLWKgvVxAo6LLmYWTBHITgBPH0gGXWMYHBUrmeqqKzr4J1q69Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gK+tpmrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gK+tpmrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C4FC32781;
	Wed,  7 Aug 2024 15:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043210;
	bh=1Rrakb5Ehev8qEaNZugvlTgPKyIWq/48y8hG9Qqq0TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gK+tpmrI9NxqB/rLlGkGAwy3pAJcvlfSJ+Qn1vsKxFNlgTBSsgqNzKvDZpSe3TrQC
	 5rMjNaK5Zof2FXqZ9+sgb0UyQ8QChlN1yWM63TSoZIjW3gX+1E+GDS2G9wpOUBfJD2
	 QGQcJH/c3fQCYDGr3RYqcXm5EZK8uWS7i5ZDkwNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.10 102/123] drm/v3d: Validate passed in drm syncobj handles in the performance extension
Date: Wed,  7 Aug 2024 17:00:21 +0200
Message-ID: <20240807150024.155950293@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit 4ecc24a84d7e0254efd150ec23e0b89638386516 upstream.

If userspace provides an unknown or invalid handle anywhere in the handle
array the rest of the driver will not handle that well.

Fix it by checking handle was looked up successfully or otherwise fail the
extension by jumping into the existing unwind.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: bae7cb5d6800 ("drm/v3d: Create a CPU job extension for the reset performance query job")
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Iago Toral Quiroga <itoral@igalia.com>
Cc: stable@vger.kernel.org # v6.8+
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240711135340.84617-6-tursulin@igalia.com
(cherry picked from commit a546b7e4d73c23838d7e4d2c92882b3ca902d213)
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_submit.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/v3d/v3d_submit.c b/drivers/gpu/drm/v3d/v3d_submit.c
index 9a3e32075ebe..4cdfabbf4964 100644
--- a/drivers/gpu/drm/v3d/v3d_submit.c
+++ b/drivers/gpu/drm/v3d/v3d_submit.c
@@ -710,6 +710,10 @@ v3d_get_cpu_reset_performance_params(struct drm_file *file_priv,
 		}
 
 		job->performance_query.queries[i].syncobj = drm_syncobj_find(file_priv, sync);
+		if (!job->performance_query.queries[i].syncobj) {
+			err = -ENOENT;
+			goto error;
+		}
 	}
 	job->performance_query.count = reset.count;
 	job->performance_query.nperfmons = reset.nperfmons;
@@ -790,6 +794,10 @@ v3d_get_cpu_copy_performance_query_params(struct drm_file *file_priv,
 		}
 
 		job->performance_query.queries[i].syncobj = drm_syncobj_find(file_priv, sync);
+		if (!job->performance_query.queries[i].syncobj) {
+			err = -ENOENT;
+			goto error;
+		}
 	}
 	job->performance_query.count = copy.count;
 	job->performance_query.nperfmons = copy.nperfmons;
-- 
2.46.0



