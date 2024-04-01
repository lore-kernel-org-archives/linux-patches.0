Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D408F5C;
	Mon,  1 Apr 2024 16:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987920; cv=none; b=eOUKaNCpbmVG/CsLrJKgeNUfXM3wEJVmNzXedYtGm9u13uy41O3t7YghWK4RDhyAFfria9ZJjNPWMhOahvYQwjFSlKJKtMmUgKtHKFNGmC5ESPk7vguat3OWqzGuIkpjXCBdoERE6TvYUgw3K+fTUVEAT/ctUe8npjdhKzaDDGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987920; c=relaxed/simple;
	bh=D4/BU+OXHcDVU2iVLIFPZ58Q068VQHURh/Emnt7HvM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfZAu67s6AVRloWG3uGsS3+iynuw+VOmDKfxLrjqfIpAamjcKqCTF1bsNOLi6T+s0C1y+yVZM1xrbnye2f+VuTbOIoPna2vQVPh2MzgmgCrmwNk2QwGi2/Cma99/lse83tftf0XMTcfFEwM19nN442wU9Lan06Qr8a9Ckt8UnfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZfVvE/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZfVvE/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BCFC433C7;
	Mon,  1 Apr 2024 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987919;
	bh=D4/BU+OXHcDVU2iVLIFPZ58Q068VQHURh/Emnt7HvM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZfVvE/f9hJSPHyPHi6oHNPIdyf7/xK/ptbNauG0h8NVhgdZiGORKKNHTIeMfZvr6
	 Uru+xontf4OYavkk4GJZM8xW7NLsicwFjGBZVUQGyRKefufLaxzO4r9771wXxftFke
	 GfEuGP/288CpwzhqBvCB7eV1Dqmlo16D2UcbuId0=
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
Subject: [PATCH 6.7 030/432] cpufreq: amd-pstate: Fix min_perf assignment in amd_pstate_adjust_perf()
Date: Mon,  1 Apr 2024 17:40:17 +0200
Message-ID: <20240401152554.030865339@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 1791d37fbc53c..07f3419954396 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -570,7 +570,7 @@ static void amd_pstate_adjust_perf(unsigned int cpu,
 	if (target_perf < capacity)
 		des_perf = DIV_ROUND_UP(cap_perf * target_perf, capacity);
 
-	min_perf = READ_ONCE(cpudata->highest_perf);
+	min_perf = READ_ONCE(cpudata->lowest_perf);
 	if (_min_perf < capacity)
 		min_perf = DIV_ROUND_UP(cap_perf * _min_perf, capacity);
 
-- 
2.43.0



