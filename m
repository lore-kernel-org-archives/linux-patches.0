Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63FB153800;
	Fri, 15 Nov 2024 06:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653623; cv=none; b=kChsMnl+HF5LG8qgcYmIIGAwRAaBI4sOz0l+hZM6XVYKws/nHvH2iSwmcG61yax3q9IV32Qk/602wSWnOTBEKmQrKJocJe17u16effeYOuEdHGZCw6vv3Mvq8Sc06D/VMqmoERzO+kdFkrQ090FdS+Q9h8c0dooKu2LDedeeohA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653623; c=relaxed/simple;
	bh=Px8ypQM53Oqb6ypvHuL8gwdV/2oC/orHxIttAzcwCNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lxvGl06fj4jSsB4BLb74Ng41fnXf7Odou0/esEemmLm0Fp93GAFtQXqf+EUrbSRnMsWiZIkzJIvXAsymgXH4EOuWoNr8uO0OJV0qPMHJMwt1o035U0N0wxOT7fqrPkZtfcd1YvL+wrxRuYl9+lJf2j0QCxrz7Ixs8zScSSFriCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOQmoQNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOQmoQNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170D2C4CED2;
	Fri, 15 Nov 2024 06:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653623;
	bh=Px8ypQM53Oqb6ypvHuL8gwdV/2oC/orHxIttAzcwCNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOQmoQNX4tce1D2J92+PzAkCdTkkZNUIVIVKEm7H8I8OHo0uIVSYsNGcbehacGVby
	 mduxsBEla5ilWPZMn/pYBlOQBgN/CeZoWbMqi/xv8vqS60NhJ9hfii9uOwSSH9UEff
	 G6qdcc29LDxWq/Nh+saYsZMSgJeSLbaJTKPxhYTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jeremy=20Lain=C3=A9?= <jeremy.laine@m4x.org>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Mike <user.service2016@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 04/39] Revert "Bluetooth: hci_core: Fix possible buffer overflow"
Date: Fri, 15 Nov 2024 07:38:14 +0100
Message-ID: <20241115063722.766718123@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 68644bf5ec6baaff40fc39b3529c874bfda709bd which is
commit 81137162bfaa7278785b24c1fd2e9e74f082e8e4 upstream.

It is reported to cause regressions in the 6.1.y tree, so revert it for
now.

Link: https://lore.kernel.org/all/CADRbXaDqx6S+7tzdDPPEpRu9eDLrHQkqoWTTGfKJSRxY=hT5MQ@mail.gmail.com/
Reported-by: Jeremy Lainé <jeremy.laine@m4x.org>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Cc: Mike <user.service2016@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Pauli Virtanen <pav@iki.fi>
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -869,7 +869,7 @@ int hci_get_dev_info(void __user *arg)
 	else
 		flags = hdev->flags;
 
-	strscpy(di.name, hdev->name, sizeof(di.name));
+	strcpy(di.name, hdev->name);
 	di.bdaddr   = hdev->bdaddr;
 	di.type     = (hdev->bus & 0x0f) | ((hdev->dev_type & 0x03) << 4);
 	di.flags    = flags;


