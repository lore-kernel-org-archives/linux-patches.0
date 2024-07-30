Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8804B1A76B2;
	Tue, 30 Jul 2024 17:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360453; cv=none; b=SBajUQ9dDWTR65h1cJUMsqgGe5KhF0fNU2wsZC/fXhWkHxWxiwaHwjd/JvPwEjr0E+CIS4EtVIaoz7X3iHvYXOhYvKoAJ9C0rX3Eo+0qS8m2CarcTpJ1CX7OVVwXhrR0yTZE/kWNMjv7S+PiM0Mdq0mxSC+SnVZbrB4w2LpsT2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360453; c=relaxed/simple;
	bh=cI46MUclEeH4o35wcWfql6nJb9UFkYUqa1E23WvHamc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4sPmAxmX96wZLBfDwENKlPhq+Mg0RIf7U4ynrGnfHlVMjW+EwFGNqVRM8xQDbJy6E3hOzDgGBNMjRbeXyBO+S6vjdWmpbbBo0FvVtqb+Z+6bZVL2gDPaoWnnayNGvLBWwZTR8o91roymjoec0VMEM2Vxpa9ArtL4i/MobEyJ5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxMkyDcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxMkyDcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC52C32782;
	Tue, 30 Jul 2024 17:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360453;
	bh=cI46MUclEeH4o35wcWfql6nJb9UFkYUqa1E23WvHamc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxMkyDcwNAPLzE9P3qBbUhZlJob94335fEdixBEI1pTLk6cANy+xrRKtoGjyKxyAe
	 98NytdhdrEIANeX8/xGI5wgYtWWf53tz/HJi+YZdOpWdIHtyGDTWOVZq6lck59Vd3T
	 cE0LwlmmtEoZqQoBtWov4ksI3OICHPmhpsmM3uq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 704/809] drm/amd/amdgpu: Fix uninitialized variable warnings
Date: Tue, 30 Jul 2024 17:49:40 +0200
Message-ID: <20240730151752.732431676@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit df65aabef3c0327c23b840ab5520150df4db6b5f upstream.

Return 0 to avoid returning an uninitialized variable r.

Cc: stable@vger.kernel.org
Fixes: 230dd6bb6117 ("drm/amd/amdgpu: implement mode2 reset on smu_v13_0_10")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6472de66c0aa18d50a4b5ca85f8272e88a737676)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/smu_v13_0_10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/smu_v13_0_10.c
+++ b/drivers/gpu/drm/amd/amdgpu/smu_v13_0_10.c
@@ -91,7 +91,7 @@ static int smu_v13_0_10_mode2_suspend_ip
 		adev->ip_blocks[i].status.hw = false;
 	}
 
-	return r;
+	return 0;
 }
 
 static int


