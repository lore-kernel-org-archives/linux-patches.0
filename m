Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619398;
	b=eBvTb7/vKgWKloX1LT7v0F+Dql6k+YQoGReSqAgtBl/tN5FBKsaWj+NxAmO1Xgr1G8bf
	 f0hC7NtnhNyvl0elG2XYFHUwWovHGCegjOQBX/oqM5eMVoxfOGRkrVSg+FjusRr7TPDxr
	 RJTIAzj6RVnjjlgC+KzoCyspO1AZcHAgVIsYRvJ5SL130wUjvDkmM5krfVoQ4C5TulXju
	 Lv/5borqte9P2ABZdTTeDjT2jwqgoBJG6tLmJ/WHByU/TMU0aTD4gjTBF82rYBXTsthQr
	 ZhoxYd5o1lLATevQmYfFyd6zfpUODOOGPe0BCYINWxc/OnJPEn0hnUTC+DSZugrDeug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fEwenWUvW9JC5AZz2/lhitU3mq1yixnmIq6TjEHpb9c=;
	b=H4NoXnHaeTByA3oLbLCUHCj5EEEycId/wCc1ml5tAZROG6yhENWICLEXc8c+s8lLGC7w
	 AU2YiIeIiG7oMS/jSLkVsTF0oy4SQjoDlqXikDP274OU3TMqU8UdMdJEf9IX+PuBWKQuM
	 SqTdfZySL5yFoAoKiYBVOiWb4NBHm45Gn2T7qmpQD2fO6FXMUdjFXlZuJ7+q4nnD2RUDG
	 2o+N/CRBjKTtr7P8OPMiEXYptLWtlsd4khVxEcC1M186ysAfZdqwQZokyzgugnSlxJhZK
	 JOWk9rGv5Zu1vuyTjZhHcTpETDYt3zI4/cfwNUvwt9cNoSEbhM6nsUNt7qtbnuaAqdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OEWcISgX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE43606A323;
	Wed, 25 Nov 2026 15:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OEWcISgX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817A11F000C6;
	Wed, 25 Nov 2026 15:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619398;
	bh=fEwenWUvW9JC5AZz2/lhitU3mq1yixnmIq6TjEHpb9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OEWcISgXByYDVFT4RhS3bcCml+9I9vjIfmuMUQ2efGv+vgE3HG6tn1XqYdPC1nkb9
	 doOKMrY7k7skrEQa7+QD2OcQmmMCRusMMdxv2hWN0XuXtXuE8Dln8q/VRBPOwbNazu
	 cCOafK/SgiaBug1ju/P4YiD3PmEdwMpeCiE4Qf2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.3 0582/1005] mmc: meson-gx: report busy from DAT0 alone
Date: Wed, 25 Nov 2026 15:32:00 +0100
Message-ID: <20261125143835.381458927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Velkov <iav@iav.lv>

commit 318fdb75f4dc9d18ae621b9fb25eb11160c95649 upstream.

meson_mmc_card_busy() reports busy only while DAT0..3 are all low. A
busy card drives DAT0 low and leaves DAT1..3 to the pull-ups, and the
callback is defined as "Check if the card is pulling dat[0] low". So a
busy card is reported free, and the core, which prefers card_busy over
CMD13 in mmc_busy_cb(), stops polling after CMD6 and erase at once. The
controller hides this on R1b commands, where it waits for busy itself.
Once max_busy_timeout is reported, the core sends the longer waits, the
120 s BKOPS and 240 s sanitize switches among them, as R1 and has only
the polling left.

Look at DAT0 only, as sdhci_card_busy() does. The checks around the
voltage switch in mmc_set_uhs_voltage() still hold: the card drives
DAT0..3 low together after CMD11 and keeps them low together on
failure.

Fixes: 186cd8b7f586 ("mmc: meson-gx: implement card_busy callback")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Velkov <iav@iav.lv>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -1079,8 +1079,8 @@ static int meson_mmc_card_busy(struct mm
 
 	regval = readl(host->regs + SD_EMMC_STATUS);
 
-	/* We are only interrested in lines 0 to 3, so mask the other ones */
-	return !(FIELD_GET(STATUS_DATI, regval) & 0xf);
+	/* The card signals busy on DAT0 alone. */
+	return !(FIELD_GET(STATUS_DATI, regval) & BIT(0));
 }
 
 static int meson_mmc_voltage_switch(struct mmc_host *mmc, struct mmc_ios *ios)


