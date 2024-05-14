Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D666D1A0;
	Tue, 14 May 2024 11:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685274; cv=none; b=W/rwsBhX1fYjwlO95lxMaP2DNclSsKxO+EXJIRWBx0nUmjr+lHI8plUiEAJNte7w8COj1QKRk1/8AhppODauJYcGsF4WxlmNQRbtYGH11UBw3LupfLPUfR0p5wQV7oUyQIXHiEhl0Rmdk8XE15pyv7FUa94XjsxjcfHTxaFsF1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685274; c=relaxed/simple;
	bh=UEbdgKuOPZoVhvqKBmUvE8T/xkKdZtjjT5iPs82uRTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjAM6I4hhjKCqNe84onK8DcvTemvGa5rOI+n4faY5xthusrdu1TLiT2rteXtn2MtJaY9U6ARTap4QbiF+dBs9C7ZeJan0LRdivnOO7PlXxI3xk80h2JVwwlXlOiHprbgVpw3R7b8cWqp1/wcMQx8r30jcBOMut9vD5TKieu9MaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihdZNYg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihdZNYg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F054C2BD10;
	Tue, 14 May 2024 11:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685274;
	bh=UEbdgKuOPZoVhvqKBmUvE8T/xkKdZtjjT5iPs82uRTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihdZNYg6J4RSH6RLOLK1l843sDfcYWhsnNqBGEzrzVOUh/G9UVDR7wX8HB+kxL9S3
	 MT2L8N4AfSudqgyuHDm6uxsocAhr9Lf7h0ssnB29H3D58fQxpdWsh0hwJjbJyd4exb
	 wCjLV6cLKAXtiWOlj60va9hhTn7ZZ2Mpo1nJIFVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng17@lenovo.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/301] tools/power turbostat: Fix Bzy_MHz documentation typo
Date: Tue, 14 May 2024 12:16:42 +0200
Message-ID: <20240514101037.194023238@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8f08c3fd498d5..1ba6340d3b3da 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -370,7 +370,7 @@ below the processor's base frequency.
 
 Busy% = MPERF_delta/TSC_delta
 
-Bzy_MHz = TSC_delta/APERF_delta/MPERF_delta/measurement_interval
+Bzy_MHz = TSC_delta*APERF_delta/MPERF_delta/measurement_interval
 
 Note that these calculations depend on TSC_delta, so they
 are not reliable during intervals when TSC_MHz is not running at the base frequency.
-- 
2.43.0



