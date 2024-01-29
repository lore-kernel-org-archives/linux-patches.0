Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A0115A48F;
	Mon, 29 Jan 2024 17:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548269; cv=none; b=piQTlsd73d/f45kQG0PmkSk3463Ry+326x1KFXnSpySQoPvgL6l+c5atjCpPsBcETkhRPwAUM9orFNOb8KIt0CNEvk+1OIwUUhYSWZHVKpKc1+T9+XvHr0uxQzTn1jR/W0WGYcgoe/58GFo8nsroNAWVZJ+3a5ncw5tV0Wdv9fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548269; c=relaxed/simple;
	bh=gFUp3Z9x/Ndha8oFOOlh4Ba+5E8QjoxImCoXAkHoRWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFIoUm8vwolTXIzz79cppc4mPiIqhLsb4ID3wwtDYDdTCLGk+9h+B4YiRe7KwR84jNuum3DgkSiXIFgetF1ZpMgvnk0cshmBf7Y/xY/7P7qkAQilTccfcjhw2YdsYsoNNJJU0FgVfvi3J++WWP+uG2pM3MKXn0FBfjHFnOHo444=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6F+upcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6F+upcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2F0C43390;
	Mon, 29 Jan 2024 17:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548269;
	bh=gFUp3Z9x/Ndha8oFOOlh4Ba+5E8QjoxImCoXAkHoRWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6F+upcBVDgnFhHaXDEChcVGuArECpGV544t5wtczFdtBBhkHFesbAM8N8juwrVVI
	 5Xt4oUNDuNQ50lw8TxBmgZ+f/zECx144r0vDQ1TE25Dn+ar4uSqw3x7GzljKRaL6cS
	 +JDQjpQWeo5gXhwmYIow9H7wyfWUgNgf3BGE63SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 262/346] drm/amdgpu: drop exp hw support check for GC 9.4.3
Date: Mon, 29 Jan 2024 09:04:53 -0800
Message-ID: <20240129170024.096741944@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c3d5e297dcae88274dc6924db337a2159279eced upstream.

No longer needed.

Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.7.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1963,8 +1963,6 @@ static int amdgpu_discovery_set_gc_ip_bl
 		amdgpu_device_ip_block_add(adev, &gfx_v9_0_ip_block);
 		break;
 	case IP_VERSION(9, 4, 3):
-		if (!amdgpu_exp_hw_support)
-			return -EINVAL;
 		amdgpu_device_ip_block_add(adev, &gfx_v9_4_3_ip_block);
 		break;
 	case IP_VERSION(10, 1, 10):


