Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6AB423A89;
	Tue, 31 Mar 2026 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975603; cv=none; b=NXEQ32qKUxg2CSpzDUauMcRX+SDzTt6ZNktKJXSep5PcB3Qc/HlKxWdzhf8YInrC6sjiQ+QXGSucPy/ZXC3tMlHlfRjNjGfJcm5BD3lIdBAaKp3mlSh4H65wDK3SNAfspcRomXQjKevOmBn2vRNSi+RM+qMRNDxgkvTIMhnjcsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975603; c=relaxed/simple;
	bh=kocFV0Qafb9HSJQE1ufqkiFp4xUVMll32onMyQfLVag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=do8UFNedW2wUAEaybfnGErLoqsQV7fNSwsAZriQzAraAe0rx3SQHX28KclmzwOPKbxjkBSYvOSfbkC60L71fJ1NtIMR6vPlvolSSt+mC5/bGKzpNP81R8fkmNaUcXftmWMZR8mK1j2B6vlrspyQLfaUreSx/lIytn39gEyKaHBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdCcAM27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdCcAM27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FEEC19423;
	Tue, 31 Mar 2026 16:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975603;
	bh=kocFV0Qafb9HSJQE1ufqkiFp4xUVMll32onMyQfLVag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdCcAM27QSAKkegLaS1pt8AQhK9Rk0pgKWgL0kTx5xGXpNR35aPpMLjBVLOXgQyZk
	 xYS3Z0bkFOAujTauOYdS/jDg6m5J0ZrUCRwCRXiERZvs9YEWWuPDyuEkvucFR5ddxI
	 IE1j3L5Bu7ZhECAsRsnetsavG2U/VZf+Hps1OmN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leif Skunberg <diamondback@cohunt.app>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/244] platform/x86: intel-hid: Enable 5-button array on ThinkPad X1 Fold 16 Gen 1
Date: Tue, 31 Mar 2026 18:19:26 +0200
Message-ID: <20260331161742.305153471@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leif Skunberg <diamondback@cohunt.app>

[ Upstream commit b38d478dad79e61e8a65931021bdfd7a71741212 ]

The Lenovo ThinkPad X1 Fold 16 Gen 1 has physical volume up/down
buttons that are handled through the intel-hid 5-button array
interface. The firmware does not advertise 5-button array support via
HEBC, so the driver relies on a DMI allowlist to enable it.

Add the ThinkPad X1 Fold 16 Gen 1 to the button_array_table so the
volume buttons work out of the box.

Signed-off-by: Leif Skunberg <diamondback@cohunt.app>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260210085625.34380-1-diamondback@cohunt.app
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 0b21d8317db30..a51b65280bc40 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -126,6 +126,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "ThinkPad X1 Tablet Gen 2"),
 		},
 	},
+	{
+		.ident = "Lenovo ThinkPad X1 Fold 16 Gen 1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "ThinkPad X1 Fold 16 Gen 1"),
+		},
+	},
 	{
 		.ident = "Microsoft Surface Go 3",
 		.matches = {
-- 
2.51.0



