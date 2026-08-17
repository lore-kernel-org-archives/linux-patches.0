Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9730C2E8DEC;
	Mon, 17 Aug 2026 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979128; cv=none; b=SP6aZVg7Q7yVmLJWHzxSFRt2KFiULWPEvTCZ36nn93jIYsJYx+XLSTo/SQVL06KAKX2nt8CWuDyP/Taa8JLNpNYPpyJwM00rojsmN4+esB0wbfCh9nlDtft+saWucCfFe0iQkm2JCPJb4N2+f/i4oXgR7evKbRFQAxzM52MgcDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979128; c=relaxed/simple;
	bh=8Xg85V6awaiOZrZ7FD5qyKBNAPTC98kKL1vBiotxY2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQvq7YIGdfKpAncEgi72+6XRBi8HfIHYJqPms/yfypdYwt1Vx8tqQy9C2C5RPcD1hGI63HCB6u+8EHVzfcApGh35S54IGsGYwGALwGWWH3HiIuIbM9km7nIB3PJhLne9T4APGF6LzJvDzrGHqEN11IrrrpCyh49/0lbn05suK+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2ijWMGu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2ijWMGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBFA1F000E9;
	Mon, 17 Aug 2026 15:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979127;
	bh=1roflaMTPunRvYV0Hq5qIzv3cdf2Q4EEnJlLXmfwyN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2ijWMGuR6PLH321NkxAoSm3o+W6gosY+/AxlZcMUIsXKlQWOJylSxJuYiVKwMoRe
	 697bMj6ZFKk5vPNPnWGm0QncVzQJhLjO9xLImIqIequrg0ZKQ1WVhSOEmgVcseQnNi
	 7Hp0zzymeNqneT0COenS43EYVF08Jg3l17Z/D8QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/609] hwmon: (asus-ec-sensors) add missed handle for ENOMEM
Date: Mon, 17 Aug 2026 15:26:55 +0200
Message-ID: <20260817132547.784118290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugene Shalygin <eugene.shalygin@gmail.com>

[ Upstream commit 9813c1f49efeadbcb17e4a41972350ac783f9cac ]

Add missing return value check in the setup function.

Fixes: d0ddfd241e57 ("hwmon: (asus-ec-sensors) add driver for ASUS EC")
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20260712130602.1256700-2-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index d6f6c8113af7ec..d7a40070185ec2 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -990,9 +990,11 @@ static int asus_ec_probe(struct platform_device *pdev)
 		if (!nr_count[type])
 			continue;
 
-		asus_ec_hwmon_add_chan_info(asus_ec_hwmon_chan, dev,
-					     nr_count[type], type,
-					     hwmon_attributes[type]);
+		status = asus_ec_hwmon_add_chan_info(asus_ec_hwmon_chan, dev,
+						     nr_count[type], type,
+						     hwmon_attributes[type]);
+		if (status)
+			return status;
 		*ptr_asus_ec_ci++ = asus_ec_hwmon_chan++;
 	}
 
-- 
2.53.0



