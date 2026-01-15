Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B263D2FEA;
	Thu, 15 Jan 2026 17:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498030; cv=none; b=HBnNkm3bk1GB6Epq2JemHgKYEBiBz7+W4O5kvGpV4i102G2b6n3189SfIPTfSP4yPgEppUQZ//80VpSmpv4RdKzGV/ibZPcSmzCAw0izWu0mwuNjaNDZQEgGcudh2/SJq4EHi5Dg6b9LZwdS/42wxUqagGrAZ4NwdQbx5+DBaNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498030; c=relaxed/simple;
	bh=r0JEcXKhNFaK2rgp0jVDMdoFX/tbVuGloowilkVCezs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCaKXjvfOBiP3KiV9MQew6BTjHuOXx90kdfpB7TECmSbWIvFJGfjjWYgV+VoS5Kxws1NngGS9xMV8rtAJkwzg2ygobRCej92lfytCecZlXRgOmli0rcLv+5xwmtffnm1SbCI6USqq6x1f0HbZomPOz2jswbdnP3dp0EmS8zzvts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=on9T+TvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="on9T+TvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA9AC2BCB0;
	Thu, 15 Jan 2026 17:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498029;
	bh=r0JEcXKhNFaK2rgp0jVDMdoFX/tbVuGloowilkVCezs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=on9T+TvO0QbnE1LGqAz5Xk8hqaakWzPlxc/IGsa8HD5U1Kbn9GS9cloh8RigwrT/m
	 EqudAHWery2MyDf8JPVeqq7BW89OqQcqFn9yHflzXGpTvYOsaopmIHUpiDtvqP8lBd
	 zLI+f+U2Rpn4cagBY2lP/+sTMj48rvPrDTbtptlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>
Subject: [PATCH 5.15 289/554] usb: usb-storage: Maintain minimal modifications to the bcdDevice range.
Date: Thu, 15 Jan 2026 17:45:55 +0100
Message-ID: <20260115164256.688397425@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Changcheng <chenchangcheng@kylinos.cn>

commit 0831269b5f71594882accfceb02638124f88955d upstream.

We cannot determine which models require the NO_ATA_1X and
IGNORE_RESIDUE quirks aside from the EL-R12 optical drive device.

Fixes: 955a48a5353f ("usb: usb-storage: No additional quirks need to be added to the EL-R12 optical drive.")
Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Link: https://patch.msgid.link/20251218012318.15978-1-chenchangcheng@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -98,7 +98,7 @@ UNUSUAL_DEV(0x125f, 0xa94a, 0x0160, 0x01
 		US_FL_NO_ATA_1X),
 
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
-UNUSUAL_DEV(0x13fd, 0x3940, 0x0309, 0x0309,
+UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x0309,
 		"Initio Corporation",
 		"INIC-3069",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,


