Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212498;
	b=ODtYshgCSfRET5gLzjhv2weUqzpZdD5aGtr3xB1Chfm1PV/Cn/gIwa2aWpYSW8PL1Iey
	 d7iQPLU+O15JepTxlKRXRQMtMudIpqyL9pTY/5/1cXIu+jGy+BFlXCSXfEWZfiUpTi3ng
	 sfxgwB9lvm7UvVEzss1G82994MbdZ5WQON4mv9b1FAhw6eyXujjPLC7MylLlfL1QIX8Lg
	 1Ov/Khujceeq1xcjzU5kp3+ycaYgaBn4Z2jMXQlIQpHlNDdXMfdNprmUTVZYozk06rN5q
	 UtMF+gXhrCzvYqZ3zi/w/ApSQ0czE6crzc9Uau9P0NwbpB37vi4s9v3mWqKpJ+6ywbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MZFIWhWdM3MWXfM1bGx213LOLEn4r65kXt18iL+AWiw=;
	b=nnwBd4DkXWoILR+PkAW1EKsiA8bHCo2ftpT9gRXg0czrVPEhgNw4Sy2zWCIwAMKmgbyj
	 yRshngaNBX2ux7SBfA3k1QHSeWSVHcWvaSe3AmADoVi2J8XHyA1jmyA+dxerO/2T+yvkc
	 jPoDKWiEsj2EpJXv4ETELyilH2aaw2Ck/VtwWTHG+gUL4CMJV68NKIcdzV89M/RCxnAJw
	 85WGI28v6kMtUW5gBo+qJWr+8DFPzCsK4r0ZFlT8I0E8tpJBuVXnwwm6xNMNmRxmpbSoH
	 ONGm3oYTiW0GA335VTFDywckg6VOoVDMvQoucPmWNpq2xF9kC3l2Ey8h81dzVcaPPpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j8zZow1B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87989606A31A;
	Wed, 28 Oct 2026 18:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j8zZow1B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95881F01825;
	Wed, 28 Oct 2026 18:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212498;
	bh=MZFIWhWdM3MWXfM1bGx213LOLEn4r65kXt18iL+AWiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8zZow1BBHKqMsNrjLmaL132HhFHWoDxnKJGk5ryYjR2uB4/YQAyn3m30bfM09SWC
	 k6SJlM5iErWsDfgmgc9S4KQi6t1n1AO7GlMexPulz4OsbcB9QL8IOSPTNDZL2aML0V
	 AFiTh1yjOPdwFp8JJDn2Y5Qu89SMcUdH3zQ+VOVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 0175/1887] of/overlay: put property on deadprops only after changeset add succeeds
Date: Wed, 28 Oct 2026 17:37:51 +0100
Message-ID: <20261028170503.220273667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


