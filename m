Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD311E25EF;
	Wed, 17 Sep 2025 12:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113334; cv=none; b=RN8ECcw1Aw0u/Mg3oFr49x16xQZOuu7PppViimn38cdVzuoYTN4EF7ViJ0U+ENhtRNC0iyg/rI8V/H84ykNeYq98YKrWo/UA+gObzcy0wZ17PXcyrDZVS1ZwjVrAQ+fsT41cG2KWBwfhtlwM8HKMueKjieo8863bzzGWJ+vRjn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113334; c=relaxed/simple;
	bh=w+HGkW1C3PyniTMLKc2xU85tTKt/1bahclJYBOaQMUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2lTB8VUEV5GsMeaCE/LEOKZLhB0UiPhOsefb9t/hTHp2/N8xpfDcepf/CvOcHRe66d1Uzvr1zN2vBpQROEuht85JoyWN745+4SVI1xNZXph4yB2s1/m71DelabBsth0GauhW8C1Ixt6AsmDD6I9WjFrl1vmwHVVGAlpJAPhmNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtjxZp6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtjxZp6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0927DC4CEF0;
	Wed, 17 Sep 2025 12:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113334;
	bh=w+HGkW1C3PyniTMLKc2xU85tTKt/1bahclJYBOaQMUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtjxZp6hUHWMVkKECGpxTabi94vHi2bDMDiOXrg1+9qW7GTdxZD6qBdAXDHxv0u8T
	 EEgcOmb0NJKELcyZExI5irmvnvjwv71DpvTAG1fmdzqy7vkkHli5fI/KKII9jpuqAI
	 MQkSZAr+G/udVqfYNxZJLqn+Crs6N3DMP2vvBqJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chiasheng Lee <chiasheng.lee@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 054/140] i2c: i801: Hide Intel Birch Stream SoC TCO WDT
Date: Wed, 17 Sep 2025 14:33:46 +0200
Message-ID: <20250917123345.628636228@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chiasheng Lee <chiasheng.lee@linux.intel.com>

commit 664596bd98bb251dd417dfd3f9b615b661e1e44a upstream.

Hide the Intel Birch Stream SoC TCO WDT feature since it was removed.

On platforms with PCH TCO WDT, this redundant device might be rendering
errors like this:

[   28.144542] sysfs: cannot create duplicate filename '/bus/platform/devices/iTCO_wdt'

Fixes: 8c56f9ef25a3 ("i2c: i801: Add support for Intel Birch Stream SoC")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=220320
Signed-off-by: Chiasheng Lee <chiasheng.lee@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.7+
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250901125943.916522-1-chiasheng.lee@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-i801.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1057,7 +1057,7 @@ static const struct pci_device_id i801_i
 	{ PCI_DEVICE_DATA(INTEL, METEOR_LAKE_P_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ PCI_DEVICE_DATA(INTEL, METEOR_LAKE_SOC_S_SMBUS,	FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ PCI_DEVICE_DATA(INTEL, METEOR_LAKE_PCH_S_SMBUS,	FEATURES_ICH5 | FEATURE_TCO_CNL) },
-	{ PCI_DEVICE_DATA(INTEL, BIRCH_STREAM_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
+	{ PCI_DEVICE_DATA(INTEL, BIRCH_STREAM_SMBUS,		FEATURES_ICH5)			 },
 	{ PCI_DEVICE_DATA(INTEL, ARROW_LAKE_H_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ PCI_DEVICE_DATA(INTEL, PANTHER_LAKE_H_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ PCI_DEVICE_DATA(INTEL, PANTHER_LAKE_P_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },


