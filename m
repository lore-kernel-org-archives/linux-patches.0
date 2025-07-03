Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AB072610;
	Thu,  3 Jul 2025 14:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554097; cv=none; b=olhZDioTLMX7fIUwScMnWTKqf5Dr2rzB86GQMqMDwTPi7ZZzJTKHlpOrXQgMNhNP36JZciLCzIhRBy5NGjGm+NOv+YKIeU5oeQ+uyRxFB0GPiKFMf2iet4s0ozMkfV51ljqZhfcuR50QlV7dxoT/bCtDqTuRqxSYVQXt8Gle70w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554097; c=relaxed/simple;
	bh=6/dEqGjYgOqoRyJZ11W9PM8rqa6bwhu6k6S/grhVjGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fK9jwozD7ABcGwqNStk7U30n6w6A67NWvipkL/Ujmv6pFzz4kA9gKjRSesd0ZJrUH0LQ8KJxO1e7IdFmLs+T7U6G0k7rabBLB3eLDezQ27GCiGNoaiaLSBx+iyQeyroKRSoqAgL/JEO41HE4z2fARGCk0MQXglGNqVwyJQh1lDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytBDa4vT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytBDa4vT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68263C4CEE3;
	Thu,  3 Jul 2025 14:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554096;
	bh=6/dEqGjYgOqoRyJZ11W9PM8rqa6bwhu6k6S/grhVjGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ytBDa4vTzM3f/BBiBe5abJUonwgOypFbhByfde0g3wsF1TfnT+YfHy/mtPX7YyEs1
	 pxps/i2HgUeaSe4oJDrRApwMtD2u/XsckE6nAuCQ4TFD7mVfG8uOQS+DrsdAVuGagZ
	 5mYX4OC3Shhv87RwrR8tdRkuZh8rNnQU9RADqpZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yang <andyybtc79@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 079/218] ata: ahci: Use correct DMI identifier for ASUSPRO-D840SA LPM quirk
Date: Thu,  3 Jul 2025 16:40:27 +0200
Message-ID: <20250703143959.098793742@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

commit 3e0809b1664b9dc650d9dbca9a2d3ac690d4f661 upstream.

ASUS store the board name in DMI_PRODUCT_NAME rather than
DMI_PRODUCT_VERSION. (Apparently it is only Lenovo that stores the
model-name in DMI_PRODUCT_VERSION.)

Use the correct DMI identifier, DMI_PRODUCT_NAME, to match the
ASUSPRO-D840SA board, such that the quirk actually gets applied.

Cc: stable@vger.kernel.org
Reported-by: Andy Yang <andyybtc79@gmail.com>
Tested-by: Andy Yang <andyybtc79@gmail.com>
Closes: https://lore.kernel.org/linux-ide/aFb3wXAwJSSJUB7o@ryzen/
Fixes: b5acc3628898 ("ata: ahci: Disallow LPM for ASUSPRO-D840SA motherboard")
Reviewed-by: Hans de Goede <hansg@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250624074029.963028-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1456,7 +1456,7 @@ static bool ahci_broken_lpm(struct pci_d
 		{
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-				DMI_MATCH(DMI_PRODUCT_VERSION, "ASUSPRO D840MB_M840SA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "ASUSPRO D840MB_M840SA"),
 			},
 			/* 320 is broken, there is no known good version. */
 		},


