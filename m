Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864E526FA45;
	Tue, 25 Mar 2025 12:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906389; cv=none; b=TfI0gB3C6dV9XDXcgZTawjoMJXeHljGJGMxNyLSMF2V7zLwvD3QxC43XoQo6yIAre9efTCIyd/CXZnYy3kgU7sJzrjtHGrB/nubL2aETw0VicWekc0XL7F9+X0RXPWrqq0gEx86hxsc+vgU+ariNd7XeCkcb6GLbtrGuSdDtqiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906389; c=relaxed/simple;
	bh=nMKjN8mt05kli6QUZFV0DwfefupBhbpMxIxr4yPXh3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOQCTVFeCJOiOB57n2XLw/a38ka7eRTGic2TeanDI+S1cZyYQWm+yH7wIcIIoZfnmH5QlNv1oi9C9Obbahb+FDhM53DZj+1JnRXVpma0a3DcCNuo3ELM1ZP2qqq1ARPLUOIKFktrmcZ9o+4vcBnqlwyH4s6F4h+VjxF+1pq8ifQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XC89wDpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XC89wDpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3936AC4CEE4;
	Tue, 25 Mar 2025 12:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906389;
	bh=nMKjN8mt05kli6QUZFV0DwfefupBhbpMxIxr4yPXh3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XC89wDpLmq0HN1Ee3ltqeQ7zEg6pw/JMKjUWYrqDkByY2MhH7+gQCpYcdrshsXvB3
	 BAEfS7yNf3D1eEBax4WB4VLX8/PNyqIh18LZsoFNNQEe1s4u55nn1ScxqqblQ38ZZg
	 /EYI7IHu+kiiln8RLRcitjv2gUZmE1nhpDpLeYNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 091/116] drm/amdgpu/gfx12: correct cleanup of me field with gfx_v12_0_me_fini()
Date: Tue, 25 Mar 2025 08:22:58 -0400
Message-ID: <20250325122151.538551387@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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
@@ -2395,7 +2395,7 @@ static int gfx_v12_0_cp_gfx_load_me_micr
 				      (void **)&adev->gfx.me.me_fw_data_ptr);
 	if (r) {
 		dev_err(adev->dev, "(%d) failed to create me data bo\n", r);
-		gfx_v12_0_pfp_fini(adev);
+		gfx_v12_0_me_fini(adev);
 		return r;
 	}
 


