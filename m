Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68D135FF45;
	Tue, 16 Dec 2025 12:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886857; cv=none; b=t6tBNvjmOvNQm7sHMZp2CqdfmGJKvFW6uaSnZgGybzA6RVPuumdbMosz04+d3y4KoctFO5Oddjs0drq0MIE6/UmTbtldNIWA/FekhOkApuvU5B/GI8Fm6+aSvkJtmyR+sGqOHhr/FoMnQhke+1C+9oqzlUXNRcNeg4aRCy0H2N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886857; c=relaxed/simple;
	bh=25yRLFdU0yHTTEIW6+iDPHBU1khl68qWRHBkklBTfoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FR9zUI+dPw5arAOPVOl8jQwHuksJrV0uweAHwWAq8CptC5F52kXfGRj/y2igDJjWmbyeFBisnJcJh7wgHzXVsN3/5iFVacB87j5cn4bc4Ebd67Y/rMLnQRUjrEZglLzWTXEDoOa+/yM/5fLJjl3nxBI+V8KrzzpUCUoypKrrYQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8vfjVGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8vfjVGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332B8C4CEF1;
	Tue, 16 Dec 2025 12:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886857;
	bh=25yRLFdU0yHTTEIW6+iDPHBU1khl68qWRHBkklBTfoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8vfjVGz/O6MwtvCcyxNV38pVF8vPDEW6KObOjgBGCVYUNOVQbYuzukOW2OMdzXZU
	 9x5N61pH/NDZUOvcDpwAgrPm+KERa3cExouK7cvDlH0JpTVwRH4vJa1ufluInDpebZ
	 oaCPt58Z/Apsru2MNYLnQM+s7hA89NXgwb8/9SMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 053/614] irqchip/qcom-irq-combiner: Fix section mismatch
Date: Tue, 16 Dec 2025 12:07:00 +0100
Message-ID: <20251216111403.230037296@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 9b685058ca936752285c5520d351b828312ac965 ]

Platform drivers can be probed after their init sections have been
discarded so the probe callback must not live in init.

Fixes: f20cc9b00c7b ("irqchip/qcom: Add IRQ combiner driver")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/qcom-irq-combiner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/qcom-irq-combiner.c b/drivers/irqchip/qcom-irq-combiner.c
index 18e696dc7f4d6..9308088773be7 100644
--- a/drivers/irqchip/qcom-irq-combiner.c
+++ b/drivers/irqchip/qcom-irq-combiner.c
@@ -222,7 +222,7 @@ static int get_registers(struct platform_device *pdev, struct combiner *comb)
 	return 0;
 }
 
-static int __init combiner_probe(struct platform_device *pdev)
+static int combiner_probe(struct platform_device *pdev)
 {
 	struct combiner *combiner;
 	int nregs;
-- 
2.51.0



