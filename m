Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0082C11C88
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE46C433EF;
	Mon, 12 Jun 2023 10:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566550;
	bh=na9N3aXF/9uTUa++8QxH3vtHXE4sIUNb1Q8uxiW2zHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDFc6IS2b78avZPQO1BLankEmC8CEzAFNOZbkf6KKTU4wPLSp5sa9BlM06qF52gyx
	 RjyvwjoAto7OushNvVSuhooq6I/7HCODrZOIqaowQn7Dq3cPwSnFjZ9q5tt+eGL6HH
	 KaH8G/I1VfnL9wJRgs9lKFALaUFuD4toPrFG0oig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 075/132] drm/amd/pm: Fix power context allocation in SMU13
Date: Mon, 12 Jun 2023 12:26:49 +0200
Message-ID: <20230612101713.681850019@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lijo Lazar <lijo.lazar@amd.com>

commit 1d13c49cf4e246b218d71873f1bb1bbd376aa10e upstream.

Use the right data structure for allocation.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -582,11 +582,11 @@ int smu_v13_0_init_power(struct smu_cont
 	if (smu_power->power_context || smu_power->power_context_size != 0)
 		return -EINVAL;
 
-	smu_power->power_context = kzalloc(sizeof(struct smu_13_0_dpm_context),
+	smu_power->power_context = kzalloc(sizeof(struct smu_13_0_power_context),
 					   GFP_KERNEL);
 	if (!smu_power->power_context)
 		return -ENOMEM;
-	smu_power->power_context_size = sizeof(struct smu_13_0_dpm_context);
+	smu_power->power_context_size = sizeof(struct smu_13_0_power_context);
 
 	return 0;
 }


