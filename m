Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063570;
	b=XGzwtn0/0lTX55qwVGPyVDZcs18JjF/PdJIueNc7G9BExiEyKuRBqeDo3p3CqyH/3d7T
	 FRRS58VvTgQvwR1Twi3YRh5Nzl2dDGIw0G1KvrPzGqRG2M5imfjhd4wuxBLcHZptRE3IK
	 AlBbRQAsHIq3OMS94maEntmQroXPgg5iaAkshWu/37l+A32ozHxJzppqlwEhEwNjMO+oc
	 x29FamwB/T6BXvQPYQxXx8W4SmDEpIgsOtI8HLefFF8NVOBxeNeOacl09wKh+Br5CxTJF
	 ALQ4fvSEDzvNGAKfsiLIxxPWsqp//kqBtfsproI2FSDLJhyI2sBkqobscPuejM5FdCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jKkaUrCEfk4wfnvETEa2Twj6Dml7LHBXmZuVIXR9fSU=;
	b=O9DPhdpkCIvX0Db5i/39YTv/4sR27U0dkuT5cbDCMNXNZV9X0W/Zlpgow+oJBR/mPz6u
	 zy0pM+foo2jCfRQSPKR7/47MA8qaOjvO8nA/VZnwRHxKjcFaHYK+l359k/HAwvOsLUPbl
	 xAsgXkhnfShjcw0dD6Edh2xpk2EZURXU3lpvABGIOB7gCKqaBINwgOytsyCP8b2DKVdOZ
	 lzJkqQYmTXt1qkrxuN0cm2cqQt4jDtgXaHzrN2w/yJb78lKEgg0gxKkuJAIlVPE8qXNw9
	 YnO+4LqIXCb4p/lVWBFMbtNuG+XaDyHtxHNZvXpNY/OHQxJeYhLuNF8mp+TJqIkmxtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLlrMZNN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36005606D829;
	Sat,  7 Nov 2026 14:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLlrMZNN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47ED1F008A2;
	Sat,  7 Nov 2026 14:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063570;
	bh=jKkaUrCEfk4wfnvETEa2Twj6Dml7LHBXmZuVIXR9fSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLlrMZNNOIobxk06lsX1vOSeXzeWLYU2x/X9R3i8AkB0MSLdjPTyHVO2/7cKJ3Gcy
	 5rFEbN9cIrEa354icw7UHb1vPZSWRFzdc7E3MJCCi+56FkGUvfEZVLOMCBnSn5R2Ry
	 goYRJrY1cxFljPpKmtxKaUHi7d3vb2hMbhwEdKjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 701/869] Documentation: hyperv: Update documentation for sending VMBus packets
Date: Sat,  7 Nov 2026 08:56:23 -0500
Message-ID: <20261107134916.717754626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 654bb48499724..c546e821ce6b2 100644
--- a/Documentation/virt/hyperv/vmbus.rst
+++ b/Documentation/virt/hyperv/vmbus.rst
@@ -141,14 +141,15 @@ Three functions exist to send VMBus channel messages:
 
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



