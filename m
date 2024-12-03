Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBD71EE00B;
	Tue,  3 Dec 2024 16:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242641; cv=none; b=j5NvXTqLJ+I/0SW9A3X+viQ9iSkwpKJ88tpLmhinavrNNKNHcxiiTvnL4ELHlCCbPypeReS6g2RXOE69YqcWHdFq6Qk5LSPEPwEw6COF2kp41Sj2IY4bsX345fshEFT8x6gYPvxuNPgVjKzUNLAfiVDmf/+gdakCEJH2JVNzZgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242641; c=relaxed/simple;
	bh=BUcvVKn9zAMfaMsxDSEWNsBitaI4Wh6Ic+d190pUQ58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNCDZHsgOjs3hUZyhx8rv769sLOddD7thpSH5AIFc6KOL0j3HmE+yo9x1XV2NU72S8VANTWXM4/YFUyF9P8uhxZEdoeoKsy60yzKKgLrerpEln4+CkrspfRtUNj6Lu+EFjXEq8ubCmexjNS+u/sKT9qVMIEuny8tAQS7e0QmH68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGV7XPM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGV7XPM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F93C4CECF;
	Tue,  3 Dec 2024 16:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242641;
	bh=BUcvVKn9zAMfaMsxDSEWNsBitaI4Wh6Ic+d190pUQ58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGV7XPM20STkRhATUe7mJUsLzQmdj9MgVDG3ThQMMVseWgRvhkInSdSoFWDO/AsTZ
	 popt6/Xs/uEe3i+cisdTy3Ai4z/W7Q5fV+EjuS0B6XOzz0aNLcYBSrKpZonxV6oIon
	 4z3dF5RBDj4Pq02dcR0oZyfzGm3ntTC9xpnLOiTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 765/826] ublk: fix error code for unsupported command
Date: Tue,  3 Dec 2024 15:48:12 +0100
Message-ID: <20241203144813.606802636@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit 34c1227035b3ab930a1ae6ab6f22fec1af8ab09e upstream.

ENOTSUPP is for kernel use only, and shouldn't be sent to userspace.

Fix it by replacing it with EOPNOTSUPP.

Cc: stable@vger.kernel.org
Fixes: bfbcef036396 ("ublk_drv: move ublk_get_device_from_id into ublk_ctrl_uring_cmd")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241119030646.2319030-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2974,7 +2974,7 @@ static int ublk_ctrl_uring_cmd(struct io
 		ret = ublk_ctrl_end_recovery(ub, cmd);
 		break;
 	default:
-		ret = -ENOTSUPP;
+		ret = -EOPNOTSUPP;
 		break;
 	}
 


