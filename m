Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6701F1DDCE;
	Tue, 16 Jul 2024 16:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146299; cv=none; b=rrr3kl0A3F+PScIfTYJkzel/9+jcf+JwS5AXsmlnHFjAp/zf1rko6xsPOcRUnLSuuNuvv4uGF34QkVmE0YvrmqvnVra4NzGqo0j04PnSNViF0ZvFtH5yO6Jt5X/h4JRWIUO9+HjXyqMrFR0YNvCZt9rxPFGEWsBVeeDq9udnAL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146299; c=relaxed/simple;
	bh=xqKL7L8x8iurU9gUAD+ewC8FWiScwpDiKxq0eI6NCLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DNDg5bPWhWGlyj28al5vJVxckqvjy6esF12dPyv1hNGhU3vIyWPXRoEEI+RrAiu4mLpWCw/hI29Hpumo7IBh+C/OfzicHJq61N9FeikdChdn9dOupHHDq+7uF07nqLqVylBqcdbZUaAyOqwojvNleaAe6Zf6JOfz/bonqmIxt00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+8QOnil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+8QOnil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FC4C116B1;
	Tue, 16 Jul 2024 16:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146299;
	bh=xqKL7L8x8iurU9gUAD+ewC8FWiScwpDiKxq0eI6NCLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+8QOnils7PrVhOAppwRF+twAf9es1Gzl6wuUNv043UxRAHn4IjnwX/jOTUBjJWXA
	 zd8nThdmz0k9d1S2Ieg1fa03oYn2ej+9EWwbqzYfrrmZhTXYPFy2y9SRqtyJMeCa2i
	 iOUL90hI56Sb4uLFvV4iT5fBtNigMTEGC0Lwv2iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.15 120/144] nvmem: core: only change name to fram for current attribute
Date: Tue, 16 Jul 2024 17:33:09 +0200
Message-ID: <20240716152757.138177852@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 0ba424c934fd43dccf0d597e1ae8851f07cb2edf upstream.

bin_attr_nvmem_eeprom_compat is the template from which all future
compat attributes are created.
Changing it means to change all subsquent compat attributes, too.

Instead only use the "fram" name for the currently registered attribute.

Fixes: fd307a4ad332 ("nvmem: prepare basics for FRAM support")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240628113704.13742-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -362,10 +362,9 @@ static int nvmem_sysfs_setup_compat(stru
 	if (!config->base_dev)
 		return -EINVAL;
 
-	if (config->type == NVMEM_TYPE_FRAM)
-		bin_attr_nvmem_eeprom_compat.attr.name = "fram";
-
 	nvmem->eeprom = bin_attr_nvmem_eeprom_compat;
+	if (config->type == NVMEM_TYPE_FRAM)
+		nvmem->eeprom.attr.name = "fram";
 	nvmem->eeprom.attr.mode = nvmem_bin_attr_get_umode(nvmem);
 	nvmem->eeprom.size = nvmem->size;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC


