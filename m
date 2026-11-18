Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060548;
	b=zEOTwz6Ptq4J0FYJoj9P08d+E6PheLQbRwzIDjTcb4pOIGspyNnJSk0pEEv3zH0eCpja
	 2gcKrZrSHvfwmLaen1dcwyGkOcDc6WXf1k/p6pWX1qecU5ADY9bS3G/3JK9i2z4QxVE5f
	 qwQWSwRa/ElU/4sAfSnCtMQxr1gCVmEZbDnlnGrYNbFE1sEcNLQChcjvIpLitQZOxFhjp
	 Tq8Ni9Hp15QI0mijotTOGyY9x8BMSKX/COkWkaXQT2PUSRKfsUYRpW37lFqhZouu/hYnS
	 Y7gNYwTXgb2BbxCjqjnGma/TzEInVRZrbyRfL1zJJlKvbZV0RVPHU+35AN/b7W6Jf1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SSamWnG25aEzp5p6wy84xfuVvqviZb50kdVrLHlxeHk=;
	b=L2YlPBgHCBw+Mpst3msTn1tXYCyNnrPofnkTJ6Jsa6ChVvIvBdwxhkjnpvBShURueM9n
	 EBZh9g6WE8rmDZUNVuuCgdb+G33VcjJ+Q+dg4EtJOXdZMynQ1aLwIpY6pYwvrdEbF6rkY
	 gFUcKsAD2iksPBwWXUwExsY5oHRLVYq1BMXbpnBdBulRhfBFshOJtgizCykv5WlV7nTi4
	 oSkJf9rINs2yH1t7kHlFUMqZ8N1wfPPg6vFgitVldQoKz7+63gpniNaKKx17XkU7E+zT4
	 IcphtMUzhepY/njN2pTLYJCEORbR6PIWZcnj2jZUAwguSiFygzL49F3o4khcRMFtG/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oF/j4F7q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A766606A325;
	Thu, 19 Nov 2026 03:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oF/j4F7q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717C31F000C4;
	Thu, 19 Nov 2026 03:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060548;
	bh=SSamWnG25aEzp5p6wy84xfuVvqviZb50kdVrLHlxeHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oF/j4F7qcX6wLvi8cskjoojJ7p5HGdJw9vyvWUz4c+MiBfEfBhmbWr6tzRCihb6je
	 tkt+LngexMBMt7CQOh8CIJW2qiDHrCLW9mJVp5zLdeFKmjNtSefQWEIzpRKGm4eVQn
	 0XLjoGj/nFCOAbitadHqrptVGTEoXimJ5JNsQxBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1236/1848] cpuidle: menu: Remove incorrect unlikely() annotation
Date: Wed, 18 Nov 2026 15:54:34 +0100
Message-ID: <20261118150011.607206792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit fcbd7897b871e157ee5c595e950c8466d86c0cd5 ]

The unlikely() annotation on the early-return condition in menu_select()
is incorrect on systems with only one idle state (e.g., ARM64 servers
with a single ACPI LPI state). Branch profiling shows 100% misprediction
on such systems since drv->state_count <= 1 is always true.

On platforms where only state0 is available, this path is the common
case, not an unlikely edge case. Remove the misleading annotation to
let the branch predictor learn the actual behavior.

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260105-annotated_idle-v1-1-10ddf0771b58@debian.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: d594187cafd5 ("cpuidle: menu: Do not return a disabled idle state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 662d61970835b..f9b201f3cc3e2 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -309,7 +309,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	nr_iowaiters = nr_iowait_cpu(dev->cpu);
 	data->bucket = which_bucket(data->next_timer_ns, nr_iowaiters);
 
-	if (unlikely(drv->state_count <= 1 || latency_req == 0) ||
+	if (drv->state_count <= 1 || latency_req == 0 ||
 	    ((data->next_timer_ns < drv->states[1].target_residency_ns ||
 	      latency_req < drv->states[1].exit_latency_ns) &&
 	     !dev->states_usage[0].disable)) {
-- 
2.53.0



