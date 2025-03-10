Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51042D023;
	Mon, 10 Mar 2025 17:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629322; cv=none; b=IM2aFpJVG/7sAIribj5BIZusbiRsKLtGczo0r0SuYs/PAnDYJ3gy7k11mmS0ZdQ9WSv8FHgsE0WsFhgkVy5eDNevmtE/SRSv1C+j1lH96WoRFbjK1KDYhbnjPMy/azvfihkBzqw9P7DWiB3Bd/0xdIxmhkcLAZVYJS0HkrXPoV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629322; c=relaxed/simple;
	bh=Ybc8gaUDeU7hhgSk+D4Wk5tlGq6SesJ6a8Ls1I2/6+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/ud0GRFz3voxJFFkBfAqnN3VuyvPCyRj2ixYk1/ZZnXs+k/Smt6Pyvbp4dP6M8SVTwrrkqiPqkhjf0V0GkIU9DXOIZltPFcEkKf4zF+hP13/by5CyErNMb5Lp5zDrNnTYw3BFbnfyDw9WXQhY7zTJ2LzaOLQXW5UMXsDA3sDIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0ARlvyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0ARlvyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3D7C4CEE5;
	Mon, 10 Mar 2025 17:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629321;
	bh=Ybc8gaUDeU7hhgSk+D4Wk5tlGq6SesJ6a8Ls1I2/6+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0ARlvyNCbMbBx5j0SHm98FQOeAMMkUsV8h4+mSDmSNULPdwtteTQ9QlswEceLHEk
	 j+xy/BPdcTGmSS8NwgGg6zb41VqFGBIZxTKTQkZnbXcFieNPIZ1Eabvl2zAVH4fGIe
	 bVHNV/KOZpW0cCGKM61zyrBE33a1vlRCoJ4upjoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/620] mfd: lpc_ich: Add another Gemini Lake ISA bridge PCI device-id
Date: Mon, 10 Mar 2025 18:00:59 +0100
Message-ID: <20250310170554.032938461@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1e89d21f8189d286f80b900e1b7cf57cb1f3037e ]

On N4100 / N4120 Gemini Lake SoCs the ISA bridge PCI device-id is 31e8
rather the 3197 found on e.g. the N4000 / N4020.

While at fix the existing GLK PCI-id table entry breaking the table
being sorted by device-id.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20241114193808.110132-1-hdegoede@redhat.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/lpc_ich.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 9ffab9aafd81b..15a6004218521 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -688,8 +688,9 @@ static const struct pci_device_id lpc_ich_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x2917), LPC_ICH9ME},
 	{ PCI_VDEVICE(INTEL, 0x2918), LPC_ICH9},
 	{ PCI_VDEVICE(INTEL, 0x2919), LPC_ICH9M},
-	{ PCI_VDEVICE(INTEL, 0x3197), LPC_GLK},
 	{ PCI_VDEVICE(INTEL, 0x2b9c), LPC_COUGARMOUNTAIN},
+	{ PCI_VDEVICE(INTEL, 0x3197), LPC_GLK},
+	{ PCI_VDEVICE(INTEL, 0x31e8), LPC_GLK},
 	{ PCI_VDEVICE(INTEL, 0x3a14), LPC_ICH10DO},
 	{ PCI_VDEVICE(INTEL, 0x3a16), LPC_ICH10R},
 	{ PCI_VDEVICE(INTEL, 0x3a18), LPC_ICH10},
-- 
2.39.5



