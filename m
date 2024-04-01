Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50FC47A6B;
	Mon,  1 Apr 2024 16:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990756; cv=none; b=Ota9hWHDcG10HUBqdz6dYOkn3pEcyrXFNCQ+7raa8Lcsse0Y8tFDAwFVIxRPlbr6vGTMX9T9j7a53t0Qkby9UofHYa9ZjxmDgVtNMD1W0agGBZEmhyzOOE7MDQF5nt8bWo2uO+qKDA11gyVNHPoAUq3PMvWuUXg7jf7/quf9SnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990756; c=relaxed/simple;
	bh=gAFaFjfMGd5pWNCz9lckxiUge+IDmbJHjKA3QbsiQ9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oykZ4umGSf5OrgS3mTiGqFyaFMupWv/0I88bms1lmOt71Gm8V1QlX627qxBtS6Ox2DSpW4fSBqS0LikpVUWDVf5mJE5thyNko36wSe9Wjca9Z1qRihfb7VvlGdXIk/8MPFUH3D+xLjsz0vXMQgVKme/AcXdgcQdzJFtusKvbfp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoXT5r0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoXT5r0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4D8C433C7;
	Mon,  1 Apr 2024 16:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990756;
	bh=gAFaFjfMGd5pWNCz9lckxiUge+IDmbJHjKA3QbsiQ9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YoXT5r0dT3F7qR0DprAokfXTbXpMk6dVqY1GFVgFXt6hRWhiAjg83YCPz3Fj/UbDW
	 QKFhNpaDrtLxXtm5UCJ2HxQs/8BGQ8+QJQxy7rBIksjCWnFJ1W2Cseg3MiIGzqEFXg
	 ggerGF0mN9DLC8Kh7XCylq82/F/dOguUPYutplQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Perry Yuan <Perry.Yuan@amd.com>,
	Tor Vic <torvic9@mailbox.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/272] cpufreq: amd-pstate: Fix min_perf assignment in amd_pstate_adjust_perf()
Date: Mon,  1 Apr 2024 17:43:37 +0200
Message-ID: <20240401152531.208234458@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

From: Tor Vic <torvic9@mailbox.org>

[ Upstream commit b26ffbf800ae3c8d01bdf90d9cd8a37e1606ff06 ]

In the function amd_pstate_adjust_perf(), the 'min_perf' variable is set
to 'highest_perf' instead of 'lowest_perf'.

Fixes: 1d215f0319c2 ("cpufreq: amd-pstate: Add fast switch function for AMD P-State")
Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Reviewed-by: Perry Yuan <Perry.Yuan@amd.com>
Signed-off-by: Tor Vic <torvic9@mailbox.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Cc: 6.1+ <stable@vger.kernel.org> # 6.1+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index edc294ee5a5bc..90dcf26f09731 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -320,7 +320,7 @@ static void amd_pstate_adjust_perf(unsigned int cpu,
 	if (target_perf < capacity)
 		des_perf = DIV_ROUND_UP(cap_perf * target_perf, capacity);
 
-	min_perf = READ_ONCE(cpudata->highest_perf);
+	min_perf = READ_ONCE(cpudata->lowest_perf);
 	if (_min_perf < capacity)
 		min_perf = DIV_ROUND_UP(cap_perf * _min_perf, capacity);
 
-- 
2.43.0



