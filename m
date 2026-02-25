Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD472C17A0;
	Wed, 25 Feb 2026 06:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002621; cv=none; b=Rzd6LgOZ+ssCGzIcvpLuKXLLUUen74DaXXXFzK7quDhyf4XFTfeJK4zKGKTujSyDJqGE8n8O/QOXDEwvwqzXNwUNCFfSpeZjhN7QDXDQmjTr2TkZuRqavbW1AFcQ3J9o6Im8ZS40sBewyVCH28DHiYjdd1gRWjiqe3Wq+Y7nOyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002621; c=relaxed/simple;
	bh=u69G7a5mOzzXIW8bQAqbKJ6tdSDmxMsqBKh0sN2QJrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fABUL8+nBkkwBGY8WUTQoTw8bhzgM7RVzP3WUHYykS8xc4xGM0UlkIQEDB3EVmYkj7AlCU9WbrekW3pCg035gJEvbPKUCTh3v4OxEq7ebLJ77HHi3P0zZ9JK8DH6hJl0+VhdfdaXACnYTWp6AYg2tIpKQHlzwshxWxQcvIur344=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1UTWa4Ms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1UTWa4Ms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACB4C116D0;
	Wed, 25 Feb 2026 06:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002621;
	bh=u69G7a5mOzzXIW8bQAqbKJ6tdSDmxMsqBKh0sN2QJrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1UTWa4Ms/WorRuWGSsM26fDh9Lshay7SankOMKxHJY7b3Cr5j+RAWVLK9y4GFssm8
	 qKR1nEpnm0HkMIL8Yim5mMek+N+DzIC014ySyUqloS/NxevF+/PLb54CB1DjwL4+6U
	 j2CnCTR5jB0rCQ/FqpYDIs8FxDkbIXevq1exEqnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 335/641] octeontx2-pf: Unregister devlink on probe failure
Date: Tue, 24 Feb 2026 17:21:01 -0800
Message-ID: <20260225012356.796893848@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 943f3b8bfbf297cf74392b50a7108ce1fe4cbd8c ]

When probe fails after devlink registration, the missing devlink unregister
call causing a memory leak.

Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20260206182645.4032737-1-hkelam@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index a7a7bc0e1b675..bbf25769f4994 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -3321,6 +3321,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_sriov_cleannup:
 	otx2_sriov_vfcfg_cleanup(pf);
 err_pf_sriov_init:
+	otx2_unregister_dl(pf);
 	otx2_shutdown_tc(pf);
 err_mcam_flow_del:
 	otx2_mcam_flow_del(pf);
-- 
2.51.0



