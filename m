Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF9B145A05;
	Fri,  6 Dec 2024 15:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498317; cv=none; b=TJGTfnWKeuGo3x+pwI9dLPPevRRHdpEelFt75FrRBWDvb1fiKuNNCW3pRYwn91d+oaiGEYq1v6CSF0TfKs6b0CMx9DTQOEsxkCaFOQ9hPhLX8RVpWZUD50d6THx3kYORzvb0Zuf1uT7SlKJGBVoZImFDbF4hRYyN2Sah5CRyS90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498317; c=relaxed/simple;
	bh=WkHiNVMsy2x0HSehbJe3I99uS8JxiokAp4MGRJ0uTfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaC0hWXwVs/1YbJs4eFs5Xif0yZNh1aMLFDIyEE71cUxn83B3CXLUDgBsXpyOwP0C3BqCxfDuchL/g8x2HyKxyUmB1dmgqHfoM3QuexaRb3MtSgLCp1yS8/XW1GhPF6Och1JYXXmf+Qrdgznbx0fTWwFEoKVig5lMRAa6YjPPoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhaGjEEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhaGjEEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D849C4CED1;
	Fri,  6 Dec 2024 15:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498317;
	bh=WkHiNVMsy2x0HSehbJe3I99uS8JxiokAp4MGRJ0uTfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhaGjEElToxXExj+KYkzIwj1hoFhQdrkwcsVV/ChLm4/WWQRnKGHlveiuzUK4eund
	 14chCcT/g44lTvFtwav8v2Km/+jL1P+nF0RFoKr4SYm+86eudPEeF+F7Eyt0mX5k77
	 iw0cBIuz4c9VtJ2LfLxDjxzIF+kEPlkS+LVGaJh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 548/676] ublk: fix error code for unsupported command
Date: Fri,  6 Dec 2024 15:36:07 +0100
Message-ID: <20241206143714.762222339@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2913,7 +2913,7 @@ static int ublk_ctrl_uring_cmd(struct io
 		ret = ublk_ctrl_end_recovery(ub, cmd);
 		break;
 	default:
-		ret = -ENOTSUPP;
+		ret = -EOPNOTSUPP;
 		break;
 	}
 


