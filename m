Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9975315CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131B7C433C1;
	Tue,  8 Nov 2022 14:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916641;
	bh=xdh7G/bIiGGJA9u5xFJF/ax3tcZiKlc8bZPavpkA3MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5ZXMMWp3bz3DTLP5kgeE5HeO/1zVd2rJOz97yxlrQ5Yg1ouXFDMXaUVFAsrrhK3e
	 RHJbW8v9qBvkQZV3Q3ti6VxstwKJOwVhRAivzYb7t4pT6Ed6siw+Nd2doVAa38oPOF
	 xU1sR6tMHLZvpjvV48wsR2ojVI0X+l01IeeKEvR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Guan Yu <Guan.Yu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 085/197] drm/amd/pm: skip loading pptable from driver on secure board for smu_v13_0_10
Date: Tue,  8 Nov 2022 14:38:43 +0100
Message-Id: <20221108133358.707384081@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit f700486cd1f2bf381671d1c2c7dc9000db10c50e ]

skip loading pptable from driver on secure board since it's loaded from psp.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Guan Yu <Guan.Yu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index 93f9b8377539..750d8da84fac 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -210,7 +210,8 @@ int smu_v13_0_init_pptable_microcode(struct smu_context *smu)
 		return 0;
 
 	if ((adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 7)) ||
-	    (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 0)))
+	    (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 0)) ||
+	    (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 10)))
 		return 0;
 
 	/* override pptable_id from driver parameter */
-- 
2.35.1



