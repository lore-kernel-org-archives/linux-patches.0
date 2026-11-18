Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025454;
	b=ClxVelmrFLxwzEtvigs/DYcTpPr5HdwN9kd8IyB9Th4hO+DpZMRfqLYcccx0aYb98Hr9
	 7JGKpEnDR+3lf5r8zNKk5SR8qyeb8cEv4X/V2jEjH6oUWE6TyE2CQF/v39lnJ48LYiOdW
	 A+OcN0LmS/MOAkoBwSeBuCMDQSVXvne/eCh+WGsFnUmJgI1QLpJWeupm1kUp92MzzBBYq
	 q/JPBa6+RzvQzg1ivi++YL5XpufLfiawBxFGMdUsascSNbS/UcDPLVWSHaCJr83rYUjJ+
	 SQyhEBnPXspfK4xF2WHu/wR9eQyf6UjEXPCzgtlvyMaJlsGbyvvxWpK1N9iW0cO+Ojg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KBS3UxUJ/8eGxzwQdkXmguV4xT31VZBXUNQvNulCUz8=;
	b=iHBslIUTFi+3f6hgb98WBQ68wkujOPHpD4G4MYv+ozLnS/oZMVDppnD4AgFvGyQDl/pD
	 OMrRCTpP6fhySgGFlUlK4ESQoAlT6Ecq6aA8GNuZgkPAdOn8XIBWYC8aISpwrxEaca2om
	 3sqTWk6jwzxDoYsf/gwaQhmDfUeUCNcrw2aVQumGYhij3w4it/SUYPzMkhaIaP+67rejW
	 sk5J1zgqyOYQkCOCbnQyU8fDxaBKJ2Ras0n5fKso5uSfwkmCSvrFMHq9nnfQ8Rxvpv3tm
	 3iMz/VRLzi/I45n77IH4O+w4uBXGrMWPSVN+HoXNtn3pz+kF0rYmqsN8/qTyAVrdePw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J5Yp+zKY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD45D606A320;
	Wed, 18 Nov 2026 18:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J5Yp+zKY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2722B1F000C7;
	Wed, 18 Nov 2026 18:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025454;
	bh=KBS3UxUJ/8eGxzwQdkXmguV4xT31VZBXUNQvNulCUz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5Yp+zKYF75pBSUfLtsQxl7mNDwwh5PtzgRm96RiH9zqgNTH8LccEg0Rw45AGiHNV
	 /itb4LKJZ1nu2WfqiB6CWJmuPCQOaOHSeK2m8whIdcAfwa1Pv0qh1UY2k7IpoOLpiH
	 fsC9qsmP80/soo7e82S/21SF7d3JA3AB5LA6FXnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1085/2151] svcrdma: Fix svc_rdma_recv_cid_init() kernel-doc
Date: Wed, 18 Nov 2026 15:47:00 +0100
Message-ID: <20261118150201.785478332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit d1caedce2d015573b4c26b127c488059f25aabc4 ]

svc_rdma_recv_cid_init() initializes a Receive Queue completion ID,
but its kernel-doc heading names svc_rdma_send_cid_init(). The latter is
a separate helper immediately below it, so kernel-doc cannot match this
comment to the receive helper.

Fix the copied function name.

Fixes: 28ee0ec8948a ("svcrdma: De-duplicate completion ID initialization helpers")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260909064343.90437-1-kmehltretter@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc_rdma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 6e1cdc3335e0a..e661f8cad0050 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -138,7 +138,7 @@ enum {
 #define RPCSVC_MAXPAYLOAD_RDMA	RPCSVC_MAXPAYLOAD
 
 /**
- * svc_rdma_send_cid_init - Initialize a Receive Queue completion ID
+ * svc_rdma_recv_cid_init - Initialize a Receive Queue completion ID
  * @rdma: controlling transport
  * @cid: completion ID to initialize
  */
-- 
2.53.0



