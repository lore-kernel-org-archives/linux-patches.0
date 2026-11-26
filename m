Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704178;
	b=BkVn28dzQHW67Tl3osqBTNRkXw44bbGzOYKijivf5nLao6I9XN/7+itEmX8Ym/Ha7t+P
	 fPyBL8LbJ6XKg/Zv7mhMGkq+O/v7Tf+GrdJt60t+/rpd9O6pR9xX8Bl2FhJVOm81Lbwir
	 gMGxXKDsZ12z2G+QhLPbwqminI7Mu0U1w9v6+8YoDe3Dd+mkt8vrQW1S4uxbAqj8yrGAv
	 TDhRLyApR+xkGLEUMizcoMG1WAmm4z2kzhB9+KDE7LfMx6ypr6YQv1acEqSFH84FfaXgq
	 UNTpu1oC8JnaBijHtOnaLxhSXc01rXw/I5cTNwLehR+brCA+3q8Os5khmZxzdsXRsiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=smmSS3a5jQyUfvMvFZsUrdfUGHB4gJJda9opn4avG7A=;
	b=j7b3zmUN9DUkbZo9yLX/8Sspeos5xoIt4Qlli4tW/DyuAov/TH+CIE+i2HxKgloO2Wn9
	 IFfhZ+uryGkKdYh3ujEauPIxDrX9tn8wO1tpD4Mrhh8yskgrQAaoo+UykNag1lPPt1eg2
	 mpsjzupbEbuXU1YvFgLDhzJ5TG/wuIBGE/NwOQ0wt5pnnTsfXGq+qdhNUMuHxJp6q16UC
	 HQNzOaBvsdZqkc8VDwui/bwd+LywiAdWUCYw57J6faQDWLIB7fqDxRel2bhXfbaTxc3gR
	 neZH2x+VbpUgZWvRnlXR89PdTQrNitzPCwkixd3vJofK06qOnpZmJIserAs6KW/ZpHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jvoEKnu7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450A5606A321;
	Thu, 26 Nov 2026 14:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jvoEKnu7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6D61F000D2;
	Thu, 26 Nov 2026 14:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704178;
	bh=smmSS3a5jQyUfvMvFZsUrdfUGHB4gJJda9opn4avG7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvoEKnu7nUQygI3yjY9AnFgYcrMaZeaIMzzQSu20XYMzLUj24B5lObldl2u3CVsti
	 u6yaYUnkYtgEKaFK71lm+FrtEG0AZuuR0ENTHN+dA719s/C24KyKcScKSS5RJKffiz
	 Fy0mFSawjhcUqIPqDzWRO3c+Jg5543h4h41xkSdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/265] scsi: target: Validate REGISTER AND MOVE TransportID length
Date: Thu, 26 Nov 2026 15:36:02 +0100
Message-ID: <20261126143607.347381840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit 5d5913710c81eed6fa275b6a24773059d9dbfdfa ]

REGISTER AND MOVE has a 24-byte parameter-list header followed by a
TransportID.  A 24-byte parameter list with a zero TransportID length
passes the existing tid_len + 24 check, then the handler reads buf[24] for
the TransportID protocol identifier, one byte past the received parameter
list.

A TransportID is at least 24 bytes.  Reject shorter TransportIDs and
compare the declared length with the bytes following the header before
reading buf[24].

A malformed PR OUT sent through vhost-scsi triggered this read on a KASAN
kernel.  The command is now rejected with INVALID PARAMETER LIST before
buf[24] is accessed.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Link: https://patch.msgid.link/20261021094334.198599-1-physicalmtea@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_pr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index cf8d536fa3e71..ce492125aec39 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3216,10 +3216,11 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	transport_kunmap_data_sg(cmd);
 	buf = NULL;
 
-	if ((tid_len + 24) != cmd->data_length) {
-		pr_err("SPC-3 PR: Illegal tid_len: %u + 24 byte header"
-			" does not equal CDB data_length: %u\n", tid_len,
-			cmd->data_length);
+	/* TransportID is at least 24 bytes. buf[24] is its first byte. */
+	if (tid_len < 24 ||
+	    tid_len != cmd->data_length - 24) {
+		pr_err("SPC-3 PR: Illegal tid_len: %u for data_length: %u\n",
+		       tid_len, cmd->data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
-- 
2.53.0



