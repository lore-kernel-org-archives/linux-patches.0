Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23742218EB1;
	Mon, 27 Oct 2025 18:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590373; cv=none; b=BGixQETCBneUBu0mckahYb5JFjzI+udCiNAPSGNnPd9upIiedDf3JCAe1NH60Eq/HDSGnoVfmA6/on35Mg4N2cg9+mM6in4cZPq7k3YLBzXPwRXiY77pdScvTbEN+Jympl5O3uCBKTigC8nYV9mYLsBamuOBJOfNqTqTsPyAD4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590373; c=relaxed/simple;
	bh=3Ib/UqkyhDPz7CA4MmWh9l458qDwyWIE3Hc2Z8C+jzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpuJ41bqCpq3yryGDVPKASnHjBQZxB3WIUzxvRBjFEo3Z+qLUqeZh8mEVdaLfxNCrIPx//a2/hIFnZgpuydVYiRvb3H8DY0SBt0MClhzdva24PO16ZGgg0EWzMMcXEgb064QMV0Jh/gqBsHlVK6c9M4FObtBFcvd45Nz83xv9kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjIZzjXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjIZzjXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02F2C4CEF1;
	Mon, 27 Oct 2025 18:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590373;
	bh=3Ib/UqkyhDPz7CA4MmWh9l458qDwyWIE3Hc2Z8C+jzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjIZzjXiHlXAJG15JixvsfrI6uss15/1T496L6JOXMKVsqXMqVVkHdIeJawi2uA0/
	 vPB8cmu6Z7b8lmmCysHthca0/AmlclujZsn6NaZdu3xcGljWSCouECXTudw+EwYY73
	 UFzLO1jjRPqkqe/I2Svmd6zsBRm32xqF5T3i5rMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/224] regmap: Remove superfluous check for !config in __regmap_init()
Date: Mon, 27 Oct 2025 19:32:46 +0100
Message-ID: <20251027183509.539668591@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 5c36b86d2bf68fbcad16169983ef7ee8c537db59 ]

The first thing __regmap_init() do is check if config is non-NULL,
so there is no need to check for this again later.

Fixes: d77e745613680c54 ("regmap: Add bulk read/write callbacks into regmap_config")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/a154d9db0f290dda96b48bd817eb743773e846e1.1755090330.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c453c24afeb8a..5824cfd288125 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -824,7 +824,7 @@ struct regmap *__regmap_init(struct device *dev,
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
-	if (config && config->read && config->write) {
+	if (config->read && config->write) {
 		map->reg_read  = _regmap_bus_read;
 
 		/* Bulk read/write */
-- 
2.51.0



