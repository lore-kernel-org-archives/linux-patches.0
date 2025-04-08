Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37737264A76;
	Tue,  8 Apr 2025 11:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112337; cv=none; b=DQYl7jS4pCJvgXm46ePyG6s8U6edazdcOaPkrqliQqv5kCj5IgGfhg8wvpOfTBOTbBUvjWNtVg2wfhJ3vZoxsOmc2kGN21EYzrHu7EXAoXX53OwJ4jKwUfudlf5D6Oz0unVdEPYlj6LWnSTGlj3dL363OhSfbQNi3IXL1yHBcfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112337; c=relaxed/simple;
	bh=1i2Rpqjvma6ZxN+3K3wTUpWGlAtF0Lec8s0U0QsNa6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBtc/KLM8UdxGsY7ZycsjLYs0uTHvH3e1+1/AmgTucK4CGSWWRBVNXUUFB2XliCtmA8vxEB4/hvhUrlQ/guG+B4wf2DNUftjbpHUCS1tTxaihSIc5Jys448Pq9Y3PAhcHN6plI+t9hmIo/osYnUS78GoxHTNNsC1AKZGtevoQDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNtNZM4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNtNZM4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95023C4CEE5;
	Tue,  8 Apr 2025 11:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112337;
	bh=1i2Rpqjvma6ZxN+3K3wTUpWGlAtF0Lec8s0U0QsNa6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNtNZM4oXwRQvVRWvRjzQtdOBnvaGfd8eJWe4yEJzbfGi7rqQKa4NWqOzhTESV3Ti
	 i0tDAchRgF50ptzDSZgGymFirAeY5hKIuWB7v2HD/pnX/wyw0PJJcG3jhlDaxhCdQZ
	 g9iDH07mfdLrWiM+s89PUdHzyOOlvq4iXC7xewp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gannon Kolding <gannon.kolding@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/279] ACPI: resource: IRQ override for Eluktronics MECH-17
Date: Tue,  8 Apr 2025 12:46:53 +0200
Message-ID: <20250408104827.196679003@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

From: Gannon Kolding <gannon.kolding@gmail.com>

[ Upstream commit 607ab6f85f4194b644ea95ac5fe660ef575db3b4 ]

The Eluktronics MECH-17 (GM7RG7N) needs IRQ overriding for the
keyboard to work.

Adding a DMI_MATCH entry for this laptop model makes the internal
keyboard function normally.

Signed-off-by: Gannon Kolding <gannon.kolding@gmail.com>
Link: https://patch.msgid.link/20250127093902.328361-1-gannon.kolding@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 56bbdd2f9a40d..0735ad7f01e22 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -556,6 +556,12 @@ static const struct dmi_system_id maingear_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "RP-15"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Eluktronics Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "MECH-17"),
+		},
+	},
 	{
 		/* TongFang GM6XGxX/TUXEDO Stellaris 16 Gen5 AMD */
 		.matches = {
-- 
2.39.5



