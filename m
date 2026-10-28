Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210321;
	b=L4doWYzS9i9SMr9mhW70GRMeAeQG8KzUjLUEB/vVwkwKJrSoFzsWk5dWVUdtPyga4UJF
	 wZmyZBu2PVzLK8Hl3VCyuANejGreJNEGQjlckKeISMbhXCv4myc4m9yT4wFLibLjVhSTi
	 rJy4IertpIPYD91CEPCcspM0oU7qr1TY+pU+eNGWBxNwNglcm3sRQ1XB3ZI9K+Grakmif
	 9c2/Dz2wulwma+lvkrSuT6jBWnlJ59+ZuvkUpfH3kPOZbBRba01A6976uwIS7iBoZ9EI2
	 0PtciCYV/eR3f6yWt1e3YJvprnzD0Md6URgbHsSvaL9Cb+4UzDYSxfIUTJAg6bFRzTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=txek+pJhw6hlJsGRxskcuohc51ltkWQmOJCNeNl2U6c=;
	b=slXNcNRjszeQo+MUDrAww7bO2EnF1rE9GVYpJ9DDuuwfRzsWtJYA0/kZmgfInVnawExi
	 0eIG7MmELsJawZKk7v009rLEVdTyT9p3qYxGru7T8cTOiJ8JovDHygXf4x/wi3/pRDHNf
	 Be1Z473Xr4YhEMy+8KyWVeUKE2q+FzEmRMvaB1hbwAKv2zYP48rexFprbCVdTZHS3nZOt
	 eaqn5P7v2QZnRXpPgY/guQbjBOKgDzzFb82R5H5J5WdlPUULbtjgU3TyAbDVK4oe2l/89
	 7tohIGxquB2f2U230TVdZyuvkenG5ypmB5FGzrbE3JeGQFAC8qRC7i6lKBHlcAEHcCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tIx39F8l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED68B606A325;
	Wed, 28 Oct 2026 17:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tIx39F8l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADD71F031E1;
	Wed, 28 Oct 2026 17:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210320;
	bh=txek+pJhw6hlJsGRxskcuohc51ltkWQmOJCNeNl2U6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIx39F8lWOFy1oVfX757YL6KeWxuac8ewxkndbX8iKJFlnqaCVWpqmZ6d9xFJvaC2
	 WFhStpGxVrrOM5MJI/qpB7ZDtU7RapCZhjDzJGiMMPfWUtZIw3s4ky1nlmpV4wSS4u
	 9Q7d4nKqfc5jnmFhX/kK1M5/3oBrVdAwpnS5qOz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.6 155/168] keys: Protect the type name while describing a key
Date: Wed, 28 Oct 2026 18:01:31 +0100
Message-ID: <20261028165946.753540133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

commit fced7238b7e80cf8aa688d5af976e4aa6e33c329 upstream.

keyctl_describe_key() must keep the key type's name alive until
kasprintf() has consumed it. The retained key reference keeps the key
and its description alive, but does not pin the module providing its
type. The name is passed to kasprintf() without holding key->sem.

kvasprintf() uses the saved name pointer in two formatting passes, with
a GFP_KERNEL allocation between them. With AF_RXRPC=m, a task that
passes View permission before type retirement can overlap a privileged
module unload in this order:

1. KEYCTL_DESCRIBE looks up the key, saves key->type->name in the
   kasprintf() arguments and completes the first formatting pass.
2. While the formatter is delayed before its second pass,
   af_rxrpc_exit() calls unregister_key_type(), which removes the type
   from the registry and waits for key_gc_keytype().
3. The collector takes key->sem for writing, retypes the retained key
   to key_type_dead and completes retirement. Unregistration and module
   exit return, allowing free_module() to release the type and name.
4. The formatter resumes its second pass and reads the saved name from
   released module storage, which can fault in string().

Hold key->sem for reading across kasprintf(). The collector then cannot
retype the key or complete retirement until both formatting passes have
finished. If retirement wins the lock first, formatting uses the core
key_type_dead name instead. Release the semaphore immediately after
kasprintf(), including on allocation failure, before copying to
userspace.

Oops report as below:

    BUG: unable to handle page fault for address: fffffbfff8054794
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    RIP: 0010:string+0x23f/0x470
    Call Trace:
     vsnprintf+0x330/0x1110

Cc: stable@vger.kernel.org
Fixes: aa9d4437893f ("KEYS: Fix the size of the key description passed to/from userspace")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/pm-key-management-objects-candidate-0009-v4-6b537c5732fd957c33fa@gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/keyctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -677,12 +677,14 @@ okay:
 
 	/* calculate how much information we're going to return */
 	ret = -ENOMEM;
+	down_read(&key->sem);
 	infobuf = kasprintf(GFP_KERNEL,
 			    "%s;%d;%d;%08x;",
 			    key->type->name,
 			    from_kuid_munged(current_user_ns(), key->uid),
 			    from_kgid_munged(current_user_ns(), key->gid),
 			    key->perm);
+	up_read(&key->sem);
 	if (!infobuf)
 		goto error2;
 	infolen = strlen(infobuf);


