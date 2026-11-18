Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039915;
	b=xbZ5FxbEIgxo9fMCtzWTr8RTMB+MFaxTajjufH2kOTG9SU/QadrOrixUlT9mHVBEPdfu
	 0tV9y5ecFiBbWyaFksNKDB+4JKcyk1MKYE7iTdtc/8pfAK3lFkccwfgvV+ECUq4EdgcC0
	 fVg3pKnX/B2YHLXMJWwC8ApwXztzqvD037BDDYVyh1EuoAurpkZBLWZuXOjyq1aKMKXLb
	 mdGmg+NI47/T/GIFNWJlHJmDXb4MmXf74RKZgje/ghuil+Gbok44uwhVxhQRyx4DKXQdI
	 hv/R8Z7hFCHrKPDs145ij7RLzJAWq6fkBJQZkHvOV8Wk3TiIxNquXlI28vOB6W2zeeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sixh1FYndiy6bE6T8Z+C3A3yhtQdYIV3F5YROjOG6ok=;
	b=s19pXPhEGI8lFgcHcFqPHvDCYVATISqzyNTLqJTpXvZqqABE994GYiMJ8vgB6ykvpoUG
	 tC5S6Xel8BslQ0ks2LfutXVno7xbNWAdxPc/qkjycBXghh4IRPSdZY551x9W4jLcWLiDE
	 p70sfZupDNBQ2He6Y4U7YHq5DHadnwVhKx26XBj/py6Fy66ELZBjlfDkkfleGwc/K692p
	 6KvOj1YoM3Y3utSPfY+mKXs5M620MJP9FY5A4NuE+U5byPzYGAyJUtiTkocFvbwn1apze
	 sxb+BUieJZF+OM+7KSjOtQdvAYBen2GWBTSVRk5nUITzi4dsV+bbZ+bds27XTl2G13w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MSO/Z0gm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F19E606A32A;
	Wed, 18 Nov 2026 22:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MSO/Z0gm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4ED41F000C4;
	Wed, 18 Nov 2026 22:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039915;
	bh=Sixh1FYndiy6bE6T8Z+C3A3yhtQdYIV3F5YROjOG6ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSO/Z0gmkeKY2vjq9oFHM3oYslAHV5rHjZa5UFyJIaeDqwEFxC586DjbYLcwaH3rB
	 3TT8EAnBaxdQITHEKMfn4leCwcUxV6fLw95FglvgCUtVtTJU5QcaBsYbOIh3TkG758
	 T8Bhfyd9DwE3cOwjNE5YNT6MhwnvK+/9F33eOVAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Triet Hoang <triet.hoang.dev@gmail.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2269/3318] clk: raspberrypi: Handle cpufreq device registration failure
Date: Wed, 18 Nov 2026 15:48:11 +0100
Message-ID: <20261118150429.869731623@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Triet Hoang <triet.hoang.dev@gmail.com>

[ Upstream commit e98e3d712023859af7cd78bb7fdb87ea3a9ffb83 ]

Check the return value of platform_device_register_data() when
registering the raspberrypi-cpufreq device and propagate the error
if registration fails.

This prevents the clock driver from reporting a successful probe
when the cpufreq device could not be registered.

Signed-off-by: Triet Hoang <triet.hoang.dev@gmail.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Fixes: e2bb18347c8e5 ("clk: raspberrypi: register platform device for raspberrypi-cpufreq")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-raspberrypi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index cc4ca336ac13a..fe8d68b9c39e0 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -437,6 +437,8 @@ static int raspberrypi_clk_probe(struct platform_device *pdev)
 
 	rpi->cpufreq = platform_device_register_data(dev, "raspberrypi-cpufreq",
 						     -1, NULL, 0);
+	if (IS_ERR(rpi->cpufreq))
+		return PTR_ERR(rpi->cpufreq);
 
 	return 0;
 }
-- 
2.53.0



