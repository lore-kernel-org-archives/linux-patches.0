Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E461117727;
	Mon, 27 May 2024 19:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838375; cv=none; b=t1OAeFIiqnUAPey9GiGlsEQMVRdUM9nndoMP0dqESI3/iKhBZXsfOB383M+u9nip8k06UCxEUJmkl0jnF5YVmk4HCA1WSz0Dhq1jYkVidMI1tgzC9duy4BYjr/8keQiO7BnXTegXWXR1x0U7Ql2d6a71bc6AE06eZ/atMwELWOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838375; c=relaxed/simple;
	bh=C/mZaWSJoE4CpuxRhdXdWyGz77MQ5LGYlDb+i2EmLUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJkUEURE3JXVXgxz1XaWSXvLGZlFq104bKuTZKx24hJv7Id5dlK75f9sVA0V8r4trbgD2YUIQG1WMHcj/EhOFRBjtTWhYV9fKEjCxZmByc42GCo7T9P+Xa8PelEVcOesToE9f+tJeXwtsi+DmZ6znI/A0Oxh4GW/wLBr9LnCuiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XFUtHqAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XFUtHqAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798F7C2BBFC;
	Mon, 27 May 2024 19:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838374;
	bh=C/mZaWSJoE4CpuxRhdXdWyGz77MQ5LGYlDb+i2EmLUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFUtHqAl5k/5805shlDPOdeWLmohb8xPUBYe8i+H5nNIsZ4l3UaGHNihqHJU/4Ro8
	 U78eM2tT0cX7+/VTAGiBQbqbfvF0/an9qKXsVAGWBfto5oxEeG3uCZLFnBTJx0GqEL
	 MNTEs7ZQfmZNodrs3oGoGoN4Am1XqbhN22L88wO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 369/493] drm/panel: ltk050h3146w: drop duplicate commands from LTK050H3148W init
Date: Mon, 27 May 2024 20:56:11 +0200
Message-ID: <20240527185642.346317453@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko.stuebner@cherry.de>

[ Upstream commit 55679cc22e60e8ec23b2340248389022798416cd ]

The init sequence specifies the 0x11 and 0x29 dsi commands, which are
the exit-sleep and display-on commands.

In the actual prepare step the driver already uses the appropriate
function calls for those, so drop the duplicates.

Fixes: e5f9d543419c ("drm/panel: ltk050h3146w: add support for Leadtek LTK050H3148W-CTA6 variant")
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Reviewed-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240320131232.327196-2-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c b/drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c
index a50f5330a6614..8e0f5c3e3b98e 100644
--- a/drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c
+++ b/drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c
@@ -295,8 +295,6 @@ static int ltk050h3148w_init_sequence(struct ltk050h3146w *ctx)
 	mipi_dsi_dcs_write_seq(dsi, 0xbd, 0x00);
 	mipi_dsi_dcs_write_seq(dsi, 0xc6, 0xef);
 	mipi_dsi_dcs_write_seq(dsi, 0xd4, 0x02);
-	mipi_dsi_dcs_write_seq(dsi, 0x11);
-	mipi_dsi_dcs_write_seq(dsi, 0x29);
 
 	ret = mipi_dsi_dcs_set_tear_on(dsi, 1);
 	if (ret < 0) {
-- 
2.43.0



