Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968B4352F86;
	Fri, 21 Nov 2025 13:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732658; cv=none; b=vFRC/gqN0JterBDVUVYiN3Do3TJ7IUqXb644iPDH3JBGgHXWd7p92rGyd8pp6yKDyxPqZKbrrbFjD+U/yQju+O9mPmOGG8KGILbBzmY7poZ1U/ijssetzcDqis2tbWk8WCecdLrB/I1TkycwF1uN1dc1+vKi0awTxfMQdWjUzjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732658; c=relaxed/simple;
	bh=2CxqMqkStMErviIIoGeRkKhx2eFkBUl0x34F6re5auQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNNi/NfJfR0hj/AViR5jgBV0+StkWio/jvep5LIwGPaY8ItIusd85PxScZa5AIC5hK0ArUHGoYrSFReapckBajbqYjhq1n28Ae5yIGgVkXiP6A5NifLRB4sjKDDuek3+lFjjbwy/iHXt0195pNro9TGdvkFU+e7Bb3JBl0E8qKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08VLereX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08VLereX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC7DC4CEF1;
	Fri, 21 Nov 2025 13:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732658;
	bh=2CxqMqkStMErviIIoGeRkKhx2eFkBUl0x34F6re5auQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08VLereXC/rJi8UhjlvtcffiLxxXIfAJmQEwwTWfFqWq2gVo8j/RxNZjla55PMZ20
	 xfBEkiVlZDBanFeMYgVNSnbMAWf0tW2eI+8LUmizXKf7lMHUOH5RFzGfUQ0LyjcvB4
	 SSql3N5s9FhcEWND/4+Nk40tV3KJEVC+FKZVnCS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/529] drm/amdgpu: dont enable SMU on cyan skillfish
Date: Fri, 21 Nov 2025 14:08:16 +0100
Message-ID: <20251121130238.026380707@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

[ Upstream commit 94bd7bf2c920998b4c756bc8a54fd3dbdf7e4360 ]

Cyan skillfish uses different SMU firmware.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index b04d789bfd100..2e492f779b54c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1819,13 +1819,16 @@ static int amdgpu_discovery_set_smu_ip_blocks(struct amdgpu_device *adev)
 	case IP_VERSION(11, 0, 5):
 	case IP_VERSION(11, 0, 9):
 	case IP_VERSION(11, 0, 7):
-	case IP_VERSION(11, 0, 8):
 	case IP_VERSION(11, 0, 11):
 	case IP_VERSION(11, 0, 12):
 	case IP_VERSION(11, 0, 13):
 	case IP_VERSION(11, 5, 0):
 		amdgpu_device_ip_block_add(adev, &smu_v11_0_ip_block);
 		break;
+	case IP_VERSION(11, 0, 8):
+		if (adev->apu_flags & AMD_APU_IS_CYAN_SKILLFISH2)
+			amdgpu_device_ip_block_add(adev, &smu_v11_0_ip_block);
+		break;
 	case IP_VERSION(12, 0, 0):
 	case IP_VERSION(12, 0, 1):
 		amdgpu_device_ip_block_add(adev, &smu_v12_0_ip_block);
-- 
2.51.0



