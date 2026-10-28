Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212803;
	b=o+r6JIzGMgFX3s2XjCt8MOehdhxuZ9zPVbcpvQa/xP1HzpgYud2qNMgM2TDpWhMCiQhq
	 CFmj7EAafn1F375GWNr1lQUfEhxDVfUGEi89/p838hKaZ5hUxdtpi3c3zt4WFAwo/BqbW
	 K6PrB/5YMPaF89P25w13kAMILH1Stx/Ohsmfz6JRfsNWeseMWPLWV7hK96S7LSp/9B3wK
	 8mwFcACAz1elRJNK3NXEovY2dXIgwfkKtH1vrAxnJroxLHd01OIrJtDNgmbnsS5YPGYtP
	 rb1OqztGcVsSpEWgCT0xwoWeSg+CdCdp41qE3+AI91zAKZXJLeM0gVCXBsU0OR27giA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hUAXDJL2dRzzaOh5VGN8ZDL0bQnHNN2UNPVLjpoLd1Q=;
	b=4mRFxWsaSuQvpmttH6EJpvY02ubx7aUPlImo+ElXTpPQykDnIfK2H9lxOr9aeebMWace
	 v1NiTZl+Hc7ssT4p++0NG1HGvshAHhqNXfwDMslGWg4AJNLvV4N+Q6IVmrw0ZMCM62bTM
	 vr71y1JjmF7XcO8NUBFfcGxUkyDV2uxjXI/QZxkrGFIZJestqiTuTI+tFxChd2vZyFCJN
	 kaPDpYOP3HHk4u/czoNvH0ERJz+ens6uiuMuQjr0PZw/nH1W+X29wJ8B68NvIXc/HBX9D
	 682pZo5BfBh7WRkO0JotZlbRmP7yk5ZPi3msUyWJwXJ9yfLn2x6xSbnIiSJplZb/2Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=viDzg1J4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605D1606A31A;
	Wed, 28 Oct 2026 18:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=viDzg1J4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DC91F01825;
	Wed, 28 Oct 2026 18:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212803;
	bh=hUAXDJL2dRzzaOh5VGN8ZDL0bQnHNN2UNPVLjpoLd1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=viDzg1J4FN7mzejuleYmZ8toHwrkUJrI3tXwFwCbfMG8ID/BkZphVz975rpZLOeKs
	 3fSTjRa7SYtvt7irMtYON0G0PZPIHZ0hN0B1wPhwlFoR/r8WwfNmyyGBugw2OGoi8U
	 HQOssvmlvl9UriWVbNMQXY5V8+ueDf2z1O8/yjx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.1 0281/1887] usb: chipidea: tegra: disable runtime PM on resume failure
Date: Wed, 28 Oct 2026 17:39:37 +0100
Message-ID: <20261028170505.623654282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit f1d6f7d25fe88ee49aaad96c8649e090fc3a4b68 upstream.

tegra_usb_probe() enables runtime PM before resuming the device. If
pm_runtime_resume_and_get() fails, probe returns without disabling runtime
PM. The later error paths reach pm_runtime_force_suspend(), but this early
return bypasses that cleanup.

Disable runtime PM before returning the resume error. Do not use the
fail_power_off path: the failed resume did not retain a usage reference,
so its pm_runtime_put_sync_suspend() would be unbalanced.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 8b85e11c1a7a ("usb: chipidea: tegra: Add runtime PM and OPP support")
Cc: stable <stable@kernel.org>
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260913041033.25144-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_tegra.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/ci_hdrc_tegra.c
+++ b/drivers/usb/chipidea/ci_hdrc_tegra.c
@@ -307,8 +307,10 @@ static int tegra_usb_probe(struct platfo
 
 	pm_runtime_enable(&pdev->dev);
 	err = pm_runtime_resume_and_get(&pdev->dev);
-	if (err)
+	if (err) {
+		pm_runtime_disable(&pdev->dev);
 		return err;
+	}
 
 	if (device_property_present(&pdev->dev, "nvidia,needs-double-reset"))
 		usb->needs_double_reset = true;


