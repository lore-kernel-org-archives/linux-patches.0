Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F2619E971;
	Mon, 23 Dec 2024 16:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969978; cv=none; b=XssbU5lhNc7Bx9JOomWKYG+ZQMx5DcV3YM6GMtjVdBKvv0foN0tyLz0Yi/VdptQ1Nt27d5rNZi8cF7qCkl0G1+QlSQbgzD6ja+96YlZ05sT501UFJZm0tslDrTion3rOkaYgmeLWtK8O5RjmrSMD0P6YeevAUhBRehv6O/NY94s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969978; c=relaxed/simple;
	bh=M3cTYHgV4/ta8WUjuVLFzUCISqzHfL1X/M74EKQS6AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lql+WhBMrxYM/MuPzINipkdss5iMxWk2SLOS1Iq601ZyHaBCic8e86rRqYzVmmtcBTRwJ9a2spj8Ys2xsx2C7PZpAQYBtyj4YFCpgn0RWlmoyPDCIFCgsbEU4zimEewAo/fOU3Dh22cUc+pDgYJ8zJcHx9xKkKAcy7Y/JPriAm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Njuxft5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Njuxft5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C428C4CED3;
	Mon, 23 Dec 2024 16:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969977;
	bh=M3cTYHgV4/ta8WUjuVLFzUCISqzHfL1X/M74EKQS6AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Njuxft5diuW2/MU6P+vrMQxgabpMN8Q/hsSyMJY+BPu+sO6SX8UVqyz+HvUAlkk7g
	 56olULRobh5upnGxucbXQmFP8wIg25Ra8aThdyH0bVTnHVLhxIBj0w6jm8gb+Dj/af
	 wOq/sOazHC/ooIZKkxwrmW6l5M5RT6PxlSQZuzfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 107/160] drm/amdgpu/nbio7.7: fix IP version check
Date: Mon, 23 Dec 2024 16:58:38 +0100
Message-ID: <20241223155412.812647012@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 458600da793da12e0f3724ecbea34a80703f4d5b upstream.

Use the helper function rather than reading it directly.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 22b9555bc90df22b585bdd1f161b61584b13af51)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c
@@ -247,7 +247,7 @@ static void nbio_v7_7_init_registers(str
 	if (def != data)
 		WREG32_SOC15(NBIO, 0, regBIF0_PCIE_MST_CTRL_3, data);
 
-	switch (adev->ip_versions[NBIO_HWIP][0]) {
+	switch (amdgpu_ip_version(adev, NBIO_HWIP, 0)) {
 	case IP_VERSION(7, 7, 0):
 		data = RREG32_SOC15(NBIO, 0, regRCC_DEV0_EPF5_STRAP4) & ~BIT(23);
 		WREG32_SOC15(NBIO, 0, regRCC_DEV0_EPF5_STRAP4, data);


