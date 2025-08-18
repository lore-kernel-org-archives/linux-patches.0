Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A2F35A2AD;
	Mon, 18 Aug 2025 14:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526462; cv=none; b=ABzjRheZ6MO358vZpY6YqyV8WKw0rCl6671blTo3j+dsK2tSkHWalAdxkOwen347mC3kmI5LKe+v7LsSuhive1vSN/6tEvky1u0CoFNdA6RanUPLdnSjT6PlL9V/yvzlw1urWTyH1Yj6pQTaIQgstfK3OpYCHIWdttF5C3tFmFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526462; c=relaxed/simple;
	bh=FrtqATlk/Uhc5Bgmd5wINCV1jh4TjpZ79hMf+FtaYvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQjpHm9jR+bSyFZCuEO4mtXI17zkUQ/F7duq+EnwNUWgd+bPJibva0TfH2a1wJbiQF0BgFfcJ0iNnQ8seQCYUCkhoJEfusV1gou6pPGr6zl0IfTse0cQxuEdAxjfFvAoUtYDPk7QDG65ontiXd1+aTlypafxHl2TotXWTAgWskc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ManPuIxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ManPuIxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42409C4CEEB;
	Mon, 18 Aug 2025 14:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526462;
	bh=FrtqATlk/Uhc5Bgmd5wINCV1jh4TjpZ79hMf+FtaYvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ManPuIxtnF1J1f1y1C1rlPwsG9+VDHugzPJMT7L4i7Ko6UJhFQIRmv+TzoyxtmErg
	 oDJSdvqwDpQ6aWtvI/gfUBQivvv6WT95f1xPcAigLnQvjnDERNYsjRRQHvA0ZQ5TTE
	 C7HtFmc59g0b68yQj1lS1WGXGSchpmnIrtDyw9r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Peng Fan <peng.fan@nxp.com>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.16 563/570] firmware: arm_scmi: Convert to SYSTEM_SLEEP_PM_OPS
Date: Mon, 18 Aug 2025 14:49:10 +0200
Message-ID: <20250818124527.566315771@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 62d6b81e8bd207ad44eff39d1a0fe17f0df510a5 upstream.

The old SET_SYSTEM_SLEEP_PM_OPS() macro leads to a warning about an
unused function:

  |  drivers/firmware/arm_scmi/scmi_power_control.c:363:12: error:
  | 	'scmi_system_power_resume' defined but not used [-Werror=unused-function]
  |         static int scmi_system_power_resume(struct device *dev)

The proper way to do this these days is to use SYSTEM_SLEEP_PM_OPS()
and pm_sleep_ptr().

Fixes: 9a0658d3991e ("firmware: arm_scmi: power_control: Ensure SCMI_SYSPOWER_IDLE is set early during resume")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Peng Fan <peng.fan@nxp.com>
Message-Id: <20250709070107.1388512-1-arnd@kernel.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/scmi_power_control.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firmware/arm_scmi/scmi_power_control.c
+++ b/drivers/firmware/arm_scmi/scmi_power_control.c
@@ -369,7 +369,7 @@ static int scmi_system_power_resume(stru
 }
 
 static const struct dev_pm_ops scmi_system_power_pmops = {
-	SET_SYSTEM_SLEEP_PM_OPS(NULL, scmi_system_power_resume)
+	SYSTEM_SLEEP_PM_OPS(NULL, scmi_system_power_resume)
 };
 
 static const struct scmi_device_id scmi_id_table[] = {
@@ -380,7 +380,7 @@ MODULE_DEVICE_TABLE(scmi, scmi_id_table)
 
 static struct scmi_driver scmi_system_power_driver = {
 	.driver	= {
-		.pm = &scmi_system_power_pmops,
+		.pm = pm_sleep_ptr(&scmi_system_power_pmops),
 	},
 	.name = "scmi-system-power",
 	.probe = scmi_syspower_probe,


