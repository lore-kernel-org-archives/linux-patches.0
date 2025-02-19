Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82E21B4F0C;
	Wed, 19 Feb 2025 09:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956950; cv=none; b=fj2p0y+wzp69f+Qszey+PYD7WqyEOmMGafG7IDA1wqWXXdmG+KzswvQcW6HhMfVLS8OT88A7L2fSnH1R1GXDQaYUMuNqNHOoEgtk+ywPIZRdGLVXyykwXGsM4TAtXhKN9u9JVbRUQGdeBqQ0oFiBkf26X1tsCJsXfTo7cJ/EpQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956950; c=relaxed/simple;
	bh=KSlQdBnpqZRC5Wo6XDwYFQ6ZWPErHPha7RKAvnFgM5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNEDc9jjNSInnmnTA8GY1T3/7QwX2/VPWWhCepfCkKDGzE2jZLzEngk3ejnHNphUmm+nM3fByCrG/t+AWJo2hCDkScnwVrFbLceKdVjr7IEWK9CTI59n7GyhYpCdbr8vCUd7LOr/yei0RVxiwhEjjO/dsAe5PgOKarcRYHcWlhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zquhRveu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zquhRveu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CDFC4CED1;
	Wed, 19 Feb 2025 09:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956950;
	bh=KSlQdBnpqZRC5Wo6XDwYFQ6ZWPErHPha7RKAvnFgM5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zquhRveuhmuOmJdG/QnaCTF3FM8TiwUMLTes+qpgzhlAXNje/60K7m4uarJWWTzf+
	 z3VY3jPl04TJm0OvD95G2WVt26qO2n/cNOKWD3DgLR77QeWBEliHA+akel8QHy9/SO
	 H0WB2lT1t9xmWctsGKpuPwldkmiwLNQQKlR02asY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 349/578] drm/amd/pm: Mark MM activity as unsupported
Date: Wed, 19 Feb 2025 09:25:53 +0100
Message-ID: <20250219082706.746059571@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lijo Lazar <lijo.lazar@amd.com>

commit 819bf6662b93a5a8b0c396d2c7e7fab6264c9808 upstream.

Aldebaran doesn't support querying MM activity percentage. Keep the
field as 0xFFs to mark it as unsupported.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1759,7 +1759,6 @@ static ssize_t aldebaran_get_gpu_metrics
 
 	gpu_metrics->average_gfx_activity = metrics.AverageGfxActivity;
 	gpu_metrics->average_umc_activity = metrics.AverageUclkActivity;
-	gpu_metrics->average_mm_activity = 0;
 
 	/* Valid power data is available only from primary die */
 	if (aldebaran_is_primary(smu)) {


