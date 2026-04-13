Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AA82C3768;
	Mon, 13 Apr 2026 16:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097899; cv=none; b=bOOqei4qlFWFZThCSod+4ACRK28SbYS76yaOeEB8rb1//ugNzYOkLl41BUxkDjSrM1roRPwN8rCLQBYioDWK8zILvaKoZoRp8yoaZzxh3NxusPOlPKhALIVjdLh0wvcuwVx6f/JY5DQejEWzrHjw9Pro548gFdExdNKk88oktOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097899; c=relaxed/simple;
	bh=+wg+pWacRFw9tqe8GaL1kwVZbJjLf8LgKRO9gdsH92k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a6fbJPixnvAebF2M2770YryL5Y8waQq16DAPSd3ogHKFqnH8gH1DBdsu7Ni/L9aJqEiUkLFjrjRcUM3kJnlc0LQ9yJKdm7mS3LKu5gN0XfszvggpyMKtK4M3w19gjIiAfnrb1m6M3jF49VbRdGiH3lGMI5S/1PP/pEeVfkY3r1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+OZC71Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+OZC71Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB34C2BCAF;
	Mon, 13 Apr 2026 16:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097898;
	bh=+wg+pWacRFw9tqe8GaL1kwVZbJjLf8LgKRO9gdsH92k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+OZC71QIN82UE7Z3Q52Jn9g6H0dY0fEgp1vzC2E8jz/cCc/pcIbWxf/hIa+1wl0G
	 Eu6bzO71jUlL2O/U0WD+ozoCXKbyewAaX6gX9dDiKuZ+OTVX2ExsJKoUszz6uMTClS
	 L3nMd5etbUQSzuE2BcV1JRwfN4NxcKOYRMqzTISo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Metz <peter.metz@unarin.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 298/570] platform/x86: intel-hid: Add Dell 14 Plus 2-in-1 to dmi_vgbs_allow_list
Date: Mon, 13 Apr 2026 17:57:09 +0200
Message-ID: <20260413155841.665912619@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Metz <peter.metz@unarin.com>

[ Upstream commit 6b3fa0615cd8432148581de62a52f83847af3d70 ]

The Dell 14 Plus 2-in-1 (model DB04250) requires the VGBS allow list
entry to correctly enable the tablet mode switch. Without this, the
chassis state is not reported, and the hinge rotation only emits
unknown scancodes.

Verified on Dell 14 Plus 2-in-1 DB04250.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221090
Signed-off-by: Peter Metz <peter.metz@unarin.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260213044627.203638-1-peter.metz@unarin.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 4d488e985dc55..6331469ee6585 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -156,6 +156,12 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Dell Pro Rugged 12 Tablet RA02260"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell 14 Plus 2-in-1 DB04250"),
+		},
+	},
 	{ }
 };
 
-- 
2.51.0



