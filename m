Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2517827B340;
	Thu, 15 Jan 2026 17:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497810; cv=none; b=dhcM6XgG9N2u9TlsDD+ZsoR28kJ96HMfBjkLv5r2Ap6stUoQDvXjviZgV8+PPh98DBZsxvdbeqGQX+Nmy8V5tn+L+eP6ZXuFEaTgYV/JZTYoz2AiWpvhlbbNEkf8i79mXY9n+aB7OmmSkA3kdLaLgpvTlWtxpCSf2ZCnwX6GRWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497810; c=relaxed/simple;
	bh=bH/r2sf1RHMQxlsvQWz8+RKI+UekEdBIH91QzEhYNm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0pfThCHe8M7eTB/1t+LJBcRuZawe9u5w71RXxqaZBtd5aE3AZCmMpA3y/DUlBrZZrGDAGc3oToNm0YDm4Tg+1SnyR1ODt/LWJN+yNqUxbZOs2VgSMD1XlVAEFL3HwGhBm/3EEvWOlsmN1/mtEwji1tCpJuuGV7r8lv5tTcA1pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MotN5MVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MotN5MVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFCCC116D0;
	Thu, 15 Jan 2026 17:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497810;
	bh=bH/r2sf1RHMQxlsvQWz8+RKI+UekEdBIH91QzEhYNm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MotN5MVMDFJB7HJ5uvP1B2JzorVVh1hHuVjg7WLbXz3NErC7N8hYvMS7Be68MdMHJ
	 tca5hJr8ICluVb1kxEJR4lv7XywI/3HFjakpb1zV2O6xTLCKxHbFkXcUTIl7N8FGAH
	 /nhdJ7d4Z5rgiX+5lL739JGQjecXFUtZ1DWDswqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.15 204/554] coresight: etm4x: Correct polling IDLE bit
Date: Thu, 15 Jan 2026 17:44:30 +0100
Message-ID: <20260115164253.639692966@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

commit 4dc4e22f9536341255f5de6047977a80ff47eaef upstream.

Since commit 4ff6039ffb79 ("coresight-etm4x: add isb() before reading
the TRCSTATR"), the code has incorrectly been polling the PMSTABLE bit
instead of the IDLE bit.

This commit corrects the typo.

Fixes: 4ff6039ffb79 ("coresight-etm4x: add isb() before reading the TRCSTATR")
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20251111-arm_coresight_power_management_fix-v6-4-f55553b6c8b3@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1761,7 +1761,7 @@ static int __etm4_cpu_save(struct etmv4_
 		state->trcpdcr = etm4x_read32(csa, TRCPDCR);
 
 	/* wait for TRCSTATR.IDLE to go up */
-	if (etm4x_wait_status(csa, TRCSTATR_PMSTABLE_BIT, 1)) {
+	if (etm4x_wait_status(csa, TRCSTATR_IDLE_BIT, 1)) {
 		dev_err(etm_dev,
 			"timeout while waiting for Idle Trace Status\n");
 		etm4_os_unlock(drvdata);


