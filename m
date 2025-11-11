Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5211C4A24;
	Tue, 11 Nov 2025 01:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824186; cv=none; b=TIi6WQwKCZqOgDtedrmLGJIpCukVAHJUJCiYELnkftwpvfMR5AjwojzPbFQp1kN/6sTHeQyPYx2thHbmgg8Oc+HuB+VnU4g88xvLNySrMsCZtxsZcVmqLIKrwuDDqVHMhYX2m1QmRQZfm6VnfX7cgno5cCAUL7I6JDShQ+pbM8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824186; c=relaxed/simple;
	bh=K3VArEx6DI15jb+KCa6NPUd2dcq6/Lr4H/0zzgKlGI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtNiGEDw1QLQWVh43nLJA1H1h9mGPmh4CayiJPYvG9mC4hyxH3vBL4W9IZ2bbpIjw5Wbihz6riB1WWoV5Q8b3/LpCAzkYrb8l3CwNpAf1lr/+Y7scyzW8Jqz7FSrDzKXJFC4FN0cLtseDHLeX3gCzf74P2XSLbE/b3dybc4vMUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qsv+p/ZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qsv+p/ZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEFEC113D0;
	Tue, 11 Nov 2025 01:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824186;
	bh=K3VArEx6DI15jb+KCa6NPUd2dcq6/Lr4H/0zzgKlGI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qsv+p/ZQimtgEGQVaack8pAtcI7lkCx6T70bFBnqVuRTKr8La2xhswH8mcHO2bfb2
	 ViCMnMV1nHHRllejTdC5M8iDnYZ4neBuukEwDfVSJi5VLbLUMPdJ+f0CSvTlMGFAsI
	 XpI1qNT3qTj56VZi9G1CckVqEFSzkKcHULMU42PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Ausef Yousof <Ausef.Yousof@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 458/849] drm/amd/display: dont wait for pipe update during medupdate/highirq
Date: Tue, 11 Nov 2025 09:40:28 +0900
Message-ID: <20251111004547.502368857@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ausef Yousof <Ausef.Yousof@amd.com>

[ Upstream commit 895b61395eefd28376250778a741f11e12715a39 ]

[why&how]
control flag for the wait during pipe update wait for vupdate should
be set if update type is not fast or med to prevent an invalid sleep
operation

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Ausef Yousof <Ausef.Yousof@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 2d2f4c4bdc97e..74efd50b7c23a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -4163,7 +4163,7 @@ static void commit_planes_for_stream(struct dc *dc,
 	}
 
 	if (dc->hwseq->funcs.wait_for_pipe_update_if_needed)
-		dc->hwseq->funcs.wait_for_pipe_update_if_needed(dc, top_pipe_to_program, update_type == UPDATE_TYPE_FAST);
+		dc->hwseq->funcs.wait_for_pipe_update_if_needed(dc, top_pipe_to_program, update_type < UPDATE_TYPE_FULL);
 
 	if (should_lock_all_pipes && dc->hwss.interdependent_update_lock) {
 		if (dc->hwss.subvp_pipe_control_lock)
-- 
2.51.0



