Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669282D73AD;
	Wed, 25 Feb 2026 06:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002616; cv=none; b=QzeuxXNnxDCAGYuRF+fpU7QX681z4loTu/Dq60mUQARCAQA5Y5aqAPHpDF5iCuzE6XJ7PE3SPQSdemMgs064dA4EXdxmQSBp4ItbmcQvI7DyJjcpnJwyI9OBcRrO5jb4KcFhAFIns4yOLtM/GsZMJfmNJjwpvASUK3wyUPRHn08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002616; c=relaxed/simple;
	bh=vtwQyzVZoeEB5XWf56eaciW76e3pBGVvOwWlll0wTko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B/6nnWRHD0je78txpMHA2Mnay340FkYrG7iU0wT3wDGgKl/D6FaXnl4N8aUCrmCU98FmQAnG8Q5jiYEetayCmL00TNdmLr29DPDwoWrrpwM03EaRJDzeS5uw8IFauZ43gGVaJGGzftkb5kXlSGIaf5Q8e306kryEzUSTluuTxmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Bk3M1oj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Bk3M1oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEB4C116D0;
	Wed, 25 Feb 2026 06:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002616;
	bh=vtwQyzVZoeEB5XWf56eaciW76e3pBGVvOwWlll0wTko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Bk3M1oj6KtxWEEZ4PXecaOuXgtt1Zm71zZHISmhDGxBlgFkvWj0/TlEaPlVbpR+X
	 cCZMXF1jyhPdy7VwJTAb71FdsTHVbzeDmxHlQLS7pi16WD19RqtGfrm/Z0Og2wguf4
	 se+og+Wiv3CyPXVve6x9aOUcDeGovV+IbBSMmC+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yijun Shen <Yijun.Shen@Dell.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 368/641] crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
Date: Tue, 24 Feb 2026 17:21:34 -0800
Message-ID: <20260225012357.524109579@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 5e599d7871bf852e94e8aa08b99724635f2cbf96 ]

tee_init_ring() only declares PSP dead if the command times out.
If there is any other failure it is still considered fatal though.
Set psp_dead for other failures as well.

Fixes: 949a0c8dd3c2 ("crypto: ccp - Move direct access to some PSP registers out of TEE")
Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://patch.msgid.link/20260116041132.153674-3-superm1@kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/tee-dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 5e1d80724678d..af881daa5855b 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -125,6 +125,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
 		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
 			FIELD_GET(PSP_CMDRESP_STS, reg));
 		tee_free_ring(tee);
+		psp_dead = true;
 		ret = -EIO;
 	}
 
-- 
2.51.0



