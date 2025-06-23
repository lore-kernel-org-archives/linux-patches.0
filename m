Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D6A230BC2;
	Mon, 23 Jun 2025 13:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686014; cv=none; b=rZgnHLLnuHafdwrcyUDc8WwNpn6fMOSGI+pZKcNWxSCVNIRH5TORQjFiYV37VhkI7dU9gMJCj5cLlNFdtJHuXQAjkrRxMVbAygmWOlogShxUTSe5jXVnmMAsj/HAxlfJQ1+t8v48iScwH0FWggVXItJ3FF5WZPLAOYFEa+f8F2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686014; c=relaxed/simple;
	bh=Olz0k3koA0PCZ5++h3sxmaetFqulgsfXXFe5pr8CqsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1QfZp4EVHnT0i+zZ68T12GFI1EyBxmWIIVE31Nl1OTigFXZvqjnbQFL9MyAki5zFwZyWpWZe41PwJe0GGE78tLj4q2hG7ODqg5TYBpoxUfVEACpadiCk1oK5OXLSqDR95/G4ww3FH0YZbV1oNjQnTadd+zqUWCArJ4NzRBbj4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1u8iAwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1u8iAwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C04BC4CEEA;
	Mon, 23 Jun 2025 13:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686014;
	bh=Olz0k3koA0PCZ5++h3sxmaetFqulgsfXXFe5pr8CqsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1u8iAwBffV6Ru9iqatfLc9tyHissXbi9Ghx3geL5HRjd93WcFVgBMdE6bDxd7K+k
	 XgUp2JRvIRP4my06q+UQi42tGsvOoZZlY3sWv3Zk42QwzRk/cgchQZJ/SC3Xi+U//z
	 KIuuVpohZvmDDWiezC4ulEGj6fzYgsFzJzMnvOtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Maya Matuszczyk <maccraft123mc@gmail.com>,
	Anthony Ruhier <aruhier@mailbox.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 266/592] drm/msm/a6xx: Increase HFI response timeout
Date: Mon, 23 Jun 2025 15:03:44 +0200
Message-ID: <20250623130706.642596335@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <quic_akhilpo@quicinc.com>

[ Upstream commit 5f02f5e78ec9688e29b6857813185b1181796abe ]

When ACD feature is enabled, it triggers some internal calibrations
which result in a pretty long delay during the first HFI perf vote.
So, increase the HFI response timeout to match the downstream driver.

Signed-off-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Tested-by: Maya Matuszczyk <maccraft123mc@gmail.com>
Tested-by: Anthony Ruhier <aruhier@mailbox.org>
Patchwork: https://patchwork.freedesktop.org/patch/649344/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_hfi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_hfi.c b/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
index 0989aee3dd2cf..628c19789e9d3 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
@@ -109,7 +109,7 @@ static int a6xx_hfi_wait_for_ack(struct a6xx_gmu *gmu, u32 id, u32 seqnum,
 
 	/* Wait for a response */
 	ret = gmu_poll_timeout(gmu, REG_A6XX_GMU_GMU2HOST_INTR_INFO, val,
-		val & A6XX_GMU_GMU2HOST_INTR_INFO_MSGQ, 100, 5000);
+		val & A6XX_GMU_GMU2HOST_INTR_INFO_MSGQ, 100, 1000000);
 
 	if (ret) {
 		DRM_DEV_ERROR(gmu->dev,
-- 
2.39.5



