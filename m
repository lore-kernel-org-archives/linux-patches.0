Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622821;
	b=jtZDIhnAEID6KJRNAYaAeiW8LCVDd9C+XUDSwoxsZ8q4q51aM3/iqoRUR/1zlGn4ZVji
	 TFkGuAUA6Po4vlxPHiBI+vbotI8m3ZIiZtWsT5EwHWjm0EPyB+lCZ/fvloMsPzNIY08YI
	 8zOL8cLKGIVBmIaS0bcpz68FyJ5/O8f2y5VLJ6CMZ5cXf5cCKhcUO24vqHL/QJ+yxb3/8
	 ktLUxgER8gMxui/vUsSWDsk8oZO+cOGX26y7IDdwt6aXfiOu72a32AOiyinUW/+3x7VeO
	 zPqksyB5kEIyupPjMYydVBjx9dF3oJ3kJ0d77eGrK3UlAjOJPJCWEW9FL5ZpyNaAKUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m8gCOxc7hYoJ20n9y/tSLtceu5eMHMJLiwG2osZMwKE=;
	b=KaCHk8IXdsX+tiNBXSmviNeAQQLXrckkHwB/SVQIOQmzZwGgC+A5IDqcYbQiu7tXkoUZ
	 BgHezQgYttSRQ32nY30+LGccAiWXMF42Ma5lKehgTW4mqpNkZlj1/q80NsDVj9jzlUkl8
	 Q0QZtpt4CKMYlhUeB0UCJG7RpgXvlLyKLfL8Q188bowQ0IOtNnFboLf9hhukkfCivkFex
	 9scsEkFFDjsVPYOgBsHldQ1Y1JcbzNtZWhuXYizPJYrsroR2ZrfdzokdcbgRA/XUaAoJi
	 7HSGwj1hGknb0EO54h0DBP/RS7L9KiRwcX2j31ovfwfFpxh09cerOl+glvUn1/zIInA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q974Rcnd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15916606A686;
	Wed, 25 Nov 2026 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q974Rcnd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8EC1F000E0;
	Wed, 25 Nov 2026 16:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622820;
	bh=m8gCOxc7hYoJ20n9y/tSLtceu5eMHMJLiwG2osZMwKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q974RcnddqbhTqfzr/IJNbP5KaYZcWBM0YrVhb0KEVYL5iqEMMz67+ngxz27ybmd3
	 +v6p0lnKZESFkFcF5GodL4nv8R7yQpGin0t0WPq9SKpIf7/OuHoBkEd7u0oylBcpB5
	 UB5GnL25BdiQCdDh/+ae7ig4TTDV7s2SW+ZnGjv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Louvignes <olivier@mgcrea.io>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 660/990] mmc: jz4740: Remove the host before resetting the controller
Date: Wed, 25 Nov 2026 15:33:47 +0100
Message-ID: <20261125143837.551115957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Louvignes <olivier@mgcrea.io>

commit 6b8b1e8827837bf4cf1f87219038fddae9e81b0b upstream.

jz4740_mmc_remove() masks every interrupt and resets the controller
before mmc_remove_host(), which removes the card and lets the card's
driver send its last commands. Those commands then run on a controller
that was just reset, and can wait out the driver's 5 s request timeout.

With an SDIO card that cost 5 s on every unbind: on a HiBy R1 (Ingenic
X1600, a BCM43430A1 driven by brcmfmac), the CMD52 that
sdio_release_irq() sends from brcmfmac's remove waited 5.1 s. The
command had finished (END_CMD_RES set in MSC_STAT), but MSC_IMASK read
0xffffffff although the request had unmasked END_CMD_RES. MSC_STAT can
still show IS_RESETTING after jz4740_mmc_reset() returns, so the reset
most likely completed after that write and undid it.

Remove the host first, then quiesce the controller, as other host
drivers do. On the R1, unbinding the Wi-Fi's MSC now takes 0.65 s.

Fixes: 61bfbdb85687 ("MMC: Add support for the controller on JZ4740 SoCs.")
Cc: stable@vger.kernel.org
Signed-off-by: Olivier Louvignes <olivier@mgcrea.io>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/jz4740_mmc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -1151,12 +1151,13 @@ static void jz4740_mmc_remove(struct pla
 {
 	struct jz4740_mmc_host *host = platform_get_drvdata(pdev);
 
+	/* The card's driver may still send commands as it goes */
+	mmc_remove_host(host->mmc);
+
 	timer_delete_sync(&host->timeout_timer);
 	jz4740_mmc_set_irq_enabled(host, 0xff, false);
 	jz4740_mmc_reset(host);
 
-	mmc_remove_host(host->mmc);
-
 	free_irq(host->irq, host);
 
 	if (host->use_dma)


