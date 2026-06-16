Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EE83A9627;
	Tue, 16 Jun 2026 16:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626263; cv=none; b=UcqTviq7GUT0Z3iIqnVWzOT5N21Z9ECi4v3e8vtJlxuwmARFgy4NYBaZQv/WXCvaaI49o/Qm4Swv2Sy9kOxphlvXEWmFoXLfNUlqAKFzkp1Q+ulJZ3sXsMNwdaibpa1YmiSRmjzzzqF1ZQfuJCRffFtGjD0oSf1CDMQ5OgO8w0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626263; c=relaxed/simple;
	bh=YlVqYevady0+1uEjlM0QNiximOr3Cp/JqLqXM1WGZfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJVnEsWzQvZUHt8fL/o6CbBACwpHo1g+SwoGRbGxrktO5TyAQ+M87qLa9UDug0ONoB1djDDXc6Vf2PR4+YZ945euBEWmljlciRpPhI4UiS3ZUIZo1Ik1QQwaTjFfFVJJJg9Gv9NScnGIbrczb7v/r1cR5i0QrnIZ0dle00EA22c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8Z8xNSX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8Z8xNSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816A01F000E9;
	Tue, 16 Jun 2026 16:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626262;
	bh=eVBLKhAtAjlWLBzygdLZUbhwEmLRliESfyjk9FcI3V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8Z8xNSXGA05a/X0Z4XY1uzP/l8soikyT0iXSd9ZmAa1XqFACG5q3tfenLABUOIfi
	 6E+RXa418tyMdgTo1RUG3i4Xe6AXHQSYiyD0uRjEjoYfbQt56dCzr/zUI2nkCmuuQj
	 SEP24hte+H/LpQ3qgCoonG8aQkKbXTyA1eahnkwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 295/325] drm/amd/pm: mark metrics.energy_accumulator is invalid for smu 14.0.2
Date: Tue, 16 Jun 2026 20:31:31 +0530
Message-ID: <20260616145113.527686465@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit ee193c5bbd5e2b56bbeb54ef554414b43a6fc896 upstream.

EnergyAccumulator is unsupported on SMU 14.0.2, mark it invalid.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 646b05043eeed04b51c14aad22a400a8250af4b7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -2222,7 +2222,6 @@ static ssize_t smu_v14_0_2_get_gpu_metri
 					       metrics->Vcn1ActivityPercentage);
 
 	gpu_metrics->average_socket_power = metrics->AverageSocketPower;
-	gpu_metrics->energy_accumulator = metrics->EnergyAccumulator;
 
 	if (metrics->AverageGfxActivity <= SMU_14_0_2_BUSY_THRESHOLD)
 		gpu_metrics->average_gfxclk_frequency = metrics->AverageGfxclkFrequencyPostDs;


