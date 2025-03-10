Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9921B81E;
	Mon, 10 Mar 2025 17:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627815; cv=none; b=pzMJs1mHhlkkfurPorhYFDSiQZ8Je+eorsu9YPAx7lCD64Y043/ED5krFArtKsfTP1KbIj00BcVg+nQp6U2g55qH/RdEhAsHxdeo4DpJOC2DiUUywBi4//k4RlYYVYQFqyVIIUUbJUlsYG0cGHZacPfjTj5lflY37eCJXtbbsLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627815; c=relaxed/simple;
	bh=8pxBmFDl0I4ADAUputZGrSAb0LU9wh2vbu99B1Ol48Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2QTsPIDeXClJEbLBbiaHlVSr4pg9PMVZEBZ1ob/roa3+hQb8NUZPG0JKEcaZ6ggOFtY/9wMds/KMKF5Y79CoP678CY0x2XY+Z3nnCO564apTCjvWV47mWfmGidh/p+Yu6HfF/4Hr576858nM/HY9vAuXoldG7+fksFwjqwqm9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hi7tOrNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hi7tOrNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200B3C4CEE5;
	Mon, 10 Mar 2025 17:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627815;
	bh=8pxBmFDl0I4ADAUputZGrSAb0LU9wh2vbu99B1Ol48Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hi7tOrNICgjMyJXmI7d5gxlF/bmvYI3aNVUaJ24YJauObd15G8h5orbEJtFzgJmar
	 Y59Og/+oGpLtY5a8PoYzn+RAKKTkcR6qxZf2Gi8/vcDLhxNHjNaJ21PZSzB1O7+AmI
	 rn2tveMMDLY8Zk3Hks/T55FhD1wEpmx6WDIWDxME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 260/269] nvme-tcp: Fix a C2HTermReq error message
Date: Mon, 10 Mar 2025 18:06:53 +0100
Message-ID: <20250310170508.152618082@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -788,7 +788,7 @@ static void nvme_tcp_handle_c2h_term(str
 		[NVME_TCP_FES_PDU_SEQ_ERR] = "PDU Sequence Error",
 		[NVME_TCP_FES_HDR_DIGEST_ERR] = "Header Digest Error",
 		[NVME_TCP_FES_DATA_OUT_OF_RANGE] = "Data Transfer Out Of Range",
-		[NVME_TCP_FES_R2T_LIMIT_EXCEEDED] = "R2T Limit Exceeded",
+		[NVME_TCP_FES_DATA_LIMIT_EXCEEDED] = "Data Transfer Limit Exceeded",
 		[NVME_TCP_FES_UNSUPPORTED_PARAM] = "Unsupported Parameter",
 	};
 


