Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD4D1DDE9;
	Tue, 16 Jul 2024 16:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145779; cv=none; b=Lk/09DZMQKaF/PkDD9C4Zw1oSMR1VIzGu4FHbhdhc085O7cEeImDs0FGSrT9ujZ9n1NfN6Om2k7qsLKZIl+CxPmkvLwhBCk7Kmmkz23wf4NgUq0osAAm3jEBwh7dXpK1+mteNh86osDNwE+c+Cp0igygUo1K8Xp8QbLui0xDQhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145779; c=relaxed/simple;
	bh=fKSnmWJlpe7mbwr2fwrc2EOQVJlX0TvAheh9EFwt8+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gtfkdkoJNm+eBsY9SrWe1zZc+ZPixTDVJQSFwKF2Qo3NHGMNtrs44X+e/BSgCzng562XpJ9c59ZBGlDPhsOBoFdPyETNa7qQz/qTWGCjGpujZBfovMUyReEzBvvHsAYOGkVnLkUrgjlYB5iGKO87mq3kXYhDoeQ2mo975GUtZCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j548hI5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j548hI5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E00EC116B1;
	Tue, 16 Jul 2024 16:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145778;
	bh=fKSnmWJlpe7mbwr2fwrc2EOQVJlX0TvAheh9EFwt8+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j548hI5ZEJZE8sAT0v73JFelHzVZDmym/lMHjK/V3cED4iJHzpXCBeiX60BeOE4G5
	 kEl9HmoTTPRkDaBzQelSJlWv/81mg0QTmo2a6JVT1i7NaB7v77ioQP6ovhKIBcK6PQ
	 hep5uRj7tauVS5D+WcsYBd3LCnR7UtkDjhYIU9X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.6 081/121] nvmem: core: only change name to fram for current attribute
Date: Tue, 16 Jul 2024 17:32:23 +0200
Message-ID: <20240716152754.444933708@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 0ba424c934fd43dccf0d597e1ae8851f07cb2edf upstream.

bin_attr_nvmem_eeprom_compat is the template from which all future
compat attributes are created.
Changing it means to change all subsquent compat attributes, too.

Instead only use the "fram" name for the currently registered attribute.

Fixes: fd307a4ad332 ("nvmem: prepare basics for FRAM support")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240628113704.13742-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -374,10 +374,9 @@ static int nvmem_sysfs_setup_compat(stru
 	if (!config->base_dev)
 		return -EINVAL;
 
-	if (config->type == NVMEM_TYPE_FRAM)
-		bin_attr_nvmem_eeprom_compat.attr.name = "fram";
-
 	nvmem->eeprom = bin_attr_nvmem_eeprom_compat;
+	if (config->type == NVMEM_TYPE_FRAM)
+		nvmem->eeprom.attr.name = "fram";
 	nvmem->eeprom.attr.mode = nvmem_bin_attr_get_umode(nvmem);
 	nvmem->eeprom.size = nvmem->size;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC


