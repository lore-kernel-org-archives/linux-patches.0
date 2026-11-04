Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831879;
	b=17XfwvVpbPiflP0pZ+371WTFB+pBGpZUnXmzAAcVduU7PgyY5N5Jhcdj62dv61geok/x
	 mT1duNdr1Ks7D+qa5auBmHthnF38RVbqfc5A4/GCJpo4N51lpKrfC6M8oik/gED9eMxL+
	 3T7Q2tnpwp9HbeeQRXcRmDYlPPJWCPtP9yW7GGS7oxyPHUNeUUjL3ouL4j91xTuriGchl
	 sWjtFbkjCm4Pp8N+zQvtMO6sMzCqo53xLKvt7FJocWRe48VKLIqD7IfCPsLJF4Ca4Ss09
	 tBqAp3EmnwS7QEkFQgQ9c3FnDV+qCGkAGGH5XB/m4wOSp9Yf6v4Ug8b/ssPKqyjKhvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YOFUnD7bz20JH8dlNXesUX8KfGTnkXNB93wKOlfu9/Y=;
	b=gczYt3Sg8/EDatgt269qQ73isdDlXRnEhP+BuU68Zp9zUXBIdEDB49GDhIP+gYXAU89p
	 VNPZh+w7juDJu9O2yxAvD+Pi1VZPLsDUBZ9F/SHcB60Zn2EEnY5ZGc+7EOAi+sPvAHCyH
	 NOXfcnFF1cpFGpe+3NUnx7B8Y0x6r4qj0aqwnPmJDGcUDLD31xv4rDG/jAGGuCDPzBEiq
	 LfVnHe9D3XUqNAym7FLocgikhhkUV+QeBgunYFzkaxxrCjm/KiCB0deWvdA8uPDKqbFjW
	 abgU+OhC1W3iAFeat68l0uTg6RDJrAbY8HuoHvZBnXQByUvLIdjRot6buHoS0p6e4KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C0xwYwKm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D97606A33F;
	Wed,  4 Nov 2026 22:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C0xwYwKm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCB71F000C1;
	Wed,  4 Nov 2026 22:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831878;
	bh=YOFUnD7bz20JH8dlNXesUX8KfGTnkXNB93wKOlfu9/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C0xwYwKm1dJ9W+IZW1rHl6OyjeRxtcpWYXDfvJkpMbrD76PRhVDReu4wfE1IFAg0M
	 4xbpl5sNA8HThwv0y5NfSvrA/Io/6m44W7xf1ol3J7TxhPMKtjtlOR1BmkAwXhbHMp
	 lX9F6eHedWBAvabKwSbhKZVpGGCOiuHvYtV3sXI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.18 0970/1005] smb: smbdirect: fix buffer length underflow in RDMA transfers
Date: Wed,  4 Nov 2026 16:11:43 -0500
Message-ID: <20261104211110.238748056@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 7193241a49c958782ba4b8df06da3734d1e317d2 upstream.

When a remote buffer descriptor is larger than the remaining local
buffer, smbdirect_connection_rdma_xmit() clamps its length and sets
buf_len to zero. The common accounting code then subtracts the clamped
length from buf_len, causing it to underflow. If another descriptor
follows, the loop processes it with a wrapped remaining length and
includes memory beyond the local buffer in the RDMA transfer.

A client can trigger an out-of-bounds kernel write with an SMB WRITE
request, or an out-of-bounds kernel read with an SMB READ request, by
supplying multiple RDMA buffer descriptors with an oversized descriptor
before the last one.

Remove the premature assignment to buf_len. Subtracting the clamped length
already consumes the remaining buffer, so the next iteration stops and
only descriptors within the local buffer are used to build work requests.

Fixes: e628bf939aaf ("ksmbd: reduce descriptor size if remaining bytes is less than request size")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-33549
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ metze: in 6.18 the code is smb_direct_rdma_xmit() in
  fs/smb/server/transport_rdma.c ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_rdma.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1724,7 +1724,6 @@ static int smb_direct_rdma_xmit(struct s
 		if (desc_buf_len > buf_len) {
 			desc_buf_len = buf_len;
 			desc[i].length = cpu_to_le32(desc_buf_len);
-			buf_len = 0;
 		}
 
 		credits_needed += calc_rw_credits(sc, desc_buf, desc_buf_len);


