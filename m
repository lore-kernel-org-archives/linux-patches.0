Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061866;
	b=s+A6TSJtSbrxaDw8ksGXeEfpoEGFvUXJ/E0WOvZTcTCTWcODugvUztGR1Gl+g5zD4J1K
	 RvC3xNNNsFdSLiSc5RdNsDYxLCjsbTBL/djZmRdkR0MtJN2W9SswvtRj6K3QdoF+ftWQO
	 +5jKyp/91oNal1PY2CKKDoUGq5rf72pQUhyIw4i2ds8VZdiL5zKbGVRin1BV+z7RR4U7g
	 FXDsGc8Vgtr2nBScKPZphqJWA/HtQypLdfcX8idNYVg7jrp2EcFeYy39Mz6ZX40fg44oF
	 63bTgz0pQd25O24V2W+VY0NjJDjoqLbni//zzQMIJ2Ep6LwZvX9GMi2fSofjXuXahFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N7kMXyUAo/NPVBglYcHSwgstgibbK1VoEodrRIU2QrE=;
	b=2vvTVRGl9P5fVmS9FwikrjE8bPk7f3RHhDU88fkH414vEJGLvyz1rrMg83C7jGOeuyNs
	 OVjpm9FDRFfwFRJmR4cDhFwOfiAgO6KS3Xt1I3VnJ46h2r5hpQbd1CrR2ZH8lIUSt1zto
	 O+AqT/6ME3HjizwyoN3APKRjllJBU9rAyljC/ZIy26vG5wAQktEJt34ps48WVJKHAVGwi
	 PVWvppzxUZNQGyRoSZKWXdymOGww/34I7qujBam0eCM/oWoxb5czhDF+uWuSxPZIe421U
	 wGcyWV3K4F6QXiJb4Od1p0uiDq00tlKnD5asw59wKtHYttz8+qwxt3kDIYpd/Py/HwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSsiMXhD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DCC606A320;
	Thu, 19 Nov 2026 04:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSsiMXhD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285AB1F000C4;
	Thu, 19 Nov 2026 04:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061866;
	bh=N7kMXyUAo/NPVBglYcHSwgstgibbK1VoEodrRIU2QrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSsiMXhDnFc5serghQk50r+oh6Z6PSEtQrVQaw57mAZpeqiZvkU2bVYslMlpyQfRe
	 GzoLDdo/hOjnYwgnm9ncqD/sxfrS4ZM4J7auvt+THxhLvPNN2ekqxRqTc2jAGR5AKu
	 tDh7bJfV7/1cIXa3W6/L3aC2Z2l44pgB9cpOi2oA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1706/1848] bpf: Dont take a program with a target program for an iterator
Date: Wed, 18 Nov 2026 16:02:24 +0100
Message-ID: <20261118150031.137246814@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit b83bacf2161d0f8583e3f1e9c90402638992ad82 ]

bpf_iter_prog_supported() goes by the name of the attach function.  Commit
7cc639dc45c5 ("bpf: Don't take an extension for an iterator program")
keeps out extensions, for which that is the name of a function of another
program.  A tracing program with BPF_TRACE_ITER that is loaded with
attach_prog_fd gets there as well: unlike for BPF_TRACE_RAW_TP,
bpf_check_attach_target() does not mind the target program.

If the function is called like that of an iterator target, bpf_iter_bpf_map
for example, its id in the BTF of the program is cached as the id of the
target, even if the load fails later.  Programs of that target which are
loaded already cannot be attached any more.  And the program itself can be
attached as an iterator of that target, with a context that the verifier
has taken from the prototype of that function:

  BUG: KASAN: stack-out-of-bounds in bpf_prog_66d4234e2e50f5b6_ts26_forged+0x12a/0x20b
  Read of size 8 at addr ffffc90000d9fc48 by task ts26/104

Refuse every program that has a target program.  That covers extensions.

Fixes: 15d83c4d7cef ("bpf: Allow loading of a bpf_iter program")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-2-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_iter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 73e9b584275ee..d8e9504bc11f4 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -322,10 +322,10 @@ bool bpf_iter_prog_supported(struct bpf_prog *prog)
 	bool supported = false;
 
 	/*
-	 * The attach function of an extension is a subprogram of the iterator
-	 * program that it extends, whatever its name is.
+	 * The attach function of a program that has a target program is a
+	 * function of that program, whatever its name is.
 	 */
-	if (prog->type == BPF_PROG_TYPE_EXT)
+	if (prog->aux->dst_prog)
 		return -EINVAL;
 
 	if (strncmp(attach_fname, prefix, prefix_len))
-- 
2.53.0



