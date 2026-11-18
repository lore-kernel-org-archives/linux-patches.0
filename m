Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050728;
	b=bl64Mrj5Tf6npnaJJMzfKomKoxBh/ZaEcTnYGWLqqYZt4wm2FNR9k6FS7KonzKmsfDv3
	 kh1jj+7FsM/irS8rYGNYbZ16foopAqMf1ZsWQDylULMKh5B38Q6RY86RIH2ghyIKy73vs
	 4+mBTkpKQOjFTJcjSDKWRC2WaUHI5RhAB9dYvv7+mpmp/2sRzcfaMNUbR+LycCvfkpNMN
	 LiLVcjLUxMI2yTp3ziNpUeI9UBQrPijCK2LQKP6uoQ11oPCQWYn5ISRPeol/94UuPO9Qc
	 99ui+KuI4+15FPLAD/rtP2KC9lqRwMioAjh+Y7jLacOryqlXLKSqs+NxYI/qbxfrO0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BT8aUUSi1AchMYmsxSqCs0PilKwHSIkN6DpjPyoUJ+U=;
	b=pihLhdZZNHPJDFQm5oR2eObkdox5p6X6RNQGnexP9A6OBGmDFXFEsW2SxCoYQQsAmdc+
	 QUiSDqgzI5ZSuONPmrS2xHmYUmma2oCgsRWzwl9as6fYUGOwSrLk37xd7dXTeIM1nam4j
	 dJ7lweVK9f6D0HJNNWhIK6Z9TDBokCmMqZ369+VHwPg5O9m8vdS4+2F4QIIrjnUXTYVTm
	 Ct8VXCDB1jbGqKSlqDefmd7pAu9JkrYOfqu/CjMjSVwovbn+46N5VYydZV1VP0L6wY2IR
	 18q68s9W5/AvrTMupj4ngtP90zVM7LzB8umEHYWqHE7BjOCzrMWy5fVoJ2J8e8f1C0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNaL1Xah;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BB1606A320;
	Thu, 19 Nov 2026 01:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNaL1Xah
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798801F000C4;
	Thu, 19 Nov 2026 01:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050728;
	bh=BT8aUUSi1AchMYmsxSqCs0PilKwHSIkN6DpjPyoUJ+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNaL1XahY87aPjS5SPwrmjE5TzEHhnAew53NwGsSDgtse+C/wEtjJfkvFf8PVDV6B
	 0d/wKQIASAbrwFsJmkjieZXXDJdGYK2VpfwPgsSn+jDDuJUnDws3iXtZTs7fK9TcgG
	 wcPD6SJm8Oc1RpaQsOypJk/LETcNw4a1Z+14qrgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2812/2857] apparmor: report a label allocation failure as -ENOMEM
Date: Wed, 18 Nov 2026 16:04:06 +0100
Message-ID: <20261118150342.851971732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit 07aee062c6ecaa7199be583c83a1c74ae9885f03 ]

aa_label_strn_parse() returns -ENOENT for every failure, so a caller
cannot tell "no such profile" from "could not allocate a label".

Report an allocation failure as -ENOMEM.

Fixes: f1bd904175e8 ("apparmor: add the base fns() for domain labels")
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 74b4fd651c423..fda1f5b57ee95 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1951,12 +1951,18 @@ struct aa_label *aa_label_strn_parse(struct aa_label *base, const char *str,
 		goto out;
 	}
 
-	if (create)
+	if (create) {
 		label = aa_vec_find_or_create_label(vec, len, gfp);
-	else
+		if (!label) {
+			/* not absence: creating only fails on allocation */
+			label = ERR_PTR(-ENOMEM);
+			goto out;
+		}
+	} else {
 		label = vec_find(vec, len);
-	if (!label)
-		goto fail;
+		if (!label)
+			goto fail;
+	}
 
 out:
 	/* use adjusted len from after vec_unique, not original */
-- 
2.53.0



