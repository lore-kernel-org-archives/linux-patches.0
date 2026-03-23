Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0124F3B27ED;
	Mon, 23 Mar 2026 15:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279107; cv=none; b=uRgrRfrenTnU1LGGG1dgr/p630p7p1bDX8xP7Z/P1tfocft57HQeCCMJFxw1pmhzjohdGtNT+fgYdHqQvHdPQ3cGaoQ8tcCNwDZfnu0L0EPS2ODvh1fKrng0uT8kMQqWzeOjLn8mwl1q0qnPblV3D+/hIxLqe0VNCFROp8R1D8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279107; c=relaxed/simple;
	bh=xVaqKeaqHKxGoz86W9ccg7AaqcLB1eyRaLdQ8jNDokw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2LWcxIe73Pk5R8eaidH4DY124s0ZxcyxSsViYEN8E83GzGYp0i2EuuwRRIU3pIukiSVAo1c//rbiYdtnyo5v+lxkopGVWRAaN+Otj7tdKUrVECQ48yIPQ8UuRp7bEGOO+1HmhqlDIVyk2Lj11nE4SugW3YR9W/mravzI/c+wa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iyAaOPss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iyAaOPss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300DAC2BC9E;
	Mon, 23 Mar 2026 15:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279106;
	bh=xVaqKeaqHKxGoz86W9ccg7AaqcLB1eyRaLdQ8jNDokw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iyAaOPssQOuOXoFdkXZjCluKeMX4witkkS+12iY4MFCzopPmB4S77fz9aXosSAxx2
	 ON6Z/4lwXhpQ42zUU/jOZ+qKra5Pzrj0+tB6xhSsiY2sDaPnDsLb1htmWQPfr/YlUk
	 4knjqDI7zuVUlbQOItYZI1j3lJqDvCxDDH3YssOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 489/567] drm/amdgpu/mmhub2.3: add bounds checking for cid
Date: Mon, 23 Mar 2026 14:46:49 +0100
Message-ID: <20260323134546.081723324@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit a54403a534972af5d9ba5aaa3bb6ead612500ec6 upstream.

The value should never exceed the array size as those
are the only values the hardware is expected to return,
but add checks anyway.

Reviewed-by: Benjamin Cheng <benjamin.cheng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 89cd90375c19fb45138990b70e9f4ba4806f05c4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
@@ -94,7 +94,8 @@ mmhub_v2_3_print_l2_protection_fault_sta
 	case IP_VERSION(2, 3, 0):
 	case IP_VERSION(2, 4, 0):
 	case IP_VERSION(2, 4, 1):
-		mmhub_cid = mmhub_client_ids_vangogh[cid][rw];
+		mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_vangogh) ?
+			mmhub_client_ids_vangogh[cid][rw] : NULL;
 		break;
 	default:
 		mmhub_cid = NULL;


