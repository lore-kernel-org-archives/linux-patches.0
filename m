Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38361779BD;
	Fri, 27 Sep 2024 12:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439933; cv=none; b=aQVfmQajLK1M++WD/+gqz2CB4vQIP46glRcB93cDoajWtw1a7kfY/Tth4CM1TI+5prbKJ11UebMcSFrsWa0v9Q79sc7vDVWxPMGF3u9G9nWivwiMhLTY42XCTIAoNh6aUKny6tOYvBGbK50pAW2k8PpfvMh0kcrsoOcrQW64NHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439933; c=relaxed/simple;
	bh=1Fx4u+YajHdXTa2VCBvudtGJDk0y3zkJ2WdvmxgoKZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlyZzrUURc51jFBo7QhCRAAZRI93m/G3d+w2KLW8w+obRoBT82eaHLqcga70Vr5jd0kSyC2I562A5jqiG3wbt5K6BHSsiMVQav6BHmJxq+xoDHONWT3aezjFAb82nNOq92jw0ml1GlXgXMzyQpYRelXeb30RWZ+xQ2l7LgVfLGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNpScSbR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNpScSbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2841C4CEC4;
	Fri, 27 Sep 2024 12:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439933;
	bh=1Fx4u+YajHdXTa2VCBvudtGJDk0y3zkJ2WdvmxgoKZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNpScSbRGiWPDm6XSsqJKM5F9bMl2EpRe2+BNiHUy9Wf8JuQURFbk5HEY3V4s0Ign
	 o1eU2/cz823HS6jG83EaI+mmdYXDesx6iuwHeqBgJfllAIZXXS7e98fUpqQgI83fkp
	 ctwRnwYNdmcLtx1Kt7wwNFkNB5FET5i6LxhZCoEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 27/54] spi: spidev: Add an entry for elgin,jg10309-01
Date: Fri, 27 Sep 2024 14:23:19 +0200
Message-ID: <20240927121720.830373657@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 5f3eee1eef5d0edd23d8ac0974f56283649a1512 ]

The rv1108-elgin-r1 board has an LCD controlled via SPI in userspace.
The marking on the LCD is JG10309-01.

Add the "elgin,jg10309-01" compatible string.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20240828180057.3167190-2-festevam@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index b97206d47ec6d..edc47a97cbe41 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -735,6 +735,7 @@ static int spidev_of_check(struct device *dev)
 static const struct of_device_id spidev_dt_ids[] = {
 	{ .compatible = "cisco,spi-petra", .data = &spidev_of_check },
 	{ .compatible = "dh,dhcom-board", .data = &spidev_of_check },
+	{ .compatible = "elgin,jg10309-01", .data = &spidev_of_check },
 	{ .compatible = "lineartechnology,ltc2488", .data = &spidev_of_check },
 	{ .compatible = "lwn,bk4", .data = &spidev_of_check },
 	{ .compatible = "menlo,m53cpld", .data = &spidev_of_check },
-- 
2.43.0



