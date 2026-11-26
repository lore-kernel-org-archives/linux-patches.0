Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705491;
	b=x2AB23WOcD7yqPi7RPKlaPoa+yp/fdvdwKWwqKqjBPz7w7yXITqP+5Kn/4HJRPMQt0RY
	 yJLbd1Sca0wZruhkWJ6YL5Uj0VZZKomrrBW2Ti8RsXI7+I2BVf6M1yo4h6F+XK9XX/o7X
	 6Slj/IlByKj8QcLf7alBO0S21jZHKwHknpVqfPqlbDy7Dw5aR53qpHpVYx1vBpl6Vv8Ww
	 Vj5H06hmYMjCK2YqG07RuBA6vnnZ9DFhMt4PkmDUx+zJ6dEmHC+ahpc6PM9pnXm0Kh4Ng
	 UYM2xjYZrFux1f3jrxJKm5WSs7/k8ZbtSijnjs2UvuDePqNqYhUm4lJwMHaoa4D89ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GG7XnbMc+4QBFw9YvAr6DWRFB5dzY/ZBxV4ycwYIGNc=;
	b=EBr3r8jUtDJSVIGpYmeV3WC/jsGqCJlxLU73VOzObE+klyT5nS4AByUbzNwAiCksKS9Q
	 4Bsciq7gLY/UJePZ4WOrFbo6zSPMFKiRyVX193ASr11ImbXaAgcmRrM6VyW7Xvgb+8kHh
	 cnrjRO4b7BZw+S7giZHIM1EkOuG5T5V63JiL9lEXiJeQ/GXznXjxbecVj9iGqnMsNqb+f
	 PePD/2V4IV7RDuLHfU7OxbwYxffvSPtfCVIj3bk41h6y8c4QQh/ocsqkmE8+0I3KSqwg+
	 OWf0029GNus/YKHZYS+iMCcgSg+jjsFX0/owKg538rS73oqnY2UtM5lRaHRLwZn2VDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oI0H+XgU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA20606A31E;
	Thu, 26 Nov 2026 15:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oI0H+XgU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571051F000D1;
	Thu, 26 Nov 2026 15:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705490;
	bh=GG7XnbMc+4QBFw9YvAr6DWRFB5dzY/ZBxV4ycwYIGNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oI0H+XgUoQzCzgkGOIZ1c/70evY5+zcUO09MvLzdAw+1wtXGizS3Tb8MRmBGQAjUl
	 49Vsfu9ozRGAVuWGaAYvzVkNl8yWmziquhzWQ8DqsWBaPz1hijaL83BjwS67rSbMAj
	 bUg8Eb9EP/4LuvJFLGt1r2KrNaKBjZC6b1UJKX3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 214/319] tpm: eventlog: check the payload size before reading tag events
Date: Thu, 26 Nov 2026 15:39:42 +0100
Message-ID: <20261126144011.575910520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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


