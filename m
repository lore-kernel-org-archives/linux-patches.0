Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056997;
	b=0F6LtKum69P0lgcGzHgwGFCJk6ZkMlAPLJBrnVcHb3uTlL9Ft8nexyO9K7WbcJBdwxe9
	 HpHxZKlwpuCbv24jmywa6aPS0zK5FyGOc35rZcEEWHHAZtzdkQVRVS6k2w3USMP1BLDyq
	 4sk29aRiRHxRv+X7uZshbBA0WnKsoSFzx/ioZ/yinHUARHqC3ptIFQabnhWk17jojYTwr
	 9ZtxA431BOZaifkhUCPf8SycyQAMU/z4PJRK5uXZrGTgW2ZBvUSaByjcNlEyiVRM2VRRB
	 2WYu9Kjj22q/zyuoXjhp74qWA7O8loeDdVmK1QqCj3BAW5nBkDiKrUlNVHqNh0oiAiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gxlH6RXXgzmL2epuI8bkTPWgW7M0jC5hV2Gzc41GHMs=;
	b=hUB+URzpHConmf+qIq7ELpsn86tzzoqVfzgXH3226JjLVTN3fdtffXPWkGjwtGPyGP7x
	 7Hw5AHafxmRng+CieG9BtbKAadO6Z1rKAbi7CFtq+ePTw/WpMSUFcXOhdj1EnJqddTXgW
	 xPZhc+nhDLPMntyS702REuKmP/K+J3PH87OhuyykCNVPkUTN5xwu3fjDBQa+pxboyo4zg
	 VRr5HA6A71h/i6oTqHmhz34jZX+05nn09QuC8k+oCH/vdIoRxz5muXXTu4HNBogXvWkB4
	 kngy3AscL6KWHrQGcbcw6axEtoPcTAXnawdH0bB/CTqavshkkABSDmaRhjkivudPziQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VU2z78Am;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D7D606A31C;
	Thu, 19 Nov 2026 02:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VU2z78Am
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4291F000C4;
	Thu, 19 Nov 2026 02:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056997;
	bh=gxlH6RXXgzmL2epuI8bkTPWgW7M0jC5hV2Gzc41GHMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VU2z78Am4dieEe5Fmw4YUV1duKt/18aYqEhSfEjHYYMeSI486iee38IYZ0ZUP2VLa
	 pUjORuL8VFnBmxikYvRf6Ku2FwlOAb4TX4v+tuJvxVY5wTQYazNe2IU4/c5y7vk2vI
	 C6RVU5yQ+2nFScOkWZlP1cAffIhq2de1wRjHOJ1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2187/2214] apparmor: report a label allocation failure as -ENOMEM
Date: Wed, 18 Nov 2026 16:04:23 +0100
Message-ID: <20261118150137.828937505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



