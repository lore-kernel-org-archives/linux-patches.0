Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE4446C4D3;
	Tue, 21 Jul 2026 17:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655941; cv=none; b=G8jZzD+UgpxLjgaZW2OP9rfkj1vBuD1fhF0JhR2PHKXm4Lt8IdRqhVjLsXFUu/YgMPnI6lShyCnqrH++eh1lbWYgIrtXBumDKl7iUJxZvGoSmcmijZPDviX0QnipJQ3QQzeqDGoUPMj2cNym6NqdURfGcI9V4eoiaFUEpD8mQWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655941; c=relaxed/simple;
	bh=L/64UuQYn+9Neg7LAAltfe23IDWOxrghVGnB0suYZ6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKwMf1wmUQvquQJdwF9gNtAgi7eWLmB/ORdbrn9qXv4N440RbNZfu0klLMLUmgqBylPBIue37W3gnNxr3n62VzB7Z+UTl4RvQxu3rBPDadCf4oa4tGJCD4YOvREbwI+0EIq0mYAWgBxJOMsrFwJOodKFnKWe2a9MQBchhTgSqiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FH0PF0X/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FH0PF0X/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E061F000E9;
	Tue, 21 Jul 2026 17:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655940;
	bh=Hb0Pl6dMraAtZdMjnHHtw48+nQ7CCMbrEyS4DwjfCT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FH0PF0X/huTpTOnehv/t+J8NkxY+SCqLSTr9210NmvWBYoSjoJFCxiSVvRKRLGGiZ
	 Pi+8ysNOpEMrhrkryFD+1dsc9b5zifB8y3quKEam/Pi+Vlk+KJqMbGwigIOw7B/7a1
	 BRJ5XilZck4pt49fDj4AD+1vldBRyIy7t3NyCsZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0200/1611] cpufreq: Documentation: fix sampling_down_factor range
Date: Tue, 21 Jul 2026 17:05:16 +0200
Message-ID: <20260721152519.453245141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 738d7b4dc33af1..33122fbe9f6a0e 100644
--- a/Documentation/admin-guide/pm/cpufreq.rst
+++ b/Documentation/admin-guide/pm/cpufreq.rst
@@ -516,7 +516,7 @@ This governor exposes the following tunables:
 	of those tasks above 0 and set this attribute to 1.
 
 ``sampling_down_factor``
-	Temporary multiplier, between 1 (default) and 100 inclusive, to apply to
+	Temporary multiplier, between 1 (default) and 100000 inclusive, to apply to
 	the ``sampling_rate`` value if the CPU load goes above ``up_threshold``.
 
 	This causes the next execution of the governor's worker routine (after
-- 
2.53.0



