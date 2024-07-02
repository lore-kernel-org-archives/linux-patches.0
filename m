Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9F41BD4F8;
	Tue,  2 Jul 2024 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941180; cv=none; b=lWg5o0fyMDz9Sp0j9EXpxuUkfVP7Wix8OOWuLS9H+2EcDyE5ahwXuuau70FjoLv2PkBWlqpxKJIRaSd8deTaAJcb+lxitt1aTZyAYZbig1a5plurm9snemTUek4Xv9H4bAatX6dq0r3fNHaWmBlAV3tTUvFMMorMmYcGR7KV9jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941180; c=relaxed/simple;
	bh=LmXyfZTchV1LVjlO4+bpTz/bhYjaw84tRscvpraQ+Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMUuhpEKhrCz5trOWgu9qCKsfVPYNR/JKEpYqkq1QrQge7JP/4jVE4XopNGJ/8eIGLqRbfVC8uG20Pk3BZLiBLsJCpB94vjEBOvp7DyOeowOUXskMMgvVajOHvNOuSI0ZhUyeOblJ9c7Z4DJTHzSzQvEEWSBnMi6qVPicImaEaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INxI/9sA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INxI/9sA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AF0C4AF0A;
	Tue,  2 Jul 2024 17:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941179;
	bh=LmXyfZTchV1LVjlO4+bpTz/bhYjaw84tRscvpraQ+Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INxI/9sART7gh8mjh0ITvWJvZPoBSeYeM8qJCZcsIWCz1Dc8VjGe/1igPYdO7zuvD
	 Ps2WKZj+PeB/A6i3KpZh8JQbomlfi0eh9F6t3d1AdEoywiVx6HDCHCjo5JyVa4SZ7V
	 zJfS2qDpjGT3eb/IXzQloa2sZ65Y9F+k2m0lbi8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars Wendler <wendler.lars@web.de>,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Peter Jung <ptr1337@cachyos.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 152/163] Revert "cpufreq: amd-pstate: Fix the inconsistency in max frequency units"
Date: Tue,  2 Jul 2024 19:04:26 +0200
Message-ID: <20240702170238.814615259@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 8f893e52b9e030a25ea62e31271bf930b01f2f07 which is
commit e4731baaf29438508197d3a8a6d4f5a8c51663f8 upstream.

It causes a regression in kernels older than 6.9.y, so drop it from
here.

Link: https://lore.kernel.org/r/18882bfe-4ca5-495c-ace5-b9bcab796ae5@amd.com
Reported-by: Lars Wendler <wendler.lars@web.de>
Cc: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Gautham R. Shenoy <gautham.shenoy@amd.com>
Cc: Peter Jung <ptr1337@cachyos.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -675,7 +675,7 @@ static int amd_pstate_set_boost(struct c
 	if (state)
 		policy->cpuinfo.max_freq = cpudata->max_freq;
 	else
-		policy->cpuinfo.max_freq = cpudata->nominal_freq * 1000;
+		policy->cpuinfo.max_freq = cpudata->nominal_freq;
 
 	policy->max = policy->cpuinfo.max_freq;
 


