Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044283;
	b=OK0Jw7izZ1FzrSqmw41jPfMn1OHUNpaXB7PhjIZzyHXJ/qu2ZsytZD34T3qDclzKoXdu
	 Lfl4VOTrvLfbqoIJcsvSVE8uxbMUFlYMBHxbGS0HUWiTH/Gr6omKYvDCb+5k56AhMROIR
	 BlLNa5kkOIK0gaGoYNPhDrzmICQh4TTw06UJ5nK3c0/6/AyTh3ZY0v4ZxZ5dQxHrRNRB8
	 TRYaoqkTTaeLgaSe9I8K9ekb/KqLUql+XBmlwFcQnHetSsCBQne3X8hhhYoY/33QWwR9K
	 ZdyueCrvN8ghdWb6saaFXdBQvhBRs33lbcWeW5O9qyyR9wg33nDySC+sPSPbHmDcyhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3XbHnpDL3v6gLJEakqC3YozQWyN1qoDKUKc6+/o41vQ=;
	b=Um7rrnargTNkZfFxY9YpSIn+lzj5pLDRnDsOatVmHcn33dqzdeJOmfLURmoHmfYXg/My
	 YtQw1ZA7bOhGTm+JqFyX8197bEwRevuEcwZRExRnm5BHwZ80bwZLmYzptLBb/WhxWslTt
	 MNnz3DS4KrSRPQKEMV58As5Jbsyx7KtLhkxbLqf/a452usc6Ea7fMylhmC6jbBPoOnFGM
	 mv1ZHuMY006qPKGQ7rUPeCXei5Tvb+QqfZf/LbOfNXql36E3PBsDq7RV4X3NnGcnqiZNC
	 GFojdUXNmebDxDRpv2XJu8xKxznRxvRSCSao6vPoS7qqVPg0ocAUGDyQ6GCMTMtfkmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLbtWuW7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98447606A325;
	Wed, 18 Nov 2026 23:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLbtWuW7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3F01F000C4;
	Wed, 18 Nov 2026 23:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044283;
	bh=3XbHnpDL3v6gLJEakqC3YozQWyN1qoDKUKc6+/o41vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLbtWuW7FCEEs88IismlgAkSWbWh7SgCyy6cAM8codibXeNyGdXFiGynUXi+tLNuv
	 sU153ZhwyNF1Qr9qxlQseOdvl5yt/WL9HZWcIMJLsmP1UIXckWIcR7tOI/3w3MpUso
	 +WQInthLBzm3Dy8bhp/oERT/xqK+WdkXeNlgTMPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 0510/2857] ksmbd: accept share config responses from ksmbd-tools before 3.5.3
Date: Wed, 18 Nov 2026 15:25:44 +0100
Message-ID: <20261118150219.824478602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
@@ -493,11 +493,25 @@ static int ipc_validate_msg(struct ipc_m
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


