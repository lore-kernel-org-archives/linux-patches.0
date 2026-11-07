Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060569;
	b=efR8RJOiyRoTX67EeMnqH8DS9DFKcrW8gdJNvmRvMLubFhNFvqmOiyHLQACS43+zXywp
	 c2vwE1URV49AG+GoWNBs/EZj5wkIkCIhpID3R7w9Qc3DDTpDI11oQe9alH51InRRdRqlQ
	 FGaLSR8+sEGs0U9TvAsHy388bSfpaejiMljTQizrykWmA9EnkaBodCfKrtvp2Qw+Lunj5
	 Iqi8QWgrJAKQVEp1mqtz2cFiHtBj1RDTCo+RhLet30Nl9F+fZ1xWqbVdkB+JvTD/fgIDT
	 SwovLE6Npv38MWXQ+mVLWUC2Tdg6Aw01Z5Q+iP4Uk7x5lvVxJsTezMDiyaynROHwJ/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DtdblSmqJ4KnZbquaWTU/g8stRhOzIo8ttxv8FLxbSQ=;
	b=uGEeUtLscZ7R4UtPdGHG/K71Kc4IfqFYbjDbUGCihvAZiSLeH1oI2FobE1MbNF5b2p4M
	 01NjaGBIxOnlq9gukOfObiPAIHUfk80G2ay+PqkPVgfKtcqb0LzSwuR5l2fFfu+VP8asf
	 MAy4QBkY59+WQ1T5/jb56utKzDmxg4mwMxQFoeOp3et9ldLaev+UdOmqpQkuz4TZ7oDUl
	 pgU3iwgh6SJoubcXnN23CA3ZHCK9Gl+9PggscuF45Xzk0beidqsyLZDW6kWONUBQR8joM
	 H/Bkm4U382Py+u+btA4QZPolWPyWV4lvtvKHQI1ZhADdNxOnDKDlinqIFecgcLAVTHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gmEcatQR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53978606A326;
	Sat,  7 Nov 2026 14:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gmEcatQR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F104A1F008A1;
	Sat,  7 Nov 2026 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060569;
	bh=DtdblSmqJ4KnZbquaWTU/g8stRhOzIo8ttxv8FLxbSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmEcatQReD0j/zd6H8qqBLo7eQh+WHhYSkOZ/M3lQZ7HaufU9PuDgjl6H5FktrnzI
	 mpWpoPjAv12ECQJ9m/z2bg0/9jmnMpshn3chxBVmiZRoLDr+TMTheDEaySB6n/oBsu
	 7oAX4/5tCVr1TvKID4Hoiqk+PSllPThZnbJJGBJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0030/1536] drm/amdgpu: add bounds check to prevent array overflow
Date: Sat,  7 Nov 2026 08:34:06 -0500
Message-ID: <20261107134958.517117337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YiPeng Chai <YiPeng.Chai@amd.com>

[ Upstream commit db15c49a17b8fab9ada38f3a548e5353d7d6b1a8 ]

Add bounds check to prevent array overflow.

v2:
  Add warning messages.

Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 1784e484798b5..fda0e5c429f68 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -4248,6 +4248,13 @@ static void amdgpu_register_bad_pages_mca_notifier(struct amdgpu_device *adev)
 	 * Use this list instead of mgpu_info to find the amdgpu
 	 * device on which the UMC error was reported.
 	 */
+	if (mce_adev_list.num_gpu >= MAX_GPU_INSTANCE) {
+		dev_warn_ratelimited(adev->dev,
+			"mce_adev_list full, skip notifier registration (max=%d)\n",
+			MAX_GPU_INSTANCE);
+		return;
+	}
+
 	mce_adev_list.devs[mce_adev_list.num_gpu++] = adev;
 
 	/*
-- 
2.53.0



