Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705377;
	b=QlR2VDUi815E5peCMS0aDxvXTrP04PtDxyyQeU16waSageTN9YjEFoqDEPW8LhP2WOiG
	 nbrGdpyFhtzgx7fKcMotL8N4QFHtz5LSWqTSzBDJfGZq1W03LBRFb8R/K1gucGWUVqgzP
	 aTFJK7CPlV9fJvoqVH0Lu0nZTX7DIJr8JUgGtnFqz79XIDle7Vo6ZI13USOsxgloSelrW
	 SOMjRp5bH6FJLFQV064evratMGKCexRjL9O9CHcYM1DZ/EPeCTVYjvEhsott61RycnimP
	 wJ0C6xsiJNQoDwiF7YENuNXEiqfcadUN1jrI/JEGS8i6IsVy+aLuBYT2EDp5Em0kI7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x3S1jomJIeVPeineb2kzuI5qj8/bFQz0OqhDryH8dUE=;
	b=iu+qGGUhJkMzWBdkgwBmHr68JvZZ+cc6RjpTEf8Fvk/oiIynhzHfTvslJ3o1Kv6GRqLI
	 n5h4/Rlkvl4GDMwlvP/M0AeMzc7cFjvjSC//HFEG87YeScOzcRz35q+4inoP8XKF/H2Bk
	 i9rOjho+qe4PsmM3/JbXJoMIA6H9Yo5NOQoRzthLqsmQ1RsvWGePikAEFt07rBqUtlKJI
	 bOtAc2sqRoosGXBUgXLVG7R61EbuRX3PMn0021kXtr4g/50PDFjc9sl1d+A0ZNU7gLCW/
	 5DBcpOhLiH4GFOr2OXZd5JJkdkuiRcYGJ4EuzU/K+7J9+0WBS0CW1VCiarhXsiAlunw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UelTmpID;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1EE606A31C;
	Thu, 26 Nov 2026 15:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UelTmpID
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DA71F000C0;
	Thu, 26 Nov 2026 15:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705376;
	bh=x3S1jomJIeVPeineb2kzuI5qj8/bFQz0OqhDryH8dUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UelTmpIDoWjDgA5ydRKFe+5Lqh6ksEzyz+xJ77EFqalRrB/MmQLn/YZQ08t8xH21H
	 3lVnpZLf6G4PK6jBwkQ4QD4n8wxOKirHTCoPcTju+hivNdWLWZOduTcB8aJ8iL4vgI
	 yoeQ2DSPbEx3OFBdEtYar5xJzbKptOzb4iV+qH48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Jie Zhan <zhanjie9@hisilicon.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/319] cpufreq: Return -EOPNOTSUPP if no policy supports boost
Date: Thu, 26 Nov 2026 15:38:10 +0100
Message-ID: <20261126144009.499791615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 77cf053b041fe13d1fdd2e572e16ee7776ff687d ]

In cpufreq_boost_trigger_state(), if none of the the policies support
boost, policy_set_boost() will not be called and this function will
return 0.

But it is better to return an error to indicate that the platform
doesn't support boost.

Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Jie Zhan <zhanjie9@hisilicon.com>
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20251202072727.1368285-2-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: a0cde2b601bc ("cpufreq: Preserve global boost state on failed updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index b8d347d0f68e8..10bec33a1d36b 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2701,7 +2701,7 @@ int cpufreq_boost_trigger_state(int state)
 {
 	struct cpufreq_policy *policy;
 	unsigned long flags;
-	int ret = 0;
+	int ret = -EOPNOTSUPP;
 
 	/*
 	 * Don't compare 'cpufreq_driver->boost_enabled' with 'state' here to
@@ -2718,6 +2718,10 @@ int cpufreq_boost_trigger_state(int state)
 		if (ret)
 			goto err_reset_state;
 	}
+
+	if (ret)
+		goto err_reset_state;
+
 	cpus_read_unlock();
 
 	return 0;
-- 
2.53.0



