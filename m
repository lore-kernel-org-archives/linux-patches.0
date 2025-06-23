Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C985016D9BF;
	Mon, 23 Jun 2025 22:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717209; cv=none; b=E83TA7D5qW6dShS+oNfjoMDnhp03vbEACvxyUWZylelYkBlNW93dFd0VAGdUjzevdIocyaeRk3wtdtCLcMW4Ml3aDRmFfmdScUofMrdakgukPD+GWkl5uO60/4JV1EyJhJFSHTPgr+XIkUmhjFI6ZkPhmBGIYfcwdTnSmxzPwUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717209; c=relaxed/simple;
	bh=3oR4ZYdjmBUO/WfKnBrq+xUhe4HlhiTd64V4SgO33Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhD/4RDVau94WhmXNLDHLZd3oWfLWHNb6Njkytax6BkR3iZZ/M1hVbzL74c7LEEXOlwZdxvMuvqu4vrseZF3s1RmCmKV7hyQ0ywM/abJnUVYIM3EcX5aA74FVfwyg4BAzJLsn2UhXzun2+xrbbi3Bdxc7c9K/RVbjGX+ezmLe+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAESK9o8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAESK9o8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B7EC4CEEA;
	Mon, 23 Jun 2025 22:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717209;
	bh=3oR4ZYdjmBUO/WfKnBrq+xUhe4HlhiTd64V4SgO33Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAESK9o8smsDdNGQguyuyxzJd0prJLlHeA/GzTx56FF2m4VMAwCu9glRPfbipX9Zh
	 q8dfTsEe7OZLJ3CTPYmj3C55cEuATvL2ldSHLY1YLfGaDalA/KTPsvZfKRiQGQHAJR
	 PCua4aTzHGHnUgoGjgRpygVEcIgpw77KYtSrAtaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>
Subject: [PATCH 6.12 339/414] drm/amdgpu: read back register after written for VCN v4.0.5
Date: Mon, 23 Jun 2025 15:07:56 +0200
Message-ID: <20250623130650.456695192@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

commit ee7360fc27d6045510f8fe459b5649b2af27811a upstream.

On VCN v4.0.5 there is a race condition where the WPTR is not
updated after starting from idle when doorbell is used. Adding
register read-back after written at function end is to ensure
all register writes are done before they can be used.

Closes: https://gitlab.freedesktop.org/mesa/mesa/-/issues/12528
Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 07c9db090b86e5211188e1b351303fbc673378cf)
Cc: stable@vger.kernel.org
(cherry picked from commit ee7360fc27d6045510f8fe459b5649b2af27811a)
Hand modified for contextual changes where there is a for loop
in 6.12 that was dropped later on.
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -985,6 +985,10 @@ static int vcn_v4_0_5_start_dpg_mode(str
 			ring->doorbell_index << VCN_RB1_DB_CTRL__OFFSET__SHIFT |
 			VCN_RB1_DB_CTRL__EN_MASK);
 
+	/* Keeping one read-back to ensure all register writes are done, otherwise
+	 * it may introduce race conditions */
+	RREG32_SOC15(VCN, inst_idx, regVCN_RB1_DB_CTRL);
+
 	return 0;
 }
 
@@ -1167,6 +1171,10 @@ static int vcn_v4_0_5_start(struct amdgp
 		tmp |= VCN_RB_ENABLE__RB1_EN_MASK;
 		WREG32_SOC15(VCN, i, regVCN_RB_ENABLE, tmp);
 		fw_shared->sq.queue_mode &= ~(FW_QUEUE_RING_RESET | FW_QUEUE_DPG_HOLD_OFF);
+
+		/* Keeping one read-back to ensure all register writes are done, otherwise
+		 * it may introduce race conditions */
+		RREG32_SOC15(VCN, i, regVCN_RB_ENABLE);
 	}
 
 	return 0;


