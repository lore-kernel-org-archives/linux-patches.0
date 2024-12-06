Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795E515575F;
	Fri,  6 Dec 2024 14:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496390; cv=none; b=VQWFBQc+98UhK3MA0OwKpz8D/yljzlpXiwJwy4gkaL1VfuZycQomKPEhTN3nxXUJ6A8lYRIO4SgD2gvo7viZpq5/FqoJgHzmqXHeZcg/l8ew1EG/WzntHVo4cTLEtYlSWIwU86oVSxoOiXLlwgu6HDkTlojeObhoVkerxT8c+D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496390; c=relaxed/simple;
	bh=GCrn4YTUPu61iPHHP7GK3EQU3d75tPPQFafrb2fe0Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaFr6C8t0uZ+QYUHWUNK3Vflflj2r/CV35ydHD5FbwGuYflpYVu9v1RUZy9s9MeaRHAs5GET+BVJFLLg8ssWm2dmEqVqXDRFK0j6Mnct3Elpfqoh7Sqot5o+gCmCLw+2eipuDBbtmHLKU16w6ad15dHsAC6Sfv/Tt3m5JO+lmXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtaVzd4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtaVzd4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE45C4CED1;
	Fri,  6 Dec 2024 14:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496390;
	bh=GCrn4YTUPu61iPHHP7GK3EQU3d75tPPQFafrb2fe0Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtaVzd4doDx1o5T0QABGXxnUqttuBtmVLm3s1c+bVt0rJy9Uum3TYa7OjvOWrx/ok
	 kPqNTWqfl/4PTfqEWTqmqZi/CSaZlHzKFn6Jqr+RyyQCU6R9AhzYyuORpFC9Ktsb8E
	 RVJQr/oHc3HDejC2qDi4uyE6KRlMLqfPejSqyzxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 138/146] drm/amd/pm: skip setting the power source on smu v14.0.2/3
Date: Fri,  6 Dec 2024 15:37:49 +0100
Message-ID: <20241206143532.965675058@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

From: Kenneth Feng <kenneth.feng@amd.com>

commit 76c7f08094767b5df3b60e18d1bdecddd4a5c844 upstream.

skip setting power source on smu v14.0.2/3

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -2769,7 +2769,6 @@ static const struct pptable_funcs smu_v1
 	.get_unique_id = smu_v14_0_2_get_unique_id,
 	.get_power_limit = smu_v14_0_2_get_power_limit,
 	.set_power_limit = smu_v14_0_2_set_power_limit,
-	.set_power_source = smu_v14_0_set_power_source,
 	.get_power_profile_mode = smu_v14_0_2_get_power_profile_mode,
 	.set_power_profile_mode = smu_v14_0_2_set_power_profile_mode,
 	.run_btc = smu_v14_0_run_btc,


