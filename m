Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E1B192D97;
	Tue, 10 Sep 2024 09:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961529; cv=none; b=UGNm38SA5V5yyFkslYCtaWT7XhIDczXL95mv961CFbmirAm0XN9ItrCGvnuAmDBwqDxJl0jPEMpc6RObmcuCHbeaaLizFrxwZBwwafLclQx8fA8GYnl7fNfZoop8xG/MdajItRJkd6Zj+P7XDQa7BZ8xufdFgZv7HyQyqD6cOkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961529; c=relaxed/simple;
	bh=JnAsjEXVDVI0BMOLjBFIvtlOLTFTbH8UyzgKCtr3evM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lalZD1sqDJKZc1h+8MLf8dVBrxdpJ0vf4I+kOT4zt1HaUBUUqgfWhnwQGN7qDexEha98Yp/hT4NSRoYNftnOdfX3fWg8bMOxUgAN58BONcTK/WQIs24H8SutMBQZM0jOPMOigpfQRmhRZ60ugRTRbwKmFvEqefDaZOl2YYREgPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9jI7qaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9jI7qaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC85C4CEC3;
	Tue, 10 Sep 2024 09:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961528;
	bh=JnAsjEXVDVI0BMOLjBFIvtlOLTFTbH8UyzgKCtr3evM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9jI7qajWzctfMjMkR3ukVsSRBSXssbiLWLrx44QGGtYH9sN4ho7XIdqWvHNL8MBU
	 JP+CfAvZDKxO3u3wCJojg1DAYTvvGx429uagSWyHzsLLu9GO/lii+T9UOVwie9ECUJ
	 4DYulLL+uGzzl84guIhgtLJMisZA++4y+oaN2T7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 100/375] virt: sev-guest: Mark driver struct with __refdata to prevent section mismatch
Date: Tue, 10 Sep 2024 11:28:17 +0200
Message-ID: <20240910092625.605332047@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 3991b04d4870fd334b77b859a8642ca7fb592603 ]

As described in the added code comment, a reference to .exit.text is ok for
drivers registered via module_platform_driver_probe(). Make this explicit to
prevent the following section mismatch warning:

  WARNING: modpost: drivers/virt/coco/sev-guest/sev-guest: section mismatch in reference: \
    sev_guest_driver+0x10 (section: .data) -> sev_guest_remove (section: .exit.text)

that triggers on an allmodconfig W=1 build.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/4a81b0e87728a58904283e2d1f18f73abc69c2a1.1711748999.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 654290a8e1ba..a100d6241992 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -1009,8 +1009,13 @@ static void __exit sev_guest_remove(struct platform_device *pdev)
  * This driver is meant to be a common SEV guest interface driver and to
  * support any SEV guest API. As such, even though it has been introduced
  * with the SEV-SNP support, it is named "sev-guest".
+ *
+ * sev_guest_remove() lives in .exit.text. For drivers registered via
+ * module_platform_driver_probe() this is ok because they cannot get unbound
+ * at runtime. So mark the driver struct with __refdata to prevent modpost
+ * triggering a section mismatch warning.
  */
-static struct platform_driver sev_guest_driver = {
+static struct platform_driver sev_guest_driver __refdata = {
 	.remove_new	= __exit_p(sev_guest_remove),
 	.driver		= {
 		.name = "sev-guest",
-- 
2.43.0



