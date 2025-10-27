Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A922D47ED;
	Mon, 27 Oct 2025 18:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591383; cv=none; b=IYWdQN5aDfFSCUm8GkuUsLkDhje10i6dQC1+xe2xnnqVrzD3CpU2LZDaBcADDET6ljjLpnsbIfU5Snhjup9xT9JnymVtLyv7Lf2PK9YiTltmTJ70xk9oPFdABVDOM1Wkakq4+C468NBzfGwpMu6Pn35cq2H5aX3KneOygT0Ii/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591383; c=relaxed/simple;
	bh=YZVdypD4g64VmCucfQU7zn2u6PWb6ePeIkp3EFcJ3tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSIczv1pXI/1vSfhubTvopiE3DxqlQ9kwthJnkhcyaEICjE4QQN/yleIj3z7WuigKHofPwrrPePKpHqA+BJDJFQ+mXFztgpypQ37IkHO9LE/HE8nYtggAUwqw7Aiv+9JuKxcDPyzTVc8DuFDrvnZmGPQK5jzS5MhtRhfBA+lj7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5Wgz0mF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5Wgz0mF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2411C4CEF1;
	Mon, 27 Oct 2025 18:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591382;
	bh=YZVdypD4g64VmCucfQU7zn2u6PWb6ePeIkp3EFcJ3tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5Wgz0mFBQKtAPzH0cI0PjlyUZk1ClDlLo0Hw9M50iOWF42PHuaiXnxiwdUBNQt8N
	 0Mm+6h8soaWGbKtUk0GPFujIcwUM4z9n57oByd/gLkpEirwOfgvnhT9Cm+GELEFq97
	 5NzIsgUpPOTP1Hk9oKxWkN4LM2D1uzgirRYLUyJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/332] mfd: intel_soc_pmic_chtdc_ti: Fix invalid regmap-config max_register value
Date: Mon, 27 Oct 2025 19:33:48 +0100
Message-ID: <20251027183529.260404903@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 70e997e0107e5ed85c1a3ef2adfccbe351c29d71 ]

The max_register = 128 setting in the regmap config is not valid.

The Intel Dollar Cove TI PMIC has an eeprom unlock register at address 0x88
and a number of EEPROM registers at 0xF?. Increase max_register to 0xff so
that these registers can be accessed.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20241208150028.325349-1-hdegoede@redhat.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 64e0d839c589 ("mfd: intel_soc_pmic_chtdc_ti: Set use_single_read regmap_config flag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/intel_soc_pmic_chtdc_ti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/intel_soc_pmic_chtdc_ti.c
+++ b/drivers/mfd/intel_soc_pmic_chtdc_ti.c
@@ -81,7 +81,7 @@ static struct mfd_cell chtdc_ti_dev[] =
 static const struct regmap_config chtdc_ti_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
-	.max_register = 128,
+	.max_register = 0xff,
 	.cache_type = REGCACHE_NONE,
 };
 


