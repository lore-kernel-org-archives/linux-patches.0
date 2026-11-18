Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026027;
	b=zUp9XM2++jD79Yns5aA6TyxXNQTlqHj2QnRe8FzxtUDpIMc91tKKMIH//O/CiEOK9966
	 pYg2BddAZv99EA8L82kz0pJ9Vh9Gi0hJI2XDsX3jDTIlQDVkN0Eg9bEqDAZ+Nj1zpHlmQ
	 rTx8YAWZlm/FtKOiT6RvSp42X2/esQOEBBKq00ixaq+XZKgC2e85SoPDMJWAdr/2umMsG
	 IcbMz3mPoEfV1ZGByhEsg85XzatIqWJYxQfcbnEhQlzD+CsvFKnnf6eBayKIhhUk4Rgwq
	 zRz5Jgg9HOoGPbVMS0p0WK9U4Q3luzsuiET0FIb4vCXgUjDyI9p07r29FWmBrIyLWng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KF0pag8Y8TIhmsk7WJiqNCgFlFpd/BUlYrl/+OzOPb8=;
	b=ejO82EhUKREreX3gQqHSxaC/btPvj4ZeMId5ZVFPWq2IlkxwgWXpCo6z1SsyaJuHK7KT
	 9QCzsvsYHEPp+D1930RFQCJ4iA04e7yxDOKrNSf9DAnDMx+AbnBvx+nyQ8BjQVDw29XcA
	 +to5warvzLe32jZDrk3A10v+Qp5zRyHsNpixSIQekR1sPhGz85lIaIh+CkPEW48IiRn1D
	 sNn/Ksxd+Z460lnO34zsPVpePzDtDoEUm2YRFk/MKYaZ3M/WLEf3dOiOPnbhPFx0LJqMC
	 J2f2jzFyVzAo3ACD43JnDrejrsyfRzI6rQwN2Ivl8KUjHh6ZTL/wQPxU7kBCigqLKqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xYdkIk/a";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255D4606A31C;
	Wed, 18 Nov 2026 18:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xYdkIk/a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2D61F000C4;
	Wed, 18 Nov 2026 18:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026027;
	bh=KF0pag8Y8TIhmsk7WJiqNCgFlFpd/BUlYrl/+OzOPb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xYdkIk/aO4eyH+s07djwbKCCHpgaqozcnlaVDjF0cE8yKvvxngkjII3NVyicNRhAk
	 ZedM66KZrziB5aqeMBu2Z2JLSVa4zN7i+iyNOWKNH2IRB6hlHuPBL+Q5HOfT5Clu2Y
	 ed3KJ9SeV+fD6GjkwQab+1w9RoE9eGGbAB6vAInM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1246/2151] drm/amd/display: fix vready offset assignment in dcn_optc_lock_unlock_state
Date: Wed, 18 Nov 2026 15:49:41 +0100
Message-ID: <20261118150207.555583668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit 3ad7f4ca58efd6c1216632c50873dfffdefbe3ff ]

vready_offset is captured by optc_state, but the trace point entry is
wrongly assigned to vupdate_offset. Fix vready_offset tracepoint field
in dcn_optc_lock_unloack_state to record optc_state->vready_offset.

Fixes: f1943a51f0f9 ("drm/amd/display: Add events log to trace OPTC lock and unlock")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
index a4b1b86237891..2e25990db002c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -701,7 +701,7 @@ TRACE_EVENT(dcn_optc_lock_unlock_state,
 			   __entry->vstartup_start = optc_state->vstartup_start;
 			   __entry->vupdate_offset = optc_state->vupdate_offset;
 			   __entry->vupdate_width = optc_state->vupdate_width;
-			   __entry->vready_offset = optc_state->vupdate_offset;
+			   __entry->vready_offset = optc_state->vready_offset;
 	    ),
 	    TP_printk("%s: %s()+%d: optc_instance=%d opp_count=%d max_h_total=%d max_v_total=%d "
 		      "min_h_blank=%d min_h_sync_width=%d min_v_sync_width=%d min_v_blank=%d "
-- 
2.53.0



