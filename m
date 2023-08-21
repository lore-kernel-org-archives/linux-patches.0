Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9231C1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10982C433C8;
	Mon, 21 Aug 2023 20:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648587;
	bh=5SUj5yo388A9EBiJZfnpq+U02gFkJdMQTtsntbfhjIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itLvXSYq5MkhVB8Bl0rbuY+fD4LQ71JlVdkcdticQl4k9tcd3oGKBFWaZ1kmOwIY8
	 sIgmm1k/gAEcDPaPPteTtuhraEjwXki7XZj054PktCPBL3c1jVVQywC90zZt+0o6Ia
	 9shM3y2d8TpYRjuzsm1S8hjC0/kHws5rJFkqcszU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 229/234] drm/amd/pm: skip the RLC stop when S0i3 suspend for SMU v13.0.4/11
Date: Mon, 21 Aug 2023 21:43:12 +0200
Message-ID: <20230821194139.044287422@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Huang <Tim.Huang@amd.com>

commit 730d44e1fa306a20746ad4a85da550662aed9daa upstream.

For SMU v13.0.4/11, driver does not need to stop RLC for S0i3,
the firmwares will handle that properly.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1573,9 +1573,9 @@ static int smu_disable_dpms(struct smu_c
 
 	/*
 	 * For SMU 13.0.4/11, PMFW will handle the features disablement properly
-	 * for gpu reset case. Driver involvement is unnecessary.
+	 * for gpu reset and S0i3 cases. Driver involvement is unnecessary.
 	 */
-	if (amdgpu_in_reset(adev)) {
+	if (amdgpu_in_reset(adev) || adev->in_s0ix) {
 		switch (adev->ip_versions[MP1_HWIP][0]) {
 		case IP_VERSION(13, 0, 4):
 		case IP_VERSION(13, 0, 11):


