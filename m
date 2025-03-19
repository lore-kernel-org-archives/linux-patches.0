Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BEC1DF73E;
	Wed, 19 Mar 2025 14:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395276; cv=none; b=FQ1s0hNmufXW3MmB0C1DZ7B78sUscS+Khfkxj13cMzAlewUILu/Xc6nz0QtXJnBqwc9l/qv16c/jXEnncvYsQWBAwEcstQXH8qxzFK7u84TI7pI1qICVwDfRO8M4M/yah+pY/YTt2Jxr3etX3qcRlheJ9gpONuJDnwfDpcBEhMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395276; c=relaxed/simple;
	bh=XTknMGRFawRHsBgWc98yfSkjEKd+z0wvMelgsIjW+4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1X1UBikiB1mFXwWR2wpvXM8ml6Ozl7VhCuF9l4TlJjMD3ITeOVBV7oD7oLywXhuPg3BL+X4/gGAXmpnXh4kbv8Our6viB2U9OrLJbNBKRXEBqEyop/b9njDzOiOpW+QSrgZ85LF+9TpXlvm3Ku2sXAXYcboVxpW6xCBY+mekTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5BeSACN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5BeSACN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8768DC4CEE4;
	Wed, 19 Mar 2025 14:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395276;
	bh=XTknMGRFawRHsBgWc98yfSkjEKd+z0wvMelgsIjW+4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5BeSACN/DtHw6Sv2sv5iBAzMIjwdfjEoIHmCPjakGqSnMEmQFZ7QRTu5SotW52X3
	 XMUnRQ/FnBA2BjoT56BsDMyKTngpMFzd6J6BFwzKtiKwETvCiiFJqcfGJhKWrhHFLq
	 ef94FlJabXUCvKlyHhH/Ts6FFVjHu+EMrhE/AEMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 162/166] nvme-tcp: Fix a C2HTermReq error message
Date: Wed, 19 Mar 2025 07:32:13 -0700
Message-ID: <20250319143024.416411466@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maurizio Lombardi <mlombard@redhat.com>

commit afb41b08c44e5386f2f52fa859010ac4afd2b66f upstream.

In H2CTermReq, a FES with value 0x05 means "R2T Limit Exceeded"; but
in C2HTermReq the same value has a different meaning (Data Transfer Limit
Exceeded).

Fixes: 84e009042d0f ("nvme-tcp: add basic support for the C2HTermReq PDU")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -719,7 +719,7 @@ static void nvme_tcp_handle_c2h_term(str
 		[NVME_TCP_FES_PDU_SEQ_ERR] = "PDU Sequence Error",
 		[NVME_TCP_FES_HDR_DIGEST_ERR] = "Header Digest Error",
 		[NVME_TCP_FES_DATA_OUT_OF_RANGE] = "Data Transfer Out Of Range",
-		[NVME_TCP_FES_R2T_LIMIT_EXCEEDED] = "R2T Limit Exceeded",
+		[NVME_TCP_FES_DATA_LIMIT_EXCEEDED] = "Data Transfer Limit Exceeded",
 		[NVME_TCP_FES_UNSUPPORTED_PARAM] = "Unsupported Parameter",
 	};
 


