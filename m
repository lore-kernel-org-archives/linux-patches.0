Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620421;
	b=CC3/K6/BnPRJq+IOkGJUcxgeomIOyAgS8KAhZulgv4S1OHHwj29AbEnXVdEYZwWW9bdI
	 rzt20Lb4mF01NajPFLOZViRvFE8ps9CyTE8NqLMreipnrl2K63pIHJzvaV/6+uHh/58e2
	 8ZSTPTyNQUzZP+nsoHlSkz5qwcYc+bQzKzBXn33Ujnuw99puNXmdDmZcQ+dvIG7EshPL2
	 5BBql5C4zSVzIEmcMzDeMA4jgm6Lv5q5q7Bd25A2bctjfnI1BNlRC4nsSA9gbzZOKp2ZR
	 E0ph2QCS+Gpqv33MRR/iGLLy9rqgwnEY4XlKUmCVstvE/G+Szw7wUX2Bqy1Wb7vrJog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d99ErwmnBTJr+slHYjds0Gh8zlh+xdGNp9E3bLxreiw=;
	b=YOQQIMY2Dz9uwcq/f0+dFJHPA7Vl0Nh5pnZqRrgrsIKXtyOm/vwv8hvC32mVwBHVwAz7
	 XS4OOaB1DqJiYviEXICndAG4pTpjuuDo8NImeaEyYB/OxpWBVoGupsLrZMQ136kyVjnZ7
	 z8fV51L5BE6GNuu78meWtp/4ljZJnwduRPWL/Ly1WT4muZbKhrMdluFrjNdyzG5+Myowf
	 uQYRZMixItgQhHaR6XQDmEyGt4hTnCyxvh1o3rauSSnsN/NX2sfgzD8K7ofYGVGAgjJF5
	 AWzsfudLQYwc2EbEujbMWAYWke3I6efhfNmMU0CV6zmg4Nbyp/dZK71HzdlwRODigvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYdWKDGU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C87606A321;
	Wed, 25 Nov 2026 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYdWKDGU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5E61F000CA;
	Wed, 25 Nov 2026 15:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620421;
	bh=d99ErwmnBTJr+slHYjds0Gh8zlh+xdGNp9E3bLxreiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYdWKDGUBSDAqs2WJjWM4VMsVOpcMVUHUz3nSFnlxmhX6o9JreYZLsvgXYb8X3wJ1
	 YBr6dqHQNzT2czjC+1ildRGscsOK6lJ35PvKQCrRXrWuZdI09x5xzcCCn8fQwQtUXS
	 AxDxh7sawvnQnRhvccDuZ+IAIzbX6ahlvPRgrsdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andreas Noever <andreas.noever@gmail.com>,
	Mika Westerberg <westeri@kernel.org>,
	Yehezkel Bernat <YehezkelShB@gmail.com>,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 7.3 0912/1005] thunderbolt: stream: Undo more if the start fails
Date: Wed, 25 Nov 2026 15:37:30 +0100
Message-ID: <20261125143843.056704980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 03e3c33fe074ba57ae4457894fe5b6a90e3be6ee upstream.

If the receive buffers cannot be allocated or mapped,
tbstream_dev_start() stops and frees the rings, but

 - leaves the DMA paths through the XDomain connection enabled, with the
   hop IDs of rings which no longer exist;
 - does not release the frame array and the pages which
   tbstream_dev_alloc_rx_buffers() had allocated and mapped before it
   failed.

Fixes: 6db21d817b43 ("thunderbolt: Add support for USB4STREAM")
Cc: stable <stable@kernel.org>
Cc: Andreas Noever <andreas.noever@gmail.com>
Cc: Mika Westerberg <westeri@kernel.org>
Cc: Yehezkel Bernat <YehezkelShB@gmail.com>
Cc: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Mika Westerberg (Intel) <westeri@kernel.org>
Link: https://patch.msgid.link/2026102751-nibble-synapse-d406@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/stream.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/thunderbolt/stream.c
+++ b/drivers/thunderbolt/stream.c
@@ -630,6 +630,12 @@ static int tbstream_dev_start(struct tbs
 err_stop:
 	tb_ring_stop(sdev->rx_ring.ring);
 	tb_ring_stop(sdev->tx_ring.ring);
+	tb_xdomain_disable_paths(xd, sdev->out_hopid,
+				 sdev->tx_ring.ring->hop,
+				 sdev->in_hopid,
+				 sdev->rx_ring.ring->hop);
+	if (sdev->rx_ring.frames)
+		tbstream_ring_free(&sdev->rx_ring);
 err_free_rx:
 	tb_ring_free(sdev->rx_ring.ring);
 err_free_tx_buffers:


