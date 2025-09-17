Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47DC2F3C26;
	Wed, 17 Sep 2025 12:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112850; cv=none; b=OVa3bj4p2fkn3s1TIyqHzuPnu3eUGSOcGQ+GyDPPLgZxnSyv9xfNvw0XV4CNtkM6RLgvfyEgIAm1Iih9zkCDGirwnBTVPgcs2GJ89/UGyomuRQXAKKx+QvsnH0C3je1BOSSE+op2CIRNPorAWYoxOq25M0bWIGmiVs0i5qkG2Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112850; c=relaxed/simple;
	bh=AT1I4qm1njDDoAvlABmKwUIlgw0aFnzMVpdmTn21Tyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFGQOSSPHRRUtIi6grDjfF6Rz+HpelG8M5xTjckPPXHxTkP/TpEg+9SFGCWu6K7nAmPh/M4VBPWY274s3qL3Yq8LdUYRkdoM08J3QE3KiLalYmNSrvRytUDwkEQ+W98RWmFAIk22CRweh0AA4YtniqvYKhz+2p9CtUvnEZujzVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbtEa7eh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbtEa7eh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5744FC4CEF5;
	Wed, 17 Sep 2025 12:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112850;
	bh=AT1I4qm1njDDoAvlABmKwUIlgw0aFnzMVpdmTn21Tyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbtEa7eh9Gl67G04msWpRl84R07nGilB61ZKhcZtVccuLcO+KD+IzxBMQAMVbGygI
	 pOU9pMFTumzCqw3do061EQH4FJM4O5A6/dhxujWqG5aCrvqCJ29f+JP2XjnEM/I20t
	 WbHfNqOKTsp6frzbe4ajBbLD7MGa+3l8Ir0yvoMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chiasheng Lee <chiasheng.lee@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.16 059/189] i2c: i801: Hide Intel Birch Stream SoC TCO WDT
Date: Wed, 17 Sep 2025 14:32:49 +0200
Message-ID: <20250917123353.308950905@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1052,7 +1052,7 @@ static const struct pci_device_id i801_i
 	{ PCI_DEVICE_DATA(INTEL, METEOR_LAKE_P_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ PCI_DEVICE_DATA(INTEL, METEOR_LAKE_SOC_S_SMBUS,	FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ PCI_DEVICE_DATA(INTEL, METEOR_LAKE_PCH_S_SMBUS,	FEATURES_ICH5 | FEATURE_TCO_CNL) },
-	{ PCI_DEVICE_DATA(INTEL, BIRCH_STREAM_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
+	{ PCI_DEVICE_DATA(INTEL, BIRCH_STREAM_SMBUS,		FEATURES_ICH5)			 },
 	{ PCI_DEVICE_DATA(INTEL, ARROW_LAKE_H_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ PCI_DEVICE_DATA(INTEL, PANTHER_LAKE_H_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ PCI_DEVICE_DATA(INTEL, PANTHER_LAKE_P_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },


