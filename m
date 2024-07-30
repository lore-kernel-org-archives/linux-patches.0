Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6784F18A6B6;
	Tue, 30 Jul 2024 17:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359415; cv=none; b=RkeLJXNyJ9cEH+E276+xjURQDjE08CrbW1+8GvH+dOHJEdp9HKgLaVVuOj6ImpvZhUaZPZxg0QrnsAUdW94ilozYEO6APMAJpzPL9Q0dPLxTaTJAM1GKF7m8bwMJx+cDdOT6B9j46V+QjaLenDFeT4iABNbemZ8avwTAGnJCtW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359415; c=relaxed/simple;
	bh=NRTtn2M89b/jdx38CY8MiF+EMkm7sQminjojwtLkoYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhsS5l2IKiAVoRCMA1GfUNfWPoeDuw336cpMSZBHDIwqT0DYtggPuTLZadQkuRV/hvaTUjjtA6DfjqHRdhQksHma2o6NRACpYD0tqtNJhMYBHxCeEDsv88zebksznTGcfnZoGFyEXRupGe1hJRsmWeHPww82gb/iGYDuvTtR0as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkPpwehu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkPpwehu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FC0C32782;
	Tue, 30 Jul 2024 17:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359414;
	bh=NRTtn2M89b/jdx38CY8MiF+EMkm7sQminjojwtLkoYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkPpwehuuYcO3BCpDGyJqTI8I+aRVvth2/4uCsYpSDijbmgEuQLnTT86SMI+/GgW3
	 YHseEE5bRXEqEScZYegECJG5e/ykByhsnf+GM0KCgcby4B0B0UXIbGwxymbJTKkJLX
	 VOUknl135XemhrI7SLpT8pESc3ViCSdjR9Qy23E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 479/568] drm/amd/amdgpu: Fix uninitialized variable warnings
Date: Tue, 30 Jul 2024 17:49:46 +0200
Message-ID: <20240730151658.748846764@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -92,7 +92,7 @@ static int smu_v13_0_10_mode2_suspend_ip
 		adev->ip_blocks[i].status.hw = false;
 	}
 
-	return r;
+	return 0;
 }
 
 static int


