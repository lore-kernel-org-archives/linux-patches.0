Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208502;
	b=pO0pM57J99tJNLUdTSpFickgUX0lmh01ekbzncPCADR7Y0uLQabRpTPr7H6I4BpHAJWR
	 MNEn43oahwxenmrx9ufnH4ZbcDxTFWkHyffzex/hIsHXwvNOhzpRRojPT23efBSw1Qm/g
	 /mFEo7RIpF7VeodMYyFwA2JBVB6gabCXul5BDoiM/SmeQIjDVY12rCe5RAWVb4S78LDvn
	 bL8luwtvS7UTnm5RDkOtZm7zzpkEc1KgfZYVoE3f0+cIjyW1bfAPyVNE9q44PA6IcC0mB
	 IX1VfcL94L8ojdQ5m+PDeSAvGITjZnEG9uQ7iFrp2koZX34IWIbNHLGSyjJP6bPBx0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PnX1bmFx4CEpWPojikZOQ8MDjJgrgijMzmsrIlP0sm8=;
	b=18lC7swc4g1YG55jRyzfFE7sEE9kDz4Gm57dUJXFJAHx9z7duYjkhoaeayWjPSKGnfNQ
	 kNfcaBm/8NcVhCKQBELKS2ahHJAsI6Q+zu0PDocxr19eCux0q5zTKynyyfSMwbeKw76At
	 0Oz8hNNnViL60YJyziAzeej0lzblfLb9sKc3BdhSASVfQp+b3AbBppfs2m8MZMYJxEJyw
	 y4cnlyRcBUcHIiMF5ShsmGZZiftEJoERtC0dy86g3g6zq0EOREkKpF1fFWh3Lcv/nqzwB
	 cjzCgRfPJKDEQikapPd3eiGmCDS2Vjh5h8Gn8ByTj/kmqzx8kPIuGPBKv0Dsg316i+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BjGZ4Oub;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85605606A31A;
	Wed, 28 Oct 2026 17:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BjGZ4Oub
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D764E1F01828;
	Wed, 28 Oct 2026 17:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208502;
	bh=PnX1bmFx4CEpWPojikZOQ8MDjJgrgijMzmsrIlP0sm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BjGZ4OubORh5oYrJZ69/8Al04GQM/mm242z8uHOGsSHhl1HL5l8NpbJ1XtI+nOCsw
	 EgCb0Pu1PP6LT2sBmp2FKnFXORZdgIcNjzU4vyi9mgpIxm0x0tfLRKhTapIjbWAFO+
	 nWUIhSM6gi5HLrpjdeKU9T+fkB4J5SCi8HP5yZM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.10 140/516] of/overlay: put property on deadprops only after changeset add succeeds
Date: Wed, 28 Oct 2026 17:54:52 +0100
Message-ID: <20261028170006.826364283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
@@ -348,12 +348,13 @@ static int add_changeset_property(struct
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


