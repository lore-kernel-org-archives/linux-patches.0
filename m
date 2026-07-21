Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8E746C4D9;
	Tue, 21 Jul 2026 19:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661652; cv=none; b=nckJlWxjVIZ/4c61v0bsWOgJHlqrrZwKKN+0NJ4vtsrfZryz2ByXMAkVJDCUOmZH5lubvpOijbF6Ckix+NnQWUOCwCmSeaaBI/cWX4LF1e+XB85h/Xm4AJPSyw/X3wxxH+zSeAGZd6DM4UaHRAGWp2IzgJDLIAjVGiNQ/HDlG9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661652; c=relaxed/simple;
	bh=0cX6zvnGD+vjrIah6w2e6OUC+ixjbcYEsEzh5ta78vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxUUWemK+g0kON8MKjTT8sQnIZw7QRg9VxyZ2UJ377SrVvQMOO1jeYoIGaWXnyFQABTOyuV+z7J3XBHeLKGnWGzwbYyn5zJecmppl/pEiaQt57NkddJQxnSeg2rs+BIWCJB/R+YdfDs6ZjrvnRnymF5IByMHpRQuXhWxqpbD+0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lPN9uJj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lPN9uJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F5B1F000E9;
	Tue, 21 Jul 2026 19:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661651;
	bh=m7BPwZNDbQ19drX4/0yUZc/HVMtr0pnC3KRNmS8Eudc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lPN9uJj/IllS9ByIqDr7GjvmwAF4QACLP80Qiwq3mAopY1XF/fV7o1U7hdWJxztu
	 YH7s7GT1LarBars7ckS1pbTRwiaK9P0fx6sqaequsSplBTzAkPnBuZ3vmR77pf07vG
	 XWors9XQY2kfiv3+SQYTjrYZ0oKm0OuXijpD6+mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0148/1276] cpufreq: Documentation: fix sampling_down_factor range
Date: Tue, 21 Jul 2026 17:09:51 +0200
Message-ID: <20260721152449.415458047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a21369eba034d5..0818f248374137 100644
--- a/Documentation/admin-guide/pm/cpufreq.rst
+++ b/Documentation/admin-guide/pm/cpufreq.rst
@@ -503,7 +503,7 @@ This governor exposes the following tunables:
 	of those tasks above 0 and set this attribute to 1.
 
 ``sampling_down_factor``
-	Temporary multiplier, between 1 (default) and 100 inclusive, to apply to
+	Temporary multiplier, between 1 (default) and 100000 inclusive, to apply to
 	the ``sampling_rate`` value if the CPU load goes above ``up_threshold``.
 
 	This causes the next execution of the governor's worker routine (after
-- 
2.53.0



