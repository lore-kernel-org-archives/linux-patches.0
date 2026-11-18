Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033384;
	b=s6WcsOU58WC49DZw2J2IwZ/gEXpfGe68916fqzRGjrMcXetGqjmDV/Jee2VM4IBrs39m
	 ny/fzp3XYfqlGiE7rDiFiy0FoL/Nja7m00NTiT69FuOjeiTZeg2crbCTge6RxkN2b/sm9
	 +g+yZVrPGBH5pt4tfEDpt8tueFYsWYMlTFMZhFGBxAkZ8DddNl4+cfTReRDZ4KExG7uDT
	 taILUruFGE5d9uB9olKSMorfQ7banlZyypLByRsBK1w4ALUx4kf6BnV5pDHljgroDRGGm
	 ZerLOoE11RqNnCU+q01mrgYXppnjhqsJSgkZ0SjSvIpjo92mwk3lWVnhmrLaTxDfmLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2t/oDkQqmZWzqJt/elw3HWzg14LFgvuH7jxRR18pHfs=;
	b=utxBmLrIQ+ci4ZR/yz81PIYvb/9/AI7xZ3IrfFAMVt2DS7o9CPWs+VnhJpUcaelWNSWo
	 GbQ/gvbs+2HEioSjbiJlZIXGA9EKgOJoI3zDzy0q+NPa8rA6+hBV933vht1KJD89nJi/o
	 7tVEmeD3Ua1Nf8up93wA29xXZgZL3Z1q8+20KtQ2cBXkA7zBVva2K4zbPK2r9QcK9UI+2
	 S37cYNOhJeeIQ6pQo7CT6c6TJ2qhlTnAKZtT0VPWyiY4p1BMa8UszQdqJuy6Uzs3sLHqs
	 cogAP7BrB/mbiv46D2E5ZLR8DW7KTgnMmdgMEQTGFVl/COwKutuXW9uwGJ/dYLSUB3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tqxdGM6/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0118560A2622;
	Wed, 18 Nov 2026 20:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tqxdGM6/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502CF1F000D3;
	Wed, 18 Nov 2026 20:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033383;
	bh=2t/oDkQqmZWzqJt/elw3HWzg14LFgvuH7jxRR18pHfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tqxdGM6/sJrfw+KP9RYKYxn0O9/Qf4hbzHNd8SJCfg4XcJ87y52GH9qyo42xahf52
	 olxPA6BE+6Cgzv1xcK46Q0sFMF40DVKAuN9h0YZJYPCLpNWfQhID0rItpnXVSfaCIW
	 /jM6QnD377gEn/FuvVYZ/MF6HgGLggsZYxKVZW1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.12 1750/1756] apparmor: fail policy unpack on accept2 allocation failure
Date: Wed, 18 Nov 2026 16:04:37 +0100
Message-ID: <20261118150119.200452101@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zygmunt Krynicki <me@zygoon.pl>

commit 45cf568241048e560a81aa2053f06a62069f5640 upstream.

unpack_pdb() may need to allocate a missing ACCEPT2 table for older policy
data. If that allocation failed, it set an error message but jumped to the
success path, returning a policydb with the required table missing.

Return -ENOMEM through the normal failure path when the ACCEPT2 allocation
fails. Remove the now-unused out label.

Fixes: 2e12c5f06017 ("apparmor: add additional flags to extended permission.")
Reviewed-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy_unpack.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -814,7 +814,8 @@ static int unpack_pdb(struct aa_ext *e,
 		pdb->dfa->tables[YYTD_ID_ACCEPT2] = kvzalloc(tsize, GFP_KERNEL);
 		if (!pdb->dfa->tables[YYTD_ID_ACCEPT2]) {
 			*info = "failed to alloc dfa flags table";
-			goto out;
+			error = -ENOMEM;
+			goto fail;
 		}
 		pdb->dfa->tables[YYTD_ID_ACCEPT2]->td_lolen = noents;
 		pdb->dfa->tables[YYTD_ID_ACCEPT2]->td_flags = tdflags;
@@ -838,7 +839,6 @@ static int unpack_pdb(struct aa_ext *e,
 	 * - move free of unneeded trans table here, has to be done
 	 *   after perm mapping.
 	 */
-out:
 	*policy = pdb;
 	return 0;
 


