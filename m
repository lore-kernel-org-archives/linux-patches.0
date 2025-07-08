Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FB21C6FEC;
	Tue,  8 Jul 2025 16:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992202; cv=none; b=Asn/5vzJ5QxhyUS2Cw02A70JSrV029INI/Zz4IO7qEzkeRcp6dUu9+EA019w3siGxmTC358qFhbNt7dTJur/Bwsjycd4IdPJTtw5n7huZViPA8mxFuV2UsNEwYXnuAKI3DvbmuDzmAUxQv+kDjVvT87NTIdRbIKA86qPFKPqN1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992202; c=relaxed/simple;
	bh=un9sD9x7n5QQzIwLfSUYN/9O4+kXaOErfTahqv0rHAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAr8DgXfWb0j80eeMngMnzdn+rCC+ft5AukaDKmAzOd0rfWfoc0p9Jip1xtBxhkH8pUuOubSUpq6nKpmoa7MVP97xB3CBVtPJhGLjBsxnG4R3bBHKoVMXy1P9LT81fnGwRpb9DAwzecRdXKUeob1y9S5z72uTA9w25IYBXC2Wck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTmIym+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTmIym+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF85C4CEED;
	Tue,  8 Jul 2025 16:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992202;
	bh=un9sD9x7n5QQzIwLfSUYN/9O4+kXaOErfTahqv0rHAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTmIym+BoZCzuQZZ1OlLMkBF/Qcvave7I8EhZkXVqas0Bl2YU57UfV0FhsUCu4srX
	 01miA3+zeuMLuD5XQltrBAp9qQukXnF9EtZezHDEjaqnxb+jcQrPlYxMmze2nYNgG4
	 EmTevgauSBr6d6LX/nm+LCFP9E2h6XlpNaLgoCAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	stable <stable@kernel.org>,
	HarshaVardhana S A <harshavardhana.sa@broadcom.com>
Subject: [PATCH 6.6 006/132] vsock/vmci: Clear the vmci transport packet properly when initializing it
Date: Tue,  8 Jul 2025 18:21:57 +0200
Message-ID: <20250708162230.951045547@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HarshaVardhana S A <harshavardhana.sa@broadcom.com>

commit 223e2288f4b8c262a864e2c03964ffac91744cd5 upstream.

In vmci_transport_packet_init memset the vmci_transport_packet before
populating the fields to avoid any uninitialised data being left in the
structure.

Cc: Bryan Tan <bryan-bt.tan@broadcom.com>
Cc: Vishnu Dasa <vishnu.dasa@broadcom.com>
Cc: Broadcom internal kernel review list
Cc: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: virtualization@lists.linux.dev
Cc: netdev@vger.kernel.org
Cc: stable <stable@kernel.org>
Signed-off-by: HarshaVardhana S A <harshavardhana.sa@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Acked-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20250701122254.2397440-1-gregkh@linuxfoundation.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/vmci_transport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -119,6 +119,8 @@ vmci_transport_packet_init(struct vmci_t
 			   u16 proto,
 			   struct vmci_handle handle)
 {
+	memset(pkt, 0, sizeof(*pkt));
+
 	/* We register the stream control handler as an any cid handle so we
 	 * must always send from a source address of VMADDR_CID_ANY
 	 */
@@ -131,8 +133,6 @@ vmci_transport_packet_init(struct vmci_t
 	pkt->type = type;
 	pkt->src_port = src->svm_port;
 	pkt->dst_port = dst->svm_port;
-	memset(&pkt->proto, 0, sizeof(pkt->proto));
-	memset(&pkt->_reserved2, 0, sizeof(pkt->_reserved2));
 
 	switch (pkt->type) {
 	case VMCI_TRANSPORT_PACKET_TYPE_INVALID:


