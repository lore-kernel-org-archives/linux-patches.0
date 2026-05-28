Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DD11DE4E0;
	Thu, 28 May 2026 20:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000910; cv=none; b=OeygsZ5qssPd1RiLZYZY5Rm1F5OslgwtHIrlyebqbV3/TmFkwMObYB2uuaZcgCm5x0z+qWvjXXoM+83nLHg7fXzLPJIo/PmUaLzjdE0GdgpxnCnhi0FeaVH9XhSfvnY/T6zWyz5MYUl24EKuuByMYsOQtuMxNUplovCipz06plE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000910; c=relaxed/simple;
	bh=CO6ziZn3MnhDAHQt+NCQ90qNX97m3+oSOWJ1QGTTRaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWvjModsjj5xwInwwzrG0o9KAcWjVq16pTf5BJqAF53ny78/e+vc/utU4a87nxEvROJEk6gOuhZPDWKa8un2qBMGkWre0CVbAxagC/E+QRFUdriXNlm/4Pg0ocZL5oZgJCI9NZvklgmdjkzOajUZ1iolnZOHRQMkdk5xTJey7i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oqye2c1o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oqye2c1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF611F000E9;
	Thu, 28 May 2026 20:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000909;
	bh=PTIvU0chbmYM5LEw1domXf9RDcwwt7D5FSZe0UnO08Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oqye2c1oA2v/OHDkPF46B9eaem4JclCO7OWqf3NJuMtmJZ+FKI1N7MdCkREOUC8xy
	 3I4UUTiwiFIhLY8x+LVxBH+0cg3/yX2fWrFv73RMseXf9DuYVeEraKNAlhPp3cfx5U
	 7D52VufsFy+x+rF05vpDSJYaAJYJYYICl+rxcX9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/272] net: ethernet: cs89x0: remove stale CONFIG_MACH_MX31ADS reference
Date: Thu, 28 May 2026 21:49:39 +0200
Message-ID: <20260528194634.979444427@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

[ Upstream commit 36a8d04a8293afcb9304cf0cd3741f67698f2a1a ]

The legacy ARM board file for MACH_MX31ADS was removed in commit
c93197b0041d ("ARM: imx: Remove i.MX31 board files"), but a reference
to it remained in the cs89x0 driver. Drop this unused code.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Fixes: c93197b0041d ("ARM: imx: Remove i.MX31 board files")
Link: https://patch.msgid.link/20260509023732.42256-1-enelsonmoore@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cirrus/cs89x0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/cirrus/cs89x0.c
index 0a21a10a791c5..6b01c44a5f728 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -1271,7 +1271,6 @@ static const struct net_device_ops net_ops = {
 
 static void __init reset_chip(struct net_device *dev)
 {
-#if !defined(CONFIG_MACH_MX31ADS)
 	struct net_local *lp = netdev_priv(dev);
 	unsigned long reset_start_time;
 
@@ -1298,7 +1297,6 @@ static void __init reset_chip(struct net_device *dev)
 	while ((readreg(dev, PP_SelfST) & INIT_DONE) == 0 &&
 	       time_before(jiffies, reset_start_time + 2))
 		;
-#endif /* !CONFIG_MACH_MX31ADS */
 }
 
 /* This is the real probe routine.
-- 
2.53.0



