Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CF84645F;
	Wed, 20 Dec 2023 16:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWSpsn0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D97BC433C7;
	Wed, 20 Dec 2023 16:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088898;
	bh=uag8lbc0CViuzSJS0DLQl8z4TbWgRbnG7DSlA+f58e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWSpsn0H+gyo3yskz/55/0plbGXWobrC7nJnhhPxme6DDVvGDbMTamTKljaADuT92
	 wWEOYHfOhPuTBNEV7nl/MBPIki2UHaDtv694+/YKXfvs6lbUJ1tt7VpPGpsipfIn4o
	 NhzBy4oASidflllidxsfBTrpm1xnpT7SihRAy7oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Talpey <tom@talpey.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 059/159] ksmbd: reduce server smbdirect max send/receive segment sizes
Date: Wed, 20 Dec 2023 17:08:44 +0100
Message-ID: <20231220160934.096829727@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Talpey <tom@talpey.com>

[ Upstream commit 78af146e109bef5b3c411964141c6f8adbccd3b0 ]

Reduce ksmbd smbdirect max segment send and receive size to 1364
to match protocol norms. Larger buffers are unnecessary and add
significant memory overhead.

Signed-off-by: Tom Talpey <tom@talpey.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_rdma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -62,13 +62,13 @@ static int smb_direct_receive_credit_max
 static int smb_direct_send_credit_target = 255;
 
 /* The maximum single message size can be sent to remote peer */
-static int smb_direct_max_send_size = 8192;
+static int smb_direct_max_send_size = 1364;
 
 /*  The maximum fragmented upper-layer payload receive size supported */
 static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
 
 /*  The maximum single-message size which can be received */
-static int smb_direct_max_receive_size = 8192;
+static int smb_direct_max_receive_size = 1364;
 
 static int smb_direct_max_read_write_size = SMBD_DEFAULT_IOSIZE;
 


