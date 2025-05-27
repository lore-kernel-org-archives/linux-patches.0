Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743BA280328;
	Tue, 27 May 2025 17:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368694; cv=none; b=IkfE3rAWFUr9T9t0EJLLqj6KhPXMTXq/IxDvzMuITVm4pPJbecqq/NSyGTOWio0O515otn7heSY0Jmwf3UKEb8ikawaDvJ1rB63XU7tiWoL3kltRtzEbV5E/SY5NVaZSo9qlJK1fOivj6Dcq1g+uDYeP4RiJauQqOC1no0GRja0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368694; c=relaxed/simple;
	bh=R32j5HPIIn4tDU9x5wF4TT5GLgBwFug3WP8cKkEdIpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilZerKMrQZ2H36ZTM7AyWir+P4vqajy/+IxsGoNwCHuWA5d2k21mMwkQHCdTUMA9vL2ZCTzV0OIMlqMQPflf39kybpYs2NLaR9PkB+FLi1gatD5oqGW7E1qU6YBC9ikuppOanKTATjQkCewm8mxHUYZLY4UB1eQO5KX/22cT+Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BScYvavJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BScYvavJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F66C4CEE9;
	Tue, 27 May 2025 17:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368694;
	bh=R32j5HPIIn4tDU9x5wF4TT5GLgBwFug3WP8cKkEdIpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BScYvavJsrWrd1heJBPLLkjBUul1vtmIxMSEmNEY+C26tqORHiLVC2wMOdhCzK9OB
	 HwMR8GrKsnMTOkeTuHiI5GennKKuETMusmW32Tc/Rq0nJzp1bmPOVqx3ylqKP1iffm
	 CZ81G/LUeo6URR4obG7DrUuSZiVXfM//A3bV9/Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Eric Naim <dnaim@cachyos.org>
Subject: [PATCH 6.14 779/783] drm/amdgpu: read back register after written for VCN v4.0.5
Date: Tue, 27 May 2025 18:29:36 +0200
Message-ID: <20250527162544.853416376@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
Tested-by: Eric Naim <dnaim@cachyos.org>
Signed-off-by: Eric Naim <dnaim@cachyos.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -983,6 +983,10 @@ static int vcn_v4_0_5_start_dpg_mode(str
 			ring->doorbell_index << VCN_RB1_DB_CTRL__OFFSET__SHIFT |
 			VCN_RB1_DB_CTRL__EN_MASK);
 
+	/* Keeping one read-back to ensure all register writes are done, otherwise
+	 * it may introduce race conditions */
+	RREG32_SOC15(VCN, inst_idx, regVCN_RB1_DB_CTRL);
+
 	return 0;
 }
 
@@ -1164,6 +1168,10 @@ static int vcn_v4_0_5_start(struct amdgp
 	WREG32_SOC15(VCN, i, regVCN_RB_ENABLE, tmp);
 	fw_shared->sq.queue_mode &= ~(FW_QUEUE_RING_RESET | FW_QUEUE_DPG_HOLD_OFF);
 
+	/* Keeping one read-back to ensure all register writes are done, otherwise
+	 * it may introduce race conditions */
+	RREG32_SOC15(VCN, i, regVCN_RB_ENABLE);
+
 	return 0;
 }
 


