Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AC1346AC6;
	Tue, 17 Mar 2026 16:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766612; cv=none; b=lnwQMIg0aUaO80qoNohbdZIXZTlZFNTZmbhocCxB3vFnITFpo7YPJ8B8qd0rsI7A4PXmO9BPkwB01YUHPDW77Fg7gc/RCzh5CXwwWEjP51QZfJdcdrotN6q3t85HpZxYCYD+DK6o2NGiZs/FJGp0EqpQRi9ER+pA2RltxOgYHow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766612; c=relaxed/simple;
	bh=XYTkfVFBLRCiKPQNIpb5fDKmI67hN2FIJUjr6mTrBnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpFEzmAX4IkwwiyEq+OLrumRooPTjAZftOKertR7HcE1Dvj/yyo0I2cBm+0NQ4s5KXNOWJDpnjqBt2l0aWlT4F3mUma01fDVnKn/Asmyep7YKqwcanbamWHCwdgvAT0XiCLCV720nIOsVV/ai3qbg170mvSpNFRo5GaAf1XFNqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQbO/hPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQbO/hPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC432C4CEF7;
	Tue, 17 Mar 2026 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766612;
	bh=XYTkfVFBLRCiKPQNIpb5fDKmI67hN2FIJUjr6mTrBnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQbO/hPTI/jZcyZhp9ZWxaoxzN1O2Yv/cKbjHeUSQDTnJ1qzF4/nZXJQKzAWQCFIk
	 dWSUjTtf/eskQaMrYIlvhUabkQKhNZP5L4HbHpt9znS/lzRnsLG8oAER99O04tcXir
	 fcyFc5Kq0FfGyVceRA0qzX8mX8aKRBpf9PXbCjWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filippo Baiamonte <filippo.ba03@bugzilla.kernel.org>,
	Maximilian Pezzullo <maximilianpezzullo@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.19 284/378] ata: libata-core: Disable LPM on ST1000DM010-2EP102
Date: Tue, 17 Mar 2026 17:34:01 +0100
Message-ID: <20260317163017.451626667@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Pezzullo <maximilianpezzullo@gmail.com>

commit b3b1d3ae1d87bc9398fb715c945968bf4c75a09a upstream.

According to a user report, the ST1000DM010-2EP102 has problems with LPM,
causing random system freezes. The drive belongs to the same BarraCuda
family as the ST2000DM008-2FR102 which has the same issue.

Cc: stable@vger.kernel.org
Fixes: 7627a0edef54 ("ata: ahci: Drop low power policy board type")
Reported-by: Filippo Baiamonte <filippo.ba03@bugzilla.kernel.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221163
Signed-off-by: Maximilian Pezzullo <maximilianpezzullo@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4186,6 +4186,7 @@ static const struct ata_dev_quirks_entry
 						ATA_QUIRK_FIRMWARE_WARN },
 
 	/* Seagate disks with LPM issues */
+	{ "ST1000DM010-2EP102",	NULL,		ATA_QUIRK_NOLPM },
 	{ "ST2000DM008-2FR102",	NULL,		ATA_QUIRK_NOLPM },
 
 	/* drives which fail FPDMA_AA activation (some may freeze afterwards)


