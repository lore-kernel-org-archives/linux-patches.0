Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB4E4A64D7;
	Mon, 31 Aug 2026 13:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183900; cv=none; b=ft/LgJQDh40lx58ShQ+tAjf2nEOpOOPLzjXkEwXDPYTvdS5fIiXKx566dOanU69yP69SFuwnwddF6QxTmlgKz6UT7Y7w6EmLwCIHZQZNADp4NNWQ3xTam1LZ+VJOAQau+E1D4EIRX27Ymkqk/mgddkstzsIumnx0liHQW9+NfUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183900; c=relaxed/simple;
	bh=KpHhR7T33xbWS9ARF9rgrSIYSqkktL2/I887A5Oi5V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r9aKcAzoQPQrUSsYYhh1/GV+crRZxls5vzmfYwGEajgDrMz9oldK3ABMNi2vvBdWvOcSlpkzre3ioQp/YtnwX2P/LAfdFM8yR9BI3nfczhE27Lc/GNQWRt+0F0mjoYQlYZVzfwBSflHBi5PC7v7KI2e3HNzKKTEqOM8MDsHh6Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DWgvjM1Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DWgvjM1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8842D1F00ACA;
	Mon, 31 Aug 2026 13:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183898;
	bh=rHdXN17Zl3nfk/mohMgINlLi2ZzSoJ53ajnoqYQ0R5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DWgvjM1Q2OrabayXXEjF6e8ZsifyMVxvn5gedyV2luErrTS2Uj62oFK7KQBaV4dGN
	 sMPJtA/a9ZsAZY8qGTDhX5/vLecndAjGcNxq8WA8of++i/CEl25CWqkwQcIVKg4M4f
	 VdnEbyXz1hIklDq+sxkl9vtUW7leoiXwCoQad332/NYBS9DClLxf3gtekPwkgnDJjY
	 vwLfrIStlHL2cxBhJmlc7FXNSRTPMy0wQTRwFdwJ369q10z+1rMD0MdzW37rNdDNYb
	 RzKuFJEznO1mA6Zc9g6lZMgarIAb9Q1//gEPq+83pvfkcG8BQJUt6UkK+3ZODMwgCf
	 jl3vliTZ5PsYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] media: video-i2c: use vb2_video_unregister_device on driver removal
Date: Mon, 31 Aug 2026 09:26:37 -0400
Message-ID: <20260831133314.4125787-369-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arash Golgol <arash.golgol@gmail.com>

[ Upstream commit 56384b486b80ce4a2bc93689aae49995f908f90d ]

The driver uses vb2_fop_release() as its file release operation, so
vb2_video_unregister_device() should be used instead of
video_unregister_device() during driver removal.

This ensures that the vb2 queue is properly disconnected before the
video device is unregistered.

Signed-off-by: Arash Golgol <arash.golgol@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background `git log -S 'vb2_video_unregister_device'` search timed
out after ~2 minutes and produced no output (it was killed). That didn’t
affect the backport verdict — the analysis already covered the relevant
code paths, API docs, and tree state directly.

The conclusion for **6.18.y** remains **YES**: one-line fix, real
teardown bug on remove during active capture, applies cleanly.

 drivers/media/i2c/video-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 1eee2d4f5b40e..16ad1831e4da7 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -888,7 +888,7 @@ static void video_i2c_remove(struct i2c_client *client)
 	if (data->chip->set_power)
 		data->chip->set_power(data, false);
 
-	video_unregister_device(&data->vdev);
+	vb2_video_unregister_device(&data->vdev);
 }
 
 #ifdef CONFIG_PM
-- 
2.53.0

