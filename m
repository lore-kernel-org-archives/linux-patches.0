Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8165D335081;
	Tue,  6 Jan 2026 17:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719704; cv=none; b=IrCP93/CwdF9OEX0w6kbre7qcGPTadco5ASIbuAvrliXF+BU/Lyf+bnt3ZhbJIZRBTanRMFrgON4uJegPDiB4I/3dFn7x7+Pzqc5EiOyLoNU+FhF3Ux2eYFORRQSz6tQvd255sebrDQTUlp3ihtxBkOaSFodf0+oh4FmK/YrbPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719704; c=relaxed/simple;
	bh=CcmdbHVghHmLK3xPeP5ZX7QEr/9DyOMpjautU0iQLck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4q1EtcyvfHiazjy29yyQv4PojU3OxHvwZP9kg+AqTfRnTF6WG+Nt6k+icicN9NFKsoW/WUR4SbdycBbRz/lLbWlOqjT6T61V2ckzIH5SCCBOnIcWum1VYpLmSgFXBws8hV68C/OwiPxmbVUWhx+v/RduPeN2sBKTHZuJzW1uqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYlWTC5V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYlWTC5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496C9C19423;
	Tue,  6 Jan 2026 17:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719703;
	bh=CcmdbHVghHmLK3xPeP5ZX7QEr/9DyOMpjautU0iQLck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYlWTC5VcGMEui/wQXqvJ7Df9NYMDmhmzR1+E1KQlPwvOU4YogFWRXWENuPEYP3Ax
	 cqR4hAgH/GIwWoSXplJ/d4L5mx7zzhZj0bc/eRTD0ggZCwgaIv2qubhhrhvExEaYPv
	 je6eK6E6pDx/GuZB6FGJeBSGU3ZmUhdgB24UlIPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hal Feng <hal.feng@starfivetech.com>,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/567] cpufreq: dt-platdev: Add JH7110S SOC to the allowlist
Date: Tue,  6 Jan 2026 17:56:37 +0100
Message-ID: <20260106170451.907840974@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Hal Feng <hal.feng@starfivetech.com>

[ Upstream commit 6e7970cab51d01b8f7c56f120486c571c22e1b80 ]

Add the compatible strings for supporting the generic
cpufreq driver on the StarFive JH7110S SoC.

Signed-off-by: Hal Feng <hal.feng@starfivetech.com>
Reviewed-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq-dt-platdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index 67bac12d4d55b..dbd73cd0cf535 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -87,6 +87,7 @@ static const struct of_device_id allowlist[] __initconst = {
 	{ .compatible = "st-ericsson,u9540", },
 
 	{ .compatible = "starfive,jh7110", },
+	{ .compatible = "starfive,jh7110s", },
 
 	{ .compatible = "ti,omap2", },
 	{ .compatible = "ti,omap4", },
-- 
2.51.0



