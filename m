Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018399;
	b=21hJbLeDB3H03s3aTL9CRou/BoLnXyG3ecBwlEcB36/FtBAlxKx/1rajxAykvYv++sFo
	 eUVHAKnyTPRTBnRfdY1nmNMIjUcjhxZMfovrr/64Yv2HXFPytU9MRCYKhdP67TMtbsPJC
	 Mi0G6WkHCbqbebmktALpdSJ7a3ZHT0GODINN34IVXp2uSj++vJ0C7DbdSp4s5G94Jq/UQ
	 9OsL1kAfewDu+u/H0rxeJJ44gIfPB5u4z1jF9mNVya2yjXrRlRDaR2TbNbBAjbXw8KEFI
	 wXYLFewQVXUyMoNRuFcsqwoRocDYY1sSYVuQDW6k41HEL45SyeeL8KIrdw19lPQamUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K6C6bWxVBpkM5XS9AXRCUjAAhc8rHBhUP80+eAWHyUs=;
	b=VqCjB1yM++Ct4AnjkMinNdpDBVEs4N+/eoXDSZXuPUza2I5RHE6fFaqXME2Ph2sC9myt
	 X5ieGskrnuftsP8D7DEyOMWv+7Bt1U843CeSdYjbaSN50nIO71saXA7CAyaDsxdzuzXaT
	 t//YiD5dy/3wO51YhY7Cf0NOncQM62POlyXA7l0+7fvNUpoPY52iZ1WNGDnogAOwGAvBg
	 k2eBeEqhAOhFP7gprarMI/aajpyWOrsD3kEb/256Prji0DUgW15+SPuKy4JhmwprN+YDJ
	 bgD8/ih0kpQEc6QDCxWbtWaNcYBbg0exiPCWE0rYZGxxC/MEMe79vlOHgRjz/uw0SBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X19pkgXU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4127A606A31C;
	Wed, 18 Nov 2026 16:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X19pkgXU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0A51F000C7;
	Wed, 18 Nov 2026 16:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018398;
	bh=K6C6bWxVBpkM5XS9AXRCUjAAhc8rHBhUP80+eAWHyUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X19pkgXU94MZ1vp0s5d/lN/yeqvF+chnD2KO/+LGr9jNppZAIjfXGTvxU2676uUgb
	 6ql8XVQqVcClQApIjdaCduReOKxKCgYa2fC3dUyqhTFrWkvu+fH5H/cf4AaDJNQzDV
	 b/4P/WnfNlBY7L0ZufnU42tXtNCx6c+jBAR1G9Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1227/2651] scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
Date: Wed, 18 Nov 2026 15:41:07 +0100
Message-ID: <20261118150332.182603905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit b81608b17c5d04c797e6fc1cfb95182c842a4db9 ]

A write whose data-out buffer is shorter than its transfer length is
short. An ordinary write transfers what the buffer holds and reports the
rest as a residual, but an atomic write cannot be short: SBC-6 r02 (T10/BSR
INCITS 587), 4.28.1, requires each atomic write operation to write either
all of its data or none of it, and 4.28.2 requires one that cannot complete
to leave the LBAs that it specifies unaltered.

resp_atomic_write() does fail a short WRITE ATOMIC (16) with DID_ERROR, but
only after do_device_access() has returned, and do_device_access() copies
one logical block at a time, so by then the blocks that the buffer did hold
have been written. An eight block WRITE ATOMIC (16) with a buffer of four
fails having overwritten the first four.

Check the length of the buffer before writing anything, and fail the
command with the same DID_ERROR as before.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-26-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8e152f8a9f62a..a9021e5448abd 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6050,6 +6050,14 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	/*
+	 * Short atomic writes are not allowed: SBC-6 4.28.2 requires an
+	 * atomic write that cannot complete to leave its LBAs unaltered, and
+	 * do_device_access() would already have written part of it.
+	 */
+	if (scsi_bufflen(scp) < len * sdebug_sector_size)
+		return DID_ERROR << 16;
+
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
-- 
2.53.0



