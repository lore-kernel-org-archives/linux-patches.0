Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51356AFAE;
	Thu, 13 Jun 2024 11:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279551; cv=none; b=itya5IxxRwXlCARfFZcOAp0b0/OUR9To/S+o90zye2LDYstFyxOeDsSGCFLMPkvr1YC8ZtDDo+SQDOafZeWFLHcPzRn3qOUCFsjqssKZ25vQZ45lFiXQDKH88z0/i0Gy9aGE1lWhTErtdhyFIGQGKlYnGWbb4rmEcG/NYzElzYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279551; c=relaxed/simple;
	bh=3P9jF3iMC9JA7PW6KHRCNynfwt5A/4itvh9CiznOo3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKoJleUUEjB/9bRNBT5Awu3SYt+sYHZpGGvy10Qtg8m7Oim5zkctbxaP02ZQQpejcSpykGbu8WmGcrCidLON+PdSaDImONtZs6E2lrlU15S1eZiw6Qst428LQlbbhZBvRZelhmsFghz96M/7sOnXQ/EyYD9LSmnRp9kd936n6IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRvgLm/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRvgLm/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5777BC2BBFC;
	Thu, 13 Jun 2024 11:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279551;
	bh=3P9jF3iMC9JA7PW6KHRCNynfwt5A/4itvh9CiznOo3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRvgLm/8JdVX56/IbnSAJM+oCa+AYimv4HhkDPiOK9WtHBsh6caCpi0SxIWTmercf
	 6VkxoUdbNtgsPYN+bzWvj1a9h0lqA7IfSrx+USpU3k+HND16fPX/5QirXmfIUTmFTP
	 fItODFEzivA0xSr9NyQDmLLHxb2dFh17X4YL595I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuval El-Hanany <YuvalE@radware.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.9 114/157] Revert "xsk: Document ability to redirect to any socket bound to the same umem"
Date: Thu, 13 Jun 2024 13:33:59 +0200
Message-ID: <20240613113231.828563152@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Karlsson <magnus.karlsson@intel.com>

commit 03e38d315f3c5258270ad50f2ae784b6372e87c3 upstream.

This reverts commit 968595a93669b6b4f6d1fcf80cf2d97956b6868f.

Reported-by: Yuval El-Hanany <YuvalE@radware.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/xdp-newbies/8100DBDC-0B7C-49DB-9995-6027F6E63147@radware.com
Link: https://lore.kernel.org/bpf/20240604122927.29080-3-magnus.karlsson@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/af_xdp.rst | 31 ++++++++++++-----------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
index 72da7057e4cf..dceeb0d763aa 100644
--- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst
@@ -329,24 +329,23 @@ XDP_SHARED_UMEM option and provide the initial socket's fd in the
 sxdp_shared_umem_fd field as you registered the UMEM on that
 socket. These two sockets will now share one and the same UMEM.
 
-In this case, it is possible to use the NIC's packet steering
-capabilities to steer the packets to the right queue. This is not
-possible in the previous example as there is only one queue shared
-among sockets, so the NIC cannot do this steering as it can only steer
-between queues.
+There is no need to supply an XDP program like the one in the previous
+case where sockets were bound to the same queue id and
+device. Instead, use the NIC's packet steering capabilities to steer
+the packets to the right queue. In the previous example, there is only
+one queue shared among sockets, so the NIC cannot do this steering. It
+can only steer between queues.
 
-In libxdp (or libbpf prior to version 1.0), you need to use the
-xsk_socket__create_shared() API as it takes a reference to a FILL ring
-and a COMPLETION ring that will be created for you and bound to the
-shared UMEM. You can use this function for all the sockets you create,
-or you can use it for the second and following ones and use
-xsk_socket__create() for the first one. Both methods yield the same
-result.
+In libbpf, you need to use the xsk_socket__create_shared() API as it
+takes a reference to a FILL ring and a COMPLETION ring that will be
+created for you and bound to the shared UMEM. You can use this
+function for all the sockets you create, or you can use it for the
+second and following ones and use xsk_socket__create() for the first
+one. Both methods yield the same result.
 
 Note that a UMEM can be shared between sockets on the same queue id
 and device, as well as between queues on the same device and between
-devices at the same time. It is also possible to redirect to any
-socket as long as it is bound to the same umem with XDP_SHARED_UMEM.
+devices at the same time.
 
 XDP_USE_NEED_WAKEUP bind flag
 -----------------------------
@@ -823,10 +822,6 @@ A: The short answer is no, that is not supported at the moment. The
    switch, or other distribution mechanism, in your NIC to direct
    traffic to the correct queue id and socket.
 
-   Note that if you are using the XDP_SHARED_UMEM option, it is
-   possible to switch traffic between any socket bound to the same
-   umem.
-
 Q: My packets are sometimes corrupted. What is wrong?
 
 A: Care has to be taken not to feed the same buffer in the UMEM into
-- 
2.45.2



