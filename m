Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078EE77658;
	Tue,  7 May 2024 21:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116092; cv=none; b=UjUQDypz+GT9iXDAun7qvP+EYMSu4+GmkR1/mpXhbrHixThDd6JRTPnpeeTOiVuk7urWRZduve9dGw30uuykpuCBB+bU89G7PCGx2emoQSsgECVcNrC+px2XLFlB2pygSGQH4O6ikJsKvGIuXDa66SA4RUJ1DyJ+U76kdcsUEes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116092; c=relaxed/simple;
	bh=2N1QLk52W+2c9Q6iDFOhjfPP4CuRAqXoC2EDY1JuuaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMIrZDpQvLOtaOC84dWzwfEzumzhquD7G6cBIFXtha1kjccUovnc2uWZ6L4n9N4ckLt7CA9zGaLNSzWAm1rT0DeVjRDtNu+XEL3t5G6YGeedfC03g0tkTNOvsrglUEikyQECI5sYd40l3u4QICHrua/dL313ALm2kA8geqKf0c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h7Z1i0Xh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h7Z1i0Xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A97C4AF17;
	Tue,  7 May 2024 21:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715116091;
	bh=2N1QLk52W+2c9Q6iDFOhjfPP4CuRAqXoC2EDY1JuuaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7Z1i0Xh6stpuP5TEXsyM+/07LVKZoZfxmP06k1j/FCCD8EVSGC4itTi6NChIi/6s
	 K5JpfJMtFF0FFiChhE/uBOkCg6krRA/aHdTRZa4em5DiC5bImpNGJ+WB6isCNWYELV
	 hKhhev3GqBOCO9khnVrBWHONGGHw7AvqOKf9WGduQHLNwLcuzMtfz/29rcEMKJfsmg
	 WTyVOnKH/xwg9A47zoD96vfIzJz2FppesiD84xpy/EvEvZ4qnqceDbDXbkwT2Jck9I
	 0ywpS5x4/JoPPssLRg4y3USnKTl8cisQ8oGGcoGjcceu8nev1EPqDAB30zF2NEU1q0
	 ZUo50o+/0hl+Q==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Ricardo B. Marliere" <ricardo@marliere.net>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 01/12] spmi: make spmi_bus_type const
Date: Tue,  7 May 2024 14:07:38 -0700
Message-ID: <20240507210809.3479953-2-sboyd@kernel.org>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240507210809.3479953-1-sboyd@kernel.org>
References: <20240507210809.3479953-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Ricardo B. Marliere" <ricardo@marliere.net>

Now that the driver core can properly handle constant struct bus_type,
move the spmi_bus_type variable to be a constant structure as well,
placing it into read-only memory which can not be modified at runtime.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
Link: https://lore.kernel.org/r/20240204-bus_cleanup-spmi-v1-1-ef7f278f1987@marliere.net
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spmi/spmi.c b/drivers/spmi/spmi.c
index 3a60fd2e09e1..667085cb199d 100644
--- a/drivers/spmi/spmi.c
+++ b/drivers/spmi/spmi.c
@@ -378,7 +378,7 @@ static int spmi_drv_uevent(const struct device *dev, struct kobj_uevent_env *env
 	return 0;
 }
 
-static struct bus_type spmi_bus_type = {
+static const struct bus_type spmi_bus_type = {
 	.name		= "spmi",
 	.match		= spmi_device_match,
 	.probe		= spmi_drv_probe,
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

