Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD3531715F;
	Tue, 31 Mar 2026 17:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976913; cv=none; b=GIn0YR6BetJmB4nHHSfSxNQPI4wLpsRBbImIfXtsQ3el/xZBQuhUP4AR/4bGAGUnAowGN4whjIrfDfX9E5sGRhiqlFscOYFzXTz3wsUPO2/T8E91sSsazl8LoGhWvo4qeP2jOowB3ZdBe6OEJu+IP1uwpgYxAcf11ECTrWtec+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976913; c=relaxed/simple;
	bh=F/JmbEEaJyX7ZD9CgnBmQeQ9Ks3zeQqmL4OFis5Twug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xly3qVBLB7uJDZP+UJ8w84CX1UQlFx8iLJdnziJFLnDh1jbu9ouQ9+Omdz1Nkf9gwIsWzsmy1tcY/96wMQqc6kDWM3Xesmuv7+RkduvJel2qTaNtee6ch67ptcIgtxpk50u8fOe7YjW6i36UR6M5SXR/eHZGLylKYm4qSvkZo2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtNqv5T2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtNqv5T2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E952C19423;
	Tue, 31 Mar 2026 17:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976913;
	bh=F/JmbEEaJyX7ZD9CgnBmQeQ9Ks3zeQqmL4OFis5Twug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtNqv5T2Sk+5oyI87g0ow3jlJSi5FKlg9esp9SUTnZWwrBxe1CZYyCDbpuDAR7INU
	 RsKsij0EI2hCWxYSjZfvVRGFyy+uZKyqWB5evDCgDqg/6QFHGscbkb4DJKgGfC34Q3
	 EdYu95e+OEJfC3sB+dRS2/UILOLWyWcWs9Ul7/Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 243/309] drm/amd/pm: Return -EOPNOTSUPP for unsupported OD_MCLK on smu_v13_0_6
Date: Tue, 31 Mar 2026 18:22:26 +0200
Message-ID: <20260331161802.516375710@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Asad Kamal <asad.kamal@amd.com>

commit 2f0e491faee43181b6a86e90f34016b256042fe1 upstream.

When SET_UCLK_MAX capability is absent, return -EOPNOTSUPP from
smu_v13_0_6_emit_clk_levels() for OD_MCLK instead of 0. This makes
unsupported OD_MCLK reporting consistent with other clock types
and allows callers to skip the entry cleanly.

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d82e0a72d9189e8acd353988e1a57f85ce479e37)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -1494,7 +1494,7 @@ static int smu_v13_0_6_print_clk_levels(
 
 	case SMU_OD_MCLK:
 		if (!smu_v13_0_6_cap_supported(smu, SMU_CAP(SET_UCLK_MAX)))
-			return 0;
+			return -EOPNOTSUPP;
 
 		size += sysfs_emit_at(buf, size, "%s:\n", "OD_MCLK");
 		size += sysfs_emit_at(buf, size, "0: %uMhz\n1: %uMhz\n",


