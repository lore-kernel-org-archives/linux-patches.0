Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211999;
	b=seOqMqjmLKZO4Rma3/oqTBZK6szFOwGzxjVJFUMRN12vcR3FBpQ7Dn5jPrMdcxJaXkhe
	 X3FvPTw+F0YO78ys1VD5bHfr5ECZFSfm4n4FL1zsjx1y+JHbLKbXVCqS88Q5r3cUGBwu1
	 8bhPd0ABuzvaaCwWjfhRwQhJI8/CjgcaECbsgD7wRCppTaFbgYG249viefpepYiv/vzSJ
	 ECLL+XZ76wrJ/FPeqKAcfCJnHU4uWx7z5pxAntyUg7ndnIAk9uUQin/EXGb1+HiF6J0ZH
	 7OqvbotrCQ6qbdLj2RtENLHTLqb7PiW7a3gbBMkWjg4j21vUW8UHiGmv8UVWUl/weZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k1k/v55b08OBA/o1efb0hphE1TBqIKrHdLqHtVfy9Ws=;
	b=kMoQvjv/WzWkmqNIAGo53HQiGuaAeAoKz9T1eyrhJDISJaCCxGqGXUrWacHgdXY8G1Qf
	 rikkjnEDnb8TN+ggL0RG1EAeUM8+DNGyIKoEBe7HUckhYvCX0oMy/fieM+2w2Ews4b6qZ
	 RhJUDsgJ/jPKBVesuST71Zbz5GdsfNhlvl7AsdMbWSqdioUisLnw1wfE2kNMFuUcCXUKs
	 e+pf6yfxxLKj52r7DwdUIfCx36bdUJXyH8EKQ2vosFUJcNULRewiW7VotOehXjT4n9Q6M
	 tymxnCKqyddv84AHoXqWjRnC3+av5jB9V1DSTLqx7UvG8J0WYNDpfo8mDug0VvoqqAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXftq1KE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CCC606A31A;
	Wed, 28 Oct 2026 18:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXftq1KE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7631F01825;
	Wed, 28 Oct 2026 18:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211998;
	bh=k1k/v55b08OBA/o1efb0hphE1TBqIKrHdLqHtVfy9Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXftq1KEAevFneDObXuK+IdQzjIlOglzMn8VH4c2kfNcJvzkoZ+Rnv29+q4huC9WQ
	 OyyDtXALaAbtkCg88/FRh7QycF3M0VJEF2w/VBTCmBTPVwxejk0dLq2GZOBXPv/FJ/
	 jnFvbfLB7sqQcMJywN/IQuOd7buBTM9qHpYSWiiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 564/571] keys: Protect the type name while describing a key
Date: Wed, 28 Oct 2026 18:01:51 +0100
Message-ID: <20261028170021.417158132@linuxfoundation.org>
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


