Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD59CA40;
	Tue, 16 Jul 2024 15:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144268; cv=none; b=GGZ/zzeDY0OZKErq43P/H1mrdDrzljGeTK1p0PVnPJ36IuTxVmvvSM07ADgRvLxYJmO7hGqizoipqqQKZ6kal2guFeyVBkYE2IftBZvXrI+Z+E7jU5/sqIFLaPBn6gYgeqL7EPPVA6PLwBKwQSGhs4LXel+1onM9xIi4vfiFU5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144268; c=relaxed/simple;
	bh=okEkkQkJOr5rBJPS0PpnthAfOd49Zc0bbatciLvcaFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0aZ6ivqJtSwKoLRLCDDOaTXGj3PXuyP3JOEYzWJYDTFk/2momPSSrER6OJb0O9xmxFNJovO8DpY4tvxByET+Soz0a+oYCbExOedwid+VPRcP+ntjLxdy5qX3xsIsLcwT5ih5lf/WpdYD6TUREj72bCpXafsna4fqnRR0YDpCUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owLR6ea4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owLR6ea4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510D3C116B1;
	Tue, 16 Jul 2024 15:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144268;
	bh=okEkkQkJOr5rBJPS0PpnthAfOd49Zc0bbatciLvcaFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owLR6ea4ljnV0MCRuEePt6/8MoKA1MvHHmbG7zWc2jeq19lt8oPEst+9cE0PBNt0L
	 2zUASeXAJ9HoXa8XqfgizAtaW0uvf1YrQF6a3miMfQgbgahZDdmuMl1ZvK4j2zGFRq
	 wnT8G/w7p90Pgbrbf+P8JCoi5R7gTpW3WDxVPBxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/78] i2c: i801: Annotate apanel_addr as __ro_after_init
Date: Tue, 16 Jul 2024 17:30:48 +0200
Message-ID: <20240716152741.258406866@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 355b1513b1e97b6cef84b786c6480325dfd3753d ]

Annotate this variable as __ro_after_init to protect it from being
overwritten later.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 18489940a947b..2c077ffcee607 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1057,7 +1057,7 @@ static const struct pci_device_id i801_ids[] = {
 MODULE_DEVICE_TABLE(pci, i801_ids);
 
 #if defined CONFIG_X86 && defined CONFIG_DMI
-static unsigned char apanel_addr;
+static unsigned char apanel_addr __ro_after_init;
 
 /* Scan the system ROM for the signature "FJKEYINF" */
 static __init const void __iomem *bios_signature(const void __iomem *bios)
-- 
2.43.0



