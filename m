Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033378;
	b=g9XUzJyDjwZH+Nb/AaqFpNiuboopxnOrJQL0IX6TzeuILBzKhKRqkOCjrUB1ugyIdXR2
	 AJ+aGNc3zS1nvoxogA3RzqBLeJZ0hHJXWFt7PeBWMPkiMWSuq3bL7q6Np8TxkLYZ/Z/HL
	 8L0V0LDiUdH3kijUy0dybnp4mxPzglF+fr1KgVwio7dgB8agvT4eJ91yKocih2EHGo3Ko
	 yAhSkDnzodd6Hd38JULe1CahTLIHzbmmaeGOFF8LSrOVmOxlPcok3+iKghdnkYQ4/Mdqp
	 JqLJNNFMK5AZDvGcjil58PbZUbiHftuMBz/Mzd829ZrfKdjwcQuj/2HSFgIyDY66ang==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OQCmIrn3tLp2Qgh9wt594vSzGxYCcHB/+4W/AOSjgbQ=;
	b=xCf+UXFwX6oK5TctlwfNgKwM4SFkb6ASRL5mS6rWPvAABQs9FTpiOLW6RyqmiLIqRHhA
	 APU0ImagdcqtoUrI+ML+VhkjppjxY3IOtcGLxBQWVsmiinO1pVd0VfNBYnww5g525i02l
	 2Th8vKcXf7iQIYyk6SnhWxTP6R1aNqfO4e7pBcNV9xLiTFg/7jJaAtgyp4I/wj5SeiNPB
	 +Ag//vrIi/opK00L4objKwsQ/gecgcRNaa+4wsDANl8NYFi+Y3ZMptToKVTWCqQFem8PP
	 nNh3P3aRgkiUO/3hoLY3ZK5ihBbLsb1vokRati4vWPagXMLkEJEoR9ah34Wy8OkFSgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DTKzGvUf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED33606A332;
	Wed, 18 Nov 2026 20:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DTKzGvUf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41621F000C9;
	Wed, 18 Nov 2026 20:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033378;
	bh=OQCmIrn3tLp2Qgh9wt594vSzGxYCcHB/+4W/AOSjgbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTKzGvUfCQglPr1lDN4+V5sf5BrAarpnhzg0IXqWOrHNfLX63ym1HqeeFq5JfFwZK
	 K7KY51ZVxcp9F51CsZYPUfSeX1HzdoFjIRWN8MLYvavBft4zj2Rf5wKXZrl+0b3tuV
	 EYaHoJNAzCC2q09kalfqD3thtnr/+Se1sXfLPMKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 1748/1756] smb: align durable reconnect v2 context to 8 byte boundary
Date: Wed, 18 Nov 2026 16:04:35 +0100
Message-ID: <20261118150119.116456966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Bharath SM <bharathsm@microsoft.com>

commit 05f5e355cf783b30bd6eb3dec17ed1a8b3cfa95c upstream.

Add a 4-byte Pad to create_durable_handle_reconnect_v2 so the DH2C
create context is 8 byte aligned.
This avoids malformed CREATE contexts on reconnect.
Recent change removed this Padding, adding it back.

Fixes: 81a45de432c6 ("smb: move create_durable_handle_reconnect_v2 to common/smb2pdu.h")

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/common/smb2pdu.h |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1320,6 +1320,7 @@ struct create_durable_handle_reconnect_v
 	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	struct durable_reconnect_context_v2 dcontext;
+	__u8 Pad[4];
 } __packed;
 
 /* See MS-SMB2 2.2.14.2.12 */


