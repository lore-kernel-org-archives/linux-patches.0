Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C9E1D88D0;
	Sun,  7 Sep 2025 20:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276639; cv=none; b=hK2cIkP9ggSOlrF6osMeItibWZRi8ZAKP2PmS6+olqjJTMNJXnNdCuu9PRkGk9GzWbozuC9f6J0if9kmSYoY89QgGkCS0mebQyiLNIAC9SxU37N5NX7tXqS/ArN4xcc/csH3HE1onwhaf+Ks2jTpz3y/A159ENnt2mdjfz+usvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276639; c=relaxed/simple;
	bh=Vau0zAnSmIpazJXlgVYjOZPp25rWiyd+/EFXTw9yrVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iMNCIP1EgCJc/FK8N8eoDnZ0zt5Fbv6YuiFyJjWhBjkujieiceSXNnHrWLyCTSb6bnvPNu6ZfMH+05SbG6QHY14shyvY7HOfpPBRrlEhnwwS/mBZQ9SMXCRdmDEbGatmb5bHVxqiGVTHAZoEyIgODMvUD4PiNWzlBjjq0X7G1W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dv3ceh2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dv3ceh2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88255C4CEF0;
	Sun,  7 Sep 2025 20:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276638;
	bh=Vau0zAnSmIpazJXlgVYjOZPp25rWiyd+/EFXTw9yrVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dv3ceh2PYEKYzqhcObq5iJTJzqbJ8SCkwWGyOIDrapgH9TI/m8ha5uDWA8rB5ISKE
	 27OTC8dMYgVMQBKCJ5poha40Ko6SuV4GctyRwrPCnk7K8YErCF3ErMbJsFoLUopWQJ
	 FBFuPMX5XaOLPDNUiAAyGpJtKrQovKfY9BTPJ9C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 064/121] platform/x86/amd/pmc: Add TUXEDO IB Pro Gen10 AMD to spurious 8042 quirks list
Date: Sun,  7 Sep 2025 21:58:20 +0200
Message-ID: <20250907195611.481873988@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit c96f86217bb28e019403bb8f59eacd8ad5a7ad1a upstream.

Prevents instant wakeup ~1s after suspend.

It seems to be kernel/system dependent if the IRQ actually manages to wake
the system every time or if it gets ignored (and everything works as
expected).

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250827131424.16436-1-wse@tuxedocomputers.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -242,6 +242,20 @@ static const struct dmi_system_id fwbug_
 			DMI_MATCH(DMI_PRODUCT_NAME, "Lafite Pro V 14M"),
 		}
 	},
+	{
+		.ident = "TUXEDO InfinityBook Pro 14/15 AMD Gen10",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "XxHP4NAx"),
+		}
+	},
+	{
+		.ident = "TUXEDO InfinityBook Pro 14/15 AMD Gen10",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "XxKK4NAx_XxSP4NAx"),
+		}
+	},
 	{}
 };
 


