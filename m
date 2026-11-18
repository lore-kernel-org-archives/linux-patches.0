Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062180;
	b=jMhm4VoZNX12RMQUOVplXSYXdBaVYk6RMmwLN4j6iJuWyraI78IKuHz3aAqhl6iM5o47
	 f+Rwp+4Uba29JcSkQjcQRdpkG1LPHa0uRr2P071f9jRG+Dv+Oiz3gWcsaWW2ys+oFggJQ
	 jjXFO+Xdu3oaK4rYeuAQCXLx4WvxUVbVunaGmgGnv/40ho0SgLzWUDAjs+GaWappF24KG
	 Lk7Lr2NzrDsJSxH8hXPUIbaU5v4IuvgMGcwc5lfGC2dGJs2Xmbt3CKohJCSM3R8dMuJh1
	 fmbzmVYW/ZJmtvqXr1HurpUdVG9iRuOF9BftDkdL9hPdFDlKwpUelKBbChjnIVXb+9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=W+LNF2GRNDfeHzykbYodA9LN4byn5nrtBb2un86WA6w=;
	b=lBPIRIalid4lprIqq9YyNm8RIsUs3vCsSFhG3HPoy6EdnPDyVHve+34ITvBDBlo2/zXG
	 ifTErJL3tLP/ocOlNXdNNxdWk4UrZg1gLFX/ltgEZZ549a8J+NYjabJLzdaeBRfyvRdKj
	 3KO05rPT8G0PmvC3aiQxoSFTSX9zw+SaFLsL7JkzqSw7IpUgdYG5Qf7aLY616xiPAMv8N
	 gKuZM1HtHdbp/EjyDN/GDG8AX1Ulp9URTUmS8DlELPOeGHyci0j4seahp3zmBfUaFjUS+
	 Usq/1eINMMQAXsalXj9y8G2xPpAloCs5BAK/+lXwgxRhsiHJDOQ74KTrD2yAR45hI6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=znz78h++;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010B3606A32F;
	Thu, 19 Nov 2026 04:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=znz78h++
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595681F000CC;
	Thu, 19 Nov 2026 04:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062179;
	bh=W+LNF2GRNDfeHzykbYodA9LN4byn5nrtBb2un86WA6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=znz78h++i17UygMf9d7bDqH/gIAJmlCCDD78erelNAJc3Nbqnc02yD6TfSUaDyB12
	 fJ5fE/Sjybg0iQdYFZIjv7quT68sL1QAc7hDhOOVYeTMPBACJ9kSXDBjoPKk/wibeL
	 mu4cJX2RyIZMRFtLpONJCZHMO4JmPmKyjfwX3jgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1816/1848] apparmor: report a label allocation failure as -ENOMEM
Date: Wed, 18 Nov 2026 16:04:14 +0100
Message-ID: <20261118150035.528695934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f14802e2c2264..9cee684ff9443 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1950,12 +1950,18 @@ struct aa_label *aa_label_strn_parse(struct aa_label *base, const char *str,
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



