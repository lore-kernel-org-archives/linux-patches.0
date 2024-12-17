Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F57E1F8AC4;
	Tue, 17 Dec 2024 17:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456409; cv=none; b=EWUVo+68dnFVU8Zcp2LA9wFCfeYp/vTglCfiXGBcEL8T6yzcc10NNxhZRRv3baBTTsUs/nzzmouoa7eVkD5RpyGPJfwxR1gtIlUf7JU4g/rs3j9kExaw+DIZ5x8pk40mHppT9SWRODXat0CYJVZh1cc13zs4jlAFF85x9JDIZKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456409; c=relaxed/simple;
	bh=S6Flm1JVuK8UP64UGHSRqfzuWQIcpno5H9OII3GK2iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQ/n3UuRcmRcEElR1F7U/PaZ6AHp/wXCjZ42rSE71K09eMwhilYU7TONE+7P57AYYJuhzoMnNW9pzXKKqqwynQZfmgIj8xAxy8QqaUlZg5w0pqRR0Acmk98aSoI9GDo1rvJcelzeJ72WLbvaUnfNFIaffKh4qf6se9lxMyKtawY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAk3X+gh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAk3X+gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF4AC4CEE0;
	Tue, 17 Dec 2024 17:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456409;
	bh=S6Flm1JVuK8UP64UGHSRqfzuWQIcpno5H9OII3GK2iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAk3X+ghPOvaULtA9rprJFDxmPWQyojLFw5OzXcm0xYJzsYCNNC1naSluqBvNfnjY
	 Y7TB9VI2CWcN+CwVkGuF4BJmAdFegWktCn11h3UgGrLCd316PbhWgSP04wKz2lsxiH
	 Bu1maHerCulrKn1iJzIRWBBY7o/AZovs8pb5J2gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.12 021/172] gpio: graniterapids: Fix GPIO Ack functionality
Date: Tue, 17 Dec 2024 18:06:17 +0100
Message-ID: <20241217170547.138246948@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

commit 0bb18e34abdde7bf58fca8542e2dcf621924ea19 upstream.

Interrupt status (GPI_IS) register is cleared by writing 1 to it, not 0.

Cc: stable@vger.kernel.org
Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20241204070415.1034449-8-mika.westerberg@linux.intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-graniterapids.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-graniterapids.c
+++ b/drivers/gpio/gpio-graniterapids.c
@@ -166,7 +166,7 @@ static void gnr_gpio_irq_ack(struct irq_
 	guard(raw_spinlock_irqsave)(&priv->lock);
 
 	reg = readl(addr);
-	reg &= ~BIT(bit_idx);
+	reg |= BIT(bit_idx);
 	writel(reg, addr);
 }
 


