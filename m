Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A2D1DC759;
	Tue,  8 Oct 2024 12:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389492; cv=none; b=SrsBWuRIbYasHqL7h0B/I+cHAaZvUs5KLyBGble4ePMJv1yrQ6ARgHYu/n+4oVdKJMWSfyVyxEYNHCoT+grO5Z/L4Bgtm+ocbZv8BXXtTw4e1/7Xwa63FvZF+TeqKUDNCX7l1dQwMclueKro9wfetfJb7DHTfpd3zwIP1zvD7AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389492; c=relaxed/simple;
	bh=AqFRUUpFbUKdnmORcG1SQZRXsBwlO6qX0KuYuFVaiYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZZ//4rNItJnJFP43E5SnJZGPVPE8vZjV7Zt6AIOPwRCEfqFA0JONtkL+KZS1bj7rUvria2cREmwKGw+9YwuGAszrI1DgGcm0jX6SGJ5EZVPOtVwWU/GtJapIFUqc+Oh+Eib5GQW0WoHOfzHMQO/E/fYx051Xds4JTwk2Ru+gzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7L8lPzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7L8lPzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E8FC4CEC7;
	Tue,  8 Oct 2024 12:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389491;
	bh=AqFRUUpFbUKdnmORcG1SQZRXsBwlO6qX0KuYuFVaiYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7L8lPzhHph5LhvWM5dl7uq57+YNap3sblWk+JyD4pNtxgtbdun6fE46FAotkjKwb
	 jv6DhVoiCNLzPMvUG5fTJpufsjZ1nwbHGPrrV9leEDMSeg2QgpD1CGOTMy6MxHJIGd
	 MLux4oSm/f0KG5yFuvOQuaXAl5f6XTWcR4FGB50w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 010/482] mailbox: ARM_MHU_V3 should depend on ARM64
Date: Tue,  8 Oct 2024 14:01:13 +0200
Message-ID: <20241008115648.703268607@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 0e4ed48292c55eeb0afab22f8930b556f17eaad2 ]

The ARM MHUv3 controller is only present on ARM64 SoCs.  Hence add a
dependency on ARM64, to prevent asking the user about this driver when
configuring a kernel for a different architecture than ARM64.

Fixes: ca1a8680b134b5e6 ("mailbox: arm_mhuv3: Add driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index 3b8842c4a3401..8d4d1cbb1d4ca 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -25,6 +25,7 @@ config ARM_MHU_V2
 
 config ARM_MHU_V3
 	tristate "ARM MHUv3 Mailbox"
+	depends on ARM64 || COMPILE_TEST
 	depends on HAS_IOMEM || COMPILE_TEST
 	depends on OF
 	help
-- 
2.43.0



