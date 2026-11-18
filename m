Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039696;
	b=h7i0msBi0GQwuewBdcV68kNAT+gjM2q2v86Y+gMvhtmvicK/glr+6q0zTyKQheVZjBZ1
	 pycEvbWWG5eiXZgLWKjwBQb5GNLDj1wcerNv6DiPNAt4VT4T0BDzGvpnyDeyJhoESQbGy
	 eD/dMzNKxlQGQUT+wss763f/qyWaU4OoacaS0vdNVHXLAnwFuwf6Ojf58iQCeZ8CUZjfC
	 HmdzfQvSWaPzcstnfkFbvHS7w9cW+XmxDzsJk6yOgkWA1O4QFeaOwKZhFGGbDzh1XEyI1
	 UvCylnPJ1X8aniDW0kk6jCVa3EqNsfizpRYXSvgnwfiDLnfXiYLwTXegV6IAqYq4jiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gagqSsbjPGHCzXSEsx6WxEdnbMKPk11VS6V63oaqtUc=;
	b=Qg4JZ/OP82jVeXH+edbw7OXmH8J3sWXle7YmO+0J91f3AfuApAaSEz/WZX4z/a57IXEK
	 5jIJ29DLrKhq/DYHovAHYQiLf/wgmknr3VhamVtEreHUkn0dLsKmrt3F2al2O0eiOdMDh
	 YgOJvTXz/T76Gl2yy7HKvOtDe5wsBgrab2mIBK1cWtXu5anHUBEQNwWiqFTUi/luXhmrl
	 O5p24oA6v1qUgjwUR+awnwksOn+HxD6j4CcbZSD5tPsGnyFLE2pTl5iKc4t9crmzJo5OA
	 3XmNLDsKAu5x7txBJBPxbuc6mMkHI1jIfgrd5s8mGrLDi49j18eutpDGAj4M8gJ5cIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jzxGcIh1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DD8606A330;
	Wed, 18 Nov 2026 22:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jzxGcIh1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7766E1F000C4;
	Wed, 18 Nov 2026 22:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039696;
	bh=gagqSsbjPGHCzXSEsx6WxEdnbMKPk11VS6V63oaqtUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzxGcIh1tt1pLn4GXS13bNvR4Y4Y4RTmS+OkUHpS2YSlOK3X53YxdugnhnotZT6VZ
	 236fLM//Bd9MUK96Sph0Nhd/wk1Vc6Ww34hu4ST0v4Me4D7sPASYIKNoeNS+rPgcGK
	 9sYrM76klm5ESyUg+bNcSX/2GxT9ybFl6t4PydNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2193/3318] ata: libata-scsi: Fix ata_scsi_hotplug() reference in kernel-doc
Date: Wed, 18 Nov 2026 15:46:55 +0100
Message-ID: <20261118150427.737324129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 5915ab523e33057224a0240e27b88c6c2798b919 ]

The ata_scsi_remove_dev() comment misspells its caller as
ata_eh_scsi_hotplug(). The caller is ata_scsi_hotplug(). Correct the
reference, which predates libata's move from drivers/scsi to
drivers/ata.

Fixes: 580b2102327a ("[PATCH] libata-hp: implement SCSI part of hotplug")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260912101215.86413-1-kmehltretter@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5f8548a4f3a8f..b9c6d953af8e6 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4651,7 +4651,7 @@ int ata_scsi_offline_dev(struct ata_device *dev)
  *	ata_scsi_remove_dev - remove attached SCSI device
  *	@dev: ATA device to remove attached SCSI device for
  *
- *	This function is called from ata_eh_scsi_hotplug() and
+ *	This function is called from ata_scsi_hotplug() and
  *	responsible for removing the SCSI device attached to @dev.
  *
  *	LOCKING:
-- 
2.53.0



