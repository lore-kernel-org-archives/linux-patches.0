Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1912225A2BB;
	Tue, 25 Mar 2025 12:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906028; cv=none; b=BHOlLp0/9b9x2Tp1//+1aZtrg14xAelbGajrE+PVwGuN+61IuIMzb/qPof+ibAcWkJvuN0n4wInye7wTEDVddb2IfYTv6e13aCjyqGCXLmhme+DRbxwUpgd3n8HFWsqqXqO/AF2anAnTYhvsbBz92XEGOg8OQhd8hDdMKDzOM9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906028; c=relaxed/simple;
	bh=eMECScl9vJUHGyw9lEW6eWJZxYxt7QlR16AU4Z4055Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQhPLpwzrpB6rlS0VQgTTA6dEm34yQT5SWgMZ/wSsXqY0pRGJPGmEbjzlAvcRtzGsxcRZ3CUNyXTpuh21uUmuCqyeBw6sBt7frMNvkyba+qRWvCYq1XUcmNX24FXJy7WXzwR6SRDU/BggrdDM4SnDxPuoov7q5++KEt5GoydJ8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vtyn9kAb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vtyn9kAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C02C4CEE4;
	Tue, 25 Mar 2025 12:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906028;
	bh=eMECScl9vJUHGyw9lEW6eWJZxYxt7QlR16AU4Z4055Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vtyn9kAbFdoOhnqNU8GHtCAGvzKjWsONL6nnuYpo3TsEDDt0slpJlvdqPlMMBPQya
	 23xlSgMENdHIdYQNEwNKWMS5vFFstSco3JMlyBjeNP6QoqK6JIjLEiUb//bM/fSTwu
	 yN/Cq5h39pn+ENW6tHJ5WF4gsDwybhd0zzfA1nY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 096/119] drm/amdgpu/gfx12: correct cleanup of me field with gfx_v12_0_me_fini()
Date: Tue, 25 Mar 2025 08:22:34 -0400
Message-ID: <20250325122151.511586662@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 86730b5261d4d8dae3f5b97709d40d694ecf1ddf upstream.

In gfx_v12_0_cp_gfx_load_me_microcode_rs64(), gfx_v12_0_pfp_fini() is
incorrectly used to free 'me' field of 'gfx', since gfx_v12_0_pfp_fini()
can only release 'pfp' field of 'gfx'. The release function of 'me' field
should be gfx_v12_0_me_fini().

Fixes: 52cb80c12e8a ("drm/amdgpu: Add gfx v12_0 ip block support (v6)")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ebdc52607a46cda08972888178c6aa9cd6965141)
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -2413,7 +2413,7 @@ static int gfx_v12_0_cp_gfx_load_me_micr
 				      (void **)&adev->gfx.me.me_fw_data_ptr);
 	if (r) {
 		dev_err(adev->dev, "(%d) failed to create me data bo\n", r);
-		gfx_v12_0_pfp_fini(adev);
+		gfx_v12_0_me_fini(adev);
 		return r;
 	}
 


