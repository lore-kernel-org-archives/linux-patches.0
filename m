Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA2725EF90;
	Tue, 11 Mar 2025 15:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705655; cv=none; b=jxtiHRgiSL0wY2UnuoMeZiyYjCvED3jDuJPo6QN35uv+zOaOIqCxXg/7IzP9FwSll1YV2YoVpl8rJrX7icsx5rnxJMFbJWop1T6fxhAOejtBLrbzjuaNZcjOYGBiTqu7y1ijxJvSuPh/QGiENRMULDCoEAsx7X0ynjdZN7YMfco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705655; c=relaxed/simple;
	bh=nWOEVO1Yh9XqesJ2nFlZ//Ea+LyduCu/54AF8S73Uj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgYSXZhmRK5N+IbfT4ayQYaqZZDDAa4nnl5bzohi1+w1uoBJ665FworWSyWIGAT+6B4ZmGJZDbeH7PzyimVLMRqv0Ahu/Bzc0L1+x5Ej4ng/qwlnrOMWTQZCyOgCKBMQnSGdc0SgcQ0BARyxQuvwW2m1pxruvUK0VTAQIw2futU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyjjAGbr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyjjAGbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971CDC4CEE9;
	Tue, 11 Mar 2025 15:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705655;
	bh=nWOEVO1Yh9XqesJ2nFlZ//Ea+LyduCu/54AF8S73Uj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyjjAGbroR672QUzbq4vai9tsZ844ZuQL2aYND9L3ypHbbjSJdnPaJDv0TtjjPp62
	 M1uP8JLf2TSjAXCiK5B1Qp3VcjHAs3nYT0Tt3ORZIaMsQQHx9Ve6AKjCxPUWgv894G
	 gPH7xUPkFaZDYvE3AAAF68IBxR9o3qzE7D8Zx2+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasad Pandit <pjp@fedoraproject.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/328] firmware: iscsi_ibft: fix ISCSI_IBFT Kconfig entry
Date: Tue, 11 Mar 2025 15:58:00 +0100
Message-ID: <20250311145719.269028926@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prasad Pandit <pjp@fedoraproject.org>

[ Upstream commit e1e17a1715982201034024863efbf238bee2bdf9 ]

Fix ISCSI_IBFT Kconfig entry, replace tab with a space character.

Fixes: 138fe4e0697 ("Firmware: add iSCSI iBFT Support")
Signed-off-by: Prasad Pandit <pjp@fedoraproject.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 7dfbd0f6b76b9..6415ff6817d9d 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -170,7 +170,7 @@ config ISCSI_IBFT
 	select ISCSI_BOOT_SYSFS
 	select ISCSI_IBFT_FIND if X86
 	depends on ACPI && SCSI && SCSI_LOWLEVEL
-	default	n
+	default n
 	help
 	  This option enables support for detection and exposing of iSCSI
 	  Boot Firmware Table (iBFT) via sysfs to userspace. If you wish to
-- 
2.39.5



