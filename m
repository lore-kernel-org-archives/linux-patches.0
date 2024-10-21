Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6681E25E3;
	Mon, 21 Oct 2024 10:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507430; cv=none; b=WyxgnB4r7t7af0HiH3rB9x5d38bTYdbpayvKieT9wp2vvsE6cqh1AMZqmbfbHOAJJ6zb8N1b4BHdK4BQvAkS5B1mCumFlgRatP1rm5yIen4jHojD6vieT7hrUh78TZtJFuninvNzbAF1UZS9CpJ5N3j8xPCs/67zdOgHwb73kqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507430; c=relaxed/simple;
	bh=fZUAUfO4BUmq9irQz3qbpcna9swZd6+hWrr5Ta0+//w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmRo4KFOyiXrBrhojGVH/90yrom03sddaT1o9b8g/qKCBNQnikSsTM1yKDONizHAjqKV4OlctLlLQKFa7dB+tWKXgxnndJJl/42jn0u2CWSFUvDqkbsGra/+asq1RMfWN4cxtglBuNm1QmHzf5Rrqzgv0FxBFG/lhG6RibUahWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMaUeMx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMaUeMx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E206AC4CEC3;
	Mon, 21 Oct 2024 10:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507430;
	bh=fZUAUfO4BUmq9irQz3qbpcna9swZd6+hWrr5Ta0+//w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMaUeMx9NpsgSmTtbDppxVvt4JE24Prt2auiBdLTHTEK96TT9w3zh5je+1dLVLD4x
	 PVyACo2pYhijSJWIm8PTDV/KwCyUcuXpjkz9oDLks0fL2e8111YM+JXThzG0kcmuIn
	 7DImxUrsUkgjcXlbB2+dC4CDpiFXhobaAsQBxwL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 57/91] iio: dac: stm32-dac-core: add missing select REGMAP_MMIO in Kconfig
Date: Mon, 21 Oct 2024 12:25:11 +0200
Message-ID: <20241021102252.046045287@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 27b6aa68a68105086aef9f0cb541cd688e5edea8 upstream.

This driver makes use of regmap_mmio, but does not select the required
module.
Add the missing 'select REGMAP_MMIO'.

Fixes: 4d4b30526eb8 ("iio: dac: add support for stm32 DAC")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-ad2s1210-select-v1-8-4019453f8c33@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -401,6 +401,7 @@ config STM32_DAC
 
 config STM32_DAC_CORE
 	tristate
+	select REGMAP_MMIO
 
 config TI_DAC082S085
 	tristate "Texas Instruments 8/10/12-bit 2/4-channel DAC driver"


