Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210752;
	b=FZdAqNBmkHvbiyUZClumApZqazEg8imAfAM/4OnY1miMBZ1dyPaORcfZdCxQW0Lm36xU
	 JCiMB7OEgLzKoiLcbP9DCPUVCPdu6E3ZQy66Ztj5q37T5NdTGiAu4XHC3/sd6FMVQenhD
	 dKZ54pE4MQUOYVY/AudL1ic0H+TIKZk6RokwGzJ8ib7NoIFVpyn2z7Qt+dB40Qt+j/LvW
	 48PQvr8xqsxDC2w0Jnbo1qojT7Uer/PbLYZhYFkTPq3ppNcfPLDYrH5xF5OYHD4h15HXi
	 cHCRH/Dhzmufw5gF4EbKHiKmS2ruhboArMUb4oPJj82yJXnX9q+og3BN81RGQfU30Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T/sESlfw3PBunLSeZ9XbC4m6VUMF0/UwBAsZYipRCpM=;
	b=QSF38pa1idOILADazPRUU/Nh5SBDBFNu954K3J0yB/GEEMxRhxDmA781JTSXdGnOhWji
	 W8vIWcLcefY7yyJsTC9yZ86YPatvK1rukiwWAbYveSyLd8llzQ6idvxi7p5H7CW/apyLz
	 DWInZl+t5KYNoD5q1lQ3FmD6VzUAbAHXzG8YjwgZNyD7P8TTLN05tcF6RdQmxPQS//qoJ
	 yP2Qz/iphMCu9EA2iEglLuUE7ECn20cvheklg6Pu3R7SY95zC+bNNCon44a61YO25Upqy
	 xypTeQloJHWqB9FEk5YCqTL5ITNhnZZaErnsZnlu11f1c7Qf/YdPiTObAKV2gV408fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Epkyty3z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2E8606A31A;
	Wed, 28 Oct 2026 18:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Epkyty3z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EA31F01825;
	Wed, 28 Oct 2026 18:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210751;
	bh=T/sESlfw3PBunLSeZ9XbC4m6VUMF0/UwBAsZYipRCpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Epkyty3zJJGb/my22b4AhmlSOtLde2L28/5rhV4zqzvhrHhXPxFFB7T/IrOvKkheA
	 svz9uSjJ7K3F8yZwJvOtuU0BN0KJhdlWRZ9S5at+vaaRd0E0oiWXomihCUNmYDk2h2
	 H8ALiK70wG4V4IbNwIsuzn77mun9PIE51g9wUfSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.15 137/571] of/overlay: put property on deadprops only after changeset add succeeds
Date: Wed, 28 Oct 2026 17:54:44 +0100
Message-ID: <20261028170011.268446223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit 814f2da6995772c07a7c9c2cc6028b6e3f3ecc9c upstream.

add_changeset_property() links a new property of a not-yet-live
target node into the node's deadprops list before handing it to
of_changeset_add_property(). If that fails, the error path frees the
property but leaves the freed pointer linked in deadprops, and
of_node_release() frees it a second time when the aborted overlay's
node is released.

Record the changeset entry first and link the property into deadprops
only on success. of_changeset_add_property() never looks at the
node's property lists, so the order of the two steps is otherwise
immaterial, and the error path frees a property that nothing
references.

Fixes: f96278810150 ("of: overlay: set node fields from properties when add new overlay node")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5 [Claude Code]
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://patch.msgid.link/20260831-nh-of-alias-overlay-v7-4-02754604805a@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/overlay.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -346,12 +346,13 @@ static int add_changeset_property(struct
 		return -ENOMEM;
 
 	if (!prop) {
-		if (!target->in_livetree) {
+		ret = of_changeset_add_property(&ovcs->cset, target->np,
+						new_prop);
+		/* the detached node owns the property until the apply */
+		if (!ret && !target->in_livetree) {
 			new_prop->next = target->np->deadprops;
 			target->np->deadprops = new_prop;
 		}
-		ret = of_changeset_add_property(&ovcs->cset, target->np,
-						new_prop);
 	} else {
 		ret = of_changeset_update_property(&ovcs->cset, target->np,
 						   new_prop);


