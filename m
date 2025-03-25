Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D513F26770A;
	Tue, 25 Mar 2025 12:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905808; cv=none; b=j822aF1CBsQXe15/knx61blzqcdvMWd/0FIFfN52mp1O00cHoFN4E2NEEMp7afmg+pjE4keR/8YHmjIQLBJmD7NCrzXIJaAnLRH0M7yDYGkwjo2ibeA+OF3qQ3FQOzpaXUB/Y/ev9LBOJGOc6RsmBMYr+BLpMTHznQzyzhyytuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905808; c=relaxed/simple;
	bh=1ClDAEhZBpv5k0XdZXnyKLovgg9R3FWQmvBsSRKNObU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxG8TVbXvHMusa4UdzYACOOMDf2YoAc7DF1iEt4uVgOo/JQQYK9kHB/Ir9rUZQMTNu2kSt9Ula62ErSiFs5DyV7AYexoL4YLGPH/FjS2XVk0kP2dV1IM47oW3Vr34KP7VsXPa0MuYWX+JuwXc4Dl8hD9QDyw+lhWzKMjur4XWpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvAderSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvAderSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE0FC4CEED;
	Tue, 25 Mar 2025 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905807;
	bh=1ClDAEhZBpv5k0XdZXnyKLovgg9R3FWQmvBsSRKNObU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvAderSq2TU8s52eOGt/zbE4gyg0bN5rX72RU9JyV6Cv4OQyvPVNhEIMtozcrHLb1
	 bYtjNge+bq52oTF2YJzQLkC7oOzhPur972pp4VDHisZ+zxQuBlmZxHmDdh5XzX3EoP
	 Aw39XjxNC6CV4zRi884fMsxA9fI7JT92fp/3rN3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 144/198] nvme-tcp: Fix a C2HTermReq error message
Date: Tue, 25 Mar 2025 08:21:46 -0400
Message-ID: <20250325122200.437134243@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -706,7 +706,7 @@ static void nvme_tcp_handle_c2h_term(str
 		[NVME_TCP_FES_PDU_SEQ_ERR] = "PDU Sequence Error",
 		[NVME_TCP_FES_HDR_DIGEST_ERR] = "Header Digest Error",
 		[NVME_TCP_FES_DATA_OUT_OF_RANGE] = "Data Transfer Out Of Range",
-		[NVME_TCP_FES_R2T_LIMIT_EXCEEDED] = "R2T Limit Exceeded",
+		[NVME_TCP_FES_DATA_LIMIT_EXCEEDED] = "Data Transfer Limit Exceeded",
 		[NVME_TCP_FES_UNSUPPORTED_PARAM] = "Unsupported Parameter",
 	};
 


