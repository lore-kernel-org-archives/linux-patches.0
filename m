Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F5C3093CF;
	Mon, 13 Apr 2026 16:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097635; cv=none; b=ko8bMqsw/P+UN6NJOunoy1Xeq7O4+iw0No61SHMy46G+GD067VKJpD5v31s1jKT0FNIxm7s3GUavk6nHCaa41P5H9ryAzcCUc5AbImpihxtx5l02Ig0f0IVoORrjwZbAkqAnIJgsxNNs7C4R+33bXT4mUR/H/r9gzvXUKU9jMEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097635; c=relaxed/simple;
	bh=V2aY2AoRycYheB1ZHFeXWZrW9kPNtIB+Wp4IO95S5vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHmOLL3yJdksHXFmBVxE5Ttn7Y1fTNqW8coCfZTLFHFbsCOiWwmzKIM5YG0YMS6ySUCcdOG6erBLx94ZJloIcuJnWx6d2o4JlKrY95rq7GZcrMBfC7zNFrShp0OwenA7UKF1l/pWRsgPybDNUNembeIJjh3s3xNMhvToXRAzV0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAq23LoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAq23LoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D688C2BCB0;
	Mon, 13 Apr 2026 16:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097635;
	bh=V2aY2AoRycYheB1ZHFeXWZrW9kPNtIB+Wp4IO95S5vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAq23LoAa6tfKVO8rh3XANmWphrtYFRYxZXZgF4X75HJ740oGtRU0VD3SkyFvBJyJ
	 QbLFqp4dyneQBPxaXQa6YaT33VTzC4Xqt50+01ss3TsK5zQbAfTJjEUTavDUr7npBw
	 mAV98EKksP5Q2Wbll9fIoOi4n1UCUpGKBTIG3HQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 213/570] drm/radeon: apply state adjust rules to some additional HAINAN vairants
Date: Mon, 13 Apr 2026 17:55:44 +0200
Message-ID: <20260413155838.435190512@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 86650ee2241ff84207eaa298ab318533f3c21a38 upstream.

They need a similar workaround.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/1839
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 87327658c848f56eac166cb382b57b83bf06c5ac)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/si_dpm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -2959,9 +2959,11 @@ static void si_apply_state_adjust_rules(
 	if (rdev->family == CHIP_HAINAN) {
 		if ((rdev->pdev->revision == 0x81) ||
 		    (rdev->pdev->revision == 0xC3) ||
+		    (rdev->pdev->device == 0x6660) ||
 		    (rdev->pdev->device == 0x6664) ||
 		    (rdev->pdev->device == 0x6665) ||
-		    (rdev->pdev->device == 0x6667)) {
+		    (rdev->pdev->device == 0x6667) ||
+		    (rdev->pdev->device == 0x666F)) {
 			max_sclk = 75000;
 		}
 		if ((rdev->pdev->revision == 0xC3) ||


