Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA81822323;
	Thu, 18 Jan 2024 10:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575113; cv=none; b=Vw3cKgLztrMNqWPBCt4r/Iw6w50/PCCtlbn+dLkm31IqtevzuKLMVv509oMxpvKvHdD/3Wg48DL7EqxL6B5pnshxzA8DmQduNHapoucpCdJxmLoHoIjH/oJiPLIteEeo6JzGxJWdigojZrF4wiJA+OgumW0OHQKbhsaIzPpvx2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575113; c=relaxed/simple;
	bh=0PaPTv0LI0WzhkZuPUqnrHkA0f0qqLOxGKZaxfHbHG8=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=olDuuve0a+ceCKuNy9DaSRnWGBQmQX7/URhgp3fH2C3TXRP0TPEKiZsj2FsxfUxXUTXU6AbcmzEeWdtwdKlseZ98SyvCQCBpjiCbDonxLTYbcqE+J/Z5ViF3iVM/xX6fwZZvi0RoJxXMPA8UVs9OMriQhFgUZjEGw+0M8RpPwPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1FQR5Oi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1FQR5Oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA14C43390;
	Thu, 18 Jan 2024 10:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575112;
	bh=0PaPTv0LI0WzhkZuPUqnrHkA0f0qqLOxGKZaxfHbHG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1FQR5Oig/MDAdShV7wPMiOcXwoYEY/ttT0GTm0N4OndnDjU9UYYRvMF/J2Q9fFhC
	 LPiPJLnbyImkhiUIQNL0SzYFgiM8N0qI7m1Im25L4oJqynZHP57BB0A9jOlzrGlboi
	 uYyQR3ZltQhEUZAoB+nuHIngypoOtwciGMPspEVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Stanley Yang <Stanley.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/150] drm/amdgpu: Do not issue gpu reset from nbio v7_9 bif interrupt
Date: Thu, 18 Jan 2024 11:47:18 +0100
Message-ID: <20240118104320.794833743@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit 884e9b0827e889a8742e203ccd052101fb0b945d ]

In nbio v7_9, host driver should not issu gpu reset

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Stanley Yang <Stanley.Yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
index f85eec05d218..ae45656eb877 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
@@ -604,11 +604,6 @@ static void nbio_v7_9_handle_ras_controller_intr_no_bifring(struct amdgpu_device
 
 		dev_info(adev->dev, "RAS controller interrupt triggered "
 					"by NBIF error\n");
-
-		/* ras_controller_int is dedicated for nbif ras error,
-		 * not the global interrupt for sync flood
-		 */
-		amdgpu_ras_reset_gpu(adev);
 	}
 }
 
-- 
2.43.0



