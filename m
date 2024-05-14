Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026C013D275;
	Tue, 14 May 2024 11:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686815; cv=none; b=dPKDbgWjuH+Z6+aS+INRfop3TLD7o8qZmoi+Lk1dLpvIt9kyGoG92zCTu4wr56plZ4QIrTJQZj/TA8F7uTmQmNozo4sXkQ13qr1kr1uD30M+HS2K0VBLEnXVsagxdpkCKKjfZkwNZN/nfs7kwUIcEsU0Ea2zcDNMilrccRThhGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686815; c=relaxed/simple;
	bh=HDXYNlxWi390Dg5rALdY6LI0TpevcSKP+p+hVpX1w+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1StA9RBGe5iB254dyC9Ec81MjOl0/mE7HHG3ZeSKsTOX6x7WmN5gxAOuM6qMiJXkuF45DdTQFVDxijdoodnk3GonJgD3wTbyO/kQohOs0Qjw1ncueEuGjEkyT9wmj0qryDXXrSpTKLjd1brpDxNrIhGcG7GYl9tzf+G5qQusTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3nvAiEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3nvAiEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE8BC2BD10;
	Tue, 14 May 2024 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686814;
	bh=HDXYNlxWi390Dg5rALdY6LI0TpevcSKP+p+hVpX1w+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3nvAiEz8svL5Hx5ckDxWrkpCTQDRN+wVkhvU/QWaUw/4soGjeni3qkbVsmKqu/Um
	 Xj6zQdU3FQbTSTeWMfkq8Xr1kenxnTmNc0mcSG59ykL2/ZQFzmbpMBideYSrcRnarX
	 n+p1++gCgzPUa8mWxghR6t7BIpZHeMCsMRZZkyeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng17@lenovo.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 32/63] tools/power turbostat: Fix Bzy_MHz documentation typo
Date: Tue, 14 May 2024 12:19:53 +0200
Message-ID: <20240514100949.230298867@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index a6db83a88e852..25a560c41321d 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -318,7 +318,7 @@ below the processor's base frequency.
 
 Busy% = MPERF_delta/TSC_delta
 
-Bzy_MHz = TSC_delta/APERF_delta/MPERF_delta/measurement_interval
+Bzy_MHz = TSC_delta*APERF_delta/MPERF_delta/measurement_interval
 
 Note that these calculations depend on TSC_delta, so they
 are not reliable during intervals when TSC_MHz is not running at the base frequency.
-- 
2.43.0



