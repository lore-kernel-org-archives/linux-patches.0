Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061083;
	b=zp2yjWQ4T2ZMi9frHRvAqoJvlkpwRpoFrE7tQ9M4rJmiZpZ/NAOgcs0f+27Veb0T2daW
	 3HKO/PdnNQ8mg6To8uYe2d83AdzsIfCOUXenLRhnkJk635cuKoJyNKjcrhrsv0UkVjmLC
	 JMyVSDHeir3epUATXOIAjb3SpzfDR3Eh5nzqE4ykEmiWfWCPB6x9EWr6gWIHN+CF9AedK
	 5W8WMbsdM1iMyKAOrYKc6DYkxAaL1sy40sP0/oRwkQZ67tPZaOZ54YptODSG5lHrZhuoa
	 TJatVEVs1mL5Tw6nGRgqmAAJJs1VHFzkuD/mDOQJarbEll69hcasGaGuMo7EiX8xKoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0lIHY37BS0sbGZzBsnzZe70dilqa42HlOy4ILP0TEOM=;
	b=0dyHuoFGpXXSavvxB9M7Oym+0BZBAan4Z8EMXKLcmaQMX3jBjZZNeAqevwecYchXa0oY
	 0MY/ghny11m/bVu2WTyoZJkL8+2mu/GfHwcu8l4ISwiuHMqx6T4JoOeGPw8M6ctLcAl5M
	 kTpbq6Ku2/U8+GK+bfy/mVNF6BhQE/KlT9dgr2kl/Q3edMesnQxKVHscAUJWSWNwFtn0Z
	 DSt1su3bGXvOP4XjXu7cWEfN3ineG7XZOgGQN01kCnXaysDGioZYEPQGegzP+2P4GDgE+
	 T5cEjKOaQ1Be3bYA4009Gtcpk0olkW8w47A/BmOttGqMTwKOkhrwuD/qCdmqmyde3rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZIJZArVT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8615C606D819;
	Sat,  7 Nov 2026 14:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZIJZArVT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A821F008A3;
	Sat,  7 Nov 2026 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061083;
	bh=0lIHY37BS0sbGZzBsnzZe70dilqa42HlOy4ILP0TEOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZIJZArVTlWnRESQUsQwGTgOKKvfSvLVA04iLhAb1RO5J3h/OihKLTjQgSAtwlDXL0
	 ohN1uiOZm1xpospOYozl3tm6NEAawdf2FetCMdyr3hUUdVenU9rNVKdbV9vRrN8esY
	 IQMcudT0pohIq5jOAL06WVb/6ABrrt0QqEsens5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ewan D. Milne" <emilne@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0406/1536] scsi: devinfo: Add BLIST_SKIP_IO_HINTS for EMC Symmetrix
Date: Sat,  7 Nov 2026 08:40:22 -0500
Message-ID: <20261107135008.984249238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3cdc4cd4b1639..a61727ec300ea 100644
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



