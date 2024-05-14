Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126CC1D54D;
	Tue, 14 May 2024 11:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686419; cv=none; b=BJlENYx0lKXOni+jnQyJqKr8KRBBqziuRjUgoe8zmKlQIomENEmY0qy29oGzY+Os3nOqgFIgLAleOrsTktkc3rKSuAdMdsqEs9Bp9FvOS3gUWwXD3pobDzTfu2AZBwCSLoCp9Szgi45rKXLHQ+jL8+Sadv2zXG0xFZs78i/rPho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686419; c=relaxed/simple;
	bh=wH23srDi+6CgZCLkoOIAxIK3aX+GYybU7i1VLZk3q7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHPpVR+JuuttjV3C3AHOhFr8K8WZg89ENTj63eL7S+I4AyQrw2WGJGMjjBX1efdiZPNXlhQivbxUdx5zcEuRPYVPATudpwEq7Z7EQMZRQjsal8dytuGhKqmQG/HjgmFpC2XUhcWwYXAvBJIdH4RDXVNGvgzyyCezB0PEdNZ7DYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HS0FuMpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HS0FuMpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F857C2BD10;
	Tue, 14 May 2024 11:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686418;
	bh=wH23srDi+6CgZCLkoOIAxIK3aX+GYybU7i1VLZk3q7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HS0FuMpeA3duzpK0teDQuoKPJEfnmHAPQ3W+8jLOwFs6qwmGRpfVESmCq1oErntND
	 2bW7RYTg5Rdus5xbVmkixa/wMX7J0Z0y6cz5AkrN4kwnzveaE/onOgRjLFyQ5PxLnZ
	 F8qljhrGjIZFvQVk8EZvsiFZE8pUVzem99kYmwx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng17@lenovo.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/236] tools/power turbostat: Fix Bzy_MHz documentation typo
Date: Tue, 14 May 2024 12:17:56 +0200
Message-ID: <20240514101024.701787940@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3e1a4c4be001a..7112d4732d287 100644
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



