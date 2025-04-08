Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21342268C61;
	Tue,  8 Apr 2025 11:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111513; cv=none; b=crHcC4PWdWok6VCtTFDz9Ufko8x5Isw+cJufoTrAmdaZjHbeMzpPMUvh24djWZQRkhs9oGypDO3n7c6d1xhEqzpi19A6LKCYP082pR7oV3mu1eVOY1TwpM+1BFEa/PXX6i5Fw8n5VsmmmqIubPZenBG2eXStt2AJjj69fyjbphw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111513; c=relaxed/simple;
	bh=M9W1g+OOs+UxMNqterJEFIWyX4heSc+Nrs6PbWPT+jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJ84Ki9SmUTIppdpOcdocSZVgXLOFZzBktr2vUSt2Ft/3SuKLmjAsCeeVFfniLD1Kcq4t5LFuxOPj8KwrY+EOKGcLgU+D2agohkJLm3+nyXmtremVvNMfuLYlGPDXeVdM2Y8ltHKa+3nA2dqBV0OqBxfQKwJO1wpK2n4Y6j0kS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4TX4iaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4TX4iaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7DDC4CEE7;
	Tue,  8 Apr 2025 11:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111512;
	bh=M9W1g+OOs+UxMNqterJEFIWyX4heSc+Nrs6PbWPT+jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4TX4iaRJUN299M8J1G43jYtB21VbmRRZXcYzESMU7FFDE1l63oHARrOmPcNUAaj/
	 Pn5/qDu8uYPYi6ynnPjuL6uP3U0nqEQ7fe4l0EpvUW4d77hlimJ9ghD5zm0V0F4vze
	 +DC5KCIGlVPoQvyTi0dGwGsrBMLTC2bKDMLDK7Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 457/731] staging: gpib: Fix cb7210 pcmcia Oops
Date: Tue,  8 Apr 2025 12:45:54 +0200
Message-ID: <20250408104924.909556391@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit c1baf6528bcfd6a86842093ff3f8ff8caf309c12 ]

The  pcmcia_driver struct was still only using the old .name
initialization in the drv field. This led to a NULL pointer
deref Oops in strcmp called from pcmcia_register_driver.

Initialize the pcmcia_driver struct name field.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202502131453.cb6d2e4a-lkp@intel.com
Fixes: e9dc69956d4d ("staging: gpib: Add Computer Boards GPIB driver")
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250213103112.4415-1-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/cb7210/cb7210.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gpib/cb7210/cb7210.c b/drivers/staging/gpib/cb7210/cb7210.c
index 4d22f647a453f..ab93061263bfe 100644
--- a/drivers/staging/gpib/cb7210/cb7210.c
+++ b/drivers/staging/gpib/cb7210/cb7210.c
@@ -1342,8 +1342,8 @@ static struct pcmcia_device_id cb_pcmcia_ids[] = {
 MODULE_DEVICE_TABLE(pcmcia, cb_pcmcia_ids);
 
 static struct pcmcia_driver cb_gpib_cs_driver = {
+	.name           = "cb_gpib_cs",
 	.owner		= THIS_MODULE,
-	.drv = { .name = "cb_gpib_cs", },
 	.id_table	= cb_pcmcia_ids,
 	.probe		= cb_gpib_probe,
 	.remove		= cb_gpib_remove,
-- 
2.39.5



