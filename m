Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C20E40710B;
	Tue, 31 Mar 2026 16:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976290; cv=none; b=k6EA/aA9pLymT+wilQOXd4YPtgo4aOJPCY0tagy0imO3d9jsj/7NUe5wiDNDQeY2skx0JQFkUDxOt1TNUMJIEscYcEBGT54YS5cMXYIN/7xEQWfx5vJAyYxPt4pBPYNkhJKnSGY3iSIoTzAaeVTNx3aoBWa1Aanh0wOBDXtXg0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976290; c=relaxed/simple;
	bh=hYbWI3ho0ETmtXHUFYcviZli0k332Qcq6nZYfpiE5gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gBMU6AP4Fp+6TyfryxZXS33uvY9ReLjBpxU0czWogoSs/vCzByfztWtKQyGNKUS5nEeVdv43lUfaZzm5KR/+s6pvKkFm4yFoMg3mmHrwyytVwHScldHzBiiSnSvUzvh3iQZixIbPhak28zZ0FH1rQVp3U4604icexqGpksQK5O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYmq/bU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYmq/bU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6010C19423;
	Tue, 31 Mar 2026 16:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976290;
	bh=hYbWI3ho0ETmtXHUFYcviZli0k332Qcq6nZYfpiE5gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYmq/bU8yZep1poqhOBgo9QcfpFvYtCweweztdp1xdTbW+Ahcn1OAiJ9kaheFQNH+
	 VKm0RT+kfmXfwmC8OiB7M5f4vDxzmZhUWQ3/xeQDoCXlDOSDru3yADPtZtNsZmpU76
	 SqK4gHUopQqgAxEsFz407GQsHQY2zcDtxN+4/VX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/309] platform/x86: oxpec: Add support for OneXPlayer X1 Air
Date: Tue, 31 Mar 2026 18:18:59 +0200
Message-ID: <20260331161754.811299910@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 2a3b4a8c10a64a62c4243007139d253dc1324dfd ]

X1 Air is an X1 variant with a newer Intel chipset. It uses the same
registers as the X1. Add a quirk for it to the oxpec driver.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20260223183004.2696892-4-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/oxpec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/oxpec.c b/drivers/platform/x86/oxpec.c
index d66c9c0003585..a30845ba37969 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -313,6 +313,13 @@ static const struct dmi_system_id dmi_table[] = {
 		},
 		.driver_data = (void *)oxp_x1,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "ONEXPLAYER X1Air"),
+		},
+		.driver_data = (void *)oxp_x1,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
-- 
2.51.0



