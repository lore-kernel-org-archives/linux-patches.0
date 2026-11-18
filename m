Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018405;
	b=1VYtZct7Ag2KyforL/UhWq4tlolrFgDNWw9A1HRW+09dGbmvUka4NBE0dXX6lpgt25Am
	 RHYI8oECaCxgSgJ2n7vQVwuBYpd+7Jq2mLokVo5wmCD452fs1ax0eviTX8MR1C18jZVQR
	 MQrfKQZilLBiZKkNq8i5juUEAkEo9AXWXfdI2jwpMaLUdR/TJwOyTVZ//LyHS/xCEJbhi
	 KKPDsML6+ukVY/Sd1eA01P+4VUYn/ry8lzEubP1MUufE0fmC6Jbd76KU8nztBBqM0cYgi
	 jtX3TfHAarHtIFaFFeHg3TsAhqbHjhYXb6kANmwlR+R7WnTk+ND8h8Lhxh2nQHdLsSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iuN1LvxlXNZNDd/QVQHprAiScKiLf8Q4Ieq9K4Wrkvw=;
	b=5fsP/TGGbcA0vWxVi+azwQYBTznDHHoUyzn9RAgrMzOguV0Mw4PfLRFC8dUGEgSH71mm
	 B80iV6QOHtQ8iMOneoYlWpa7tM7NODtfBIL8wl1gos8PX24HfVNyRN9YinQH3P5ECKQUB
	 oA3zHEXTKLhq9Dhd2jXUUBOytJrtlbCizMz52H7vJK6RHFCEaVPsTkmwT6DnpN2bwMNeG
	 tLNafayrmdhtVvqTMCMds2z68fJXfofN5TTc/16GeEEEEBRGEvdOTO7X58392pPVpm9ps
	 XMZNx78hr+mU0DcYb8nAKnmDyA6abAV8YwOR9d0kBUlEtIwW/qrRndheGfwN1krheMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J4Y1d404;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E500D606A31C;
	Wed, 18 Nov 2026 16:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J4Y1d404
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62BA1F000CA;
	Wed, 18 Nov 2026 16:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018404;
	bh=iuN1LvxlXNZNDd/QVQHprAiScKiLf8Q4Ieq9K4Wrkvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J4Y1d404Loi5EssNDTDFnBuAjuAqzR1j9XFWxRlcIox8pXFtp/KgexH2JhJD8sULu
	 7FFOrBpDXJ/T+UkMPGhOuE+zOaZXWWw6aXSE5xEZOrEfzR01mHXiF811zBnzuFjZK+
	 bRDZs70k6O1YrHA89PFDmkk5FBwoAsijdfqINnBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1229/2651] scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)
Date: Wed, 18 Nov 2026 15:41:09 +0100
Message-ID: <20261118150332.257958858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit a6c339feb830daa097ccc4c50c339c1733c12d42 ]

resp_atomic_write() validates the fields that are specific to an atomic
write, but never the range that the command addresses. Every other command
that writes user data calls check_device_access_params() first, which
rejects a transfer that ends beyond the capacity of the device, one whose
length exceeds the size of the store, and any write to a write protected
device.

Call check_device_access_params(). The zone checks that it ends with are
unreachable, as atomic writes and ZBC emulation are mutually exclusive.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-28-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5a89742997116..384f70afe3fc8 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6056,6 +6056,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	ret = check_device_access_params(scp, lba, len, true);
+	if (ret)
+		return ret;
+
 	/*
 	 * Short atomic writes are not allowed: SBC-6 4.28.2 requires an
 	 * atomic write that cannot complete to leave its LBAs unaltered, and
-- 
2.53.0



