Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774143;
	b=oXWEW9X4ntNwSlokFwm/Zsv6pwcpA/Q6RHDDu34awftXs79izKkg1tVWv7AcBIQ/X3JY
	 r1MbXq4qEtfW5mvIyZXwQ2NjCRz3N7nI1LZ3XqN6Ft/WGlYTsDv6LhFzZKfQEAxoDQ4+y
	 L3nQ4XL7wFBZf9iwt5tAPJwVOCRpRHBM8jLSZ1GX3T7FJz1RczbquCgx2vwRw1o8qdkEn
	 VttL5wdQmy5PeFXMdVKd/I/9gmquPnKUfLU7yPNsoV+47L002wwsaw8walGZlm29vOHeN
	 flUNHJIQRGusx7EAQFWfX6/NnpaDxpZHTWz/u1kIHRnRj14e3M6Arf0LeqYDMGGC7OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ChdcfuHEKepcu8xnm1lrQovLDYeLTDrnfXdd0/nlQ1g=;
	b=vcsSibahEdXAkjfwcA8uQhNkcLE7eRWNJ6IMMeE2JsYPwFplczaOlYtnwndHXxIw0tqg
	 wapj8lksosWTBWL941MXXq+l2JpBjRcS0d/l3QlHzSeRmLVEEQ4GLUaBj/xmrnK6ZnuHI
	 JIOfDCYWNn9EGxWF3+6l9/upw/ePeb48fN7dxG0SVfY79lxTdeyVsbd/aj54R7yFiEm/k
	 Cy0RJVtkxASHODx5wZ6keCRljynlJHLWKyL/DC0pzHrwNwqZJX0sis2vAE0Y5mcO46WfT
	 U9A4uzuuBcw1q5DXNZYpJmN8bm6+GU1GWO0Ok6DR5KCI3ACuuw/PLd2veZsIpoUIEJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOUvqUgX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC02606A32F;
	Fri, 23 Oct 2026 16:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOUvqUgX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1498D1F01825;
	Fri, 23 Oct 2026 16:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774142;
	bh=ChdcfuHEKepcu8xnm1lrQovLDYeLTDrnfXdd0/nlQ1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOUvqUgXzjIRH8jloIa80viqVl7B78AZs5bPbFLMIlwVwgJ+6l1qPjx3DnDlmQZrg
	 8HzGu0Dm9EfejCXedSYgQMav+Mj2/JDyZ5W5cwSKL6vVYSEE+JOZjXcuNsgGoQZwTK
	 AhXOxV98JNa9R6e6Pu/0nrgo8AqhiYAvXR44+O04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 133/193] netlink: specs: add missing mask attributes for conntrack dump
Date: Fri, 23 Oct 2026 18:36:50 +0200
Message-ID: <20261023163717.355661803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

commit 8b348496cbec0d5ca24a99f668096e2e16e8fbeb upstream.

'mark-mask' and 'status-mask' are defined and supported by the
conntrack dump, but missing from the list of arguments.

While at it, the order of the arguments should follow the order of
their definition in the enum ctattr_type.  That appears to be a common
convention for other spec files.

Fixes: 23fc9311a526 ("netlink: specs: add conntrack dump and stats dump support")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Link: https://patch.msgid.link/20260826220444.4054714-3-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/netlink/specs/conntrack.yaml | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
index 6ba28cb1c2ab..b1eb102ab843 100644
--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -604,10 +604,12 @@ operations:
           attributes:
             - tuple-orig
             - tuple-reply
-            - mark
-            - filter
             - status
+            - mark
             - zone
+            - mark-mask
+            - filter
+            - status-mask
         reply:
           value: 0x100
           attributes:
-- 
2.56.0



