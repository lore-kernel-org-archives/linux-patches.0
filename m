Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D21A44607D;
	Tue, 21 Jul 2026 20:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665754; cv=none; b=EGwHDdx6o2dc9l2BTvCKJogrA/7YHOEKFmXsX8LC6Dheg1yMjoNps9j1gwzXhJM+BPMZKXTekA3RufkUVfwDRjOhvsJFnRq/PCjVuuXQ5zmxFX6ETWToJGCT381KN6kGNEsl4P3spDPjxaqOmQgUW0ihwxi4VL/OgrDwuvOlf8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665754; c=relaxed/simple;
	bh=dWtpo4Xh/Gxh+oQ5dUtPhkpjXF4Y/Li7m6jWqVgPE+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWuaSGbNNt9aZniX0X7oau0aNgZ+jM2c6f117oJ84/G9lt1a7oy7HqvSelFJhBwj+ij883KZZuDTb6osqC5mhC4AbViNwo5cOE2TadPdPJdcqyG454naeUweZ1HjMXumroK3HPZEc1LLWtcaTMzVb85MZOBhJnucPAPPtDMwkGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpPNvDAD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpPNvDAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC09F1F000E9;
	Tue, 21 Jul 2026 20:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665753;
	bh=5lDeQto07JHfz0f5i6CVn6MKijUs1r8J95AaNKjNCVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dpPNvDAD0VeT61dsJjDo0cxp+7VVpLf6hjm0nU/LfiSNHMBwT3t3qnPy8wnyTOAHa
	 ftI+Ice17yEeoKKcyYCkLwPrazrgJuEr5TqB8+GK0jH4mgUD3IDyRwFUUCeQIlLAfL
	 aQtrjZPCTDUiDCePcXBvBZUBimp3b4i+awBOh2es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0424/1266] cpufreq: Documentation: fix sampling_down_factor range
Date: Tue, 21 Jul 2026 17:14:21 +0200
Message-ID: <20260721152451.328571608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengjie Zhang <zhangpengjie2@huawei.com>

[ Upstream commit 85524e651d20944399322d46fb97960337831d43 ]

The ondemand governor implementation accepts sampling_down_factor values
from 1 to 100000 via MAX_SAMPLING_DOWN_FACTOR, but the documentation in
admin-guide/pm/cpufreq.rst still says the valid range is 1 to 100.

Update the documentation to match the actual code.

Fixes: 2a0e49279850 ("cpufreq: User/admin documentation update and consolidation")
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Link: https://patch.msgid.link/20260518133457.2408463-1-zhangpengjie2@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/pm/cpufreq.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/pm/cpufreq.rst b/Documentation/admin-guide/pm/cpufreq.rst
index 6adb7988e0eb6d..d2f37309cca3b3 100644
--- a/Documentation/admin-guide/pm/cpufreq.rst
+++ b/Documentation/admin-guide/pm/cpufreq.rst
@@ -499,7 +499,7 @@ This governor exposes the following tunables:
 	of those tasks above 0 and set this attribute to 1.
 
 ``sampling_down_factor``
-	Temporary multiplier, between 1 (default) and 100 inclusive, to apply to
+	Temporary multiplier, between 1 (default) and 100000 inclusive, to apply to
 	the ``sampling_rate`` value if the CPU load goes above ``up_threshold``.
 
 	This causes the next execution of the governor's worker routine (after
-- 
2.53.0



