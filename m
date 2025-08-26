Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D60529D26A;
	Tue, 26 Aug 2025 11:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207453; cv=none; b=M6diS/Vo5TuFp+StUAAamjsp6qW4y/6R7xh+xaZPhEqoLLGidrVhtnPhpu8x9amfGtRXQhB/uQd7chrSbF+wRxaqG7UfVhyaiR3HfbmT+MuRLBENLGQmyGiPFRTn8YiiQz8NA0DEWjfkB/Ck1xjyWVx4XoFUdgCCVBTkiCedscY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207453; c=relaxed/simple;
	bh=v63Fe5SfwoBpBnzz7muaqRR1mJwV0LybCDILlSujg4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ig75yNri9o0VCyo9ztiPl8e7zAVhbTx882Ze7hfiwP1whHEBt9b3At9bEz4EdsjpA8KsG9GlEG27V6Lx+ZH/wYmnpjFhtUgGObgNSGLQzC+nKcCCkvhfrbofsDyYb3lhmUa8+71+OPt3Lcq3voMHrBPwAKe5bTduKRsw8gSphMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXsyOGdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXsyOGdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D09C4CEF1;
	Tue, 26 Aug 2025 11:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207453;
	bh=v63Fe5SfwoBpBnzz7muaqRR1mJwV0LybCDILlSujg4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXsyOGdqjJwiG9CmmDtGr417GhWpE5lL/BKLnZ1z+edGbgl1XYRaU7xiWTVkJGvkb
	 5AwX+wjKE2xCHu9yZAL6Qp/xOhJy0DST/SpFt8o+u502umQbdsJM0FMiH6OZCYP9JB
	 l11NUNR1p6MLOX8mAmkvS7wl/EBo6byyju3CE+QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 180/457] drm/amdgpu: Update external revid for GC v9.5.0
Date: Tue, 26 Aug 2025 13:07:44 +0200
Message-ID: <20250826110941.825868024@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 05c8b690511854ba31d8d1bff7139a13ec66b9e7 upstream.

Use different external revid for GC v9.5.0 SOCs.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 21c6764ed4bfaecad034bc4fd15dd64c5a436325)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1218,6 +1218,8 @@ static int soc15_common_early_init(struc
 			AMD_PG_SUPPORT_JPEG;
 		/*TODO: need a new external_rev_id for GC 9.4.4? */
 		adev->external_rev_id = adev->rev_id + 0x46;
+		if (amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 5, 0))
+			adev->external_rev_id = adev->rev_id + 0x50;
 		break;
 	default:
 		/* FIXME: not supported yet */


