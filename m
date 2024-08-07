Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E6382D66;
	Wed,  7 Aug 2024 15:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043125; cv=none; b=gjZU9padD8f2KPpupr+uN2h6o5rLq4vGz90MxY8JyDOAyFery7j8j8qIqH2mWKF+lDPt7Z7oVL0Acy6QL6ESV1Sf68vkoywjCXVAZLymeK1j1g8XQkJiI79h3aIIVhLNJx0f72G9sDbDxNUc33PY7xCzIoWAxpUTeK/eA/PcDSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043125; c=relaxed/simple;
	bh=ihfaLr+S5BjVF9wzNa/lhvfeRt1HTluPjvkOKb8wGCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NsikQvPpwP+sMArFGq2O1ON0Eq6J4O9HeGiTWDP/ZjcAMIjvUex6CJENu+D2TBAsQ7xVlvCD5iYEEWZIlRLGkEKo0wxxIk7gq5tYoue+NUKF3VZlX7wsWyHCQMgPMrxMJGPQ8rW1+0HF1zTxFJ4JlDxd2Y3ESaKuYs0qaqvF2kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E34Axw40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E34Axw40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC30C4AF0D;
	Wed,  7 Aug 2024 15:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043124;
	bh=ihfaLr+S5BjVF9wzNa/lhvfeRt1HTluPjvkOKb8wGCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E34Axw4074qHLczocrpBxzJ3ojl+IkivFll0M0qGkVNXLqXMAzy4AlN7ZOUfmnIN0
	 U0zmhgc3hXoYIRf78hBhPoLgGYAyb3i/HJMiQJ6Ez5U+otKeOJZKTyFFGkBSpprO5S
	 coargHqgY8pnMdWCa0IUtOIm7SGnVdjXgzNbK/Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.10 098/123] drm/v3d: Prevent out of bounds access in performance query extensions
Date: Wed,  7 Aug 2024 17:00:17 +0200
Message-ID: <20240807150024.010194126@linuxfoundation.org>
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

commit 6ce9efd12ae81cf46bf44eb0348594558dfbb9d2 upstream.

Check that the number of perfmons userspace is passing in the copy and
reset extensions is not greater than the internal kernel storage where
the ids will be copied into.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: bae7cb5d6800 ("drm/v3d: Create a CPU job extension for the reset performance query job")
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Iago Toral Quiroga <itoral@igalia.com>
Cc: stable@vger.kernel.org # v6.8+
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240711135340.84617-2-tursulin@igalia.com
(cherry picked from commit f32b5128d2c440368b5bf3a7a356823e235caabb)
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_submit.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/v3d/v3d_submit.c
+++ b/drivers/gpu/drm/v3d/v3d_submit.c
@@ -637,6 +637,9 @@ v3d_get_cpu_reset_performance_params(str
 	if (copy_from_user(&reset, ext, sizeof(reset)))
 		return -EFAULT;
 
+	if (reset.nperfmons > V3D_MAX_PERFMONS)
+		return -EINVAL;
+
 	job->job_type = V3D_CPU_JOB_TYPE_RESET_PERFORMANCE_QUERY;
 
 	job->performance_query.queries = kvmalloc_array(reset.count,
@@ -708,6 +711,9 @@ v3d_get_cpu_copy_performance_query_param
 	if (copy.pad)
 		return -EINVAL;
 
+	if (copy.nperfmons > V3D_MAX_PERFMONS)
+		return -EINVAL;
+
 	job->job_type = V3D_CPU_JOB_TYPE_COPY_PERFORMANCE_QUERY;
 
 	job->performance_query.queries = kvmalloc_array(copy.count,


