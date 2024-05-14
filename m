Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190C1F9D4;
	Tue, 14 May 2024 11:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687787; cv=none; b=jhxBLFXfJoAjt8+gExlbxwNWbxAhKy78JeMWNDpXhoTfUGAMd3GGsverX7/o+23NkptUUlSBgqC/TQmSXDR3E8wWXt2VWPusqldOvRqel8GO7zHdhIMU+fEwnzEa0vhuEGETdrsy/ButDa/mlPaVYK689Q7Z+2iwTc8LBe5arco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687787; c=relaxed/simple;
	bh=dTO2IZshiySB7K/m84Ou0gRyTInFJjd3Am9TBTu28k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXqLqVxzRHXlH7uvTm1z9drGrmiLghsX0UstIvmvZc4Orqgis4oBZwszvma3Y6Obbcgpb349DOer3hKbLGA8gIFhFNWgPCfLJi3wKI9jErE0XOAl068cASPYausBHV2//UfXTmDxymT54OD4Xa8MecY2fnF9VnQPpqNxeg5gyrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3iYdEc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3iYdEc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A32C2BD10;
	Tue, 14 May 2024 11:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687786;
	bh=dTO2IZshiySB7K/m84Ou0gRyTInFJjd3Am9TBTu28k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3iYdEc3fxjOo0F5x8wnC9hMm/wyzd12zVyfuMEFnV29Sy7EPkmSDBuO843dtUNoA
	 /rScDVYa3SF3v9sWJLP6F8MpgAkPWPA+O1rFgOjSSSACiRmbwWMqsVtaiS3OTX/w/b
	 FUbhkAEXhFq3E+2Jh1QFoahJr/fTUQ5xQ9TlOANU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng17@lenovo.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/168] tools/power turbostat: Fix Bzy_MHz documentation typo
Date: Tue, 14 May 2024 12:19:35 +0200
Message-ID: <20240514101009.601689112@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Liu <liupeng17@lenovo.com>

[ Upstream commit 0b13410b52c4636aacb6964a4253a797c0fa0d16 ]

The code calculates Bzy_MHz by multiplying TSC_delta * APERF_delta/MPERF_delta
The man page erroneously showed that TSC_delta was divided.

Signed-off-by: Peng Liu <liupeng17@lenovo.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index b3d4bf08e70b1..f382cd53cb4e8 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -322,7 +322,7 @@ below the processor's base frequency.
 
 Busy% = MPERF_delta/TSC_delta
 
-Bzy_MHz = TSC_delta/APERF_delta/MPERF_delta/measurement_interval
+Bzy_MHz = TSC_delta*APERF_delta/MPERF_delta/measurement_interval
 
 Note that these calculations depend on TSC_delta, so they
 are not reliable during intervals when TSC_MHz is not running at the base frequency.
-- 
2.43.0



