Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C478F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95864C4339B;
	Mon, 13 Feb 2023 14:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300209;
	bh=RjQ1xj08Jy6vW/6dRljkUKBEhu4sCKRHG9ljjbnbwa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdHUSOVzyIKQIFONboXtywtL4rZeMkV8iYAvQbHcP47n6J2y5edLSnu/6WKAPY0Pz
	 1YmEAL4UZBppfKgD5u/Hf7pHpSI4TGnyBTHzn8sC2ZDhYiHG30CX2YTmSEJsYKYEDz
	 fKPFBadECKSj1YhWFQ+578H7ithqvNGvIPiqpkx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 106/114] drm/amdgpu: Add unique_id support for GC 11.0.1/2
Date: Mon, 13 Feb 2023 15:49:01 +0100
Message-Id: <20230213144747.686317636@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kent Russell <kent.russell@amd.com>

commit c108a18462949fe709ebd6b0be68398d643bc285 upstream.

These can support unique_id, so create the sysfs file for them

Signed-off-by: Kent Russell <kent.russell@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index a9170360d7e8..2f3e239e623d 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -1991,6 +1991,8 @@ static int default_attr_update(struct amdgpu_device *adev, struct amdgpu_device_
 		case IP_VERSION(9, 4, 2):
 		case IP_VERSION(10, 3, 0):
 		case IP_VERSION(11, 0, 0):
+		case IP_VERSION(11, 0, 1):
+		case IP_VERSION(11, 0, 2):
 			*states = ATTR_STATE_SUPPORTED;
 			break;
 		default:
-- 
2.39.1



