Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619856;
	b=VLJ48ZOp7n5fwvckwgfmCgMHmYYW2ECIaICCsKYHZcA2FTaehpgYsclvOq2vIyO9/T44
	 m8zqBdfkDd1bBASfOFNueUxIzxxWnbvOapfvHM+8zQCmcFqI/+aeGQOj88yw2idH9fB70
	 7bcrzrewMy87ZaPBmljr5XxFi089QgHNTmPKwMnNCLmr/KLk1lf7L0XUOzQEbzxPLqv4Z
	 BIgeFqV1uxaIlFweFXM7Bi8G4CDQj2Hyt4uKki0Avc71OYgUChkfLm5GdPCmJVwtNQH2A
	 +CzmUvaw9OXAUzNkPHBrCytiXDt6+9eaBa0WTbQAavFEGObuLwOiqMtVX9dCpISl8Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wBkIpiwYvPjJ39GB981rx5gggI9Cec52MkERhX2lY9M=;
	b=zLq975G3QFdL7U1vvF01u9P6QrAntGUV8Xl4oeOWSvkxOfL10Mq7hhSI7xLRJA2HQlIr
	 U9wf6m9RItZNaCfj0iOl3vBpL5nDrSoZYKBssK42pbftBCIsXNppBROpYAdhxGGEIvZMn
	 yT5Sk393QL+HInszgOShol5eQXZcLaDorwNw8w8pYCpbsgAE0ECw3HJilATXhAHeZ/MqC
	 h3Jlb1uYEtM7J4gg7aGyZ9eDZ1fSTRxArteeYLaArJ8tkppseVkm2LDkaRpkt4WIXktwp
	 PH/tSFnPJpwNx44z05ZrhTr25EArEYpxhqtdOpHzpFkyxOCL+V2M2e8Qm6RKHt582zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GILbxMmX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCE0606A326;
	Wed, 25 Nov 2026 15:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GILbxMmX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C16C1F000E6;
	Wed, 25 Nov 2026 15:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619855;
	bh=wBkIpiwYvPjJ39GB981rx5gggI9Cec52MkERhX2lY9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GILbxMmXDnJzik6YiK+tjyAZL/qgkL0AGwnBn3im5QlEkd6hAPICKbpX37vRD+Mgr
	 f4El9+rJwzFRyy8lVBy5ye/FPVMkCjdiCMlzPjhPE5KlhMTDFBre0EoE1y63IUOyYo
	 Yx5XIsDGFu0rJ2N/8ceTDW8lrbVTKqNRbG8NgCIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.3 0728/1005] tpm: eventlog: check the payload size before reading tag events
Date: Wed, 25 Nov 2026 15:34:26 +0100
Message-ID: <20261125143838.817567082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanglei Zhu <zhugl3@xiaopeng.com>

commit 0a385f668ba77d29ae167c1668fd452418ebc9d6 upstream.

The EVENT_TAG branch of get_event_name() casts the event payload to
struct tcpa_pc_event and reads from it:

	pc_event = (struct tcpa_pc_event *)event_entry;

	switch (do_endian_conversion(pc_event->event_id)) {
	...
		for (i = 0; i < 20; i++)
			d_len += sprintf(&data[2*i], "%02x",
					pc_event->event_data[i]);

The log iterators only verify that the event header plus the declared
event_size stays within the log buffer; they do not require the
payload of an EVENT_TAG entry to be large enough for the fields the
branch reads. A truncated entry makes the branch read up to 20 bytes
of event_data[] past the end of the entry, and, for the last entry in
the log, past the end of the buffer itself.

The legacy PC Client spec defines the EV_EVENT_TAG payload as a
TCPA_PC_EVENT - event_id, event_size and event-type-specific data -
so a conformant entry carries the 8-byte header and the hash-type
ids carry a full digest. The log itself, however, is an ACPI table
the firmware leaves in memory: the TPM never measures the log, so
the kernel cannot tell a conformant log from a corrupted one. The
iterators already work on that assumption - they stop once the
declared event_size runs past the buffer end - and the readers
should apply the same rule to what they take off the payload.

Skip entries whose payload cannot even hold the event id, and skip
the 20-byte digest dump when the payload cannot hold the full
tcpa_pc_event header plus the digest, so the branch never reads
beyond the entry it is formatting.

Cc: stable@vger.kernel.org
Fixes: 55a82ab3181b ("[PATCH] tpm: add bios measurement log")
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/eventlog/tpm1.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/char/tpm/eventlog/tpm1.c
+++ b/drivers/char/tpm/eventlog/tpm1.c
@@ -178,6 +178,10 @@ static int get_event_name(char *dest, st
 		}
 		break;
 	case EVENT_TAG:
+		if (do_endian_conversion(event->event_size) <
+		    sizeof(pc_event->event_id))
+			break;
+
 		pc_event = (struct tcpa_pc_event *)event_entry;
 
 		/* ToDo Row data -> Base64 */
@@ -203,6 +207,9 @@ static int get_event_name(char *dest, st
 			name = tcpa_pc_event_id_strings[do_endian_conversion
 							(pc_event->event_id)];
 			n_len = strlen(name);
+			if (do_endian_conversion(event->event_size) <
+			    sizeof(struct tcpa_pc_event) + 20)
+				break;
 			for (i = 0; i < 20; i++)
 				d_len += sprintf(&data[2*i], "%02x",
 						pc_event->event_data[i]);


