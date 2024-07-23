Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4570315821E;
	Tue, 23 Jul 2024 18:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759962; cv=none; b=CtOx4hMl1z/VE5T9JOIGwKzBnW5h3gT5K/UiDTZxDJyFnP046gSw5swZ6p2rTni9oPVnjZh5Oyz40ForQc8USaEoA1O2Ose86qh+n3MYkoxw/WHlN9dZY9FaCoDDhoWVWd0ZvFdh7qk/bUb0yHht2v+tJhebZ5EKnRi0yyMPit0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759962; c=relaxed/simple;
	bh=GaIQt3WTqgci55cYJ+wEeCyNOi/nt8/ug05s6Ll6VXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F6pmr0zjQsMu4LVO6+ijcDfLP8cVKkRD0I7VWAudogSZP9XgIWxq6oUUwlc6Fin6zMR7xBO3Sypxhd2EmQnTdqTIzaWVee/nfp0aINMey5O8jQfjXdAjsRpyGtSaSjkVTePoQB6byKOs41lQKRuOtGb4Cv9U6KFaWhaHImbwh1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JuUNoJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JuUNoJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F7CC4AF09;
	Tue, 23 Jul 2024 18:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759962;
	bh=GaIQt3WTqgci55cYJ+wEeCyNOi/nt8/ug05s6Ll6VXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0JuUNoJsg5bRkCwaoOcHANfyxhrntCqTOADVpbGzRSHajKtK6C3dhkJvF8BN9o7rR
	 xrdtkZFNXfgwtbFdzlD5IwMB3Z03IMyJ9aVlWY/BPY6+0ME5bSKAwNnCE/8aNiPbaf
	 ihbckuvBC3SMFE3ldCA6nIdOumpzJo0vO716TFS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 056/163] parport: amiga: Mark driver struct with __refdata to prevent section mismatch
Date: Tue, 23 Jul 2024 20:23:05 +0200
Message-ID: <20240723180145.640244686@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 73fedc31fed38cb6039fd8a7efea1774143b68b0 ]

As described in the added code comment, a reference to .exit.text is ok
for drivers registered via module_platform_driver_probe(). Make this
explicit to prevent the following section mismatch warning

	WARNING: modpost: drivers/parport/parport_amiga: section mismatch in reference: amiga_parallel_driver+0x8 (section: .data) -> amiga_parallel_remove (section: .exit.text)

that triggers on an allmodconfig W=1 build.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20240513075206.2337310-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parport/parport_amiga.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/parport/parport_amiga.c b/drivers/parport/parport_amiga.c
index e6dc857aac3fe..e06c7b2aac5c4 100644
--- a/drivers/parport/parport_amiga.c
+++ b/drivers/parport/parport_amiga.c
@@ -229,7 +229,13 @@ static void __exit amiga_parallel_remove(struct platform_device *pdev)
 	parport_put_port(port);
 }
 
-static struct platform_driver amiga_parallel_driver = {
+/*
+ * amiga_parallel_remove() lives in .exit.text. For drivers registered via
+ * module_platform_driver_probe() this is ok because they cannot get unbound at
+ * runtime. So mark the driver struct with __refdata to prevent modpost
+ * triggering a section mismatch warning.
+ */
+static struct platform_driver amiga_parallel_driver __refdata = {
 	.remove_new = __exit_p(amiga_parallel_remove),
 	.driver   = {
 		.name	= "amiga-parallel",
-- 
2.43.0



