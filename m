Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036808;
	b=iB6MY+Eood9fqHGou1QsnrRDxScgdLC0cJWPRWM5OQgjIxVPcOu62O8F2SPoQ5nV7KV8
	 pqjFejJWd/jzeSnj/Ex2+mOFs/lYX31JNNEt5ND7rwJDqk8J/IWxlIgxHULSQGAbHy4vR
	 Ab6gTKZqE7ZsTqbBDt3+YSaG2w3bHZkHriJm1GxWwxWysIOKeg7rMMDhGoaLWBgNWNmEt
	 sLzLA3/xUsHTS2DJxSb0R+TrflaF0LVImTL17RmAU26LpRe4sy91Cnhe6OjpHe62XxLGK
	 bnDTITXprf159jPz7+B5GMNxg+pucWAWqIR/pxQLwhp/ypdxglQ3sDVZDB+4yGs3euA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v7NQo4vLiMmIaFf/Ub4zTfBfFawuDHZzaKiTTiFxbXw=;
	b=i6SX8Tbcw8xcCT+wDX2TICUbOAqbVLVvU57wt3G8G1wQAxcta/xuOG234Rgqz6XtdGK7
	 Fqz5vX5MRd9PtDskjpwbQRY1REn/u5mffwEtnKNB47zqgGGzhpjh4AOVVYiZknZsBhlGs
	 9jkYO8cIob0yp0WiZG3xRBEp00f68zmbWzD1SwK7sCOYdnKphoJf2A/Ig1uKPURlWT8r6
	 pdywAi+lZl/FoJEgUFtSJzKHBaS4fqQgcega1gRxFJ7Bfz0h6LlnCFj1nWwmMxSTVjHxz
	 R6bJuTcMfO9Rh6ElYI3AEdZr/gPSdnMzfvLvk1uqkymaCiVN97a855L/rWCv8njDBZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Qz/bi4YG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D1D606A31C;
	Wed, 18 Nov 2026 21:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qz/bi4YG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9521F000C4;
	Wed, 18 Nov 2026 21:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036808;
	bh=v7NQo4vLiMmIaFf/Ub4zTfBfFawuDHZzaKiTTiFxbXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qz/bi4YGrTh144kSYAAELnBjJ7ktLTCZwG7NuddGHfMK8CxwXuc21VKUNmkU5Hj1Z
	 hCpGRzu+x3Tv/FwsjvDInsGm5UvQat6tlaE0MPCd5E/51a+Lh0d4BwT8VQrOpbxiqn
	 ry71Pd+k7i6FmCwMS1LTCZULdKeAj+ySwDUlPxG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1190/3318] Documentation: hyperv: Update documentation for sending VMBus packets
Date: Wed, 18 Nov 2026 15:30:12 +0100
Message-ID: <20261118150355.862599071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhkelley58@gmail.com>

[ Upstream commit 6a3d77a0a8cf69cf3d234305e6711729eb5d10c4 ]

The functions for sending VMBus packets have changed.
vmbus_sendpacket_mpb_desc() can target multiple ranges, and
vmbus_sendpacket_pagebuffer() has been removed. vmbus_sendpacket_getid()
has been added. Update the documentation accordingly.

Fixes: 45a442fe369e ("Drivers: hv: vmbus: Remove vmbus_sendpacket_pagebuffer()")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virt/hyperv/vmbus.rst | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/hyperv/vmbus.rst b/Documentation/virt/hyperv/vmbus.rst
index d2012d9022c5e..3326bb103a5ab 100644
--- a/Documentation/virt/hyperv/vmbus.rst
+++ b/Documentation/virt/hyperv/vmbus.rst
@@ -141,14 +141,15 @@ Three functions exist to send VMbus messages:
 
 1. vmbus_sendpacket():  Control-only messages and messages with
    embedded data -- no GPAs
-2. vmbus_sendpacket_pagebuffer(): Message with list of GPAs
-   identifying data to transfer.  An offset and length is
-   associated with each GPA so that multiple discontinuous areas
-   of guest memory can be targeted.
-3. vmbus_sendpacket_mpb_desc(): Message with list of GPAs
-   identifying data to transfer.  A single offset and length is
-   associated with a list of GPAs.  The GPAs must describe a
-   single logical area of guest memory to be targeted.
+2. vmbus_sendpacket_getid(): Similar to vmbus_sendpacket() but returns
+   a transaction ID that is matched against a reply from the Hyper-V
+   host. Useful when the struct completion (or other rendezvous data)
+   must reside on the caller's stack. By invalidating the transaction
+   ID before exiting the function due to a timeout or other error, a
+   late arriving interrupt is assured to not trash the stack.
+3. vmbus_sendpacket_mpb_desc(): Message with one or more data ranges
+   to target. Each range consists of a single offset and length plus
+   a list of GPAs that describe a logical area of guest memory.
 
 Historically, Linux guests have trusted Hyper-V to send well-formed
 and valid messages, and Linux drivers for synthetic devices did not
-- 
2.53.0



