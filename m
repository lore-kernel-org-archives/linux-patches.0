Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9A212D1FC;
	Tue, 30 Apr 2024 10:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474410; cv=none; b=Mu/izlvtUvle31Ulze84QZoy7F2ANSaNvBNOWXfyrvlK0NbTzC8UvsIjCbo8tz+5Gt9KXRHeeQaSJ2bG5sXb9K5ZZrmuTAvYSRdundJ+kEbDI5/2EeSzHmwSRG2StpltRhl9u9PLAzLd7ODbxEYgO5euQRR9wCjdLbpWuYKQsLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474410; c=relaxed/simple;
	bh=6GjzXq1kGhgHQjK4OsBtH897CEl3DXIUlPtP6463DqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgasVQlsxU8Y62bvjyH2j8pO54AzLDNhDJHPDNkTwgKz1LABJXPDHfhG0yB9LCEmHtWv4o40dVGLs4M6eJkLubdhHvFSeH76XHYoEkOd6EjJEsQYsvd2wvkEcsuaka0lB+NrCavw0sslWpFK2Aw61e28fZaAz9JtT2+Lb+jf+Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+f3Kftr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+f3Kftr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E31FC2BBFC;
	Tue, 30 Apr 2024 10:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474409;
	bh=6GjzXq1kGhgHQjK4OsBtH897CEl3DXIUlPtP6463DqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+f3KftrlFlGTPvdMnrNFbPCs1GN+kKWfx6OTScF7Dq/9Ide+hqAZoDeYNmvAPLHt
	 eJk5K+P8Pw1NbH2JWkVVuzgTG0o7IN5VwmT4oVH3beX2VTCqVqYAVqN7Mx1yA3o+jH
	 myxL35F5j58V/DegU2qd+jgj4jj+WAp9pbvkZEAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drew Fustini <drew@pdp7.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Maksim Kiselev <bigunclemax@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.8 149/228] mmc: sdhci-of-dwcmshc: th1520: Increase tuning loop count to 128
Date: Tue, 30 Apr 2024 12:38:47 +0200
Message-ID: <20240430103108.107266347@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maksim Kiselev <bigunclemax@gmail.com>

commit ace323f80b9bc6734289a4e8a77938a3ce964c7d upstream.

Fix SD card tuning error by increasing tuning loop count
from 40(MAX_TUNING_LOOP) to 128.

For some reason the tuning algorithm requires to move through all the taps
of delay line even if the THRESHOLD_MODE (bit 2 in AT_CTRL_R) is used
instead of the LARGEST_WIN_MODE.

Tested-by: Drew Fustini <drew@pdp7.com>
Tested-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Maksim Kiselev <bigunclemax@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 43658a542ebf ("mmc: sdhci-of-dwcmshc: Add support for T-Head TH1520")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240402093539.184287-1-bigunclemax@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -612,6 +612,7 @@ static int th1520_execute_tuning(struct
 
 	/* perform tuning */
 	sdhci_start_tuning(host);
+	host->tuning_loop_count = 128;
 	host->tuning_err = __sdhci_execute_tuning(host, opcode);
 	if (host->tuning_err) {
 		/* disable auto-tuning upon tuning error */


