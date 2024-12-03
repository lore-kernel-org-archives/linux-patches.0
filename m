Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31CA1F669E;
	Tue,  3 Dec 2024 15:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238230; cv=none; b=Qco6zXhKQubuwzuKxNev+9Ah7LyeAEgKwWYGGB+x8bxsj6eeDWh0qIUgzl6Ms2FwOYiBe66ousJ0xko36lown4c1Dm5nO9lZ2vP4T3kWCe5oWR7PgWQcbuleAZeBT2PuBby+TBWSaZDN161yxVcLpp7cdGwY+aTRjDuG10AKai0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238230; c=relaxed/simple;
	bh=0vSfjBnSxj6tLobPzqb2XlncN/cHCBuEmPfUs8Zzs74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9j7PQiVKP/RAYElug6PV7/sSBsJYzFMxnlhDEON2lUB/zyfcufU2T9GtAjAqJZQeWsu+OwIXQDGMADqPmcwmkBxeTChs/mHkJVsP5UtAS8OclEPaqZsEXLqVZnumXDlELfEhsXRXp9fWZ4XKWH11MtZGdDxRHyeYP1vCo9vL6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhmWRbZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhmWRbZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B03FC4CECF;
	Tue,  3 Dec 2024 15:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238229;
	bh=0vSfjBnSxj6tLobPzqb2XlncN/cHCBuEmPfUs8Zzs74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhmWRbZ/uFvgtmoW8WvN+9iMJNWFqHm8ggy12p26+CD32uJoe4GxEvZUf+uSIyTol
	 kY9UsfyYa0IA216bzRaH57z2sJLDgJV0Nz8wXhBXhxazY/+gvXKej4vgp3r4e+NlXK
	 +otISK2xU4xjjwnNVSiIo00ttqMHecg2kCqRQQiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 175/817] power: sequencing: make the QCom PMU pwrseq driver depend on CONFIG_OF
Date: Tue,  3 Dec 2024 15:35:47 +0100
Message-ID: <20241203144002.562892074@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit f82bf3c5796e1630d553669fb451e6c9d4070512 ]

This driver uses various OF-specific functions and depends on phandle
parsing. There's no reason to make it available to non-OF systems so add
a relevant dependency switch to its Kconfig entry.

Fixes: 2f1630f437df ("power: pwrseq: add a driver for the PMU module on the QCom WCN chipsets")
Link: https://lore.kernel.org/r/20241004130449.51725-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/sequencing/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/sequencing/Kconfig b/drivers/power/sequencing/Kconfig
index c9f1cdb665248..ddcc42a984921 100644
--- a/drivers/power/sequencing/Kconfig
+++ b/drivers/power/sequencing/Kconfig
@@ -16,6 +16,7 @@ if POWER_SEQUENCING
 config POWER_SEQUENCING_QCOM_WCN
 	tristate "Qualcomm WCN family PMU driver"
 	default m if ARCH_QCOM
+	depends on OF
 	help
 	  Say Y here to enable the power sequencing driver for Qualcomm
 	  WCN Bluetooth/WLAN chipsets.
-- 
2.43.0



