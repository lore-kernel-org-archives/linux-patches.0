Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028390;
	b=FCOpI9LhiKcrETAJMSLtnzwpBEdtlGBRC3WbAyWMZePdggA/RZvZdoes5OW2yqTZuMXv
	 3WGuDoiw2zxqHoBUaEtc9RH4c6vCU6MyK0lQ6beLxYjNqj084eU2yBwhrkjvi8MrGhtNw
	 a3hl7qy9+ItGd7QaY4FpS/LI9CZtF+PNd9aW/P1MGJQS1uM7Ga7Wte5G+P7d76AZu0vZw
	 mFP2ufdzxNkw5SeX+a5LSbfSDYFqtvVKw3nvA3H+OR1cFZWCWQDQKTxXAri0H4fL7brUP
	 bDaPNBpZNL+UrQ5GFz6Hmh0pRovefHXTQ4h7heYMG4jG1VqB5y8AT4m4ygWuGjBRH5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mP30uge2S92qSQ2YmtJkQp/RCIIk9FTvkSGcn8NNoio=;
	b=Bn3oMXLmwIpcn73FNRv6KfKMXecPjn0rxL9IM4IcgF+sFexRDRvzv8jAoctl6YiySRz4
	 43Ssd35YObwSHIp1uT3c6wjfK9jr1jkOBiFQ6uvTGq4UVea1XnumGkFhWgNeNbrnmU4PC
	 rlPco7elyBHV2AEX1bK5usw4nleFeU68pMBRlrXTWePOXFXs3cAm6i4GsiYlZswZYGsxd
	 6s9itcGdpgDMJ+RNmWbyu57TZQofvW4KZcHDESOk0/eYa/OOsPa1ofFAqhrgGaWDutok5
	 0CQbcXpWVri6uzsekK/odMMnDoo0Cs18ZIUWSVrAvL983GyC/Uohk2YUrTUc6C9Y8eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4GgenQR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DDC606A320;
	Wed, 18 Nov 2026 18:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4GgenQR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD301F000C4;
	Wed, 18 Nov 2026 18:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028389;
	bh=mP30uge2S92qSQ2YmtJkQp/RCIIk9FTvkSGcn8NNoio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H4GgenQRSqCL7vuEpxc5PpNkZCOB50okX26InvRUhM49o36eP5897YEc8ApmWnjNo
	 0veRmFE1gm6962uv/ZtMkW5Ls4lSOHThT3sdvKqahIMbRqkvFcljSXmyyEoL7zUEOp
	 ddOeIYZht4UXtLwH1DC/xwkzXw9DBHi4A5Zi+sjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2091/2151] apparmor: report a label allocation failure as -ENOMEM
Date: Wed, 18 Nov 2026 16:03:46 +0100
Message-ID: <20261118150237.871851104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d0610e9d7961a..18f71d7f9ba67 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1919,12 +1919,18 @@ struct aa_label *aa_label_strn_parse(struct aa_label *base, const char *str,
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



