Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1E4221297;
	Mon,  2 Jun 2025 14:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873866; cv=none; b=jOanzNXI+wJlGPS91AuSBms7gxqHC99xj6t631EpgpO3xj8s/lXQmoE53qc4QAHNsFZI98dVgxLmgNJ406XRv/AW3cCxiUP9yB2ArbXjahDrR+Lg60NlCe3JR7+j6gVFh5aqWQt4MlmSjAWNDBGVbl2rVbBAE4FPG3DGzDQOB5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873866; c=relaxed/simple;
	bh=NMJEitYzklJ1YHe2qgS2VPqpyGaV0PfP+nEqDJVyDTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4HRhJBkpQ/BKukgyeq3Ul+nq9I2EUmgQNwTFpyYzABnQ6wJuUFNMMSeHXV14mt57slZHYfoC+GUrMpjo/iWMOQsYLBTPwwfCFtWcsXJfsblvMPsKrUe16zUrY44QWDfu7veoOeOoADij2NI4WHpHXPYZhLufRRR6GvLgwnOnUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLeBvrys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLeBvrys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F0EC4CEEB;
	Mon,  2 Jun 2025 14:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873864;
	bh=NMJEitYzklJ1YHe2qgS2VPqpyGaV0PfP+nEqDJVyDTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLeBvrys17SwZLsrVM8XGFOdpuVXA9b2K2DEq+z3FSZxZpmqvnQIUPZ25Ek8SEuto
	 V/8U9KTYI+BG4Kc6aLxB5tQqlTSKs03mIe2bGoBedef/dvd0ctomZzQoCjrNSAas9y
	 V/U5tbqSuBuMtUxOl1LLKnlIY3rGRz12uq3HtktI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 271/444] hwmon: (xgene-hwmon) use appropriate type for the latency value
Date: Mon,  2 Jun 2025 15:45:35 +0200
Message-ID: <20250602134351.962436902@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vatoropin <a.vatoropin@crpt.ru>

[ Upstream commit 8df0f002827e18632dcd986f7546c1abf1953a6f ]

The expression PCC_NUM_RETRIES * pcc_chan->latency is currently being
evaluated using 32-bit arithmetic.

Since a value of type 'u64' is used to store the eventual result,
and this result is later sent to the function usecs_to_jiffies with
input parameter unsigned int, the current data type is too wide to
store the value of ctx->usecs_lat.

Change the data type of "usecs_lat" to a more suitable (narrower) type.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
Link: https://lore.kernel.org/r/20250204095400.95013-1-a.vatoropin@crpt.ru
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/xgene-hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/xgene-hwmon.c b/drivers/hwmon/xgene-hwmon.c
index 207084d55044a..6768dbf390390 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -111,7 +111,7 @@ struct xgene_hwmon_dev {
 
 	phys_addr_t		comm_base_addr;
 	void			*pcc_comm_addr;
-	u64			usecs_lat;
+	unsigned int		usecs_lat;
 };
 
 /*
-- 
2.39.5



