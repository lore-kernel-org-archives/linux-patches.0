Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE71F22EED
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBLxR1LJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6BDC433C9;
	Mon,  6 Nov 2023 13:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277374;
	bh=CDE/sjSGIAgiLdgqTtFLjoI9/5SYziaotkLzqnRVfzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBLxR1LJdwx2vZ2rPvHv3cWus8UJfaVY+oF2mf2R8bkVZhelwTxX0WAHQqrKraOwD
	 kIeFVIRCpeAUDwH5oa/SiUVMWSB6MI9Qp9aFclOInmmo3q2tqG6s9nTE2cwU4pXJg9
	 UrV1BSfnVthJ/+y0WG3pJUGmGeJJoc4qRYmu4F5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>
Subject: [PATCH 5.15 122/128] tty: 8250: Fix port count of PX-257
Date: Mon,  6 Nov 2023 14:04:42 +0100
Message-ID: <20231106130314.722797502@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

From: Cameron Williams <cang1@live.co.uk>

commit d0ff5b24c2f112f29dea4c38b3bac9597b1be9ba upstream.

The port count of the PX-257 Rev3 is actually 2, not 4.

Fixes: ef5a03a26c87 ("tty: 8250: Add support for Brainboxes PX cards.")
Cc: stable@vger.kernel.org
Signed-off-by: Cameron Williams <cang1@live.co.uk>
Link: https://lore.kernel.org/r/DU0PR02MB7899C804D9F04E727B5A0E8FC4DBA@DU0PR02MB7899.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -5607,7 +5607,7 @@ static const struct pci_device_id serial
 	{	PCI_VENDOR_ID_INTASHIELD, 0x4015,
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0,
-		pbn_oxsemi_4_15625000 },
+		pbn_oxsemi_2_15625000 },
 	/*
 	 * Brainboxes PX-260/PX-701
 	 */


