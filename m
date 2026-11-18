Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033221;
	b=wlKYt6ZbtPWhm3lyQ+Q9/VoMwBVRCS9iqP1wJMqrgeUFin+4sSWfkpB7SF46Vpw/Xtcs
	 soXh2WHyYFVQl1TOAnexNlOOVpHdsXJx6kQK6WlXhdZm9u6EwPWD5OSbIux4OVgSw4ewm
	 jBGrkKFuCaC0fSYGme05PXUjhIFDL+5K15T3eASobEU/T6jzJWEYCNhs1a/7YrmOV6cTr
	 +nhMdjMo1kojLiOL68dpa5jfpKtdqqV5in5hUusyV45xYGAcIUhk/AEs5aF7E+/6Z7I+W
	 TtsIXlqu7aXgm7EMZbQEmB/km0D6AOjR9u0sHWJiEq+2TyO1qQi220rcZafAWmo8SZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=YYf7b2rvw4u9RtszxpCFwIS3dcPWwDnPI+RPHMaK1Wo=;
	b=nXLUYyoetJ1kRI6U+i8t7XMF5WzCdIP8V+G73jrxFj5WQ8qqXj6DNtKUmMTSpkTmFQQ6
	 WxIzoAr4x1Jioofh/gF6D9lU5hWzC06sHhG7t3HTEiC3aFYUjRZm0OIUfbmbPMgVlxWWc
	 Cmrv757K5ai2C1RKUpMWkFWw9XgZ23mtf3c3/0wodUvAejVIQUcAdIOeyhUMDEoEvB/kj
	 K2xcphrRvHs76+w7qMJ6xcz2nNM/CVYpsglZzbUxFRtWqzgt7OuST7Z+R+ke2c8c3lsM0
	 KvcNj6GOJAVqE8f+cPR4QM3tC6jdmYbfJroy0GA1UPuPzmBa5A1DSvBl+uXFZEH8yDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sD1WdcqG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDC6606A31C;
	Wed, 18 Nov 2026 20:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sD1WdcqG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033981F000C4;
	Wed, 18 Nov 2026 20:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033221;
	bh=YYf7b2rvw4u9RtszxpCFwIS3dcPWwDnPI+RPHMaK1Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sD1WdcqGZd0SUQ/oPVuMc7XroKgPgO5XQrT4MeckLzO+OxiV7xjeuzmLsP5p7hbbN
	 Ytqwalq7W3xQe5axqN+GILksJh2FlpM3+10uehpXjGCxuaoYqbyujgP3kxGHUIkFVY
	 uZ63WIKlR/hAfTNCxH5mmjR9vzX9xnkAi5BPa+VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1689/1756] apparmor: report a label allocation failure as -ENOMEM
Date: Wed, 18 Nov 2026 16:03:36 +0100
Message-ID: <20261118150116.917902513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6508f13e9544f..a5fe6ce689692 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1947,12 +1947,18 @@ struct aa_label *aa_label_strn_parse(struct aa_label *base, const char *str,
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



