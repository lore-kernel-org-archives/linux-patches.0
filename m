Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061533;
	b=aNZ5BSepXf9QZeey/m+PxigC8wrZeq5H48Orq5LlAc4AAfxDSAs0wYEl7cvJdUoxlFGr
	 VpxKcNveb1Ml3hKwSp8aQ2rBWxj+RWeOw2aMFeFWN/T2Aed4vDMbyqVHpxLP1B8qbIxJp
	 NacgvoitqhY6tqqgizO68c0FIIVglup/7gP1rGDExbZfs+ViLjPTeWOAvLrU/PJTLn8NZ
	 96wvjbjzfwMpQFb8I6zXojz5dM0ledLhMQiv6RwMT82OXw+NPPicnIdYCMA8qTyce8zSZ
	 Eeck3XnjTuvklq4lWpK6dA6EZwkeIa1+RoJSwrg+iQLuAUXQvFjs1ux0DbIKYShca3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hg728cHDGX2ihcSvhA9Ao45luCSlta5UChq8lUvmf7g=;
	b=uEr6C+sh/oAH4fNgYsRgno98nOHn9JXPU6jG0CzkcQmQ08hZ9/yq/k16XileCw7SU7PG
	 GlL9MzdOJQkCUimorHVUaF+4UBJlwtggaiE3MUbB+lldugbcefTylDSO3bF2lJBht7Dp6
	 J4iM3R+OQVGTVMuQ1QzqfGhTq3EoTLwoS7P/+gz0iOdqRt5HycYk2wXSc8HnI4K4WhEKT
	 4sZXPL/eKpfsAEVqlQbG78tfgd4slyxROWk0CUiqTQ8oe66DSq7uJVWjCHcRLRx6l+Hly
	 FdGzmlaehBDvD3E7dcQrQg2xQEDFCvkCQRAbFfPiYtLMI/Ed4BTonSatuWJLAbMKNKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gmu3Ptkc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D73F606A32E;
	Sat,  7 Nov 2026 14:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gmu3Ptkc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2E41F0089F;
	Sat,  7 Nov 2026 14:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061533;
	bh=Hg728cHDGX2ihcSvhA9Ao45luCSlta5UChq8lUvmf7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gmu3PtkcxUchUpe35YAvospPMSzyqfOZnkueyzCmpwdet2pS09rmY++DJuG6X7fMc
	 Y9JHo+HAwIFdUAbrhzbfnjANKoeJ690dxsS+G7/0sv2Qt5MSgdQ/v4spp3UjXxx4ls
	 bV+HUhIoB0HVrhpfD3bR5yaNMdKorRdRRE4+vCFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 0582/1536] ksmbd: accept share config responses from ksmbd-tools before 3.5.3
Date: Sat,  7 Nov 2026 08:43:18 -0500
Message-ID: <20261107135013.896034490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>

commit 4f1ce9ffb996a524acf864316479a7806ae500c6 upstream.

ksmbd-tools releases before 3.5.2 do not have the payload_sz field in
struct ksmbd_share_config_response; the field occupies the last word of
their reserved[] area, so the kernel always sees payload_sz == 0 from
them.  ipc_validate_msg() and share_config_request() used to treat
payload_sz == 0 as "legacy userspace" and skip the payload size checks.

That case was removed by
commit f25e93768fcc ("ksmbd: prevent out-of-bounds reads in share config
responses").
With payload_sz == 0:

 - the IPC$ (pipe) response fails the final message size comparison:
   these tools always send a one-byte payload, so msg_sz is
   sizeof(*resp) + 1, but the expected size is now computed as
   sizeof(*resp) + 0;
 - every other share fails "payload_sz <= veto_list_sz".

In addition, ksmbd-tools before 3.5.3 copy a global "veto files" setting
into the IPC$ response, so with such a configuration IPC$ also fails the
now unconditional "veto_list_sz > payload_sz" check, even though pipe
shares never use a veto list.

ksmbd_ipc_share_config_request() then returns NULL and every tree
connect fails with STATUS_BAD_NETWORK_NAME, so ksmbd cannot serve any
share when used with these ksmbd-tools releases, for example the 3.5.1
package shipped by Ubuntu 24.04.  Login still works, which makes the
failure look like a configuration problem:

  CIFS: VFS: BAD_NETWORK_NAME: \\127.0.0.1\IPC$
  CIFS: VFS: \\127.0.0.1 failed to connect to IPC (rc=-2)

When payload_sz is zero, derive it from the size of the message actually
received and store it back in the response, so that the checks in
ipc_validate_msg() and the path and veto list parsing in
share_config_request() all use the same bound.  The response is the
kernel's own copy made by handle_response(), and msg_sz has already been
checked to be at least sizeof(*resp), so this cannot underflow.  All
checks added by that commit then apply unchanged, bounded by the bytes
that really arrived, and newer ksmbd-tools that fill in payload_sz are
unaffected.  Also skip the veto list size check for pipe shares:
share_config_request() reads neither the path nor the veto list for
them.

Tested in QEMU with ksmbd-tools 3.5.1 and 3.5.7 and the in-kernel SMB
client over loopback, with and without a global "veto files" setting.

Fixes: f25e93768fcc ("ksmbd: prevent out-of-bounds reads in share config responses")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_ipc.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -524,11 +524,25 @@ static int ipc_validate_msg(struct ipc_m
 		if (entry->msg_sz < sizeof(struct ksmbd_share_config_response))
 			return -EINVAL;
 
+		/*
+		 * ksmbd-tools releases before 3.5.2 leave payload_sz zero.
+		 * Derive it from the size of the message actually received so
+		 * the checks below bound the payload for those releases too.
+		 */
+		if (!resp->payload_sz)
+			resp->payload_sz = entry->msg_sz -
+				sizeof(struct ksmbd_share_config_response);
+
 		if (strnlen(resp->share_name, sizeof(resp->share_name)) ==
 		    sizeof(resp->share_name))
 			return -EINVAL;
 
-		if (resp->veto_list_sz > resp->payload_sz)
+		/*
+		 * Pipe shares carry no veto list, but ksmbd-tools before 3.5.3
+		 * copy a global "veto files" setting into the IPC$ response.
+		 */
+		if (!(resp->flags & KSMBD_SHARE_FLAG_PIPE) &&
+		    resp->veto_list_sz > resp->payload_sz)
 			return -EINVAL;
 
 		if (resp->flags != KSMBD_SHARE_FLAG_INVALID &&


