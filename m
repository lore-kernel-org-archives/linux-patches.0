Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22E4D2FB;
	Tue,  8 Apr 2025 13:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117216; cv=none; b=N4F+0Y6EVziBFP6SPwxdXpR+2EcZ93LCa4pEs9P5bOe0BtaCOWx379X7w82txOOGXxTzM+lE1smNGdK0si2lN8vIcSjKTZKJ7Aq02pnCx/ExvlpUx1jvDx7zh0TtcCy04zx6tkGm82YBWIhfG80+k98PWkFRim7qG+ZPMFNSdRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117216; c=relaxed/simple;
	bh=qx/p2qV7xGdaow5qvt9wH7ZIQZiS56skV+WOedzB4zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeD7eqdOF0HHq0AL8HsvIwBTzqE9xQEtFKL/hYnfdFWHuwzLtFE/psJY3+8TZ71HaJapZ2p3RjY0FCleiAZ3vjbuQyvht+2J6i/Cjax1Z8KGknB0MbiJygYhMV5RD7mkZeINTMhe+kKJ9SDA/X+0bhgci1/tz0AHdp95e4lauJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sx/HQeOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sx/HQeOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05733C4CEE5;
	Tue,  8 Apr 2025 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117216;
	bh=qx/p2qV7xGdaow5qvt9wH7ZIQZiS56skV+WOedzB4zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sx/HQeOt5YnhUqwW/1uX+21unGaTUztKGZDvXFdWefle3ShEYmz55RQ34qPhbfMgL
	 fYSbCA6MvMjFHodaCYT4R2B+NMIOccTNIpb1o2LEquo44DZH1NSN4/mpVP3ozoheai
	 wTCRK9kiMTnQSOKEMAypFEgibMYPYs8rFUnfNTXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Owens <daowens01@gmail.com>,
	Romain Naour <romain.naour@smile.fr>,
	Robert Nelson <robertcnelson@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6.12 392/423] mmc: sdhci-omap: Disable MMC_CAP_AGGRESSIVE_PM for eMMC/SD
Date: Tue,  8 Apr 2025 12:51:58 +0200
Message-ID: <20250408104855.025229756@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 49d162635151d0dd04935070d7cf67137ab863aa upstream.

We have received reports about cards can become corrupt related to the
aggressive PM support. Let's make a partial revert of the change that
enabled the feature.

Reported-by: David Owens <daowens01@gmail.com>
Reported-by: Romain Naour <romain.naour@smile.fr>
Reported-by: Robert Nelson <robertcnelson@gmail.com>
Tested-by: Robert Nelson <robertcnelson@gmail.com>
Fixes: 3edf588e7fe0 ("mmc: sdhci-omap: Allow SDIO card power off and enable aggressive PM")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20250312121712.1168007-1-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-omap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -1339,8 +1339,8 @@ static int sdhci_omap_probe(struct platf
 	/* R1B responses is required to properly manage HW busy detection. */
 	mmc->caps |= MMC_CAP_NEED_RSP_BUSY;
 
-	/* Allow card power off and runtime PM for eMMC/SD card devices */
-	mmc->caps |= MMC_CAP_POWER_OFF_CARD | MMC_CAP_AGGRESSIVE_PM;
+	/*  Enable SDIO card power off. */
+	mmc->caps |= MMC_CAP_POWER_OFF_CARD;
 
 	ret = sdhci_setup_host(host);
 	if (ret)


