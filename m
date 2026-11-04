Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831059;
	b=E+7wDbFx/QAWsg7gOaHWLc3aT01+Wb8YJhuhNqRx5BPVV5nGB/Ta98+T6nJ1HhSaatG4
	 rSq+vWwvvFvY19YtRtwD5WaXFUZsGwtwj/uzHlmAaURkyxpoM/IOYKYuVT5KUJQOtEKbD
	 4JnioLP3GcHxZrYlXG2pRvDqlLSxpUH32ccx00RLFkRJgv3ZCHVmxGmpJe6FwUwOLDYYV
	 BNieq1VHtVoat5Hog7OUAjcWtse59huNryZHC4LpVsnN8SvNzebQ/lcwb33xEftpMcj6d
	 PMn9RTZLz8KTLwsHja/AfZlgqmwismRtjKb7o2UJ3Ftpg97TVWKWdNJe2HFSA3hVTXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QXbVUA3x8HcPACnqfeeCQNs/DUbD0IupZ0X7cQKgFWs=;
	b=TqeyDbPBk6ottVe2rXyl/cxuuEboqosYDJPIisqxkOjEcrXEtI6mR00rUqquNknpt9R1
	 9OmW6tWy6pX6XT+6iZjW53gC+Sut7U2OEoZxu36Y6BVbSqzGwEptQTuQr0SUyFgsJENkx
	 8YRaAnAWxUzQWasaXW1+aaAyJ4hMPmfr/G8Koqy8t7xH2J+X92lqdJdbH2GPsnMerHEt6
	 LCbBUIegEaZdcOYMlhayBsF1ebZgjqZt9VyVrMoCMgqqshpVEpwYUA6qy+/ri6L9jetPo
	 eorAQC+bfSPqZUso3ocONYmMW7HC83ulA269ufLECPC2BsPSE2aZvNXPKqHUc73xlAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SjypbBni;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396D1606A843;
	Wed,  4 Nov 2026 22:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SjypbBni
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A581F0093A;
	Wed,  4 Nov 2026 22:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831059;
	bh=QXbVUA3x8HcPACnqfeeCQNs/DUbD0IupZ0X7cQKgFWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjypbBnivV1pQWav9kdT3zAyS0RScQgyGVPYfCGe/QN/LsLyjVAbTVvib1OiRoUj9
	 0zHPrTORlLgdzWAxQTN2Lz0h97/AAByx7iJ5jJ9acRbMlN0BvWf5BJRLotHQ+4eGWV
	 vUI6tTMeeZCAIiu1vnPZwXiTXmpBQxGo/saWLbj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ewan D. Milne" <emilne@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0481/1005] scsi: devinfo: Add BLIST_SKIP_IO_HINTS for EMC Symmetrix
Date: Wed,  4 Nov 2026 16:03:34 -0500
Message-ID: <20261104211057.464096945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ewan D. Milne <emilne@redhat.com>

[ Upstream commit f06a44e235ef188689ba23ffc72e9e89b10951a9 ]

EMC Symmetrix returns an error on MODE SENSE for page 0Ah subpage 05h
because it does not implement the SBC-5 I/O hints.  These commands began to
be sent as a result of commit 4f53138fffc2 ("scsi: sd: Translate data
lifetime information").  Add BLIST_SKIP_IO_HINTS to avoid sending these
commands because in large configurations the failed commands are displacing
other useful information in internal error logs.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Link: https://patch.msgid.link/20260915173800.39117-1-emilne@redhat.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_devinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index c51146882a1fa..a438e510f2cae 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -161,7 +161,7 @@ static struct {
 	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* EMC CLARiiON, no storage on LUN 0 */
 	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN |
-	 BLIST_REPORTLUN2 | BLIST_RETRY_ITF},
+	 BLIST_REPORTLUN2 | BLIST_RETRY_ITF | BLIST_SKIP_IO_HINTS},
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
 	{"easyRAID", "16P", NULL, BLIST_NOREPORTLUN},
 	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},
-- 
2.53.0



