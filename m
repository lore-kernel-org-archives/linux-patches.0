Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4C214A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Me6Ej4/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC7EC433C7;
	Mon, 23 Oct 2023 11:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059607;
	bh=bQdjad5Oe7bm+6dqPXGW+lxkzi3G2pdja2PFWEfRLPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Me6Ej4/LsBSZ10sbACdlLa9dMp2EQp5EC5NZjMlejVIggHVZS3odXN8v9wDXWQTj2
	 3iKZnhnWX2AAtm1Jh6dst9bmCT/lX5iYNkJkDhbK4NteK5SDIInzk84Fxhs46mRdtP
	 oKW+wQ2ILSLC3Q4kKSiiH+o896Cuq3aeNf8E9e4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aakash Singh <mail@singhaakash.dev>,
	Jose Angel Pastrana <japp0005@red.ujaen.es>,
	Nikita Kravets <teackot@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.5 207/241] platform/x86: msi-ec: Fix the 3rd config
Date: Mon, 23 Oct 2023 12:56:33 +0200
Message-ID: <20231023104838.901412130@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Kravets <teackot@gmail.com>

commit 6284e67aa6cb3af870ed11dfcfafd80fd927777b upstream.

Fix the charge control address of CONF3 and remove an incorrect firmware
version which turned out to be a BIOS firmware and not an EC firmware.

Fixes: 392cacf2aa10 ("platform/x86: Add new msi-ec driver")
Cc: Aakash Singh <mail@singhaakash.dev>
Cc: Jose Angel Pastrana <japp0005@red.ujaen.es>
Signed-off-by: Nikita Kravets <teackot@gmail.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20231006175352.1753017-5-teackot@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/msi-ec.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/platform/x86/msi-ec.c
+++ b/drivers/platform/x86/msi-ec.c
@@ -276,14 +276,13 @@ static struct msi_ec_conf CONF2 __initda
 
 static const char * const ALLOWED_FW_3[] __initconst = {
 	"1592EMS1.111",
-	"E1592IMS.10C",
 	NULL
 };
 
 static struct msi_ec_conf CONF3 __initdata = {
 	.allowed_fw = ALLOWED_FW_3,
 	.charge_control = {
-		.address      = 0xef,
+		.address      = 0xd7,
 		.offset_start = 0x8a,
 		.offset_end   = 0x80,
 		.range_min    = 0x8a,


