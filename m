Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213754;
	b=R3gugXgnPQroUzKDCwvJoGyDbJonFaIPiIdtrL5KdbzHx/QtIQQX7Nuis7LkDPaCSLUM
	 shK0ElTtbi4O3wMsX8/uRIs1L1sFlyqs3+0/dUmGtFEncrZTfUWIg5UW67kkh5wa/ucIU
	 jzQ9PNKoNbRtt0GOn0J3T2jDV9eluonkc/XJq179+Ou2BNozhFEysrog3ipfpm8t9hD0f
	 fKSKCZSa2EEtY1UDFzVTUkQ7XRmlV8ZjipPHQbF75UHI8eU28lGiZBmTeoEPRD/J1OxOS
	 On9C66yO4Dxv7kUBg0FOATpXNsT2E6ltb1UVhT5C4FTBCYL7epwPVaG3bMMbqd0v3uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yekua5LXOCALO1dJr+3m/h4ztyxnVBW0dQyoX09KTXI=;
	b=A0cTIMLdFC1N5GNdzB57a2OT/8S/ee+bx2ArZal4nQ4KhjBBi//wtuE12eBvj+bieACh
	 Z2KhoDNLtTcRk6XGGTmW94mWwhqUxfcZBKnYEWe01o4fpIsXacZhP/VNe15QO+IpRoGIr
	 fWwdC5iViwr9RtND8VIqAqvIufwaAaZiyFGpo1WKs/rt4S6bvTiV91JlJi4zrfFlsLR4L
	 2HSmUv25lXIjG8Ky7sNaXXO1wtGPewaQzbYkSdXyDhZ56arAeZk8/RT75od9H4ocEWYV3
	 hSxQX2dh/fFCdYFUUdV1fwiERmUzhCXQJAKHd+ZkBu+g4L7rWOeXpNSlMmomRflF/uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gy6WdVOz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5F1606A320;
	Wed, 28 Oct 2026 18:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gy6WdVOz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF3C1F01828;
	Wed, 28 Oct 2026 18:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213753;
	bh=Yekua5LXOCALO1dJr+3m/h4ztyxnVBW0dQyoX09KTXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gy6WdVOz07CyOfJWK5sbpKV565XrFw//GB/q56Us1ATpDTxEvXDtrCJKLAGF3ux+M
	 82pInixj9m70kKSDds5A/4/HygBWNsiUwJ1YXURD0A5bV6WQq2CmTfoErfqp2VRcfM
	 CvBC3XC+ItzTj6GGu+JW7BDmppu+eiJgoisidfIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0615/1887] hv_netvsc: Dont free decrypted memory
Date: Wed, 28 Oct 2026 17:45:11 +0100
Message-ID: <20261028170513.406281565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

[ Upstream commit bbf9ac34677b57506a13682b31a2a718934c0e31 ]

In CoCo VMs it is possible for the untrusted host to cause
set_memory_encrypted() or set_memory_decrypted() to fail such that an
error is returned and the resulting memory is shared. Callers need to
take care to handle these errors to avoid returning decrypted (shared)
memory to the page allocator, which could lead to functional or security
issues.

The netvsc driver could free decrypted/shared pages if
set_memory_decrypted() fails. Check the decrypted field in the gpadl
to decide whether to free the memory.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/r/20240311161558.1310-4-mhklinux@outlook.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20240311161558.1310-4-mhklinux@outlook.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 077595b42d4a7..e17c6dadfef86 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -156,15 +156,19 @@ static void free_netvsc_device(struct rcu_head *head)
 
 	kfree(nvdev->extension);
 
-	if (nvdev->recv_original_buf)
-		vfree(nvdev->recv_original_buf);
-	else
-		vfree(nvdev->recv_buf);
+	if (!nvdev->recv_buf_gpadl_handle.decrypted) {
+		if (nvdev->recv_original_buf)
+			vfree(nvdev->recv_original_buf);
+		else
+			vfree(nvdev->recv_buf);
+	}
 
-	if (nvdev->send_original_buf)
-		vfree(nvdev->send_original_buf);
-	else
-		vfree(nvdev->send_buf);
+	if (!nvdev->send_buf_gpadl_handle.decrypted) {
+		if (nvdev->send_original_buf)
+			vfree(nvdev->send_original_buf);
+		else
+			vfree(nvdev->send_buf);
+	}
 
 	bitmap_free(nvdev->send_section_map);
 
-- 
2.53.0



