Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C396E6A8D2;
	Tue, 17 Feb 2026 20:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360790; cv=none; b=uKPqVFObiNW5eibFZRAwLFjHJdiHAEvw8Pty9eCILncnrGY1VzdjqrZ1Y3bhTAmOqTHuYdtOCJDDG/qILeA6terSv1RiDkU74dZAfBvgqV3HhDV0ve3u+KxyQtPCqFfTB9NlhIpwFRGsnGHLeBwvq8MJ0vXP0ZG9GuRQghKBfRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360790; c=relaxed/simple;
	bh=8zbpdFqrj047vvAylMTXpsU+Poz/lQF3jKXjpXKjoq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=toCJSr+i+NR31cUD1WUMFgoUX4mfHhSvr4tzTC9w74rjNhIemhIHBYHuBUimZAtBhoZfH/iW8AUCj5SZ2NCR7p4VpHjeo+SWkPzZaRnO2PbujSHbyq4QyNcxi8W9NJOXh3bMDH56PjVB2GqbdF1sFc3EOATdKwy1Z1BP+PRIaCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fELe2i9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fELe2i9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2465EC4CEF7;
	Tue, 17 Feb 2026 20:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360790;
	bh=8zbpdFqrj047vvAylMTXpsU+Poz/lQF3jKXjpXKjoq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fELe2i9PpSW5kwzWKNstvsDdo0k+oUhAvycS0ep9bviHy97uPcZ16gqoeoKVK3fvt
	 K4+ormKsYSjL3+fFNoWeztdLKS9DBvRhLctku+hE5+KKakrzaCjR/NSusmBneaohiG
	 6bRHOx9FRnJt6P74i+ZnkSQkzefF8m4VKy3GYXFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gongqi <550230171hxy@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 16/39] platform/x86/amd/pmc: Add quirk for MECHREVO Wujie 15X Pro
Date: Tue, 17 Feb 2026 21:30:38 +0100
Message-ID: <20260217200004.848431918@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: gongqi <550230171hxy@gmail.com>

[ Upstream commit 2b4e00d8e70ca8736fda82447be6a4e323c6d1f5 ]

The MECHREVO Wujie 15X Pro suffers from spurious IRQ issues related to
the AMD PMC. Add it to the quirk list to use the spurious_8042 fix.

Signed-off-by: gongqi <550230171hxy@gmail.com>
Link: https://patch.msgid.link/20260122155501.376199-4-550230171hxy@gmail.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index a5031339dac8c..a6006b4ec2cc0 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -296,6 +296,13 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "XxKK4NAx_XxSP4NAx"),
 		}
 	},
+	{
+		.ident = "MECHREVO Wujie 15X Pro",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "WUJIE Series-X5SP4NAG"),
+		}
+	},
 	{}
 };
 
-- 
2.51.0



