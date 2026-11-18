Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049436;
	b=Ks1KaPEbMc1++uOkj7Ns7snK8dsMeWGzjs9wchIjCns1rIU+5Ok7KFRBiemltolq2Wp4
	 IVDUW8PMfrabK9nav8b/C0i6bJJdUv/nZWqIfH8eRi2UgZD4ZsiRCFiyNLgSbF/yIvPA+
	 LGoG81YwiiPbFvguhO77Et0EnGxQpeLPjS8GkSKIKjfztZA8mca2EJvjYtq5PXk3ZjBaE
	 aV2yyG+tztivIhffWALHUkO0fv9FgU6/2aTf3+5vRSp6a+DImlYFkHpOudCoM1XItpVDQ
	 VzYaHiiMFdViCKfzJLcAHuQMROF9NkiyX3J9ojTb2uFDADNgyi0zLRZZKbZMmIhViZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dNcz/nJmTzPca1C2eWELhkx36/xZbRsnJFzCYmAwJl8=;
	b=e8mEwTdmCUe31rBxU6VwJ1l9etaE1fKMxy5I2SEydvK+YmU0xXjIr9iR24/4DIOohMZg
	 tb+v2/eRgB/UD92jxzBLmQWRu8JuYmk4gyKwN4e00wbTBIVM1P4phU4gt/5ahVUQzoeZ3
	 rZWogHVtk28MI1cqBV0lQjOuW+EwLldoAC6E4H87fcqaHnf736H/gRwPnA5wYLYH3xrRZ
	 9K8mH64HTOvhHsU0mapyv5tYnlLzC/03OLKvAPk+NWFvehu8ZN7NCGhacl9roFAAH1myM
	 Q0d2Uj1bLG2WgHZQMrMYx3PqMFcyU272HisMfN7sJIUJwyCbrGYYAxblrAMjNl8Vq9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nHuxdOE0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6831F606A320;
	Thu, 19 Nov 2026 00:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nHuxdOE0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08F91F000C4;
	Thu, 19 Nov 2026 00:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049436;
	bh=dNcz/nJmTzPca1C2eWELhkx36/xZbRsnJFzCYmAwJl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nHuxdOE0dAWuZDWA0CuFeYovLaCIdejJV1OwV0h8AU1hV7+8Ivs5iuW8sxKf/dNqT
	 EJTPoci8KtoDx6pcBqiwHV0X9hm+Mi3CIOLVa6IygJRBxWFPpbe/IuBR7PmhuWP7BM
	 ObKgvSb+tn2BZnGt3z+ijoLf4tZiMS+EY0/kRdyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Tushar Dave <tdave@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2350/2857] PCI/P2PDMA: Safely terminate ACS redirect lists
Date: Wed, 18 Nov 2026 15:56:24 +0100
Message-ID: <20261118150326.139943573@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit fa291d6429ebc1efb7fab011f643b842ae5f23f1 ]

seq_buf marks an overflow by setting len to size + 1. The ACS diagnostic
path unconditionally writes a terminator to buffer[len - 1], so a path with
enough ACS ports to fill the 128-byte buffer writes one byte beyond the
buffer when verbose diagnostics are requested.

Use seq_buf_str() to terminate truncated output safely and remove the final
semicolon only when the buffer did not overflow.

Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/20260830-batch-p2p-fixes-v1-4-5044e8dfbe2e@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/p2pdma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index d5e38c6a812f0..a4210960bba10 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -515,11 +515,13 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	}
 
 	if (verbose) {
-		acs_list.buffer[acs_list.len-1] = 0; /* drop final semicolon */
+		/* Drop the final semicolon; the list is not empty here */
+		if (!seq_buf_has_overflowed(&acs_list))
+			acs_list.buffer[acs_list.len - 1] = '\0';
 		pci_warn(client, "ACS redirect is set between the client and provider (%s)\n",
 			 pci_name(provider));
 		pci_warn(client, "to disable ACS redirect for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
-			 acs_list.buffer);
+			 seq_buf_str(&acs_list));
 	}
 	acs_redirects = true;
 
-- 
2.53.0



